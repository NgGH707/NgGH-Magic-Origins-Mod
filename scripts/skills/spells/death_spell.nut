this.death_spell <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		Cooldown = 2,
	},
	
	function setCaster( _c )
	{
		this.m.Caster = _c;
	}
	
	function getCaster()
	{
		return this.m.Caster;
	}
	
	function create()
	{
		this.m.ID = "spells.death";
		this.m.Name = "True Death";
		this.m.Description = "Die, just simply die. For NgGH707 only";
		this.m.KilledString = "Sucked all life";
		this.m.Icon = "skills/active_102.png";
		this.m.IconDisabled = "skills/active_102_sw.png";
		this.m.Overlay = "active_102";
		this.m.SoundOnUse = [
			"sounds/enemies/horror_spell_01.wav",
			"sounds/enemies/horror_spell_02.wav",
			"sounds/enemies/horror_spell_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury + 1;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsShieldRelevant = false;
		this.m.IsIgnoredAsAOO = false;
		this.m.IsIgnoringRiposte = true;
		this.m.IsUsingHitchance = false;
		this.m.DirectDamageMult = 1.0;
		this.m.BonusMagicAccuracy = 15;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
		this.m.ChanceDecapitate = 100;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 0;
	}
	
	function onTurnStart()
	{
		this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Death"
				
			}
		]);
		return ret;
	}
	
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		
		local _target = _targetTile.getEntity();
		
		if (_target.getSkills().hasSkill("trait.player"))
		{
			return false;
		}
		
		return true;
	}
	
	function isUsable()
	{
		return this.skill.isUsable() && this.m.Cooldown == 0;
	}

	function onUse( _user, _targetTile )
	{
		this.Tactical.CameraDirector.addMoveToTileEvent(0, _targetTile);
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " points at " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()));
		//this.onSpawnEffect(_targetTile);
		
		local tag = {
			User = _user,
			TargetTile = _targetTile
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 1000, this.onDelayedEffect.bindenv(this), tag);
		
		this.m.Cooldown = 4;
		return true;
	}
	
	function onDelayedEffect( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local target = _targetTile.getEntity();
		this.Tactical.spawnSpriteEffect("effect_skull_02", this.createColor("#ffffff"), _targetTile, 0, 40, 1.0, 0.25, 0, 400, 300);
		target.kill(_user, null, this.Const.FatalityType.Decapitated);
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 1000;
			_properties.DamageRegularMax = 1000;
			_properties.DamageArmorMult *= 0.0;
			_properties.HitChance[this.Const.BodyPart.Head] += 50.0;
			_properties.IsIgnoringArmorOnAttack = true;
			
			if (this.canDoubleGrip())
			{
				_properties.DamageTotalMult /= 1.25;
			}
		}
	}
	
	function onSpawnEffect( _tile )
	{
		local effect = {
			Delay = 0,
			Quantity = 12,
			LifeTimeQuantity = 12,
			SpawnRate = 100,
			Brushes = [
				"bust_lich_aura_01"
			],
			Stages = [
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = this.createColor("ffffff5f"),
					ColorMax = this.createColor("ffffff5f"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-1.0, -1.0),
					DirectionMax = this.createVec(1.0, 1.0),
					SpawnOffsetMin = this.createVec(-10, -10),
					SpawnOffsetMax = this.createVec(10, 10),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				},
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = this.createColor("ffffff2f"),
					ColorMax = this.createColor("ffffff2f"),
					ScaleMin = 0.9,
					ScaleMax = 0.9,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-1.0, -1.0),
					DirectionMax = this.createVec(1.0, 1.0),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = this.createColor("ffffff00"),
					ColorMax = this.createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-1.0, -1.0),
					DirectionMax = this.createVec(1.0, 1.0),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				}
			]
		};
		this.Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
	}
	
});