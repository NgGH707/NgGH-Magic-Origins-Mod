::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_demon_shadows_skill", function(q) 
{
	q.m.Tiles <- [];

	q.create = @(__original) function()
	{
		__original();
		m.Description = "Summon hellfire to bring out the agony from your foe, using the juicy nightmarish cry to fuel the inferno.";
		m.Icon = "skills/active_alp_hellfire.png";
		m.IconDisabled = "skills/active_alp_hellfire_sw.png";
		m.Overlay = "active_alp_hellfire";
		m.IsSerialized = true;
		m.Order = ::Const.SkillOrder.UtilityTargeted - 1;
		m.IsAttack = true;
		m.IsRanged = true;
		m.InjuriesOnBody = ::Const.Injury.BurningBody;
		m.InjuriesOnHead = ::Const.Injury.BurningHead;
		m.DirectDamageMult = 0.35;
		m.FatigueCost = 15;
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player")) {
			setBaseValue("MaxRange", 8);
			setBaseValue("IsVisibleTileNeeded", true);
			m.IsVisibleTileNeeded = true;
		}
	}

	q.hasTile <- function( _id )
	{
		foreach (i, t in m.Tiles) 
		{
		    if (t.ID == _id) return true;
		}

		return false;
	}

	q.updateTiles <- function()
	{
		local new = [];

		foreach ( t in m.Tiles )
		{
			if (t.Properties.Effect != null && t.Properties.Effect.Type == "alp_hellfire")
				new.push(t);
		}

		m.Tiles = new;
	}

	q.removeAllTiles <- function()
	{
		foreach ( t in m.Tiles )
		{
			if (t.Properties.Effect != null && t.Properties.Effect.Type == "alp_hellfire")
				::Tactical.Entities.removeTileEffect(t);
		}
	}

	q.onUpdate <- function( _properties )
	{
		_properties.InitiativeForTurnOrderAdditional += 999;
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = getContainer().hasSkill("perk.control_flame") ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Brings hellfire to the earth"
		});
		return ret;
	}

	q.onTurnStart <- function()
	{
		updateTiles();
	}

	q.onResumeTurn <- function()
	{
		updateTiles();
	}

	q.onDeath <- function( _fatalityType )
	{
		removeAllTiles();
	}

	q.onUse = function( _user, _targetTile )
	{
		local targets = [], self = this;
		local specialized_1 = getContainer().hasSkill("perk.hellish_flame");
		local specialized_2 = getContainer().hasSkill("perk.control_flame");
		local specialized_3 = getContainer().hasSkill("perk.fiece_flame");
		local time = specialized_3 ? 2 : 4;
		targets.extend(::MSU.Tile.getNeighbors(_targetTile));
		targets.push(_targetTile);

		for( local i = 0; i != 6; ++i )
		{
			if (!_targetTile.hasNextTile(i))
				continue;

				targets.push(_targetTile.getNextTile(i));
		}

		local custom = ;
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
			Callback = self.onApplyFirefield,
			Custom = {
				Specialized_1 = specialized_1,
				Specialized_2 = specialized_2,
				Specialized_3 = specialized_3,
				UserID = _user.getID(),
			},
			function Applicable( _a )
			{
				return _a;
			}
		};

		foreach( tile in targets )
		{
			if (tile.Properties.Effect != null && tile.Properties.Effect.Type == "alp_hellfire") {
				tile.Properties.Effect = clone p;
				tile.Properties.Effect.Timeout = ::Time.getRound() + (time * 0.5);
			}
			else {
				if (tile.Properties.Effect != null)
					::Tactical.Entities.removeTileEffect(tile);

				tile.Properties.Effect = clone p;
				local particles = [];

				for( local i = 0; i < ::Const.Tactical.FireParticles.len(); ++i )
				{
					particles.push(::Tactical.spawnParticleEffect(true, ::Const.Tactical.FireParticles[i].Brushes, tile, ::Const.Tactical.FireParticles[i].Delay, ::Const.Tactical.FireParticles[i].Quantity, ::Const.Tactical.FireParticles[i].LifeTimeQuantity, ::Const.Tactical.FireParticles[i].SpawnRate, ::Const.Tactical.FireParticles[i].Stages));
				}
				
				::Tactical.Entities.addTileEffect(tile, tile.Properties.Effect, particles);
			}

			if (!hasTile(tile.ID))
				m.Tiles.push(tile);

			if (specialized_1 && tile.IsOccupiedByActor)
				onApplyFirefield(tile, tile.getEntity());
		}

		return true;
	}

	q.onApplyFirefield <- function( _tile, _entity )
	{
		local data = _tile.Properties.Effect;
		local injuries, custom = data.Custom;
		local damage = ::Math.rand(15, 20), damageMult = 1.0;
		local attacker = ::Tactical.getEntityByID(custom.UserID);

		if (::MSU.isNull(attacker) || !attacker.isAlive() || attacker.isDying())
			attacker = null;

		if (custom.Specialized_2 && _entity.getID() == custom.UserID)
			return;

		if (custom.Specialized_1)
			damage += ::Math.rand(5, 12);

		if (custom.Specialized_3) {
			damage += ::Math.rand(5, 20);
			injuries = ::Const.Injury.Burning;
		}

		if (_entity.getCurrentProperties().IsImmuneToFire)
			damageMult *= 0.33;

		if (_entity.getSkills().hasSkill("items.firearms_resistance"))
			damageMult *= 0.75;

		if (_entity.getSkills().hasSkill("racial.serpent"))
			damageMult *= 0.75;

		if ([
			::Const.EntityType.Schrat,
			::Const.EntityType.SchratSmall,
			::Const.EntityType.LegendGreenwoodSchrat,
			::Const.EntityType.LegendGreenwoodSchratSmall,
		].find(_entity.getType()) != null || _entity.getFlags().has("isSmallSchrat") || _entity.getFlags().has("isSchrat"))
		{
			damageMult *= 2.5;
		}

		::Tactical.spawnIconEffect("status_effect_116", _tile, ::Const.Tactical.Settings.SkillIconOffsetX, ::Const.Tactical.Settings.SkillIconOffsetY, ::Const.Tactical.Settings.SkillIconScale, ::Const.Tactical.Settings.SkillIconFadeInDuration, ::Const.Tactical.Settings.SkillIconStayDuration, ::Const.Tactical.Settings.SkillIconFadeOutDuration, ::Const.Tactical.Settings.SkillIconMovement);
		::Sound.play(::MSU.Array.rand([
			"sounds/combat/dlc6/status_on_fire_01.wav",
			"sounds/combat/dlc6/status_on_fire_02.wav",
			"sounds/combat/dlc6/status_on_fire_03.wav"
		]), ::Const.Sound.Volume.Actor, _entity.getPos());
		local hitInfo = clone ::Const.Tactical.HitInfo;
		hitInfo.DamageRegular = damage * damageMult;
		hitInfo.DamageArmor = hitInfo.DamageRegular * 1.25;
		hitInfo.DamageDirect = 0.35;
		hitInfo.BodyPart = ::Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		hitInfo.Injuries = injuries;
		hitInfo.IsPlayingArmorSound = false;
		_entity.onDamageReceived(attacker, null, hitInfo);
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 15;
			_properties.DamageRegularMax = 20;
			_properties.DamageArmorMult = 1.25;
			_properties.RangedDamageMult /= 0.9;

			if (getContainer().hasSkill("perk.hellish_flame")) {
				_properties.DamageRegularMin += 5;
				_properties.DamageRegularMax += 12;
			}

			if (getContainer().hasSkill("perk.fiece_flame")) {
				_properties.DamageRegularMin += 5;
				_properties.DamageRegularMax += 20;
			}
		}
	}

	q.onCombatStarted <- function()
	{
		m.Tiles.clear();
	}

	q.onCombatFinished <- function()
	{
		m.Tiles.clear();
	}

	q.onTargetSelected <- function( _targetTile )
	{
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);	

		for( local i = 0; i < 6; ++i )
		{
			if (!_targetTile.hasNextTile(i))
				continue;

			local nextTile = _targetTile.getNextTile(i);
			::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);	
		}
	}

});