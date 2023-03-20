::mods_hookExactClass("skills/actives/horror_skill", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		//this.m.IsMagicSkill = true;
		//this.m.MagicPointsCost = 6;
		this.m.Description = "Fill selected target\'s mind with horrific images, weakening their will to fight and even making them freeze in place because of fear.";
		this.m.Icon = "skills/active_102.png";
		this.m.IconDisabled = "skills/active_102_sw.png";
		this.m.Overlay = "active_102";
	};
	obj.onAdded <- function()
	{
		this.m.IsVisibleTileNeeded = this.getContainer().getActor().isPlayerControlled();
	};
	obj.getTooltip <- function()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
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
				text = "Scare the shit out of your target"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can affect up to 7 targets"
			},
		]);
		return ret;
	};
	local ws_onUse = obj.onUse;
	obj.onUse = function( _user, _targetTile )
	{
		// if the user is player, this skill will also affect allies
		if (_user.isPlayerControlled())
		{
			local targets = [];

			if (_targetTile.IsOccupiedByActor)
			{
				local entity = _targetTile.getEntity();

				if (this.isViableTarget(_user, entity))
				{
					targets.push(entity);
				}
			}

			for( local i = 0; i < 6; i = ++i )
			{
				if (!_targetTile.hasNextTile(i))
				{
				}
				else
				{
					local adjacent = _targetTile.getNextTile(i);

					if (adjacent.IsOccupiedByActor && ::Math.rand(1, 100) <= 33)
					{
						local entity = adjacent.getEntity();

						if (this.isViableTarget(_user, entity))
						{
							targets.push(entity);
						}
					}
				}
			}

			foreach( target in targets )
			{
				local effect = ::Tactical.spawnSpriteEffect("effect_skull_03", ::createColor("#ffffff"), target.getTile(), 0, 40, 1.0, 0.25, 0, 400, 300);

				if (target.getCurrentProperties().MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0)
				{
					continue;
				}

				target.checkMorale(-1, -1 * ::Math.rand(5, 15), ::Const.MoraleCheckType.MentalAttack);

				if (!target.checkMorale(0, -1 * ::Math.rand(1, 5), ::Const.MoraleCheckType.MentalAttack))
				{
					target.getSkills().add(::new("scripts/skills/effects/horrified_effect"));

					if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
					{
						::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " is horrified");
					}
				}
			}
		}
		else
		{
			return ws_onUse(_user, _targetTile);
		}

		return true;
	};
	obj.onTargetSelected <- function( _targetTile )
	{
		local ownTile = _targetTile;

		for( local i = 0; i != 6; i = ++i )
		{
			if (!ownTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = ownTile.getNextTile(i);

				if (::Math.abs(tile.Level - ownTile.Level) <= 1)
				{
					::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
				}
			}
		}
	};
});