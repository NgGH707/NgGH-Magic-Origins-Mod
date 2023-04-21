::mods_hookExactClass("skills/actives/legend_demon_shadows_skill", function(obj) 
{
	obj.m.Tiles <- [];

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Summon the hellfire to bring out the agony pain from your foe, fueling the juicy nightmare to the inferno.";
		this.m.Icon = "skills/active_alp_hellfire.png";
		this.m.IconDisabled = "skills/active_alp_hellfire_sw.png";
		this.m.Overlay = "active_alp_hellfire";
		this.m.Order = ::Const.SkillOrder.UtilityTargeted - 1;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.InjuriesOnBody = ::Const.Injury.BurningBody;
		this.m.InjuriesOnHead = ::Const.Injury.BurningHead;
		this.m.DirectDamageMult = 0.35;
		this.m.FatigueCost = 15;
	};
	obj.onAdded <- function()
	{
		if (this.getContainer().getActor().isPlayerControlled())
		{
			this.m.MaxRange = 8;
			this.m.IsVisibleTileNeeded = true;
		}
	};
	obj.hasTile <- function( _id )
	{
		foreach (i, t in this.m.Tiles) 
		{
		    if (t.ID == _id)
		    {
		    	return true;
		    }
		}

		return false;
	};
	obj.updateTiles <- function()
	{
		local new = [];

		foreach ( t in this.m.Tiles )
		{
			if (t.Properties.Effect != null && t.Properties.Effect.Type == "alp_hellfire")
			{
				new.push(t);
			}
		}

		this.m.Tiles = new;
	};
	obj.removeAllTiles <- function()
	{
		foreach ( t in this.m.Tiles )
		{
			if (t.Properties.Effect != null && t.Properties.Effect.Type == "alp_hellfire")
			{
				::Tactical.Entities.removeTileEffect(t);
			}
		}
	};
	obj.onUpdate <- function( _properties )
	{
		_properties.InitiativeForTurnOrderAdditional += 999;
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = this.getContainer().hasSkill("perk.control_flame") ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	};
	obj.getTooltip <- function()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Brings hellfire to the earth"
		});
		return ret;
	};
	obj.onTurnStart <- function()
	{
		this.updateTiles();
	};
	obj.onResumeTurn <- function()
	{
		this.updateTiles();
	};
	obj.onDeath <- function( _fatalityType )
	{
		this.removeAllTiles();
	};
	obj.onUse = function( _user, _targetTile )
	{
		local targets = [];
		local self = this;
		local applyFire = self.onApplyFirefield;
		local specialized_1 = this.getContainer().hasSkill("perk.hellish_flame");
		local specialized_2 = this.getContainer().hasSkill("perk.control_flame");
		local specialized_3 = this.getContainer().hasSkill("perk.fiece_flame");
		local time = specialized_3 ? 2 : 4;
		targets.push(_targetTile);

		for( local i = 0; i != 6; ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				targets.push(tile);
			}
		}

		local custom = {
			Specialized_1 = specialized_1,
			Specialized_2 = specialized_2,
			Specialized_3 = specialized_3,
			UserID = _user.getID(),
		};
		local p = {
			Type = "alp_hellfire",
			Tooltip = "The inferno of nightmare, burns everything dare to go near it. Created by " + _user.getName(),
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = true,
			IsAppliedOnEnter = false,
			IsPositive = false,
			Timeout = ::Time.getRound() + time,
			IsByPlayer = _user.isPlayerControlled(),
			Callback = applyFire,
			Custom = custom,
			function Applicable( _a )
			{
				return _a;
			}
		};

		foreach( tile in targets )
		{
			if (tile.Properties.Effect != null && tile.Properties.Effect.Type == "alp_hellfire")
			{
				tile.Properties.Effect = clone p;
				tile.Properties.Effect.Timeout = ::Time.getRound() + (time * 0.5);
			}
			else
			{
				if (tile.Properties.Effect != null)
				{
					::Tactical.Entities.removeTileEffect(tile);
				}

				tile.Properties.Effect = clone p;
				local particles = [];

				for( local i = 0; i < ::Const.Tactical.FireParticles.len(); ++i )
				{
					particles.push(::Tactical.spawnParticleEffect(true, ::Const.Tactical.FireParticles[i].Brushes, tile, ::Const.Tactical.FireParticles[i].Delay, ::Const.Tactical.FireParticles[i].Quantity, ::Const.Tactical.FireParticles[i].LifeTimeQuantity, ::Const.Tactical.FireParticles[i].SpawnRate, ::Const.Tactical.FireParticles[i].Stages));
				}
				
				::Tactical.Entities.addTileEffect(tile, tile.Properties.Effect, particles);
			}

			if (!this.hasTile(tile.ID))
			{
				this.m.Tiles.push(tile);
			}

			if (specialized_1 && tile.IsOccupiedByActor)
			{
				this.onApplyFirefield(tile, tile.getEntity());
			}
		}

		return true;
	};
	obj.onApplyFirefield <- function( _tile, _entity )
	{
		local data = _tile.Properties.Effect;
		local custom = data.Custom;
		local damage = ::Math.rand(15, 20);
		local damageMult = 1.0;
		local injuries = null;
		local attacker = ::Tactical.getEntityByID(custom.UserID);

		if (attacker == null || !attacker.isAlive() || attacker.isDying())
		{
			attacker = null;
		}

		if (custom.Specialized_2 && _entity.getID() == custom.UserID)
		{
			return;
		}

		if (custom.Specialized_1)
		{
			damage += ::Math.rand(5, 12);
		}

		if (custom.Specialized_3)
		{
			damage += ::Math.rand(5, 20);
			injuries = ::Const.Injury.Burning;
		}

		if (_entity.getCurrentProperties().IsImmuneToFire)
		{
			damageMult *= 0.33;
		}

		if (_entity.getSkills().hasSkill("items.firearms_resistance"))
		{
			damageMult *= 0.67;
		}

		if (_entity.getSkills().hasSkill("racial.serpent"))
		{
			damageMult *= 0.67;
		}

		if ([
			::Const.EntityType.Schrat,
			::Const.EntityType.SchratSmall,
			::Const.EntityType.LegendGreenwoodSchrat,
			::Const.EntityType.LegendGreenwoodSchratSmall,
		].find(_entity.getType()) != null || _entity.getFlags().has("isSmallSchrat") || _entity.getFlags().has("isSchrat"))
		{
			damageMult *= 2.0;
		}

		::Tactical.spawnIconEffect("fire_circle", _tile, ::Const.Tactical.Settings.SkillIconOffsetX, ::Const.Tactical.Settings.SkillIconOffsetY, ::Const.Tactical.Settings.SkillIconScale, ::Const.Tactical.Settings.SkillIconFadeInDuration, ::Const.Tactical.Settings.SkillIconStayDuration, ::Const.Tactical.Settings.SkillIconFadeOutDuration, ::Const.Tactical.Settings.SkillIconMovement);
		local sounds = [
			"sounds/combat/fire_01.wav",
			"sounds/combat/fire_02.wav",
			"sounds/combat/fire_03.wav",
			"sounds/combat/fire_04.wav",
			"sounds/combat/fire_05.wav",
			"sounds/combat/fire_06.wav"
		];
		::Sound.play(::MSU.Array.rand(sounds), ::Const.Sound.Volume.Actor, _entity.getPos());
		local hitInfo = clone ::Const.Tactical.HitInfo;
		hitInfo.DamageRegular = damage * damageMult;
		hitInfo.DamageArmor = hitInfo.DamageRegular * 1.25;
		hitInfo.DamageDirect = 0.35;
		hitInfo.BodyPart = ::Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		hitInfo.Injuries = injuries;
		hitInfo.InjuryThresholdMult = 1.15;
		hitInfo.IsPlayingArmorSound = false;
		_entity.onDamageReceived(attacker, null, hitInfo);
	};
	obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local specialized_1 = this.getContainer().hasSkill("perk.hellish_flame");
			local specialized_3 = this.getContainer().hasSkill("perk.fiece_flame");
			_properties.DamageRegularMin = 15;
			_properties.DamageRegularMax = 20;
			_properties.DamageArmorMult = 1.25;
			_properties.RangedDamageMult /= 0.9;

			if (specialized_1)
			{
				_properties.DamageRegularMin += 5;
				_properties.DamageRegularMax += 12;
			}

			if (specialized_3)
			{
				_properties.DamageRegularMin += 5;
				_properties.DamageRegularMax += 20;
			}
		}
	};
	obj.onCombatStarted <- function()
	{
		this.m.Tiles = [];
	};
	obj.onCombatFinished <- function()
	{
		this.m.Tiles = [];
	};
	obj.onTargetSelected <- function( _targetTile )
	{
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);	

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = _targetTile.getNextTile(i);
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);	
			}
		}
	};
});