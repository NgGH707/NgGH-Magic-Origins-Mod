this.nggh_mod_ghost_possess <- ::inherit("scripts/skills/skill", {
	m = {
		IsEnhanced = false
	},
	function create()
	{
		this.m.ID = "actives.ghost_possess";
		this.m.Name = "Possess";
		this.m.Description = "Take control of a living creature.";
		this.m.Icon = "skills/active_ghost_possess.png";
		this.m.IconDisabled = "skills/active_ghost_possess_sw.png";
		this.m.Overlay = "active_ghost_possess";
		this.m.SoundOnUse = [
			"sounds/enemies/geist_idle_01.wav",
			"sounds/enemies/geist_idle_02.wav",
			"sounds/enemies/geist_idle_03.wav",
			"sounds/enemies/geist_idle_04.wav",
			"sounds/enemies/geist_idle_05.wav",
			"sounds/enemies/geist_idle_06.wav",
			"sounds/enemies/geist_idle_07.wav",
			"sounds/enemies/geist_idle_08.wav",
			"sounds/enemies/geist_idle_09.wav",
			"sounds/enemies/geist_idle_10.wav",
			"sounds/enemies/geist_idle_11.wav",
			"sounds/enemies/geist_idle_12.wav",
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.Delay = 250;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 4;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local players = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player);
		local allies = ::Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction());

		if (players.len() == 1 || allies.len() == 1)
		{
			return false;
		}

		local _target = _targetTile.getEntity();
		
		if (_target.getMoraleState() != ::Const.MoraleState.Fleeing)
		{
			return false;
		}

		if (_target.getCurrentProperties().MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0)
		{
			return false;
		}
		
		if (_target.isNonCombatant())
		{
			return false;
		}

		local skills = [
			"effects.charmed",
			"effects.charmed_captive",
			"effects.legend_intensely_charmed",
			"effects.ghost_possessed",
			"trait.player"
		];

		foreach ( id in skills ) 
		{
		    if (_target.getSkills().hasSkill(id))
		    {
		    	return false;
		    }
		}

		return true;
	}

	function isViableTarget( _user, _target )
	{
		if (_target.isAlliedWith(_user))
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local tag = {
			User = _user,
			TargetTile = _targetTile,
			Sprite = _user.getSprite("body").getBrush().Name
		};

		local dir = _targetTile.getDirectionTo(myTile);

		if (myTile.hasNextTile(dir))
		{
			tag.OriginTile <- myTile.getNextTile(dir);
		}
		else
		{
			tag.OriginTile <- myTile;
		}

		this.getContainer().setBusy(true);
		::Time.scheduleEvent(::TimeUnit.Virtual, 250, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local myTile = _user.getTile();
		local target = _targetTile.getEntity();
		local flip = target.getPos().X > _user.getPos().X;

		if (typeof _user == "instance")
		{
			_user = _user.get();
		}

		local possessed = ::new("scripts/skills/effects/nggh_mod_ghost_possessed_effect");
		possessed.setPossessorFaction(_user.getFaction());
		possessed.setPossessor(_user);
		possessed.setEffect(this.m.IsEnhanced);
		possessed.m.LastTile = myTile;
		::Tactical.getTemporaryRoster().add(_user);

		if (!_user.isHiddenToPlayer())
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " vanishes");
		}

		this.spawnGhostEffect(myTile);
		local time = ::Tactical.spawnProjectileEffect(_tag.Sprite, _tag.OriginTile, _targetTile, 1.0, 1.0, false, flip);
		::Time.scheduleEvent(::TimeUnit.Virtual, time, function ( _e )
		{
			target.getSkills().add(possessed);
			target.setMoraleState(::Const.MoraleState.Wavering);
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " has rallied");
			_user.getSkills().setBusy(false);
			_user.removeFromMap();
		}.bindenv(this), this);
	}

	function spawnGhostEffect( _tile )
	{
		local effect = {
			Delay = 0,
			Quantity = 12,
			LifeTimeQuantity = 12,
			SpawnRate = 100,
			Brushes = [
				"bust_ghost_01"
			],
			Stages = [
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = ::createColor("ffffff5f"),
					ColorMax = ::createColor("ffffff5f"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					SpawnOffsetMin = ::createVec(-10, -10),
					SpawnOffsetMax = ::createVec(10, 10),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = ::createColor("ffffff2f"),
					ColorMax = ::createColor("ffffff2f"),
					ScaleMin = 0.9,
					ScaleMax = 0.9,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = ::createColor("ffffff00"),
					ColorMax = ::createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				}
			]
		};
		::Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
	}

});

