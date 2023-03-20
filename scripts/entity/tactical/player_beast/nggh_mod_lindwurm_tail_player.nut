this.nggh_mod_lindwurm_tail_player <- ::inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {
		Body = null,
		Racial = null,
		IsStollWurm = false,
		IsUsingDefaultStats = false,
	},

	function setBody( _b )
	{
		if (_b == null)
		{
			this.m.Body = null;
		}
		else
		{
			if (typeof _b == "instance")
			{
				this.m.Body = _b;
			}
			else
			{
				this.m.Body = ::WeakTableRef(_b);
			}
		}
	}

	function getBody()
	{
		return this.m.Body;
	}
	
	function isSummoned()
	{
		return true;
	}
	
	function getBackground()
	{
		return this.m.Body != null ? this.m.Body.getBackground() : null;
	}
	
	function getBaseProperties()
	{
		return this.m.Body.getBaseProperties();
	}

	function getCurrentProperties()
	{
		return this.m.Body.getCurrentProperties();
	}

	function setCurrentProperties( _c )
	{
		this.m.Body.setCurrentProperties(_c);
	}

	function getTalents()
	{
		return this.m.Body != null ? this.m.Body.getTalents() : [0, 0, 0, 0, 0, 0, 0, 0];
	}

	function getItems()
	{
		return this.m.Body != null ? this.m.Body.getItems() : this.m.Items;
	}

	function getHitpoints()
	{
		return this.m.Body != null ? this.m.Body.getHitpoints() : 0;
	}

	function getHitpointsMax()
	{
		return this.m.Body != null ? this.m.Body.getHitpointsMax() : 0;
	}

	function getHitpointsPct()
	{
		return this.m.Body != null ? this.m.Body.getHitpointsPct() : 0.0;
	}

	function setHitpoints( _h )
	{
		this.m.Body.setHitpoints(_h);
	}

	function setHitpointsPct( _h )
	{
		this.m.Body.setHitpointsPct(_h);
	}

	function getMoraleState()
	{
		return this.m.Body != null ? this.m.Body.getMoraleState() : 0;
	}

	function setMaxMoraleState( _s )
	{
		this.m.Body.setMaxMoraleState(_s);
	}

	function getBravery()
	{
		return this.m.Body != null ? this.m.Body.getBravery() : 0;
	}

	function getFatigue()
	{
		return this.m.Body != null ? this.m.Body.getFatigue() : 0;
	}

	function getFatigueMax()
	{
		return this.m.Body != null ? this.m.Body.getFatigueMax() : 0;
	}

	function setFatigue( _f )
	{
		this.m.Body.setFatigue(_f);
	}

	function getInitiative()
	{
		return this.m.Body != null ? this.m.Body.getInitiative() - 1 : 0;
	}

	function getXPValue()
	{
		return this.m.Body != null ? this.m.Body.getXPValue() : 0;
	}

	function getHitpointsState()
	{
		return this.m.Body.getHitpointsState();
	}

	function getFatigueState()
	{
		return this.m.Body.getFatigueState();
	}

	function getArmorState( _bodyPart )
	{
		return this.m.Body.getArmorState(_bodyPart);
	}

	function getArmor( _bodyPart )
	{
		return this.m.Body != null ? this.m.Body.getArmor(_bodyPart) : 0;
	}

	function getArmorMax( _bodyPart )
	{
		return this.m.Body != null ? this.m.Body.getArmorMax(_bodyPart) : 0;
	}

	function getWorldTroop()
	{
		return this.m.Body != null ? this.m.Body.getWorldTroop() : null;
	}

	function getCombatStats()
	{
		return this.m.Body != null ? this.m.Body.getCombatStats() : this.nggh_mod_player_beast.getCombatStats();
	}

	function getLifetimeStats()
	{
		return this.m.Body != null ? this.m.Body.getLifetimeStats() : this.nggh_mod_player_beast.getLifetimeStats();
	}

	function getIdealRange()
	{
		return 1;
	}

	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.Name = "Lindwurm Tail";
		this.m.BloodType = ::Const.BloodType.Green;
		this.m.BloodSplatterOffset = ::createVec(0, 0);
		this.m.DecapitateSplatterOffset = ::createVec(-10, -25);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/lindwurm_fleeing_01.wav",
			"sounds/enemies/lindwurm_fleeing_02.wav",
			"sounds/enemies/lindwurm_fleeing_03.wav",
			"sounds/enemies/lindwurm_fleeing_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/lindwurm_hurt_01.wav",
			"sounds/enemies/lindwurm_hurt_02.wav",
			"sounds/enemies/lindwurm_hurt_03.wav",
			"sounds/enemies/lindwurm_hurt_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/lindwurm_idle_01.wav",
			"sounds/enemies/lindwurm_idle_02.wav",
			"sounds/enemies/lindwurm_idle_03.wav",
			"sounds/enemies/lindwurm_idle_04.wav",
			"sounds/enemies/lindwurm_idle_05.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/lindwurm_flee_01.wav",
			"sounds/enemies/lindwurm_flee_02.wav",
			"sounds/enemies/lindwurm_flee_03.wav",
			"sounds/enemies/lindwurm_flee_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/lindwurm_death_01.wav",
			"sounds/enemies/lindwurm_death_02.wav",
			"sounds/enemies/lindwurm_death_03.wav",
			"sounds/enemies/lindwurm_death_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc2/krake_idle_13.wav",
			"sounds/enemies/dlc2/krake_idle_14.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Attack] = this.m.Sound[::Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] = 1.5;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Attack] = 2.0;
		this.m.SoundPitch = ::Math.rand(95, 105) * 0.01;
		this.m.Flags.add("body_immune_to_acid");
		this.m.Flags.add("head_immune_to_acid");
		this.m.Flags.add("lindwurm");
		this.m.Flags.add("tail");

		// add an additional behavior 
		this.m.AIAgent.addBehavior(::new("scripts/ai/tactical/behaviors/ai_move_tail_player"));
	}

	function playAttackSound()
	{
		this.playSound(::Const.Sound.ActorEvent.Attack, ::Const.Sound.Volume.Actor * this.m.SoundVolume[::Const.Sound.ActorEvent.Attack] * (::Math.rand(75, 100) * 0.01), this.m.SoundPitch * 1.15);
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		if (!this.isAlive() || !this.isPlacedOnMap())
		{
			return 0;
		}

		if (_hitInfo.DamageRegular == 0 && _hitInfo.DamageArmor == 0)
		{
			return 0;
		}

		if (typeof _attacker == "instance")
		{
			_attacker = _attacker.get();
		}

		_hitInfo.BodyPart = ::Const.BodyPart.Body;

		if (_attacker != null && _attacker.isAlive() && _attacker.isPlayerControlled() && !this.isPlayerControlled())
		{
			this.setDiscovered(true);
			this.getTile().addVisibilityForFaction(::Const.Faction.Player);
			this.getTile().addVisibilityForCurrentEntity();
		}

		local self = this.getBody();
		local p = self.getSkills().buildPropertiesForBeingHit(_attacker, _skill, _hitInfo);
		this.getItems().onBeforeDamageReceived(_attacker, _skill, _hitInfo, p);
		local dmgMult = p.DamageReceivedTotalMult;

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
			armor = p.Armor[_hitInfo.BodyPart] * p.ArmorMult[_hitInfo.BodyPart];
			armorDamage = ::Math.min(armor, _hitInfo.DamageArmor);
			armor = armor - armorDamage;
			_hitInfo.DamageInflictedArmor = ::Math.max(0, armorDamage);
		}

		_hitInfo.DamageFatigue *= p.FatigueEffectMult;
		this.setFatigue(::Math.min(this.getFatigueMax(), ::Math.round(this.getFatigue() + _hitInfo.DamageFatigue * p.FatigueReceivedPerHitMult)));
		local damage = 0;
		damage = damage + ::Math.maxf(0.0, _hitInfo.DamageRegular * _hitInfo.DamageDirect * p.DamageReceivedDirectMult - armor * ::Const.Combat.ArmorDirectDamageMitigationMult);

		if (armor <= 0 || _hitInfo.DamageDirect >= 1.0)
		{
			damage = damage + ::Math.max(0, _hitInfo.DamageRegular * ::Math.maxf(0.0, 1.0 - _hitInfo.DamageDirect * p.DamageReceivedDirectMult) - armorDamage);
		}

		damage = damage * _hitInfo.BodyDamageMult;
		damage = ::Math.max(0, ::Math.max(::Math.round(damage), ::Math.min(::Math.round(_hitInfo.DamageMinimum), ::Math.round(_hitInfo.DamageMinimum * p.DamageReceivedTotalMult))));
		_hitInfo.DamageInflictedHitpoints = damage;
		self.m.Skills.onDamageReceived(_attacker, _hitInfo.DamageInflictedHitpoints, _hitInfo.DamageInflictedArmor);
		this.m.Skills.onDamageReceived(_attacker, _hitInfo.DamageInflictedHitpoints, _hitInfo.DamageInflictedArmor);
		//this.m.Racial.onDamageReceived(_attacker, _hitInfo.DamageInflictedHitpoints, _hitInfo.DamageInflictedArmor);

		if (armorDamage > 0 && !this.isHiddenToPlayer() && _hitInfo.IsPlayingArmorSound)
		{
			local armorHitSound = this.getItems().getAppearance().ImpactSound[_hitInfo.BodyPart];

			if (armorHitSound.len() > 0)
			{
				::Sound.play(armorHitSound[::Math.rand(0, armorHitSound.len() - 1)], ::Const.Sound.Volume.ActorArmorHit, this.getPos());
			}

			if (damage < ::Const.Combat.PlayPainSoundMinDamage)
			{
				this.playSound(::Const.Sound.ActorEvent.NoDamageReceived, ::Const.Sound.Volume.Actor * this.m.SoundVolume[::Const.Sound.ActorEvent.NoDamageReceived] * this.m.SoundVolumeOverall);
			}
		}

		if (damage > 0)
		{
			if (!this.m.IsAbleToDie && damage >= this.getHitpoints())
			{
				this.setHitpoints(1);
			}
			else
			{
				this.setHitpoints(this.getHitpoints() - damage);
			}
		}

		if (this.getHitpoints() <= 0)
		{
			local lorekeeperPotionEffect = self.m.Skills.getSkillByID("effects.lorekeeper_potion");

			if (lorekeeperPotionEffect != null && (!lorekeeperPotionEffect.isSpent() || lorekeeperPotionEffect.getLastFrameUsed() == this.Time.getFrame()))
			{
				self.getSkills().removeByType(::Const.SkillType.DamageOverTime);
				this.getSkills().removeByType(::Const.SkillType.DamageOverTime);
				this.setHitpoints(this.getHitpointsMax());
				lorekeeperPotionEffect.setSpent(true);
				::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(self) + " is reborn by the power of the Lorekeeper!");
			}
			else
			{
				local nineLivesSkill = self.m.Skills.getSkillByID("perk.nine_lives");

				if (nineLivesSkill != null && (!nineLivesSkill.isSpent() || nineLivesSkill.getLastFrameUsed() == ::Time.getFrame()))
				{
					self.getSkills().removeByType(::Const.SkillType.DamageOverTime);
					this.getSkills().removeByType(::Const.SkillType.DamageOverTime);
					this.setHitpoints(::Math.rand(11, 15));
					nineLivesSkill.setSpent(true);
					::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(self) + " has nine lives!");
				}
			}
		}

		local fatalityType = ::Const.FatalityType.None;

		if (this.getHitpoints() <= 0)
		{
			this.m.IsDying = true;

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

			if (this.getBaseProperties().Armor[_hitInfo.BodyPart] != 0)
			{
				overflowDamage = overflowDamage - this.getBaseProperties().Armor[_hitInfo.BodyPart] * this.getBaseProperties().ArmorMult[_hitInfo.BodyPart];
				this.getBaseProperties().Armor[_hitInfo.BodyPart] = ::Math.max(0, this.getBaseProperties().Armor[_hitInfo.BodyPart] * this.getBaseProperties().ArmorMult[_hitInfo.BodyPart] - _hitInfo.DamageArmor);
				::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(self) + "\'s armor is hit for [b]" + ::Math.floor(_hitInfo.DamageArmor) + "[/b] damage");
			}

			if (overflowDamage > 0)
			{
				this.getItems().onDamageReceived(overflowDamage, fatalityType, _hitInfo.BodyPart, _attacker);
			}
		}

		if (this.getFaction() == ::Const.Faction.Player && _attacker != null && _attacker.isAlive())
		{
			::Tactical.getCamera().quake(_attacker, this, 5.0, 0.16, 0.3);
		}

		if (damage <= 0 && armorDamage >= 0)
		{
			if ((this.m.IsFlashingOnHit || this.getCurrentProperties().IsStunned || this.getCurrentProperties().IsRooted) && !this.isHiddenToPlayer() && _attacker != null && _attacker.isAlive())
			{
				local layers = this.m.ShakeLayers[_hitInfo.BodyPart];
				local recoverMult = 1.0;
				::Tactical.getShaker().cancel(this);
				::Tactical.getShaker().shake(this, _attacker.getTile(), this.m.IsShakingOnHit ? 2 : 3, ::Const.Combat.ShakeEffectArmorHitColor, ::Const.Combat.ShakeEffectArmorHitHighlight, ::Const.Combat.ShakeEffectArmorHitFactor, ::Const.Combat.ShakeEffectArmorSaturation, layers, recoverMult);
			}

			this.m.Skills.update();
			self.m.Skills.update();
			this.setDirty(true);
			return 0;
		}

		if (damage >= ::Const.Combat.SpawnBloodMinDamage)
		{
			this.spawnBloodDecals(this.getTile());
		}

		if (this.getHitpoints() <= 0)
		{
			this.spawnBloodDecals(this.getTile());
			this.kill(_attacker, _skill, fatalityType);
		}
		else
		{
			if (damage >= ::Const.Combat.SpawnBloodEffectMinDamage)
			{
				local mult = ::Math.maxf(0.75, ::Math.minf(2.0, damage / this.getHitpointsMax() * 3.0));
				this.spawnBloodEffect(this.getTile(), mult);
			}

			if (::Tactical.State.getStrategicProperties() != null && ::Tactical.State.getStrategicProperties().IsArenaMode && _attacker != null && _attacker.getID() != this.getID())
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

			if (this.getCurrentProperties().IsAffectedByInjuries && this.m.IsAbleToDie && damage >= ::Const.Combat.InjuryMinDamage && this.getCurrentProperties().ThresholdToReceiveInjuryMult != 0 && _hitInfo.InjuryThresholdMult != 0 && _hitInfo.Injuries != null)
			{
				local potentialInjuries = [];
				local bonus = 1.0;

				foreach( inj in _hitInfo.Injuries )
				{
					if (inj.Threshold * _hitInfo.InjuryThresholdMult * ::Const.Combat.InjuryThresholdMult * this.getCurrentProperties().ThresholdToReceiveInjuryMult * bonus <= damage / (this.getHitpointsMax() * 1.0))
					{
						if (!self.getSkills().hasSkill(inj.ID) && this.m.ExcludedInjuries.find(inj.ID) == null)
						{
							potentialInjuries.push(inj.Script);
						}
					}
				}

				local appliedInjury = false;

				while (potentialInjuries.len() != 0)
				{
					local r = ::Math.rand(0, potentialInjuries.len() - 1);
					local injury = ::new("scripts/skills/" + potentialInjuries[r]);

					if (injury.isValid(this))
					{
						self.getSkills().add(injury);

						if (this.isPlayerControlled() && ::isKindOf(this, "player"))
						{
							self.worsenMood(::Const.MoodChange.Injury, "Suffered an injury");

							if (("State" in ::World) && ::World.State != null && ::World.Ambitions.hasActiveAmbition() && ::World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_sacrifice")
							{
								::World.Statistics.getFlags().increment("OathtakersInjuriesSuffered");
							}
						}

						if (this.isPlayerControlled() || !this.isHiddenToPlayer())
						{
							::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(self) + "\'s " + ::Const.Strings.BodyPartName[_hitInfo.BodyPart] + " is hit for [b]" + ::Math.floor(damage) + "[/b] damage and suffers " + injury.getNameOnly() + "!");
						}

						appliedInjury = true;
						break;
					}
					else
					{
						potentialInjuries.remove(r);
					}
				}

				if (!appliedInjury)
				{
					if (damage > 0 && !this.isHiddenToPlayer())
					{
						::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(self) + "\'s " + ::Const.Strings.BodyPartName[_hitInfo.BodyPart] + " is hit for [b]" + ::Math.floor(damage) + "[/b] damage");
					}
				}
			}
			else if (damage > 0 && !this.isHiddenToPlayer())
			{
				::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(self) + "\'s " + ::Const.Strings.BodyPartName[_hitInfo.BodyPart] + " is hit for [b]" + ::Math.floor(damage) + "[/b] damage");
			}

			if (this.getMoraleState() != ::Const.MoraleState.Ignore && damage > ::Const.Morale.OnHitMinDamage && this.getCurrentProperties().IsAffectedByLosingHitpoints)
			{
				if (this.m.Skills.hasSkill("effects.berserker_mushrooms"))
				{
				}
				else if (self.getSkills().hasSkill("effects.berserker_mushrooms"))
				{
				}
				else if (!this.isPlayerControlled())
				{
					this.checkMorale(-1, ::Const.Morale.OnHitBaseDifficulty * (1.0 - this.getHitpoints() / this.getHitpointsMax()) - (_attacker != null && _attacker.getID() != this.getID() ? _attacker.getCurrentProperties().ThreatOnHit : 0), ::Const.MoraleCheckType.Default, "", true);
				}
			}

			this.getSkills().onAfterDamageReceived();
			self.getSkills().onAfterDamageReceived();

			if (damage >= ::Const.Combat.PlayPainSoundMinDamage && this.m.Sound[::Const.Sound.ActorEvent.DamageReceived].len() > 0)
			{
				local volume = 1.0;

				if (damage < ::Const.Combat.PlayPainVolumeMaxDamage)
				{
					volume = damage / ::Const.Combat.PlayPainVolumeMaxDamage;
				}

				this.playSound(::Const.Sound.ActorEvent.DamageReceived, ::Const.Sound.Volume.Actor * this.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] * this.m.SoundVolumeOverall * volume, this.m.SoundPitch);
			}

			self.m.Skills.update();
			this.m.Skills.update();
			this.onUpdateInjuryLayer();

			if ((this.m.IsFlashingOnHit || this.getCurrentProperties().IsStunned || this.getCurrentProperties().IsRooted) && !this.isHiddenToPlayer() && _attacker != null && _attacker.isAlive())
			{
				local layers = this.m.ShakeLayers[_hitInfo.BodyPart];
				local recoverMult = ::Math.minf(1.5, ::Math.maxf(1.0, damage * 2.0 / this.getHitpointsMax()));
				::Tactical.getShaker().cancel(this);
				::Tactical.getShaker().shake(this, _attacker.getTile(), this.m.IsShakingOnHit ? 2 : 3, ::Const.Combat.ShakeEffectHitpointsHitColor, ::Const.Combat.ShakeEffectHitpointsHitHighlight, ::Const.Combat.ShakeEffectHitpointsHitFactor, ::Const.Combat.ShakeEffectHitpointsSaturation, layers, recoverMult);
			}

			this.setDirty(true);
		}

		return damage;
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			this.m.IsCorpseFlipped = ::Math.rand(0, 100) < 50;
			local body = this.getSprite("body");
			local decal = _tile.spawnDetail(this.m.IsStollWurm ? "bust_stollwurm_tail_01_dead" : "bust_lindwurm_tail_01_dead", this.Const.Tactical.DetailFlag.Corpse, this.m.IsCorpseFlipped);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;

			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone ::Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsHeadAttached = false;
			corpse.IsPlayer = true;
			corpse.Value = 10.0;
			_tile.Properties.set("Corpse", corpse);
			::Tactical.Entities.addCorpse(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function checkMorale( _change, _difficulty, _type = ::Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
	{
		this.m.Body.checkMorale(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
	}

	function kill( _killer = null, _skill = null, _fatalityType = ::Const.FatalityType.None, _silent = false )
	{
		this.actor.kill(_killer, _skill, _fatalityType, _silent);

		if (this.m.Body != null && !this.m.Body.isNull() && this.m.Body.isAlive() && !this.m.Body.isDying())
		{
			this.m.Body.kill(_killer, _skill, _fatalityType, _silent);
			this.m.Body = null;
		}
	}
	
	function onAfterFactionChanged()
	{
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
	}

	function onInit()
	{
		if (this.m.ParentID != 0)
		{
			this.setBody(::Tactical.getEntityByID(this.m.ParentID));
			this.m.BaseProperties = this.m.Body.getBaseProperties();
			this.m.Items = this.m.Body.getItems();
			this.m.Flags = this.m.Body.getFlags();
		}
		
		this.actor.onInit();

		if (this.m.Body != null && !this.m.Body.isNull())
		{
			this.m.BaseProperties = this.m.Body.getBaseProperties();
		}
		else
		{
			this.m.IsUsingDefaultStats = true;
		}
		
		local b = this.m.BaseProperties;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;

		this.addSprite("socket").setBrush("bust_base_player");
		this.addSprite("body");
		this.addSprite("head");
		this.addSprite("injury");
		local body_blood = this.addSprite("body_blood");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", ::createVec(0, 0));

		// add the default skills
		this.m.Racial = ::new("scripts/skills/racial/lindwurm_racial");
		this.m.Skills.add(this.m.Racial);
		this.m.Skills.add(::new("scripts/skills/actives/tail_slam_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/tail_slam_big_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/tail_slam_split_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/tail_slam_zoc_skill"));
	}

	function setVariant( _type , _brush )
	{
		local b = this.m.BaseProperties;
		
		if (this.m.IsUsingDefaultStats)
		{
			b.setValues(::Const.EntityType.LegendStollwurm ? ::Const.Tactical.Actor.LegendStollwurm : ::Const.Tactical.Actor.Lindwurm);
			b.IsAffectedByNight = false;
			b.IsAffectedByRain = false;
			b.IsImmuneToKnockBackAndGrab = true;
			b.IsImmuneToStun = true;
			b.IsMovable = false;
			b.IsImmuneToDisarm = true;
		}
		
		switch(_type)
		{
		case ::Const.EntityType.Lindwurm:
			this.m.Skills.add(::new("scripts/skills/actives/move_tail_skill"));
			break;

		case ::Const.EntityType.LegendStollwurm:
			this.m.IsStollWurm = true;
			this.m.Skills.add(::new("scripts/skills/actives/legend_stollwurm_move_tail_skill"));
			break;
		}

		local isStollWurmBrush = _brush.find("stollwurm") != null;
		local body = this.getSprite("body");
		body.setBrush(isStollWurmBrush ? "bust_stollwurm_tail_01" : "bust_lindwurm_tail_01");
		body.Color = this.m.Body.getSprite("body").Color;
		body.Saturation = this.m.Body.getSprite("body").Saturation;

		local head = this.getSprite("head");
		head.Color = body.Color;
		head.Saturation = body.Saturation;

		local injury = this.getSprite("injury");
		injury.Visible = false;
		injury.setBrush(isStollWurmBrush ? "bust_stollwurm_tail_01_injured" : "bust_lindwurm_tail_01_injured");
		this.setDirty(true);
	}

	function onActorKilled( _actor, _tile, _skill )
	{
		this.nggh_mod_player_beast.onActorKilled(_actor, _tile, _skill);
		
		if (this.m.Body != null && !this.m.Body.isNull() && this.m.Body.isAlive() && !this.m.Body.isDying())
		{
			local stats = this.m.Body.getSkills().getSkillByID("special.stats_collector");

			if (stats != null)
			{
				stats.onTargetKilled(_actor, _skill);
			}
		}
	}
	
	function addXP( _xp, _scale = true )
	{	
		if (this.m.Body != null && !this.m.Body.isNull() && this.m.Body.isAlive() && !this.m.Body.isDying())
		{
			this.m.Body.addXP(_xp, _scale);
		}
	}

});
