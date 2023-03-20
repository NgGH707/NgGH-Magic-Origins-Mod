::mods_hookExactClass("skills/actives/charge", function ( obj )
{
	obj.m.rawdelete("IsSpent");

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Throw yourself at the enemies and slam at them with your hugemungus body.";
		this.m.Icon = "skills/active_52.png";
		this.m.IconDisabled = "skills/active_52_sw.png";
	};
	obj.onAdded <- function()
	{
		this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 30 : 25;
		local AI = this.getContainer().getActor().getAIAgent();

		if (AI.getID() == ::Const.AI.Agent.ID.Player)
		{
			return;
		}

		AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_charge"));
		AI.m.Properties.EngageRangeMin = 1;
		AI.m.Properties.EngageRangeMax = 2;
		AI.m.Properties.EngageRangeIdeal = 2;
	};
	obj.getTooltip = function()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can cause [color=" + ::Const.UI.Color.NegativeValue + "]Stun[/color]"
			}
		];
	};
	obj.isUsable = function()
	{
		return !::Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	};
	obj.onTurnStart = function() {};
	obj.onUse = function( _user, _targetTile )
	{
		local tag = {
			Skill = this,
			User = _user,
			OldTile = _user.getTile(),
			TargetTile = _targetTile,
			OnRepelled = this.onRepelled
		};

		if (tag.OldTile.IsVisibleForPlayer || _targetTile.IsVisibleForPlayer)
		{
			local myPos = _user.getPos();
			local targetPos = _targetTile.Pos;
			local distance = tag.OldTile.getDistanceTo(_targetTile);
			local Dx = (targetPos.X - myPos.X) / distance;
			local Dy = (targetPos.Y - myPos.Y) / distance;

			for( local i = 0; i < distance; ++i )
			{
				local x = myPos.X + Dx * i;
				local y = myPos.Y + Dy * i;
				local tile = ::Tactical.worldToTile(::createVec(x, y));

				if (::Tactical.isValidTile(tile.X, tile.Y) && ::Const.Tactical.DustParticles.len() != 0)
				{
					for( local i = 0; i < ::Const.Tactical.DustParticles.len(); i = ++i )
					{
						::Tactical.spawnParticleEffect(false, ::Const.Tactical.DustParticles[i].Brushes, ::Tactical.getTile(tile), ::Const.Tactical.DustParticles[i].Delay, ::Const.Tactical.DustParticles[i].Quantity * 0.5, ::Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, ::Const.Tactical.DustParticles[i].SpawnRate, ::Const.Tactical.DustParticles[i].Stages);
					}
				}
			}
		}

		::Tactical.getNavigator().teleport(_user, _targetTile, this.onTeleportDone, tag, false, 2.0);
		return true;
	};
});