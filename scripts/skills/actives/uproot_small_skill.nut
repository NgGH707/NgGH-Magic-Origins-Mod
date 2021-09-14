this.uproot_small_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.uproot_small";
		this.m.Name = "Uproot";
		this.m.Description = "Puncture your enemies with roots are hidden underground.";
		this.m.KilledString = "Crushed";
		this.m.Icon = "skills/active_122.png";
		this.m.IconDisabled = "skills/active_122_sw.png";
		this.m.Overlay = "active_122";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/schrat_uproot_short_01.wav",
			"sounds/enemies/dlc2/schrat_uproot_short_02.wav",
			"sounds/enemies/dlc2/schrat_uproot_short_03.wav",
			"sounds/enemies/dlc2/schrat_uproot_short_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/schrat_uproot_hit_01.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_02.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_03.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.IsSerialized = false;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 250;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsTargetingActor = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 25;
		this.m.ChanceSmash = 25;
	}
	
	function getTooltip()
	{
		return this.getDefaultTooltip();
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInSpears ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;

		if (_properties.IsSpecializedInSpears)
		{
			_properties.DamageRegularMin += 5;
			_properties.DamageRegularMax += 15;
		}
	}

	function applyEffectToTarget( _user, _target, _targetTile )
	{
		if (_target.isNonCombatant())
		{
			return;
		}

		_target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has staggered " + this.Const.UI.getColorizedEntityName(_target) + " for one turn");
		}
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local dir = myTile.getDirectionTo(_targetTile);
		this.Tactical.spawnAttackEffect("uproot", _targetTile, 0, -50, 100, 300, 100, this.createVec(0, 80), 200, this.createVec(0, -80), true);

		for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _targetTile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
		}

		if (_targetTile.IsOccupiedByActor && _targetTile.getEntity().isAttackable() && _targetTile.getEntity().getFaction() != _user.getFaction())
		{
			if (_targetTile.getEntity().m.IsShakingOnHit)
			{
				this.Tactical.getShaker().shake(_targetTile.getEntity(), _targetTile, 7);
				_user.playSound(this.Const.Sound.ActorEvent.Move, 2.0);
			}

			this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, function ( _tag )
			{
				if (this.attackEntity(_user, _targetTile.getEntity()) && !_targetTile.IsEmpty)
				{
					this.applyEffectToTarget(_user, _targetTile.getEntity(), _targetTile);
				}
			}.bindenv(this), null);
		}

		return true;
	}
	
	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 40;
		_properties.DamageRegularMax += 60;
		_properties.DamageArmorMult *= 0.85;
	}

});

