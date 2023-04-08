this.mount_manager <- {
	m = {
		Actor = null,
		Mount = null,
		MountType = null,
		RiderSkill = null,
		ShakeLayers = null,
		ExcludedMount = [],
		Skills = [],
		Armor = {
			Condition = 0,
			ConditionMax = 0,
			StaminaModifier = 0,
		},
		Appearance = {
			HideArmor = false,
			Flipping = false,
			Scale = 1.0,
			Body = "",
			Head = "",
			Extra = "",
			Extra1 = "",
			Extra2 = "",
			Injury = "",
			Armor = "",
			ArmorDamage = "",
			Restrain = "",
			Corpse = "",
			CorpseHead = "",
			CorpseArmor = "",
			Bloodpool = "",
			OldSounds = []
		},
		Attributes = {
			Hitpoints = 0,
			HitpointsMax = 0,
			Armor = [0, 0],
			ArmorMax = [0, 0],

			function clearAll()
			{
				this.Hitpoints = 0;
				this.HitpointsMax = 0;
				this.Armor = [0, 0];
				this.ArmorMax = [0, 0];
			}
		},
		IsRegenHealth = false,
		IsInBattle = false,
		IsReleased = false,
		IsUpdating = false
	},
	function create()
	{
		this.m.ShakeLayers = ::Const.GoblinRider.ShakeLayers;
		//this.clear();
	}

	function setActor( _a )
	{
		this.m.Actor = ::WeakTableRef(_a);
		this.m.Actor.getFlags().set("can_mount", true);
	}

	function getActor()
	{
		return this.m.Actor;
	}

	function setMount( _m )
	{
		this.m.Mount = ::WeakTableRef(_m);
	}

	function getMount()
	{
		return this.m.Mount;
	}

	function setMountType( _type )
	{
		this.m.MountType = _type;
	}

	function getMountType()
	{
		return this.m.MountType;
	}

	function getStrengthMult()
	{
		return ::Const.GoblinRiderMounts[this.getMountType()].Strength;
	}

	function getMountArmor()
	{
		return this.m.Armor;
	}

	function isMounted()
	{
		if (this.m.IsReleased)
		{
			return false;
		}

		return this.m.Mount != null && !this.m.Mount.isNull();
	}

	function getExcludedMount()
	{
		return this.m.ExcludedMount;
	}

	function addExcludedMount( _id )
	{
		if (this.m.ExcludedMount.find(_id) != null)
		{
			return;
		}

		this.m.ExcludedMount.push(_id);
	}

	function getArmor( _bodyPart )
	{
		return ::Math.floor(this.m.Attributes.Armor[_bodyPart] + (_bodyPart == ::Const.BodyPart.Body ? this.m.Armor.Condition : 0));
	}

	function getArmorMax( _bodyPart )
	{
		return ::Math.floor(this.m.Attributes.ArmorMax[_bodyPart] + (_bodyPart == ::Const.BodyPart.Body ? this.m.Armor.ConditionMax : 0));
	}

	function getHitpoints()
	{
		if (!this.m.IsInBattle)
		{
			return 50;
		}

		return this.m.Attributes.Hitpoints;
	}

	function getHitpointsMax()
	{
		if (!this.m.IsInBattle)
		{
			return 50;
		}

		return this.m.Attributes.HitpointsMax;
	}

	function getHitpointsPct()
	{
		if (!this.m.IsInBattle)
		{
			return 1.0;
		}

		return ::Math.minf(1.0, this.getHitpoints() / ::Math.maxf(1.0, this.getHitpointsMax()));
	}

	function setHitpoints( _h )
	{
		this.m.Attributes.Hitpoints = ::Math.round(_h);
		this.updateInjuryLayer();
	}

	function setHitpointsPct( _h )
	{
		this.m.Attributes.Hitpoints = ::Math.round(this.getHitpointsMax() * _h);
		this.updateInjuryLayer();
	}

	function getSkills()
	{
		return this.m.Skills;
	}

	function setRiderSkill( _s )
	{
		this.m.RiderSkill = ::WeakTableRef(_s);
	}

	function getRiderSkill()
	{
		return this.m.RiderSkill;
	}

	function getAppearance()
	{
		return this.m.Appearance;
	}

	function getAttributes()
	{
		return this.m.Attributes;
	}

	function setAttributes( _a )
	{
		if (_a.rawin("Hitpoints"))
		{
			this.m.Attributes.Hitpoints = _a.Hitpoints;
		}

		if (_a.rawin("HitpointsMax"))
		{
			this.m.Attributes.HitpointsMax = _a.HitpointsMax;
		}

		if (_a.rawin("HitpointsPct"))
		{
			this.m.Attributes.Hitpoints = ::Math.round(this.m.Attributes.HitpointsMax * _a.HitpointsPct);
		}

		if (_a.rawin("Armor"))
		{
			this.m.Attributes.Armor[0] = _a.Armor[0];
			this.m.Attributes.Armor[1] = _a.Armor[1];
			this.m.Attributes.ArmorMax = clone this.m.Attributes.Armor;
		}

		if (_a.rawin("ArmorMax"))
		{
			this.m.Attributes.ArmorMax[0] = _a.ArmorMax[0];
			this.m.Attributes.ArmorMax[1] = _a.ArmorMax[1];
		}
	}

	function addFlags()
	{
		this.m.Actor.getFlags().set("isRider", true);

		foreach ( i, _f in ::Const.GoblinRiderMounts[this.m.MountType].Flags ) 
		{
			this.m.Actor.getFlags().add(_f);
		}
	}

	function clearFlags()
	{
		if (this.m.Actor == null || this.m.Actor.isNull())
		{
			return;
		}

		this.m.Actor.getFlags().set("isRider", false);

		if (this.m.MountType == null)
		{
			return;
		}

		foreach ( _f in ::Const.GoblinRiderMounts[this.m.MountType].Flags ) 
		{
			this.m.Actor.getFlags().remove(_f);
		}
	}

	function addSkills()
	{
		local quirkNames = [];

		foreach ( i, skill in ::Const.GoblinRiderMounts[this.m.MountType].Skills ) 
		{
		    local _s = ::new("scripts/skills/" + skill);
		    _s.m.IsSerialized = false;
		    _s.setItem(this.m.Mount);

		    if (_s.rawin("setRestrained") && !this.m.Actor.getFlags().has("egg"))
			{
				_s.setRestrained(true);
				_s.m.ActionPointCost = 0;
				_s.setFatigueCost(6);
			}
			else
			{
				_s.setFatigueCost(::Math.floor(_s.getFatigueCostRaw() * 0.5));
			}

			if (_s.isType(::Const.SkillType.Perk) && !_s.isType(::Const.SkillType.Racial))
			{
				_s.m.Type -= ::Const.SkillType.Perk;
				_s.m.Type = _s.m.Type | ::Const.SkillType.Racial;
			} 

			if (!_s.isType(::Const.SkillType.Active))
			{
				quirkNames.push(_s.getName());
			} 

			this.m.Actor.getSkills().add(_s);
		    this.m.Skills.push(_s);
		}

		if (::Is_AccessoryCompanions_Exist)
		{
			foreach( i, quirk in this.m.Mount.getQuirks() )
			{
				if (::Const.ExcludedQuirks.find(quirk) != null)
				{
					continue;
				}

				local _q = ::new(quirk);
				_q.m.IsSerialized = false;
			    _q.setItem(this.m.Mount);

			    if (_q.isType(::Const.SkillType.Perk) && !_q.isType(::Const.SkillType.Racial))
				{
					_q.m.Type -= ::Const.SkillType.Perk;
					_q.m.Type = _q.m.Type | ::Const.SkillType.Racial;
				}

			    if (!this.m.Actor.getSkills().hasSkill(_q.getID()))
			    {
			   		this.m.Actor.getSkills().add(_q);
					this.m.Skills.push(_q);
					quirkNames.push(_q.getName());
				}
			}
		}

		if (quirkNames.len() != 0) 
		{
			this.m.RiderSkill.addQuirks(quirkNames);
		}
	}

	function clearSkills()
	{
		if (this.m.Actor == null || this.m.Actor.isNull())
		{
			this.m.Skills = [];
			return;
		}

		foreach (i, skill in this.m.Skills) 
		{
		    local _s = this.m.Actor.getSkills().getSkillByID(skill.getID());

		    if (_s != null && _s.getItem() != null && _s.getItem().getInstanceID() == skill.getItem().getInstanceID())
		    {
		    	_s.removeSelf();
		    }
		}

		this.m.Skills = [];
		this.m.RiderSkill.clearQuirks();
	}

	function addSpritesAndArmor( _item )
	{
		::Const.GoblinRider.updateMountSprites(_item, this.m.Appearance);
		::Const.GoblinRider.updateMountArmor(_item, this.m.Appearance, this.m.Armor);
	}

	function updateInjuryLayer()
	{
		if (!this.isMounted())
		{
			return;
		}

		local percentage = this.getHitpointsPct();
		local mount_injury = this.m.Actor.getSprite("mount_injury");
		local type = this.getMountType();
		local flip = !this.m.Actor.isAlliedWithPlayer();

		if (percentage > 0.5)
		{
			mount_injury.setBrush(this.m.Appearance.Injury);
			mount_injury.setHorizontalFlipping(this.m.Appearance.Flipping ? !flip : flip);
			mount_injury.Scale = this.m.Appearance.Scale;
			this.m.Actor.setSpriteOffset("mount_injury", ::createVec(::Const.GoblinRiderMounts[type].Sprite[1][0], ::Const.GoblinRiderMounts[type].Sprite[1][1]));
		}
		else
		{
			mount_injury.Visible = false;
		}

		this.m.Actor.setDirty(true);
	}

	function updateAppearance()
	{
		if (this.m.Actor == null || this.m.Actor.isNull())
		{
			return;
		}

		local _actor = this.getActor();
		local flip = !_actor.isAlliedWithPlayer();
		local mount = _actor.getSprite("mount");
		local mount_head = _actor.getSprite("mount_head");
		local mount_extra = _actor.getSprite("mount_extra");
		local mount_extra1 = _actor.getSprite("mount_extra1");
		local mount_extra2 = _actor.getSprite("mount_extra2");
		local mount_armor = _actor.getSprite("mount_armor");
		local mount_injury = _actor.getSprite("mount_injury");
		local mount_restrain = _actor.getSprite("mount_restrain");

		if (!this.isMounted())
		{
			mount.Visible = false;
			mount_head.Visible = false;
			mount_extra.Visible = false;
			mount_extra1.Visible = false;
			mount_extra2.Visible = false;
			mount_armor.Visible = false;
			mount_injury.Visible = false;
			mount_restrain.Visible = false;
			return;
		}

		local _appearance = this.getAppearance();
		local type = this.getMountType();
		local offset = ::createVec(::Const.GoblinRiderMounts[type].Sprite[1][0], ::Const.GoblinRiderMounts[type].Sprite[1][1]);

		mount.setBrush(_appearance.Body);
		mount.Visible = true;
		mount.setHorizontalFlipping(_appearance.Flipping ? !flip : flip);
		mount.Scale = _appearance.Scale;
		_actor.setSpriteOffset("mount", offset);

		mount_head.setBrush(_appearance.Head);
		mount_head.Visible = true;
		mount_head.setHorizontalFlipping(_appearance.Flipping ? !flip : flip);
		mount_head.Scale = _appearance.Scale;
		_actor.setSpriteOffset("mount_head", offset);
		
		if (_appearance.Extra != "")
		{
			mount_extra.setBrush(_appearance.Extra);
			mount_extra.Visible = true;
			mount_extra.setHorizontalFlipping(_appearance.Flipping ? !flip : flip);
			mount_extra.Scale = _appearance.Scale;
			_actor.setSpriteOffset("mount_extra", offset);
		}
		else 
		{
		    mount_extra.Visible = false;
		}

		if (_appearance.Extra1 != "")
		{
			mount_extra1.setBrush(_appearance.Extra1);
			mount_extra1.Visible = true;
			mount_extra1.setHorizontalFlipping(_appearance.Flipping ? !flip : flip);
			mount_extra1.Scale = _appearance.Scale;
			_actor.setSpriteOffset("mount_extra1", offset);
		}
		else 
		{
		    mount_extra1.Visible = false;
		}

		if (_appearance.Extra2 != "")
		{
			mount_extra2.setBrush(_appearance.Extra2);
			mount_extra2.Visible = true;
			mount_extra2.setHorizontalFlipping(_appearance.Flipping ? !flip : flip);
			mount_extra2.Scale = _appearance.Scale;
			_actor.setSpriteOffset("mount_extra2", offset);
		}
		else 
		{
		    mount_extra.Visible = false;
		}

		if (_appearance.Armor != "")
		{
			local percentage = this.m.Armor.Condition / this.Math.max(1, this.m.Armor.ConditionMax);

			if (percentage < 0.5 && _appearance.ArmorDamage != "")
			{
			    mount_armor.setBrush(_appearance.ArmorDamage);
			}
			else
			{
				mount_armor.setBrush(_appearance.Armor);
			}

			mount_armor.Visible = true;
			mount_armor.setHorizontalFlipping(_appearance.Flipping ? !flip : flip);
			mount_armor.Scale = _appearance.Scale;
			_actor.setSpriteOffset("mount_armor", offset);
		}
		else
		{
		    mount_armor.Visible = false;
		}

		if (_appearance.Restrain != "")
		{
			mount_restrain.setBrush(_appearance.Restrain);
			mount_restrain.Visible = true;
			mount_restrain.setHorizontalFlipping(_appearance.Flipping ? !flip : flip);
			mount_restrain.Scale = _appearance.Scale;
			_actor.setSpriteOffset("mount_restrain", offset);
		}
		else 
		{
		    mount_restrain.Visible = false;
		}
	}

	function onAccessoryEquip( _item )
	{
		if (this.m.Actor == null || this.m.Actor.isNull())
		{
			return;
		}

		if (!this.m.Actor.isAbleToMount())
		{
			return;
		}

		local id = _item.getID();

		if (this.getExcludedMount().find(id) != null)
		{
			return;
		}

		if (::Const.GoblinRider.ID.find(id) == null)
		{
			return;
		}

		this.setMount(_item);
		this.setMountType(::Const.GoblinRider.getMountType(_item));
	
		this.m.Appearance.OldSounds.push(this.m.Actor.m.Sound[::Const.Sound.ActorEvent.Other1]);
		this.m.Appearance.OldSounds.push(this.m.Actor.m.Sound[::Const.Sound.ActorEvent.Other2]);
		this.m.Appearance.OldSounds.push(this.m.Actor.m.Sound[::Const.Sound.ActorEvent.Idle]);
		this.m.Appearance.OldSounds.push(this.m.Actor.m.Sound[::Const.Sound.ActorEvent.Move]);

		this.m.Actor.m.Sound[::Const.Sound.ActorEvent.Other1] = ::Const.GoblinRiderMounts[this.m.MountType].SoundsOther1;
		this.m.Actor.m.Sound[::Const.Sound.ActorEvent.Other2] = ::Const.GoblinRiderMounts[this.m.MountType].SoundsOther2;
		this.m.Actor.m.Sound[::Const.Sound.ActorEvent.Idle] = ::Const.GoblinRiderMounts[this.m.MountType].SoundsIdle;
		this.m.Actor.m.Sound[::Const.Sound.ActorEvent.Move] = ::Const.GoblinRider.SoundsMove;
		this.addFlags();
		this.addSkills();
		this.addSpritesAndArmor(_item);
		this.m.Actor.getItems().updateAppearance();
	}

	function onAccessoryUnequip()
	{
		if (this.m.Appearance.OldSounds.len() != 0)
		{
			this.m.Actor.m.Sound[::Const.Sound.ActorEvent.Other1] = this.m.Appearance.OldSounds[0];
			this.m.Actor.m.Sound[::Const.Sound.ActorEvent.Other2] = this.m.Appearance.OldSounds[1];
			this.m.Actor.m.Sound[::Const.Sound.ActorEvent.Idle] = this.m.Appearance.OldSounds[2];
			this.m.Actor.m.Sound[::Const.Sound.ActorEvent.Move] = this.m.Appearance.OldSounds[3];
		}

		this.onUnequip();
		this.m.Actor.getItems().updateAppearance();
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		local attributes = this.m.Attributes;
		local rider = this.m.Actor;

		if (!rider.isAlive() || !rider.isPlacedOnMap())
		{
			return 0;
		}

		if (_hitInfo.DamageRegular == 0 && _hitInfo.DamageArmor == 0)
		{
			return 0;
		}

		if (typeof rider == "instance")
		{
			rider = rider.get();
		}

		if (typeof _attacker == "instance")
		{
			_attacker = _attacker.get();
		}

		if (_attacker != null && _attacker.isAlive() && _attacker.isPlayerControlled() && !rider.isPlayerControlled())
		{
			rider.setDiscovered(true);
			rider.getTile().addVisibilityForFaction(::Const.Faction.Player);
			rider.getTile().addVisibilityForCurrentEntity();
		}

		if (rider.m.Skills.hasSkill("perk.steel_brow"))
		{
			_hitInfo.BodyDamageMult = 1.0;
		}
		
		local p = rider.getSkills().buildPropertiesForBeingHit(_attacker, _skill, _hitInfo);
		rider.getItems().onBeforeDamageReceived(_attacker, _skill, _hitInfo, p);
		local dmgMult = p.DamageReceivedTotalMult;
		_hitInfo.BodyDamageMult = 1.0;

		if (_skill != null)
		{
			dmgMult = dmgMult * (_skill.isRanged() ? p.DamageReceivedRangedMult : p.DamageReceivedMeleeMult);
		}

		_hitInfo.DamageRegular -= p.DamageRegularReduction;
		_hitInfo.DamageArmor -= p.DamageArmorReduction;
		_hitInfo.DamageRegular *= p.DamageReceivedRegularMult * dmgMult;
		_hitInfo.DamageArmor *= p.DamageReceivedArmorMult * dmgMult;
		local armor = 0;
		local armorDamage = 0;

		if (_hitInfo.DamageDirect < 1.0)
		{
			armor = this.getArmor(_hitInfo.BodyPart);
			armorDamage = ::Math.min(armor, _hitInfo.DamageArmor);
			armor = armor - armorDamage;
			_hitInfo.DamageInflictedArmor = ::Math.max(0, armorDamage);
		}

		_hitInfo.DamageFatigue *= p.FatigueEffectMult;
		rider.m.Fatigue = ::Math.min(rider.getFatigueMax(), ::Math.round(rider.m.Fatigue + _hitInfo.DamageFatigue * p.FatigueReceivedPerHitMult * 0.25));
		local damage = 0;
		damage = damage + ::Math.maxf(0.0, _hitInfo.DamageRegular * _hitInfo.DamageDirect * p.DamageReceivedDirectMult - armor * ::Const.Combat.ArmorDirectDamageMitigationMult);

		if (armor <= 0 || _hitInfo.DamageDirect >= 1.0)
		{
			damage = damage + ::Math.max(0, _hitInfo.DamageRegular * ::Math.maxf(0.0, 1.0 - _hitInfo.DamageDirect * p.DamageReceivedDirectMult) - armorDamage);
		}

		damage = damage * _hitInfo.BodyDamageMult;
		damage = ::Math.max(0, ::Math.max(::Math.round(damage), ::Math.min(::Math.round(_hitInfo.DamageMinimum), ::Math.round(_hitInfo.DamageMinimum * p.DamageReceivedTotalMult))));
		_hitInfo.DamageInflictedHitpoints = damage;
		rider.getSkills().onDamageReceived(_attacker, _hitInfo.DamageInflictedHitpoints, _hitInfo.DamageInflictedArmor);

		if (armorDamage > 0 && damage < ::Const.Combat.PlayPainSoundMinDamage && !rider.isHiddenToPlayer() && _hitInfo.IsPlayingArmorSound)
		{
			rider.playSound(::Const.Sound.ActorEvent.NoDamageReceived, ::Const.Sound.Volume.Actor * rider.m.SoundVolume[::Const.Sound.ActorEvent.NoDamageReceived] * rider.m.SoundVolumeOverall);
		}

		if (damage > 0)
		{
			attributes.Hitpoints = ::Math.round(this.getHitpoints() - damage);
		}

		local fatalityType = ::Const.FatalityType.None;

		if (this.getHitpoints() <= 0)
		{
			if (_skill != null)
			{
				if (_skill.getChanceDecapitate() >= 100 || _hitInfo.BodyPart == ::Const.BodyPart.Head && ::Math.rand(1, 100) <= _skill.getChanceDecapitate() * _hitInfo.FatalityChanceMult)
				{
					fatalityType = ::Const.FatalityType.Decapitated;
				}
				else if (_skill.getChanceSmash() >= 100 || _hitInfo.BodyPart == ::Const.BodyPart.Head && ::Math.rand(1, 100) <= _skill.getChanceSmash() * _hitInfo.FatalityChanceMult)
				{
					fatalityType = ::Const.FatalityType.Smashed;
				}
				else if (_skill.getChanceDisembowel() >= 100 || _hitInfo.BodyPart == ::Const.BodyPart.Body && ::Math.rand(1, 100) <= _skill.getChanceDisembowel() * _hitInfo.FatalityChanceMult)
				{
					fatalityType = ::Const.FatalityType.Disemboweled;
				}
			}
		}

		if (_hitInfo.DamageDirect < 1.0)
		{
			local overflowDamage = _hitInfo.DamageArmor;
			local currentArmor = this.getArmor(_hitInfo.BodyPart);

			if (currentArmor != 0)
			{
				local overflowDamage = _hitInfo.DamageArmor - this.m.Armor.Condition;

				if (overflowDamage > 0)
				{
					attributes.Armor[_hitInfo.BodyPart] = ::Math.max(0, attributes.Armor[_hitInfo.BodyPart] - overflowDamage);
				}
				else 
				{
					this.m.Armor.Condition = ::Math.max(0, this.m.Armor.Condition - _hitInfo.DamageArmor);
				}

				::Tactical.EventLog.logEx("[color=#1e468f]" + this.m.Mount.getName() + "[/color]\'s armor is hit for [b]" + ::Math.floor(_hitInfo.DamageArmor) + "[/b] damage");
			}
		}

		if (rider.getFaction() == ::Const.Faction.Player && _attacker != null && _attacker.isAlive())
		{
			::Tactical.getCamera().quake(_attacker, rider, 5.0, 0.16, 0.3);
		}

		if (damage <= 0 && armorDamage >= 0)
		{
			if (!rider.isHiddenToPlayer() && _attacker != null && _attacker.isAlive())
			{
				local layers = this.m.ShakeLayers[_hitInfo.BodyPart];
				local recoverMult = 1.0;
				::Tactical.getShaker().cancel(rider);
				::Tactical.getShaker().shake(rider, _attacker.getTile(), 2, ::Const.Combat.ShakeEffectArmorHitColor, ::Const.Combat.ShakeEffectArmorHitHighlight, ::Const.Combat.ShakeEffectArmorHitFactor, ::Const.Combat.ShakeEffectArmorSaturation, layers, recoverMult);
			}

			rider.getSkills().update();
			rider.setDirty(true);
			return 0;
		}

		if (damage >= ::Const.Combat.SpawnBloodMinDamage)
		{
			rider.spawnBloodDecals(rider.getTile());
		}

		if (this.getHitpoints() <= 0)
		{
			rider.spawnBloodDecals(rider.getTile());
			rider.playSound(::Const.Sound.ActorEvent.Other2, ::Const.Sound.Volume.Actor * 0.7 * rider.m.SoundVolumeOverall, rider.m.SoundPitch);
			this.killMount(_attacker, _skill, fatalityType);
		}
		else
		{
			if (damage >= ::Const.Combat.SpawnBloodEffectMinDamage)
			{
				local mult = ::Math.maxf(0.75, ::Math.minf(2.0, damage / this.getHitpointsMax() * 3.0));
				rider.spawnBloodEffect(rider.getTile(), mult);
			}

			if (::Tactical.State.getStrategicProperties() != null && ::Tactical.State.getStrategicProperties().IsArenaMode && _attacker != null && _attacker.getID() != rider.getID())
			{
				local mult = damage / this.getHitpointsMax();

				if (mult >= 0.75)
				{
					::Sound.play(::Const.Sound.ArenaBigHit[::Math.rand(0, ::Const.Sound.ArenaBigHit.len() - 1)], ::Const.Sound.Volume.Tactical * ::Const.Sound.Volume.Arena);
				}
				else if (mult >= 0.25 || ::Math.rand(1, 100) <= 20)
				{
					::Sound.play(::Const.Sound.ArenaHit[::Math.rand(0, ::Const.Sound.ArenaHit.len() - 1)], ::Const.Sound.Volume.Tactical * ::Const.Sound.Volume.Arena);
				}
			}
			
			if (damage > 0 && !rider.isHiddenToPlayer())
			{
				::Tactical.EventLog.logEx("[color=#1e468f]" + this.m.Mount.getName() + "[/color]\'s " + ::Const.Strings.BodyPartName[_hitInfo.BodyPart] + " is hit for [b]" + ::Math.floor(damage) + "[/b] damage");
			}

			if (rider.m.MoraleState != ::Const.MoraleState.Ignore && damage > ::Const.Morale.OnHitMinDamage && rider.getCurrentProperties().IsAffectedByLosingHitpoints)
			{
				if (!rider.isPlayerControlled() || !rider.m.Skills.hasSkill("effects.berserker_mushrooms"))
				{
					rider.checkMorale(-1, ::Const.Morale.OnHitBaseDifficulty * (1.0 - this.getHitpointsPct()) + 25 - (_attacker != null && _attacker.getID() != rider.getID() ? _attacker.getCurrentProperties().ThreatOnHit : 0), ::Const.MoraleCheckType.Default, "", true);
				}
			}

			rider.getSkills().onAfterDamageReceived();

			if (damage >= ::Const.Combat.PlayPainSoundMinDamage && rider.m.Sound[::Const.Sound.ActorEvent.Other1].len() > 0)
			{
				local volume = 1.0;

				if (damage < ::Const.Combat.PlayPainVolumeMaxDamage)
				{
					volume = damage / ::Const.Combat.PlayPainVolumeMaxDamage;
				}

				rider.playSound(::Const.Sound.ActorEvent.Other1, ::Const.Sound.Volume.Actor * rider.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] * rider.m.SoundVolumeOverall * volume, rider.m.SoundPitch);
			}

			rider.getSkills().update();
			this.updateAppearance();
			this.updateInjuryLayer();

			if (!rider.isHiddenToPlayer() && _attacker != null && _attacker.isAlive())
			{
				local layers = this.m.ShakeLayers[_hitInfo.BodyPart];
				local recoverMult = ::Math.minf(1.5, ::Math.maxf(1.0, damage * 2.0 / this.getHitpointsMax()));
				::Tactical.getShaker().cancel(rider);
				::Tactical.getShaker().shake(rider, _attacker.getTile(), 2, ::Const.Combat.ShakeEffectHitpointsHitColor, ::Const.Combat.ShakeEffectHitpointsHitHighlight, ::Const.Combat.ShakeEffectHitpointsHitFactor, ::Const.Combat.ShakeEffectHitpointsSaturation, layers, recoverMult);
			}

			rider.setDirty(true);
		}

		return damage;
	}

	function killMount( _killer, _skill, _fatalityType )
	{
		if (_killer != null && !_killer.isAlive())
		{
			_killer = null;
		}

		local rider = this.m.Actor;

		if (typeof rider == "instance")
		{
			rider = rider.get();
		}

		local myTile = rider.isPlacedOnMap() ? rider.getTile() : null;
		local tile = rider.findTileToSpawnCorpse(_killer);
		::Tactical.EventLog.logEx("[color=#1e468f]" + this.m.Mount.getName() + "[/color] is killed");
		this.spawnDeadMount( _killer, _skill, tile, _fatalityType);

		if (!::Tactical.State.isFleeing() && _killer != null)
		{
			_killer.onActorKilled(rider, tile, _skill);
		}

		if (!::Tactical.State.isFleeing() && myTile != null)
		{
			foreach( i in ::Tactical.Entities.getAllInstances() )
			{
				foreach( a in i )
				{
					if (a.getID() != rider.getID())
					{
						a.onOtherActorDeath(_killer, rider, _skill);
					}
				}
			}
		}

		if (!::Tactical.State.isScenarioMode())
		{
			if (::Tactical.State.getStrategicProperties() != null && ::Tactical.State.getStrategicProperties().IsArenaMode)
			{
				if (_killer == null)
				{
					::Sound.play(::Const.Sound.ArenaFlee[::Math.rand(0, ::Const.Sound.ArenaFlee.len() - 1)], ::Const.Sound.Volume.Tactical * ::Const.Sound.Volume.Arena);
				}
				else
				{
					::Sound.play(::Const.Sound.ArenaKill[::Math.rand(0, ::Const.Sound.ArenaKill.len() - 1)], ::Const.Sound.Volume.Tactical * ::Const.Sound.Volume.Arena);
				}
			}
		}

		if (rider.isAlive() && !rider.isDying())
		{
			if (!rider.getCurrentProperties().IsImmuneToDaze && ::Math.rand(1, 100) <= 50)
			{
				rider.getSkills().add(::new("scripts/skills/effects/dazed_effect"));

				if (!rider.isHiddenToPlayer())
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(rider) + " is dazed for one turn due to falling from your mount");
				}
			}
			else
			{
				rider.getSkills().add(::new("scripts/skills/effects/staggered_effect"));

				if (!rider.isHiddenToPlayer())
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(rider) + " is staggered for one turn due to falling from your mount");
				}
			}

			if (rider.getCurrentProperties().IsAffectedByDyingAllies)
			{
				rider.worsenMood(0.5, "My mount, [color=#1e468f]" + this.m.Mount.getName() + "[/color] died in battle");
			}
		}

		if (this.m.Mount != null && !this.m.Mount.isNull())
		{
			this.m.Mount.setEntity(null);

			if (this.m.Actor != null)
			{
				if (this.m.Mount.getCurrentSlotType() == ::Const.ItemSlot.Bag)
				{
					this.m.Actor.getItems().removeFromBag(this.m.Mount.get());
				}
				else
				{
					this.m.Actor.getItems().unequip(this.m.Mount.get());
				}
			}
		}
	}

	function spawnDeadMount( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile == null)
		{
			return;
		}
		
		local isSpider = this.getMountType() == ::Const.GoblinRider.Mounts.Spider;
		local appearance = this.getAppearance();
		local flip = ::Math.rand(0, 100) < 50;
		local isCorpseFlipped = flip;
		local decal = _tile.spawnDetail(appearance.Corpse, ::Const.Tactical.DetailFlag.Corpse, flip);
		decal.setBrightness(0.9);
		decal.Scale = 0.95;
		local body_decal = decal;
		local head_decal;

		if (appearance.CorpseArmor != "")
		{
			decal = _tile.spawnDetail(appearance.CorpseArmor, ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.setBrightness(0.9);
			decal.Scale = 0.95;
		}

		if (isSpider && _fatalityType != ::Const.FatalityType.Decapitated)
		{
			decal = _tile.spawnDetail("bust_spider_head_01_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = head.Color;
			decal.Saturation = head.Saturation;
			decal.Scale = 0.95;
			head_decal = decal;

			if (_fatalityType == ::Const.FatalityType.None)
			{
				local corpse_data = {
					Body = body_decal,
					Head = head_decal,
					Start = ::Time.getRealTimeF(),
					Vector = ::createVec(0.0, -1.0),
					Iterations = 0,
					function onCorpseEffect( _data )
					{
						if (::Time.getRealTimeF() - _data.Start > 0.2)
						{
							if (++_data.Iterations > 5)
							{
								return;
							}

							_data.Vector = ::createVec(::Math.rand(-100, 100) * 0.01, ::Math.rand(-100, 100) * 0.01);
							_data.Start = ::Time.getRealTimeF();
						}

						local f = (::Time.getRealTimeF() - _data.Start) / 0.2;
						_data.Body.setOffset(::createVec(0.0 + 0.5 * _data.Vector.X * f, 30.0 + 1.0 * _data.Vector.Y * f));
						_data.Head.setOffset(::createVec(0.0 + 0.5 * _data.Vector.X * f, 30.0 + 1.0 * _data.Vector.Y * f));
						::Time.scheduleEvent(::TimeUnit.Real, 10, _data.onCorpseEffect, _data);
					}

				};
				::Time.scheduleEvent(::TimeUnit.Real, 10, corpse_data.onCorpseEffect, corpse_data);
			}
		}
		else if (_fatalityType != ::Const.FatalityType.Decapitated)
		{
			decal = _tile.spawnDetail(appearance.CorpseHead, ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.setBrightness(0.9);
			decal.Scale = 0.95;

			if (appearance.Extra != "" && ::doesBrushExist(appearance.Extra + "_dead"))
			{
				decal = _tile.spawnDetail(appearance.Extra + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
		}
		else if (_fatalityType == ::Const.FatalityType.Decapitated) 
		{
			local layers = [
				appearance.CorpseHead
			];

			if (appearance.Extra != "" && ::doesBrushExist(appearance.Extra + "_dead"))
			{
				layers.push(appearance.Extra + "_dead");
			}

			local bloodpool = appearance.Bloodpool == "" ? "bust_wolf_head_bloodpool" : appearance.Bloodpool;
			local decap = ::Tactical.spawnHeadEffect(this.m.Actor.getTile(), layers, ::createVec(-20, 15), 0.0, bloodpool);
			decap[0].setBrightness(0.9);
			decap[0].Scale = 0.95;
		}
		else if (!isSpider && _skill && _skill.getProjectileType() == ::Const.ProjectileType.Arrow)
		{
			decal = _tile.spawnDetail(appearance.Body + "_dead_arrows", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Scale = 0.95;
		}
		else if (!isSpider &&_skill && _skill.getProjectileType() == ::Const.ProjectileType.Javelin)
		{
			decal = _tile.spawnDetail(appearance.Body + "_dead_javelin", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Scale = 0.95;
		}

		this.m.Actor.spawnTerrainDropdownEffect(_tile);
		local corpse = clone ::Const.Corpse;
		corpse.CorpseName = this.m.Mount.getName();
		corpse.IsHeadAttached = _fatalityType != ::Const.FatalityType.Decapitated;
		corpse.IsResurrectable = false;
		_tile.Properties.set("Corpse", corpse);
		::Tactical.Entities.addCorpse(_tile);
	}

	function onActorDied( _onTile )
	{
		this.m.IsUpdating = true;

		if (!this.isMounted())
		{
			return;
		}

		local e = this.m.Mount.m.Entity;

		if (e != null)
		{
			local b = e.getBaseProperties();
			local armor = e.getItems().getItemAtSlot(::Const.ItemSlot.Body);
			local attr = this.getAttributes();
			local hpLeft = this.getHitpointsPct();
			e.setHitpointsPct(hpLeft);
			b.Armor = attr.Armor;
			b.ArmorMax = attr.ArmorMax;

			if (armor != null)
			{
				armor.setArmor(this.m.Armor.Condition);
			}

			e.m.CurrentProperties = clone b;
			e.getSkills().update();
		}

		this.m.IsUpdating = false;
	}

	function onDismountPet()
	{
		this.m.IsUpdating = true;

		if (!this.isMounted())
		{
			return;
		}

		local e = this.m.Mount.m.Entity;

		if (e != null)
		{
			local b = e.getBaseProperties();
			local armor = e.getItems().getItemAtSlot(::Const.ItemSlot.Body);
			local attr = this.getAttributes();
			local hpLeft = this.getHitpointsPct();
			e.setHitpointsPct(hpLeft);
			b.Armor = attr.Armor;
			b.ArmorMax = attr.ArmorMax;

			if (armor != null)
			{
				armor.setArmor(this.m.Armor.Condition);
			}

			e.m.CurrentProperties = clone b;
			e.getSkills().update();
		}

		this.m.IsReleased = true;

		if (this.m.Actor != null && !this.m.Actor.isNull() && this.m.Actor.isAlive() && !this.m.Actor.isDying())
		{
			this.clearSkills();
			this.m.Actor.getSkills().removeByID("special.nggh_mounted_charge");
			this.m.Actor.getSkills().update();
			this.m.Actor.getItems().updateAppearance();
		}

		this.m.IsUpdating = false;
	}

	function applyingAttributes( _attr = null )
	{
		local key = ::Const.GoblinRiderMounts[this.m.MountType].Attributes;

		if (_attr == null)
		{
			_attr = ::Const.Tactical.Actor[key];
		}

		this.setAttributes(_attr);
		this.m.Attributes.HitpointsMax = this.m.Attributes.Hitpoints;
		this.m.IsRegenHealth = false;

		if (::Is_AccessoryCompanions_Exist)
		{
			local attr = {
				Hitpoints = 0,
				HitpointsMax = 0,
			};

			local healthPercentage = (100.0 - this.m.Mount.m.Wounds) / 100.0;
			attr.HitpointsMax = this.m.Mount.getAttributes().Hitpoints;
			attr.Hitpoints =  ::Math.max(1, ::Math.floor(healthPercentage * attr.HitpointsMax));

			foreach( i, quirk in this.m.Mount.getQuirks() )
			{
				if (quirk == "scripts/companions/quirks/companions_healthy")
				{
					attr.Hitpoints += 25;
					attr.HitpointsMax += 25;
				}
				else if (quirk == "scripts/skills/perks/perk_colossus")
				{
					attr.Hitpoints = ::Math.round(attr.Hitpoints * 1.25);
					attr.HitpointsMax = ::Math.round(attr.HitpointsMax * 1.25);
				}
			}

			this.m.IsRegenHealth = this.m.Mount.getQuirks().find("scripts/companions/quirks/companions_regenerative") != null;
			this.setAttributes(attr);
		}
	}

	function onTurnStart()
	{
		if (this.m.IsRegenHealth && this.isMounted())
		{
			local healthMissing = this.getHitpointsMax() - this.getHitpoints();
			local healthAdded = ::Math.min(healthMissing, ::Math.floor(this.getHitpointsMax() * 0.1));

			if (healthAdded <= 0)
			{
				return;
			}

			this.setHitpoints(this.getHitpoints() + healthAdded);
				
			if (this.m.Actor.getTile().IsVisibleForPlayer)
			{
				::Tactical.EventLog.log("[color=#1e468f]" + this.m.Mount.getName() + "[/color] heals for " + healthAdded + " points");
				::Tactical.spawnIconEffect("status_effect_79", this.m.Actor.getTile(), ::Const.Tactical.Settings.SkillIconOffsetX, ::Const.Tactical.Settings.SkillIconOffsetY, ::Const.Tactical.Settings.SkillIconScale, ::Const.Tactical.Settings.SkillIconFadeInDuration, ::Const.Tactical.Settings.SkillIconStayDuration, ::Const.Tactical.Settings.SkillIconFadeOutDuration, ::Const.Tactical.Settings.SkillIconMovement);
			}
		}
	}

	function onLeashMount()
	{
		this.m.IsReleased = false;

		if (this.isMounted())
		{
			if (this.m.Skills.len() == 0)
			{
				this.addSkills();
			}

			this.applyingAttributes();

			local e = this.m.Mount.m.Entity;

			if (e != null)
			{
				local healthPercentage = e.getHitpointsPct();
				this.setHitpointsPct(healthPercentage);
			}
			
			this.m.Actor.getSkills().add(::new("scripts/skills/special/nggh_mod_mounted_charge_effect"));
			this.m.Actor.getItems().updateAppearance();
		}
	}

	function getMountTooltip()
	{
		return [
			{
				id = 4,
				type = "progressbar",
				icon = "ui/icons/armor_head.png",
				value = this.getArmor(::Const.BodyPart.Head),
				valueMax = this.getArmorMax(::Const.BodyPart.Head),
				text = "" + this.getArmor(::Const.BodyPart.Head) + " / " + this.getArmorMax(::Const.BodyPart.Head) + "",
				style = "armor-head-slim"
			},
			{
				id = 5,
				type = "progressbar",
				icon = "ui/icons/armor_body.png",
				value = this.getArmor(::Const.BodyPart.Body),
				valueMax = this.getArmorMax(::Const.BodyPart.Body),
				text = "" + this.getArmor(::Const.BodyPart.Body) + " / " + this.getArmorMax(::Const.BodyPart.Body) + "",
				style = "armor-body-slim"
			},
			{
				id = 6,
				type = "progressbar",
				icon = "ui/icons/health.png",
				value = this.getHitpoints(),
				valueMax = this.getHitpointsMax(),
				text = "" + this.getHitpoints() + " / " + this.getHitpointsMax() + "",
				style = "hitpoints-slim"
			}
		];
	}

	function onCombatStarted()
	{
		this.m.IsInBattle = true;

		if (this.isMounted())
		{
			this.applyingAttributes();
			this.m.Actor.onUpdateInjuryLayer();
			this.m.Actor.getSkills().add(::new("scripts/skills/special/nggh_mod_mounted_charge_effect"));
			this.m.Actor.getItems().updateAppearance();
		}
	}

	function onCombatFinished()
	{
		this.m.IsInBattle = false;
		this.m.IsReleased = false;

		if (this.isMounted())
		{
			if (this.m.Skills.len() == 0)
			{
				this.addSkills();
			}

			if (::Is_AccessoryCompanions_Exist)
			{
				local lossPct = ::Math.floor((1 - this.getHitpointsPct()) * 100);
				this.getMount().setWounds(lossPct);
			}

			this.m.Actor.onUpdateInjuryLayer();
			this.m.Actor.getItems().updateAppearance();
		}
	}

	function onUnequip()
	{
		this.clearFlags();
		this.clearSkills();
		this.m.Mount = null;
		this.m.MountType = null;
		this.m.IsRegenHealth = false;
		this.m.Armor = {
			Condition = 0,
			ConditionMax = 0,
			StaminaModifier = 0,
		};
		this.m.Appearance = {
			HideArmor = false,
			Flipping = false,
			Scale = 1.0,
			Body = "",
			Head = "",
			Extra = "",
			Extra1 = "",
			Extra2 = "",
			Injury = "",
			Armor = "",
			ArmorDamage = "",
			Restrain = "",
			Corpse = "",
			CorpseHead = "",
			CorpseArmor = "",
			Bloodpool = "",
			OldSounds = []
		};
		this.m.Attributes.clearAll();
	}

};

