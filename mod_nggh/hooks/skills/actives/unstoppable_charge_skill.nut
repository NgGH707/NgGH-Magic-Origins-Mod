::mods_hookExactClass("skills/actives/unstoppable_charge_skill", function ( obj )
{
	obj.m.rawdelete("IsSpent");

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Charge forward with unbeleivable speed and ram at enemy formation. Can cause knock back or stun. Can not be used in melee.";
		this.m.Icon = "skills/active_110.png";
		this.m.IconDisabled = "skills/active_110_sw.png";
	};
	obj.getTooltip = function()
	{
		local ret = [
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
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "May [color=" + ::Const.UI.Color.PositiveValue + "]Stun[/color] or [color=" + ::Const.UI.Color.PositiveValue + "]Knock Back[/color] to nearby foes"
			}
		];
		
		if (::Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not be used because this unhold is engaged in melee[/color]"
			});
		}
		
		return ret;
	};
	obj.isUsable = function()
	{
		return !::Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	};
	obj.onTurnStart = function() {};
	obj.onUse = function( _user, _targetTile )
	{
		this.m.TilesUsed = [];
		local tag = {
			Skill = this,
			User = _user,
			OldTile = _user.getTile(),
			TargetTile = _targetTile
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

		::Tactical.getNavigator().teleport(_user, _targetTile, this.onTeleportDone, tag, false, 2.5);
		return true;
	};
});