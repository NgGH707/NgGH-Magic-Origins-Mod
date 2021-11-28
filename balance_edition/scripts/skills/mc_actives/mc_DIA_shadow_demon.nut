this.mc_DIA_shadow_demon <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		Entity = null,
		Cooldown = 0,
		Script = "scripts/entity/tactical/minions/special/alp_shadow_minion_entity",
	},
	function setCooldown()
	{
		this.m.Cooldown = 2;
	}

	function removeEntity()
	{
		this.m.Entity = null;
	}

	function setEntity( _e )
	{
		if (_e == null)
		{
			this.removeEntity();
		}
		else 
		{
		    this.m.Entity = typeof _e == "instance" ? _e : this.WeakTableRef(_e);
		}
	}

	function getEntity()
	{
		if (this.m.Entity == null || this.m.Entity.isNull() || !this.m.Entity.isAlive())
		{
			return null;
		}

		return this.m.Entity;
	}

	function killEntity()
	{
		if (this.m.Entity == null || this.m.Entity.isNull() || !this.m.Entity.isAlive())
		{
			return;
		}

		this.m.Entity.setLink(null);
		this.m.Entity.killSilently();
		this.removeEntity();
	}

	function create()
	{
		this.m.ID = "actives.mc_shadow_demon";
		this.m.Name = "Shadow Demon";
		this.m.Description = "Summon a shadow demon that will fight for you. Can\'t have more than one shadow demon. The higher your resolve the stronger your shadow demon can be.";
		this.m.Icon = "skills/active_117.png";
		this.m.IconDisabled = "skills/active_117_sw.png";
		this.m.Overlay = "active_117";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/alp_sleep_01.wav",
			"sounds/enemies/dlc2/alp_sleep_02.wav",
			"sounds/enemies/dlc2/alp_sleep_03.wav",
			"sounds/enemies/dlc2/alp_sleep_04.wav",
			"sounds/enemies/dlc2/alp_sleep_05.wav",
			"sounds/enemies/dlc2/alp_sleep_06.wav",
			"sounds/enemies/dlc2/alp_sleep_07.wav",
			"sounds/enemies/dlc2/alp_sleep_08.wav",
			"sounds/enemies/dlc2/alp_sleep_09.wav",
			"sounds/enemies/dlc2/alp_sleep_10.wav",
			"sounds/enemies/dlc2/alp_sleep_11.wav",
			"sounds/enemies/dlc2/alp_sleep_12.wav"
		];
		this.m.IsUsingActorPitch = true;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = false;
		this.m.IsUtility = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 40;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 4;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		
		if (this.getEntity() != null)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/health.png",
				text = "Give your shadow demon an extra life"
			});
		}

		if (this.m.Cooldown > 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "Skill is under cooldown"
			});
		}
	
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return _targetTile.IsEmpty;
	}

	function onAfterUpdate( _properties )
	{
		this.mc_magic_skill.onAfterUpdate(_properties);

		if (this.getEntity() != null)
		{
			this.m.FatigueCostMult /= 3;
			this.m.ActionPointCost = 3;
			this.m.IsTargeted = false;
		}
		else 
		{
			this.m.ActionPointCost = 6;
			this.m.IsTargeted = true;
		}
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.m.Cooldown == 0;
	}

	function onUse( _user, _targetTile )
	{
		if (this.getEntity() != null)
		{
			this.spawnIcon("status_effect_81", this.getEntity().getTile());
			this.getEntity().addNineLivesCount();

			if (!_user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " blesses his shadow demon with vitality");
			}

			return true;
		}

		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " summons a shadow demon");
		}

		local stats = this.calculatingStats();
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 300, function( _skill )
		{
			local demon = this.Tactical.spawnEntity(_skill.m.Script, _targetTile.Coords);
			demon.setFaction(2);
			demon.setMaster(_user);
			demon.setLink(_skill);
			demon.setNewStats(stats);
			_skill.setEntity(demon);
		}.bindenv(this), this);
		
		return true;
	}

	function calculatingStats()
	{
		local mult = this.getBonusDamageFromResolve(this.getContainer().getActor().getCurrentProperties());
		local stats = {
			XP = 0,
			ActionPoints = 9,
			Hitpoints = 5,
			Bravery = 100,
			Stamina = 100,
			MeleeSkill = this.Math.rand(50, 60),
			RangedSkill = this.Math.rand(50, 60),
			MeleeDefense = 20,
			RangedDefense = 50,
			Initiative = 115,
			FatigueEffectMult = 0.0,
			MoraleEffectMult = 0.0,
			FatigueRecoveryRate = 15,
			Vision = this.Math.rand(4, 5),
			Armor = [
				0,
				0
			]
		};

		stats.DamageTotalMult <- mult;
		stats.MeleeSkill = this.Math.floor(stats.MeleeSkill * mult);
		stats.RangedSkill = this.Math.floor(stats.RangedSkill * mult);
		stats.MeleeDefense = this.Math.floor(stats.MeleeDefense * mult);
		stats.RangedDefense = this.Math.floor(stats.RangedDefense * mult);
		return stats;
	}

	function applyDamage( _damage , _skill )
	{
		local entity = this.getEntity();

		if (entity == null)
		{
			return;
		}

		local sounds = [
			"sounds/enemies/dlc2/hexe_hex_damage_01.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_02.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_03.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_04.wav"
		];
		this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, entity.getPos());
		local color;
		do
		{
			color = this.createColor("#ff0000");
			color.varyRGB(0.75, 0.75, 0.75);
		}
		while (color.R + color.G + color.B <= 150);
		this.Tactical.spawnSpriteEffect("effect_pentagram_02", color, entity.getTile(), !entity.getSprite("status_hex").isFlippedHorizontally() ? 10 : -5, 88, 3.0, 1.0, 0, 400, 300);
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = _damage;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		entity.onDamageReceived(this.getContainer().getActor(), _skill, hitInfo);
	}

	function onDeath()
	{
		this.killEntity();
	}

	function onTurnStart()
	{
		this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
	}

	function onCombatStarted()
	{
		this.setEntity(null);
		this.m.Cooldown = 0;
	}

	function onCombatFinished()
	{
		this.setEntity(null);
		this.m.Cooldown = 0;
	}

});

