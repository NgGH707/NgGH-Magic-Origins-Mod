this.stollwurm_tail_player <- this.inherit("scripts/entity/tactical/player_beast", {
	m = {
		Body = null,
		Racial = null,
		Mode = 0
	},
	
	function isSummoned()
	{
		return true;
	}
	
	function getImageOffsetY()
	{
		return 20;
	}
	
	function getMode()
	{
		return this.m.Mode;
	}
	
	function getBackground()
	{
		return this.m.Body != null ? this.m.Body.getBackground() : null;
	}

	function getTalents()
	{
		return this.m.Body != null ? this.m.Body.getTalents() : [0, 0, 0, 0, 0, 0, 0, 0];
	}

	function setMode( _m )
	{
		this.m.Mode = _m;

		if (this.isPlacedOnMap())
		{
			if (this.m.Mode == 0 && _m == 1)
			{
				this.m.IsUsingZoneOfControl = true;
				this.getTile().addZoneOfControl(this.getFaction());
			}

			this.onUpdateInjuryLayer();
		}
	}
	
	function getBaseProperties()
	{
		return this.m.Body.m.BaseProperties;
	}

	function getCurrentProperties()
	{
		return this.m.Body.m.CurrentProperties;
	}

	function setCurrentProperties( _c )
	{
		this.m.Body.setCurrentProperties(_c);
	}

	function getItems()
	{
		return this.m.Body.getItems();
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

	function getBody()
	{
		return this.m.Body;
	}

	function getIdealRange()
	{
		return 1;
	}

	function getOverlayImage()
	{
		return "lindwurm_tail_orientation";
	}
	
	function getName()
	{
		return this.m.Body != null ? this.getBody().getName() + " Tail" : "Stollwurm Tail";
	}

	function create()
	{
		this.player_beast.create();
		this.m.IsControlledByPlayer = true;
		this.m.Name = "Stollwurm Tail";
		this.m.Type = this.Const.EntityType.Player;
		this.m.BloodType = this.Const.BloodType.Green;
		this.m.XP = this.Const.Tactical.Actor.LegendStollwurm.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(-10, -25);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.IsUsingZoneOfControl = false;
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/lindwurm_fleeing_01.wav",
			"sounds/enemies/lindwurm_fleeing_02.wav",
			"sounds/enemies/lindwurm_fleeing_03.wav",
			"sounds/enemies/lindwurm_fleeing_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/lindwurm_hurt_01.wav",
			"sounds/enemies/lindwurm_hurt_02.wav",
			"sounds/enemies/lindwurm_hurt_03.wav",
			"sounds/enemies/lindwurm_hurt_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/lindwurm_idle_01.wav",
			"sounds/enemies/lindwurm_idle_02.wav",
			"sounds/enemies/lindwurm_idle_03.wav",
			"sounds/enemies/lindwurm_idle_04.wav",
			"sounds/enemies/lindwurm_idle_05.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/lindwurm_flee_01.wav",
			"sounds/enemies/lindwurm_flee_02.wav",
			"sounds/enemies/lindwurm_flee_03.wav",
			"sounds/enemies/lindwurm_flee_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/lindwurm_death_01.wav",
			"sounds/enemies/lindwurm_death_02.wav",
			"sounds/enemies/lindwurm_death_03.wav",
			"sounds/enemies/lindwurm_death_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/lindwurm_idle_06.wav",
			"sounds/enemies/lindwurm_idle_07.wav",
			"sounds/enemies/lindwurm_idle_08.wav",
			"sounds/enemies/lindwurm_idle_09.wav",
			"sounds/enemies/lindwurm_idle_10.wav",
			"sounds/enemies/lindwurm_idle_11.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Attack] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 1.5;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Attack] = 2.0;
		this.m.SoundPitch = this.Math.rand(95, 105) * 0.01;
		this.getFlags().add("body_immune_to_acid");
		this.getFlags().add("head_immune_to_acid");
		this.getFlags().add("lindwurm");
		this.getFlags().add("isLindwurmTail");
		this.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_move_tail_player"));
	}

	function playAttackSound()
	{
		this.playSound(this.Const.Sound.ActorEvent.Attack, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Attack] * (this.Math.rand(75, 100) * 0.01), this.m.SoundPitch * 1.15);
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		if (!this.isAlive())
		{
			return 0;
		}

		if (_hitInfo.DamageRegular == 0 && _hitInfo.DamageArmor == 0)
		{
			return 0;
		}

		_hitInfo.BodyPart = this.Const.BodyPart.Body;

		if (_attacker != null && _attacker.isPlayerControlled() && !this.isPlayerControlled())
		{
			this.setDiscovered(true);
			this.getTile().addVisibilityForFaction(this.Const.Faction.Player);
		}

		local p = this.m.Body.m.Skills.buildPropertiesForBeingHit(_attacker, _skill, _hitInfo.BodyPart);
		_hitInfo.DamageRegular *= p.DamageReceivedRegularMult * p.DamageReceivedTotalMult;
		_hitInfo.DamageArmor *= p.DamageReceivedArmorMult * p.DamageReceivedTotalMult;
		local armor = 0;
		local armorDamage = 0;

		if (_hitInfo.DamageDirect < 1.0)
		{
			armor = p.Armor[_hitInfo.BodyPart] * p.ArmorMult[_hitInfo.BodyPart];
			armorDamage = this.Math.min(armor, _hitInfo.DamageArmor);
			armor = armor - armorDamage;
			_hitInfo.DamageInflictedArmor = this.Math.max(0, armorDamage);
		}

		_hitInfo.DamageFatigue *= p.FatigueEffectMult;
		this.m.Body.m.Fatigue = this.Math.min(this.getFatigueMax(), this.Math.round(this.m.Body.m.Fatigue + _hitInfo.DamageFatigue * p.FatigueReceivedPerHitMult));
		local damage = 0;
		damage = damage + this.Math.maxf(0.0, _hitInfo.DamageRegular * _hitInfo.DamageDirect - armor * this.Const.Combat.ArmorDirectDamageMitigationMult);

		if (armor <= 0 || _hitInfo.DamageDirect >= 1.0)
		{
			damage = damage + this.Math.max(0, _hitInfo.DamageRegular * this.Math.maxf(0.0, 1.0 - _hitInfo.DamageDirect) - armorDamage);
		}

		damage = damage * _hitInfo.BodyDamageMult;
		damage = this.Math.max(0, this.Math.max(damage, this.Math.min(_hitInfo.DamageMinimum, _hitInfo.DamageMinimum * p.DamageReceivedTotalMult)));
		_hitInfo.DamageInflictedHitpoints = damage;
		this.m.Body.m.Skills.onDamageReceived(_attacker, _hitInfo.DamageInflictedHitpoints, _hitInfo.DamageInflictedArmor);
		this.m.Racial.onDamageReceived(_attacker, _hitInfo.DamageInflictedHitpoints, _hitInfo.DamageInflictedArmor);

		if (armorDamage > 0 && !this.isHiddenToPlayer())
		{
			local armorHitSound = this.m.Items.getAppearance().ImpactSound[_hitInfo.BodyPart];

			if (armorHitSound.len() > 0)
			{
				this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, this.getPos());
			}

			if (damage < this.Const.Combat.PlayPainSoundMinDamage)
			{
				this.playSound(this.Const.Sound.ActorEvent.NoDamageReceived, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.NoDamageReceived]);
			}
		}

		if (damage > 0)
		{
			if (!this.m.IsAbleToDie && damage >= this.m.Body.m.Hitpoints)
			{
				this.m.Body.m.Hitpoints = 1;
			}
			else
			{
				this.m.Body.m.Hitpoints = this.Math.round(this.m.Body.m.Hitpoints - damage);
			}
		}

		local fatalityType = this.Const.FatalityType.None;

		if (this.m.Body.m.Hitpoints <= 0)
		{
			this.m.IsDying = true;

			if (_skill != null)
			{
				if (_skill.getChanceDecapitate() >= 100 || _hitInfo.BodyPart == this.Const.BodyPart.Head && this.Math.rand(1, 100) <= _skill.getChanceDecapitate() * _hitInfo.FatalityChanceMult)
				{
					fatalityType = this.Const.FatalityType.Decapitated;
				}
				else if (_skill.getChanceSmash() >= 100 || _hitInfo.BodyPart == this.Const.BodyPart.Head && this.Math.rand(1, 100) <= _skill.getChanceSmash() * _hitInfo.FatalityChanceMult)
				{
					fatalityType = this.Const.FatalityType.Smashed;
				}
				else if (_skill.getChanceDisembowel() >= 100 || _hitInfo.BodyPart == this.Const.BodyPart.Body && this.Math.rand(1, 100) <= _skill.getChanceDisembowel() * _hitInfo.FatalityChanceMult)
				{
					fatalityType = this.Const.FatalityType.Disemboweled;
				}
			}
		}

		if (_hitInfo.DamageDirect < 1.0)
		{
			local overflowDamage = _hitInfo.DamageArmor;

			if (this.m.Body.m.BaseProperties.Armor[_hitInfo.BodyPart] != 0)
			{
				overflowDamage = overflowDamage - this.m.Body.m.BaseProperties.Armor[_hitInfo.BodyPart] * this.m.Body.m.BaseProperties.ArmorMult[_hitInfo.BodyPart];
				this.m.Body.m.BaseProperties.Armor[_hitInfo.BodyPart] = this.Math.max(0, this.m.Body.m.BaseProperties.Armor[_hitInfo.BodyPart] * this.m.Body.m.BaseProperties.ArmorMult[_hitInfo.BodyPart] - _hitInfo.DamageArmor);
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + "\'s natural armor is hit for [b]" + this.Math.floor(_hitInfo.DamageArmor) + "[/b] damage");
			}

			if (overflowDamage > 0)
			{
				this.m.Items.onDamageReceived(overflowDamage, fatalityType, _hitInfo.BodyPart == this.Const.BodyPart.Body ? this.Const.ItemSlot.Body : this.Const.ItemSlot.Head, _attacker);
			}
		}

		if (this.getFaction() == this.Const.Faction.Player && _attacker != null && _attacker.isAlive())
		{
			this.Tactical.getCamera().quake(_attacker, this, 5.0, 0.16, 0.3);
		}

		if (damage <= 0 && armorDamage >= 0)
		{
			if (!this.isHiddenToPlayer())
			{
				local layers = this.m.ShakeLayers[_hitInfo.BodyPart];
				local recoverMult = 1.0;

				if (_attacker != null && _attacker.isAlive())
				{
					this.Tactical.getShaker().cancel(this);
					this.Tactical.getShaker().shake(this, _attacker.getTile(), this.m.IsShakingOnHit ? 2 : 3, this.Const.Combat.ShakeEffectArmorHitColor, this.Const.Combat.ShakeEffectArmorHitHighlight, this.Const.Combat.ShakeEffectArmorHitFactor, this.Const.Combat.ShakeEffectArmorSaturation, layers, recoverMult);
				}
			}

			this.m.Body.m.Skills.update();
			this.setDirty(true);
			return 0;
		}

		if (damage >= this.Const.Combat.SpawnBloodMinDamage)
		{
			this.spawnBloodDecals(this.getTile());
		}

		if (this.m.Body.m.Hitpoints <= 0)
		{
			this.spawnBloodDecals(this.getTile());
			this.kill(_attacker, _skill, fatalityType);
		}
		else
		{
			if (damage >= this.Const.Combat.SpawnBloodEffectMinDamage)
			{
				local mult = this.Math.maxf(0.75, this.Math.minf(2.0, damage / this.getHitpointsMax() * 3.0));
				this.spawnBloodEffect(this.getTile(), mult);
			}

			if (this.m.Body.m.CurrentProperties.IsAffectedByInjuries && this.m.IsAbleToDie && damage >= this.Const.Combat.InjuryMinDamage && this.m.Body.m.CurrentProperties.ThresholdToReceiveInjuryMult != 0 && _hitInfo.InjuryThresholdMult != 0 && _hitInfo.Injuries != null)
			{
				local potentialInjuries = [];
				local bonus = _hitInfo.BodyPart == this.Const.BodyPart.Head ? 1.25 : 1.0;

				foreach( inj in _hitInfo.Injuries )
				{
					if (inj.Threshold * _hitInfo.InjuryThresholdMult * this.Const.Combat.InjuryThresholdMult * this.m.Body.m.CurrentProperties.ThresholdToReceiveInjuryMult * bonus <= damage / (this.getHitpointsMax() * 1.0))
					{
						if (!this.m.Body.m.Skills.hasSkill(inj.ID))
						{
							potentialInjuries.push(inj.Script);
						}
					}
				}

				if (potentialInjuries.len() != 0)
				{
					local injury = this.new("scripts/skills/" + potentialInjuries[this.Math.rand(0, potentialInjuries.len() - 1)]);
					this.m.Body.m.Skills.add(injury);

					if (this.isPlayerControlled() && this.isKindOf(this, "player"))
					{
						this.worsenMood(this.Const.MoodChange.Injury, "Suffered an injury");
					}

					if (this.isPlayerControlled() || !this.isHiddenToPlayer())
					{
						this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + "\'s " + this.Const.Strings.BodyPartName[_hitInfo.BodyPart] + " is hit for [b]" + this.Math.floor(damage) + "[/b] damage and suffers " + injury.getNameOnly() + "!");
					}
				}
				else if (damage > 0 && !this.isHiddenToPlayer())
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + "\'s " + this.Const.Strings.BodyPartName[_hitInfo.BodyPart] + " is hit for [b]" + this.Math.floor(damage) + "[/b] damage");
				}
			}
			else if (damage > 0 && !this.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + "\'s " + this.Const.Strings.BodyPartName[_hitInfo.BodyPart] + " is hit for [b]" + this.Math.floor(damage) + "[/b] damage");
			}

			if (this.m.Body.m.MoraleState != this.Const.MoraleState.Ignore && damage > this.Const.Morale.OnHitMinDamage && this.getCurrentProperties().IsAffectedByLosingHitpoints)
			{
				this.checkMorale(-1, this.Const.Morale.OnHitBaseDifficulty * (1.0 - this.getHitpoints() / this.getHitpointsMax()), this.Const.MoraleCheckType.Default, "", true);
			}

			this.m.Body.m.Skills.onAfterDamageReceived();

			if (damage >= this.Const.Combat.PlayPainSoundMinDamage && this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived].len() > 0)
			{
				local volume = 1.0;

				if (damage < this.Const.Combat.PlayPainVolumeMaxDamage)
				{
					volume = damage / this.Const.Combat.PlayPainVolumeMaxDamage;
				}

				this.playSound(this.Const.Sound.ActorEvent.DamageReceived, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] * volume, this.m.SoundPitch);
			}

			this.m.Body.m.Skills.update();
			this.onUpdateInjuryLayer();

			if (!this.isHiddenToPlayer())
			{
				local layers = this.m.ShakeLayers[_hitInfo.BodyPart];
				local recoverMult = this.Math.minf(1.5, this.Math.maxf(1.0, damage * 2.0 / this.getHitpointsMax()));

				if (_attacker != null && _attacker.isAlive())
				{
					this.Tactical.getShaker().cancel(this);
					this.Tactical.getShaker().shake(this, _attacker.getTile(), this.m.IsShakingOnHit ? 2 : 3, this.Const.Combat.ShakeEffectHitpointsHitColor, this.Const.Combat.ShakeEffectHitpointsHitHighlight, this.Const.Combat.ShakeEffectHitpointsHitFactor, this.Const.Combat.ShakeEffectHitpointsSaturation, layers, recoverMult);
				}
			}

			this.setDirty(true);
		}

		return damage;
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			local flip = this.Math.rand(0, 100) < 50;
			local decal;
			this.m.IsCorpseFlipped = flip;
			local body = this.getSprite("body");
			decal = _tile.spawnDetail("bust_lindwurm_tail_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;
			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = "A Lindwurm";
			corpse.IsHeadAttached = true;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function checkMorale( _change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
	{
		this.m.Body.checkMorale(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
	}

	function kill( _killer = null, _skill = null, _fatalityType = this.Const.FatalityType.None, _silent = false )
	{
		this.actor.kill(_killer, _skill, _fatalityType, _silent);

		if (this.m.Body != null && !this.m.Body.isNull() && this.m.Body.isAlive() && !this.m.Body.isDying())
		{
			this.m.Body.kill(_killer, _skill, _fatalityType, _silent);
			this.m.Body = null;
		}
	}
	
	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
	}

	function onInit()
	{
		if (this.m.ParentID != 0)
		{
			this.m.Body = this.Tactical.getEntityByID(this.m.ParentID);
			this.m.Items = this.m.Body.m.Items;
		}

		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.LegendStollwurm);
		b.IsAffectedByNight = false;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsMovable = false;
		b.IsImmuneToDisarm = true;
		b.IsAffectedByRain = false;
		b.MeleeSkill += 10;
		b.DamageTotalMult += 0.1;

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_player");
		local body = this.addSprite("body");
		body.setBrush("bust_stollwurm_tail_0" + this.Math.rand(1, 1));

		if (this.Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.2);
		}

		if (this.Math.rand(0, 100) < 90)
		{
			body.varyColor(0.08, 0.08, 0.08);
		}

		local head = this.addSprite("head");
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_stollwurm_tail_01_injured");
		local body_blood = this.addSprite("body_blood");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", this.createVec(0, 0));
		this.m.Racial = this.new("scripts/skills/racial/lindwurm_racial");
		this.m.Skills.add(this.m.Racial);
		this.m.Skills.add(this.new("scripts/skills/actives/tail_slam_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/tail_slam_big_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/tail_slam_split_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_reach_advantage"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/actives/legend_stollwurm_move_tail_skill"));
	}
	
	function addXP( _xp, _scale = true )
	{	
		if (this.m.Body != null && !this.m.Body.isNull() && this.m.Body.isAlive() && !this.m.Body.isDying())
		{
			this.m.Body.addXP(_xp, _scale);
		}
	}

});

