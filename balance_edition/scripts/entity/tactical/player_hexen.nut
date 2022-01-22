this.player_hexen <- this.inherit("scripts/entity/tactical/player", {
	m = {
		IsCharming = false,
		RealHead = null,
		RealHair = null,
		RealBody = null,
		CharmHead = null,
		CharmHair = null,
		CharmBody = null
	},

	function getName()
	{
		if (!this.m.Flags.has("isBonus"))
		{
			return this.Const.UI.getColorized(this.player.getName(), "#ff0898");
		}

		return this.player.getName()
	}
	
	function playIdleSound()
	{
		local r = this.Math.rand(1, 30);

		if (r <= 5)
		{
			this.playSound(this.Const.Sound.ActorEvent.Idle, this.Const.Sound.Volume.Actor * this.Const.Sound.Volume.ActorIdle * this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] * this.m.SoundVolumeOverall * (this.Math.rand(60, 100) * 0.01) * (this.isHiddenToPlayer ? 0.33 : 1.0), this.m.SoundPitch * (this.Math.rand(85, 115) * 0.01));
		}
		else
		{
			this.playSound(this.Const.Sound.ActorEvent.Other1, this.Const.Sound.Volume.Actor * this.Const.Sound.Volume.ActorIdle * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1] * this.m.SoundVolumeOverall * (this.Math.rand(60, 100) * 0.01) * (this.isHiddenToPlayer ? 0.33 : 1.0), this.m.SoundPitch * (this.Math.rand(85, 115) * 0.01));
		}
	}

	function onTurnStart()
	{
		this.player.onTurnStart();
		this.playIdleSound();
	}

	function onTurnResumed()
	{
		this.player.onTurnResumed();
		this.playIdleSound();
	}

	function onUpdateInjuryLayer()
	{
		if (!this.hasSprite("injury"))
		{
			return;
		}
		
		local cursed = this.getSkills().getSkillByID("effects.cursed");
		local lesserCursed = this.getSkills().getSkillByID("effects.lesser_cursed");
		
		if (cursed != null || lesserCursed != null)
		{
			if (this.m.IsCharming)
			{
				return;
			}

			local injury = this.getSprite("injury");
			local injury_body = this.getSprite("injury_body");
			local p = this.m.Hitpoints / this.getHitpointsMax();

			if (p > 0.66)
			{
				this.setDirty(this.m.IsDirty || injury.Visible || injury_body.Visible);
				injury.Visible = false;
				injury_body.Visible = false;
			}
			else
			{
				this.setDirty(this.m.IsDirty || !injury.Visible || !injury_body.Visible);
				injury.setBrush("bust_head_injured_01");
				injury.Visible = true;
				injury_body.Visible = true;

				if (p > 0.4)
				{
					injury_body.Visible = false;
				}
				else
				{
					injury_body.setBrush("bust_hexen_true_body_injured");
					injury_body.Visible = true;
				}
			}
		}
		else
		{
			local injury = this.getSprite("injury");
			local injury_body = this.getSprite("injury_body");
			local p = this.m.Hitpoints / this.getHitpointsMax();

			if (p > 0.66)
			{
				this.setDirty(this.m.IsDirty || injury.Visible || injury_body.Visible);
				injury.Visible = false;
				injury_body.Visible = false;
			}
			else
			{
				this.setDirty(this.m.IsDirty || !injury.Visible || !injury_body.Visible);
				injury.Visible = true;
				injury_body.Visible = true;

				if (p > 0.33)
				{
					injury.setBrush("bust_head_injured_01");
				}
				else
				{
					injury.setBrush("bust_head_injured_02");
				}

				if (p > 0.4)
				{
					injury_body.Visible = false;
				}
				else
				{
					injury_body.setBrush("bust_hexen_fake_body_00_injured");
					injury_body.Visible = true;
				}
			}
		}
	}

	function create()
	{
		this.player.create();
		this.m.Type = this.Const.EntityType.Player;
		this.m.DecapitateSplatterOffset = this.createVec(-8, -26);
		this.m.IsUsingZoneOfControl = true;
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/women/woman_light_01.wav",
			"sounds/women/woman_light_02.wav",
			"sounds/women/woman_light_03.wav",
			"sounds/women/woman_light_04.wav",
			"sounds/women/woman_light_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/women/woman_injury_01.wav",
			"sounds/women/woman_injury_02.wav",
			"sounds/women/woman_injury_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/women/woman_fatigue_01.wav",
			"sounds/women/woman_fatigue_02.wav",
			"sounds/women/woman_fatigue_03.wav",
			"sounds/women/woman_fatigue_04.wav",
			"sounds/women/woman_fatigue_05.wav",
			"sounds/women/woman_fatigue_06.wav",
			"sounds/women/woman_fatigue_07.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/women/woman_flee_01.wav",
			"sounds/women/woman_flee_02.wav",
			"sounds/women/woman_flee_03.wav",
			"sounds/women/woman_flee_04.wav",
			"sounds/women/woman_flee_05.wav",
			"sounds/women/woman_flee_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/hexe_death_01.wav",
			"sounds/enemies/dlc2/hexe_death_02.wav",
			"sounds/enemies/dlc2/hexe_death_03.wav",
			"sounds/enemies/dlc2/hexe_death_04.wav",
			"sounds/enemies/dlc2/hexe_death_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc2/hexe_idle_01.wav",
			"sounds/enemies/dlc2/hexe_idle_02.wav",
			"sounds/enemies/dlc2/hexe_idle_03.wav",
			"sounds/enemies/dlc2/hexe_idle_04.wav",
			"sounds/enemies/dlc2/hexe_idle_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/dlc2/hexe_idle_06.wav",
			"sounds/enemies/dlc2/hexe_idle_07.wav",
			"sounds/enemies/dlc2/hexe_idle_08.wav",
			"sounds/enemies/dlc2/hexe_idle_09.wav",
			"sounds/enemies/dlc2/hexe_idle_05.wav",
			"sounds/enemies/dlc2/hexe_idle_10.wav",
			"sounds/enemies/dlc2/hexe_idle_11.wav",
			"sounds/enemies/dlc2/hexe_idle_12.wav",
			"sounds/enemies/dlc2/hexe_idle_13.wav",
			"sounds/enemies/dlc2/hexe_idle_14.wav",
			"sounds/enemies/dlc2/hexe_idle_15.wav",
			"sounds/enemies/dlc2/hexe_idle_16.wav",
			"sounds/enemies/dlc2/hexe_idle_17.wav",
			"sounds/enemies/dlc2/hexe_idle_18.wav",
			"sounds/enemies/dlc2/hexe_idle_19.wav",
			"sounds/enemies/dlc2/hexe_idle_20.wav",
			"sounds/enemies/dlc2/hexe_idle_21.wav",
			"sounds/enemies/dlc2/hexe_idle_22.wav",
			"sounds/enemies/dlc2/hexe_idle_23.wav",
			"sounds/enemies/dlc2/hexe_idle_24.wav",
			"sounds/enemies/dlc2/hexe_idle_25.wav",
			"sounds/enemies/dlc2/hexe_idle_26.wav",
			"sounds/enemies/dlc2/hexe_idle_27.wav",
			"sounds/enemies/dlc2/hexe_idle_28.wav",
			"sounds/enemies/dlc2/hexe_idle_29.wav",
			"sounds/enemies/dlc2/hexe_idle_30.wav"
		];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 1.5;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 5.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1] = 2.5;
		this.m.RealHead = this.Const.HexenOrigin.TrueHead[this.Math.rand(0, 2)];
		this.m.RealHair = this.Const.HexenOrigin.TrueHair[this.Math.rand(0, 3)];
		this.m.RealBody = this.Const.HexenOrigin.Body[2];
		this.m.CharmHead = this.Const.HexenOrigin.FakeHead[this.Math.rand(0, 1)];
		this.m.CharmHair = this.Const.HexenOrigin.FakeHair[this.Math.rand(0, 4)];
		this.m.CharmBody = this.Const.HexenOrigin.Body[1];
		this.m.Items = this.new("scripts/items/nggh707_item_container");
		this.m.Items.setActor(this);
		this.getFlags().set("Hexe", 0);
	}
	
	function onInit()
	{
		this.player.onInit();
		local b = this.m.BaseProperties;
		b.TargetAttractionMult = 1.25;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToDamageReflection = true;
		b.IsContentWithBeingInReserve = true;
		
		this.removeSprite("miniboss");
		this.removeSprite("status_hex");
		this.removeSprite("status_sweat");
		this.removeSprite("status_stunned");
		this.removeSprite("shield_icon");
		this.removeSprite("arms_icon");
		this.removeSprite("status_rooted");
		this.removeSprite("morale");
		
		local charm_body = this.addSprite("charm_body");
		charm_body.setHorizontalFlipping(true);
		charm_body.Visible = false;
		local charm_armor = this.addSprite("charm_armor");
		charm_armor.setHorizontalFlipping(true);
		charm_armor.Visible = false;
		local charm_head = this.addSprite("charm_head");
		charm_head.setHorizontalFlipping(true);
		charm_head.Visible = false;
		local charm_hair = this.addSprite("charm_hair");
		charm_hair.setHorizontalFlipping(true);
		charm_hair.Visible = false;
		
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.55;
		this.setSpriteOffset("status_rooted", this.createVec(0, 5));

		local mind_break = this.new("scripts/skills/actives/mod_mind_break_skill");
		mind_break.m.Order = this.Const.SkillOrder.UtilityTargeted + 1;
		this.m.Skills.add(mind_break);
		this.m.Skills.add(this.new("scripts/skills/spell_hexe/sleep_spell"));
		this.m.Skills.add(this.new("scripts/skills/spell_hexe/hex_spell"));
		this.m.Skills.add(this.new("scripts/skills/spell_hexe/charm_spell"));
		this.m.Skills.add(this.new("scripts/skills/spell_hexe/charm_captive_spell"));
		this.m.Skills.update();
		this.onFactionChanged();
	}

	function isReallyKilled( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.None)
		{
			return true;
		}

		if (this.Tactical.State.isScenarioMode())
		{
			return true;
		}

		if (this.Tactical.State.isAutoRetreat())
		{
			return true;
		}

		if (this.isGuest())
		{
			return true;
		}

		if (this.Math.rand(1, 100) <= this.Const.Combat.SurviveWithInjuryChance * this.m.CurrentProperties.SurviveWithInjuryChanceMult || this.World.Assets.m.IsSurvivalGuaranteed && !this.m.Skills.hasSkillOfType(this.Const.SkillType.PermanentInjury) && (this.World.Assets.getOrigin().getID() != "scenario.manhunters" || this.getBackground().getID() != "background.slave"))
		{
			local potential = [];
			local injuries = this.Const.HexenOrigin.PermanentInjury;
			local numPermInjuries = 0;

			foreach( inj in injuries )
			{
				if (!this.m.Skills.hasSkill(inj.ID))
				{
					potential.push(inj);
				}
				else
				{
					numPermInjuries = ++numPermInjuries;
				}
			}

			if (potential.len() != 0)
			{
				local skill = this.new("scripts/skills/" + potential[this.Math.rand(0, potential.len() - 1)].Script);
				this.m.Skills.add(skill);
				this.Tactical.getSurvivorRoster().add(this);
				this.m.IsDying = false;
				this.worsenMood(this.Const.MoodChange.PermanentInjury, "Suffered a permanent injury");
				this.updateAchievement("ScarsForLife", 1, 1);

				if (numPermInjuries + 1 >= 3)
				{
					this.updateAchievement("HardToKill", 1, 1);
				}

				return false;
			}
		}

		return true;
	}

	function checkMorale( _change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
	{	
		_difficulty = _difficulty + 10;
		return this.player.checkMorale(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
	}

	function isPerkTierUnlocked( _category, _tier )
	{
		return true;
	}

	function getAttributeLevelUpValues()
	{
		local b = this.getBaseProperties();

		if (this.m.Attributes[0].len() == 0)
		{
			for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
			{
				this.m.Attributes[i].push(1);
			}
		}

		local ret = {
			hitpoints = b.Hitpoints,
			hitpointsMax = 100,
			hitpointsIncrease = this.m.Attributes[this.Const.Attributes.Hitpoints][0],
			bravery = b.Bravery,
			braveryMax = 250,
			braveryIncrease = this.m.Attributes[this.Const.Attributes.Bravery][0],
			fatigue = b.Stamina,
			fatigueMax = 150,
			fatigueIncrease = this.m.Attributes[this.Const.Attributes.Fatigue][0],
			initiative = b.Initiative,
			initiativeMax = 200,
			initiativeIncrease = this.m.Attributes[this.Const.Attributes.Initiative][0],
			meleeSkill = b.MeleeSkill,
			meleeSkillMax = 75,
			meleeSkillIncrease = this.m.Attributes[this.Const.Attributes.MeleeSkill][0],
			rangeSkill = b.RangedSkill,
			rangeSkillMax = 125,
			rangeSkillIncrease = this.m.Attributes[this.Const.Attributes.RangedSkill][0],
			meleeDefense = b.MeleeDefense,
			meleeDefenseMax = 80,
			meleeDefenseIncrease = this.m.Attributes[this.Const.Attributes.MeleeDefense][0],
			rangeDefense = b.RangedDefense,
			rangeDefenseMax = 125,
			rangeDefenseIncrease = this.m.Attributes[this.Const.Attributes.RangedDefense][0]
		};
		return ret;
	}

	function getNachoAppearance()
	{
		if (!this.World.Flags.get("IsLuftAdventure"))
		{
			return null;
		}

		local r = this.Math.rand(1, 4);
		local noDress = this.Math.rand(1, 2) == 1;
		local ret = [];
		ret.push(r == 1 ? "bust_ghoulskin_head_01" : "bust_ghoulskin_0" + r + "_head_0" + this.Math.rand(1, 3));
		ret.push((noDress ? "bust_boobas_ghoul_body_0" : "bust_boobas_ghoul_with_dress_0") + r);
		return ret;
	}
	
	function setCharming( _f )
	{
		if (_f == this.m.IsCharming)
		{
			return;
		}
		
		this.m.IsCharming = _f;
		local t = 300;
		local isNude = false;
		local nudist = this.getSkills().getSkillByID("perk.charm_nudist")

		if (nudist != null)
		{
			isNude = nudist.getBonus() != 0;
		}

		if (this.m.IsCharming)
		{
			local a = this.getNachoAppearance();
			local sprite;

			if (a != null)
			{
				sprite = this.getSprite("charm_body");
				sprite.setBrush(a[1]);
				sprite.Visible = true;
				sprite.fadeIn(t);

				sprite = this.getSprite("charm_head");
				sprite.setBrush(a[0]);
				sprite.Visible = true;
				sprite.fadeIn(t);

				sprite = this.getSprite("charm_armor");
				sprite.resetBrush();
				
				sprite = this.getSprite("charm_hair");
				sprite.resetBrush();
				
			}
			else 
			{
			    sprite = this.getSprite("charm_body");
				sprite.setBrush("bust_hexen_charmed_body_01");
				sprite.Visible = true;
				sprite.fadeIn(t);
				sprite = this.getSprite("charm_armor");
				sprite.setBrush("bust_hexen_charmed_dress_0" + this.Math.rand(1, 3));
				sprite.Visible = !isNude;
				sprite.fadeIn(t);
				sprite = this.getSprite("charm_head");
				sprite.setBrush("bust_hexen_charmed_head_0" + this.Math.rand(1, 2));
				sprite.Visible = true;
				sprite.fadeIn(t);
				sprite = this.getSprite("charm_hair");
				sprite.setBrush("bust_hexen_charmed_hair_0" + this.Math.rand(1, 5));
				sprite.Visible = true;
				sprite.fadeIn(t);
			}
			
			this.onAllSpritesHidden(true);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, t + 100, function ( _e )
			{
				if (!_e.isAlive())
				{
					return;
				}
				
				local sprite;
				local isNude = false;
				local nudist = _e.getSkills().getSkillByID("perk.charm_nudist")

				if (nudist != null)
				{
					isNude = nudist.getBonus() != 0;
				}

				sprite = _e.getSprite("charm_body");
				sprite.Visible = true;
				sprite = _e.getSprite("charm_armor");
				sprite.Visible = !isNude;
				sprite = _e.getSprite("charm_head");
				sprite.Visible = true;
				sprite = _e.getSprite("charm_hair");
				sprite.Visible = true;
				_e.onAllSpritesHidden(true);
				_e.setDirty(true);
			}, this);
		}
		else
		{
			local sprite;
			sprite = this.getSprite("charm_body");
			sprite.fadeOutAndHide(t);
			sprite = this.getSprite("charm_armor");
			sprite.fadeOutAndHide(t);
			sprite = this.getSprite("charm_head");
			sprite.fadeOutAndHide(t);
			sprite = this.getSprite("charm_hair");
			sprite.fadeOutAndHide(t);
			
			this.onAllSpritesHidden(false);
			this.onUpdateInjuryLayer();
			this.Time.scheduleEvent(this.TimeUnit.Virtual, t + 100, function ( _e )
			{
				if (!_e.isAlive())
				{
					return;
				}

				local sprite;
				sprite = _e.getSprite("charm_body");
				sprite.Visible = false;
				sprite = _e.getSprite("charm_armor");
				sprite.Visible = false;
				sprite = _e.getSprite("charm_head");
				sprite.Visible = false;
				sprite = _e.getSprite("charm_hair");
				sprite.Visible = false;
				_e.onAllSpritesHidden(false);
				_e.setDirty(true);
			}, this);
		}

		this.Const.HexenOrigin.Magic.SpawnCharmParticleEffect(this.getTile());
	}
	
	function onAllSpritesHidden( _isHidden = true )
	{
		foreach( a in this.Const.HexenOrigin.AffectedSprites )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.getSprite(a).Visible = !_isHidden;
			
			if (this.getSprite(a).HasBrush)
			{
				this.getSprite(a)[_isHidden ? "fadeOutAndHide" : "fadeIn"](300);
			}
		}
		
		if (!_isHidden)
		{
			this.updateInjuryVisuals(true);
			this.onAppearanceChanged(this.getItems().getAppearance());
		}
	}
	
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (!this.Tactical.State.isScenarioMode() && _fatalityType != this.Const.FatalityType.Unconscious)
		{
			if (this.getLevel() >= 11 && this.World.Assets.isIronman())
			{
				this.updateAchievement("ToughFarewell", 1, 1);
			}
			else
			{
				this.updateAchievement("BloodyToll", 1, 1);
			}

			if (_killer != null && this.isKindOf(_killer, "player") && _killer.getSkills().hasSkill("effects.charmed"))
			{
				this.updateAchievement("NothingPersonal", 1, 1);
			}
		}

		local flip = this.Math.rand(0, 100) < 50;
		this.m.IsCorpseFlipped = flip;
		local isResurrectable = false;
		local appearance = this.getItems().getAppearance();
		local sprite_body = this.getSprite("body");
		sprite_body.setBrush(this.m.RealBody);
		local sprite_head = this.getSprite("head");
		sprite_head.setBrush(this.m.RealHead);
		local sprite_hair = this.getSprite("hair");
		sprite_hair.setBrush(this.m.RealHair);
		local sprite_beard = this.getSprite("beard");
		local sprite_beard_top = this.getSprite("beard_top");
		local tattoo_body = this.getSprite("tattoo_body");
		local tattoo_head = this.getSprite("tattoo_head");
		local sprite_surcoat = this.getSprite("surcoat");
		local sprite_accessory = this.getSprite("accessory");

		if (!this.isGuest())
		{
			local stub = this.Tactical.getCasualtyRoster().create("scripts/entity/tactical/player_corpse_stub");
			stub.setCommander(this.isCommander());
			stub.setOriginalID(this.getID());
			stub.setName(this.getNameOnly());
			stub.setTitle(this.getTitle());
			stub.setCombatStats(this.m.CombatStats);
			stub.setLifetimeStats(this.m.LifetimeStats);
			stub.m.DaysWithCompany = this.getDaysWithCompany();
			stub.m.Level = this.getLevel();
			stub.m.DailyCost = this.getDailyCost();
			stub.addSprite("blood_1").setBrush(this.Const.BloodPoolDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodPoolDecals[this.Const.BloodType.Red].len() - 1)]);
			stub.addSprite("blood_2").setBrush(this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)]);
			stub.setSpriteOffset("blood_1", this.createVec(0, -15));
			stub.setSpriteOffset("blood_2", this.createVec(0, -30));

			if (_fatalityType == this.Const.FatalityType.Devoured)
			{
				for( local i = 0; i != this.Const.CorpsePart.len(); i = i )
				{
					stub.addSprite("stuff_" + i).setBrush(this.Const.CorpsePart[i]);
					i = ++i;
				}
			}
			else
			{
				local decal = stub.addSprite("body");
				decal.setBrush(sprite_body.getBrush().Name + "_dead");
				decal.Color = sprite_head.Color;
				decal.Saturation = sprite_head.Saturation;

				if (appearance.CorpseArmor != "")
				{
					decal = stub.addSprite("armor");
					decal.setBrush(appearance.CorpseArmor);
				}

				if (sprite_surcoat.HasBrush)
				{
					decal = stub.addSprite("surcoat");
					decal.setBrush("surcoat_" + (this.m.Surcoat < 10 ? "0" + this.m.Surcoat : this.m.Surcoat) + "_dead");
				}

				if (appearance.CorpseArmorUpgradeBack != "")
				{
					decal = stub.addSprite("upgrade_back");
					decal.setBrush(appearance.CorpseArmorUpgradeBack);
				}

				if (sprite_accessory.HasBrush)
				{
					decal = stub.addSprite("accessory");
					decal.setBrush(sprite_accessory.getBrush().Name + "_dead");
				}

				if (_fatalityType == this.Const.FatalityType.Disemboweled)
				{
					stub.addSprite("guts").setBrush("bust_body_guts_01");
				}
				else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
				{
					if (appearance.CorpseArmor != "")
					{
						stub.addSprite("arrows").setBrush(appearance.CorpseArmor + "_arrows");
					}
					else
					{
						stub.addSprite("arrows").setBrush(appearance.Corpse + "_arrows");
					}
				}
				else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
				{
					if (appearance.CorpseArmor != "")
					{
						stub.addSprite("arrows").setBrush(appearance.CorpseArmor + "_javelin");
					}
					else
					{
						stub.addSprite("arrows").setBrush(appearance.Corpse + "_javelin");
					}
				}

				if (_fatalityType != this.Const.FatalityType.Decapitated)
				{
					if (!appearance.HideCorpseHead)
					{
						decal = stub.addSprite("head");
						decal.setBrush(sprite_head.getBrush().Name + "_dead");
						decal.Color = sprite_head.Color;
						decal.Saturation = sprite_head.Saturation;
					}

					if (!appearance.HideHair && !appearance.HideCorpseHead && sprite_hair.HasBrush)
					{
						decal = stub.addSprite("hair");
						decal.setBrush(sprite_hair.getBrush().Name + "_dead");
						decal.Color = sprite_hair.Color;
						decal.Saturation = sprite_hair.Saturation;
					}

					if (_fatalityType == this.Const.FatalityType.Smashed)
					{
						stub.addSprite("smashed").setBrush("bust_head_smashed_01");
					}
					else if (appearance.HelmetCorpse != "")
					{
						decal = stub.addSprite("helmet");
						decal.setBrush(this.getItems().getAppearance().HelmetCorpse);
					}
				}

				if (appearance.CorpseArmorUpgradeFront != "")
				{
					decal = stub.addSprite("upgrade_front");
					decal.setBrush(appearance.CorpseArmorUpgradeFront);
				}
			}
		}

		if (_tile != null)
		{
			this.human.onDeath(_killer, _skill, _tile, _fatalityType);
			local corpse = _tile.Properties.get("Corpse");
			corpse.IsPlayer = true;
			corpse.Value = 10.0;
			corpse.IsResurrectable = false;
		}

		if (!this.m.IsGuest && !this.Tactical.State.isScenarioMode())
		{
			this.World.Assets.addScore(-5 * this.getLevel());
		}

		if (!this.m.IsGuest && !this.Tactical.State.isScenarioMode() && _fatalityType != this.Const.FatalityType.Unconscious && (_skill != null && _killer != null || _fatalityType == this.Const.FatalityType.Devoured))
		{
			local killedBy;

			if (_fatalityType == this.Const.FatalityType.Devoured)
			{
				killedBy = "Devoured by a Nachzehrer";
			}
			else if (_fatalityType == this.Const.FatalityType.Suicide)
			{
				killedBy = "Committed Suicide";
			}
			else if (_skill.isType(this.Const.SkillType.StatusEffect))
			{
				killedBy = _skill.getKilledString();
			}
			else if (_killer.getID() == this.getID())
			{
				killedBy = "Killed in battle";
			}
			else
			{
				if (_fatalityType == this.Const.FatalityType.Decapitated)
				{
					killedBy = "Beheaded";
				}
				else if (_fatalityType == this.Const.FatalityType.Disemboweled)
				{
					if (this.Math.rand(1, 2) == 1)
					{
						killedBy = "Disemboweled";
					}
					else
					{
						killedBy = "Gutted";
					}
				}
				else
				{
					killedBy = _skill.getKilledString();
				}

				killedBy = killedBy + (" by " + _killer.getKilledName());
			}

			this.World.Statistics.addFallen(this, killedBy);
		}
	}
	
	function getBarterModifier()
	{
		local bg = this.getBackground();

		if (bg == null)
		{
			return 0;
		}

		local mod = this.getBackground().getModifiers().Barter;
		local skills = [
			"perk.legend_barter_trustworthy",
			"perk.legend_barter_convincing",
			"perk.legend_barter_greed",
			"perk.boobas_charm",
			"trait.seductive",
		];

		foreach( s in skills )
		{
			local skill = this.getSkills().getSkillByID(s);

			if (skill != null)
			{
				mod = mod + skill.getModifier();
			}
		}

		return mod;
	}
	
	function getPercentOnKillOtherActorModifier()
	{
		return 1.0;
	}
	
	function getFlatOnKillOtherActorModifier()
	{
		return 1.0;
	}
	
	function isCommander()
	{
		return true;
	}
	
	function getRiderID()
	{
		return "";
	}
	
	function setRider()
	{
	}
	
	function assignRandomEquipment()
	{
	}

	function canEquipThis( _item )
	{
		return true;
	}

	function canUnequipThis( _item )
	{
		return true;
	}

	function onActorEquip( _item )
	{
	}

	function onActorUnequip( _item )
	{
	}

	function onActorAfterEquip( _item )
	{
	}

	function onActorAfterUnequip( _item )
	{
	}
	
	function resetPerkTree()
	{
		return;

		if (this.getFlags().getAsInt("Hexe_Origin") >= this.HexeVersion || this.getFlags().has("isBonus"))
		{
			return;
		}
	
		local perks = 0;
		local skills = this.getSkills();

		foreach( skill in skills.m.Skills )
		{
			if (!skill.isGarbage() && skill.isType(this.Const.SkillType.Perk) && !skill.isType(this.Const.SkillType.Racial))
			{
				perks = perks + 1;
			}
		}

		perks = perks + this.m.PerkPoints;
		this.logDebug("perks before: " + perks);

		this.getSkills().removeByType(this.Const.SkillType.Perk);
		this.m.PerkPoints = 0;
		this.m.PerkPointsSpent = 0;
		this.m.PerkPoints = perks;
		this.getBackground().resetPerkTree();
		this.getFlags().set("Hexe_Origin", this.HexeVersion);
	}

	function gainbuff()
	{
		if (this.getFlags().getAsInt("Hexe_Origin") >= this.HexeVersion || this.getFlags().has("isBonus"))
		{
			return;
		}

		local b = this.getBaseProperties();
		b.Stamina += 10;
		b.Bravery += 5;
		b.RangedSkill += 3;
		b.MeleeDefense += 3;
		b.RangedDefense += 5;
		b.Initiative += 5;
		this.getFlags().set("Hexe_Origin", this.HexeVersion);
	}

	function onSerialize( _out )
	{
		this.player.onSerialize(_out);
		_out.writeBool(this.m.IsCharming);
		_out.writeString(this.m.RealHead);
		_out.writeString(this.m.RealBody);
		_out.writeString(this.m.RealHair);
		_out.writeString(this.m.CharmHead);
		_out.writeString(this.m.CharmBody);
		_out.writeString(this.m.CharmHair);
	}

	function onDeserialize( _in )
	{
		if (_in.getMetaData().getVersion() >= 59)
		{
			this.player.onDeserialize(_in);
		}
		else
		{
			this.human.onDeserialize(_in);
		}

		this.m.IsCharming = _in.readBool();
		this.m.RealHead = _in.readString();
		this.m.RealBody = _in.readString();
		this.m.RealHair = _in.readString();
		this.m.CharmHead = _in.readString();
		this.m.CharmHair = _in.readString();
		this.m.CharmBody = _in.readString();
				
		this.resetPerkTree();
		this.m.Skills.update();
	}

});

