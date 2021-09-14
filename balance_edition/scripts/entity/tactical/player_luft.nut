this.player_luft <- this.inherit("scripts/entity/tactical/player", {
	m = {
		IsCharming = false,
		Size = 1,
		Head = 1,		
		ScaleStartTime = 0,
		IsLoadingSaveData = false,
	},
	
	function getStrength()
	{
		return  2.0;
	}
	
	function getSize()
	{
		return this.m.Size;
	}

	function setSize( _s ) 
	{
		if (this.m.Size == _s)
		{
			this.onAdjustingSprite();
			return;
		}

	    if (_s <= 1)
	    {
	    	this.getSprite("body").setBrush("bust_ghoulskin_body_01");
			this.getSprite("head").setBrush("bust_ghoulskin_head_01");
			this.getSprite("injury").setBrush("bust_ghoulskin_01_injured");
	    	this.m.BloodSplatterOffset = this.createVec(0, 0);
			this.m.DecapitateSplatterOffset = this.createVec(33, -26);
			this.m.DecapitateBloodAmount = 0.7;
			this.m.BloodPoolScale = 0.7;
			this.getSprite("status_rooted").Scale = 0.45;
			this.setSpriteOffset("status_rooted", this.createVec(-4, 7));
	    	this.m.Size = 1;
	    	this.onAdjustingSprite();
	    }
	    else if (_s <= 2)
	    {
	    	this.m.Size = 1;
	    	this.grow(true);
	    }
	    else if (_s <= 3)
	    {
	    	this.m.Size = 1;
	    	this.grow(true);
	    	this.grow(true);
	    }
	}
	
	function getHealthRecoverMult()
	{
		return this.m.Size;
	}
	
	function onUpdateInjuryLayer()
	{
		this.actor.onUpdateInjuryLayer();
	}
	
	function getDaysWounded()
	{
		if (this.getHitpoints() < this.getHitpointsMax())
		{
			return this.Math.ceil((this.getHitpointsMax() - this.getHitpoints()) / (this.Const.World.Assets.HitpointsPerHour * this.getHealthRecoverMult() * (("State" in this.World) && this.World.State != null ? this.World.Assets.m.HitpointsPerHourMult : 1.0)) / 24.0);
		}
		else
		{
			return 0;
		}
	}
	
	function getRosterTooltip()
	{
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			}
		];
		local time = this.getDaysWithCompany();
		local text;

		if (!this.isGuest())
		{
			if (this.m.Background != null && this.m.Background.getID() == "background.companion")
			{
				text = "With the company from the very beginning.";
			}
			else if (time > 1)
			{
				text = "With the company for " + time + " days.";
			}
			else
			{
				text = "Has just joined the company.";
			}

			if (this.m.LifetimeStats.Battles != 0)
			{
				if (this.m.LifetimeStats.Battles == 1)
				{
					text = text + (" Took part in " + this.m.LifetimeStats.Battles + " battle");
				}
				else
				{
					text = text + (" Took part in " + this.m.LifetimeStats.Battles + " battles");
				}

				if (this.m.LifetimeStats.Kills == 1)
				{
					text = text + (" and has " + this.m.LifetimeStats.Kills + " kill.");
				}
				else if (this.m.LifetimeStats.Kills > 1)
				{
					text = text + (" and has " + this.m.LifetimeStats.Kills + " kills.");
				}
				else
				{
					text = text + ".";
				}

				if (this.m.LifetimeStats.MostPowerfulVanquished != "")
				{
					text = text + (" The most powerful opponent he vanquished was " + this.m.LifetimeStats.MostPowerfulVanquished + ".");
				}
			}

			tooltip.push({
				id = 2,
				type = "description",
				text = text
			});
			tooltip.push({
				id = 5,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "Level " + this.m.Level
			});

			if (this.getDailyCost() != 0)
			{
				tooltip.push({
					id = 3,
					type = "text",
					icon = "ui/icons/asset_daily_money.png",
					text = "Paid [img]gfx/ui/tooltips/money.png[/img]" + this.getDailyCost() + " daily"
				});
			}

			tooltip.push({
				id = 4,
				type = "text",
				icon = this.Const.MoodStateIcon[this.getMoodState()],
				text = this.Const.MoodStateName[this.getMoodState()]
			});

			if (!this.isInReserves())
			{
				tooltip.push({
					id = 6,
					type = "hint",
					icon = "ui/icons/stat_screen_dmg_dealt.png",
					text = "In the fighting line"
				});
			}
			else
			{
				tooltip.push({
					id = 6,
					type = "hint",
					icon = "ui/icons/camp.png",
					text = "In reserve"
				});
			}

			tooltip.push({
				id = 7,
				type = "hint",
				text = this.getBackground().getBackgroundDescription(false)
			});
		}

		local injuries = this.getSkills().query(this.Const.SkillType.Injury | this.Const.SkillType.SemiInjury);

		foreach( injury in injuries )
		{
			if (injury.isType(this.Const.SkillType.TemporaryInjury))
			{
				local ht = injury.getHealingTime();

				if (ht.Min != ht.Max)
				{
					tooltip.push({
						id = 90,
						type = "text",
						icon = injury.getIcon(),
						text = injury.getName() + " (" + ht.Min + "-" + ht.Max + " days)"
					});
				}
				else if (ht.Min > 1)
				{
					tooltip.push({
						id = 90,
						type = "text",
						icon = injury.getIcon(),
						text = injury.getName() + " (" + ht.Min + " days)"
					});
				}
				else
				{
					tooltip.push({
						id = 90,
						type = "text",
						icon = injury.getIcon(),
						text = injury.getName() + " (" + ht.Min + " day)"
					});
				}
			}
			else
			{
				tooltip.push({
					id = 90,
					type = "text",
					icon = injury.getIcon(),
					text = injury.getName()
				});
			}
		}

		if (this.getHitpoints() < this.getHitpointsMax())
		{
			local ht = this.getDaysWounded();

			if (ht > 1)
			{
				tooltip.push({
					id = 133,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Light Wounds (" + ht + " days)"
				});
			}
			else
			{
				tooltip.push({
					id = 133,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Light Wounds (" + ht + " day)"
				});
			}
		}

		return tooltip;
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

	function create()
	{
		this.actor.create();
		this.m.IsControlledByPlayer = true;
		this.m.IsGeneratingKillName = false;
		this.m.Type = this.Const.EntityType.Player;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Ghoul.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(33, -26);
		this.m.DecapitateBloodAmount = 0.7;
		this.m.BloodPoolScale = 0.7;
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/ghoul_hurt_01.wav",
			"sounds/enemies/ghoul_hurt_02.wav",
			"sounds/enemies/ghoul_hurt_03.wav",
			"sounds/enemies/ghoul_hurt_04.wav",
			"sounds/enemies/ghoul_hurt_05.wav",
			"sounds/enemies/ghoul_hurt_06.wav",
			"sounds/enemies/ghoul_hurt_07.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/ghoul_hurt_08.wav",
			"sounds/enemies/ghoul_hurt_09.wav",
			"sounds/enemies/ghoul_hurt_10.wav",
			"sounds/enemies/ghoul_hurt_11.wav",
			"sounds/enemies/ghoul_hurt_12.wav",
			"sounds/enemies/ghoul_hurt_13.wav",
			"sounds/enemies/ghoul_hurt_14.wav",
			"sounds/enemies/ghoul_hurt_15.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/ghoul_flee_05.wav",
			"sounds/enemies/ghoul_flee_06.wav",
			"sounds/enemies/ghoul_flee_07.wav",
			"sounds/enemies/ghoul_flee_08.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/ghoul_flee_01.wav",
			"sounds/enemies/ghoul_flee_02.wav",
			"sounds/enemies/ghoul_flee_03.wav",
			"sounds/enemies/ghoul_flee_04.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/ghoul_death_01.wav",
			"sounds/enemies/ghoul_death_02.wav",
			"sounds/enemies/ghoul_death_03.wav",
			"sounds/enemies/ghoul_death_04.wav",
			"sounds/enemies/ghoul_death_05.wav",
			"sounds/enemies/ghoul_death_06.wav",
			"sounds/enemies/ghoul_death_07.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/ghoul_idle_01.wav",
			"sounds/enemies/ghoul_idle_02.wav",
			"sounds/enemies/ghoul_idle_03.wav",
			"sounds/enemies/ghoul_idle_04.wav",
			"sounds/enemies/ghoul_idle_05.wav",
			"sounds/enemies/ghoul_idle_06.wav",
			"sounds/enemies/ghoul_idle_07.wav",
			"sounds/enemies/ghoul_idle_08.wav",
			"sounds/enemies/ghoul_idle_09.wav",
			"sounds/enemies/ghoul_idle_10.wav",
			"sounds/enemies/ghoul_idle_11.wav",
			"sounds/enemies/ghoul_idle_12.wav",
			"sounds/enemies/ghoul_idle_13.wav",
			"sounds/enemies/ghoul_idle_14.wav",
			"sounds/enemies/ghoul_idle_15.wav",
			"sounds/enemies/ghoul_idle_16.wav",
			"sounds/enemies/ghoul_idle_17.wav",
			"sounds/enemies/ghoul_idle_18.wav",
			"sounds/enemies/ghoul_idle_19.wav",
			"sounds/enemies/ghoul_idle_20.wav",
			"sounds/enemies/ghoul_idle_21.wav",
			"sounds/enemies/ghoul_idle_22.wav",
			"sounds/enemies/ghoul_idle_23.wav",
			"sounds/enemies/ghoul_idle_24.wav",
			"sounds/enemies/ghoul_idle_25.wav",
			"sounds/enemies/ghoul_idle_26.wav",
			"sounds/enemies/ghoul_idle_27.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/ghoul_grows_01.wav",
			"sounds/enemies/ghoul_grows_02.wav",
			"sounds/enemies/ghoul_grows_03.wav",
			"sounds/enemies/ghoul_grows_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other2] = [
			"sounds/enemies/ghoul_death_fullbelly_01.wav",
			"sounds/enemies/ghoul_death_fullbelly_02.wav",
			"sounds/enemies/ghoul_death_fullbelly_03.wav"
		];
		this.m.SoundPitch = 1.15;
		local onArmorHitSounds = this.getItems().getAppearance().ImpactSound;
		onArmorHitSounds[this.Const.BodyPart.Body] = this.Const.Sound.ArmorLeatherImpact;
		onArmorHitSounds[this.Const.BodyPart.Head] = this.Const.Sound.ArmorLeatherImpact;
		this.m.Items = this.new("scripts/items/nggh707_item_container");
		this.m.Items.setActor(this);
		this.m.Items.blockAllSlots();
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Accessory] = false;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Head] = false;
		this.m.AIAgent = this.new("scripts/ai/tactical/player_agent");
		this.m.AIAgent.setActor(this);
		this.m.Formations = this.new("scripts/entity/tactical/formations_container");
		this.m.LifetimeStats.Tags = this.new("scripts/tools/tag_collection");
		this.getFlags().set("Hexe", 0);
		this.getFlags().set("PotionLastUsed", 0.0);
		this.getFlags().set("PotionsUsed", 0);
		this.getFlags().add("ghoul");
		this.getFlags().add("undead");
		this.getFlags().add("luft");
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
	
	function onInit()
	{
		this.entity.onInit();

		if (!this.isInitialized())
		{
			this.createOverlay();
			this.m.BaseProperties = this.Const.HexenOrigin.CharacterProperties.getClone();
			this.m.CurrentProperties = this.Const.HexenOrigin.CharacterProperties.getClone();
			this.m.IsAttackable = true;

			if (this.m.MoraleState != this.Const.MoraleState.Ignore)
			{
				this.m.Skills.add(this.new("scripts/skills/special/morale_check"));
			}

			this.m.Items.setUnlockedBagSlots(2);
		}
	
		local b = this.m.BaseProperties;
		b.TargetAttractionMult = 1.5;
		b.ArmorMult[1] = 0.5;
		b.IsAffectedByNight = false;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToDamageReflection = true;
		b.IsContentWithBeingInReserve = true;
		
		this.m.ActionPoints = b.ActionPoints;	
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		local arrow = this.addSprite("arrow");
		arrow.setBrush("bust_arrow");
		arrow.Visible = false;
		this.setSpriteColorization("arrow", false);
		local rooted = this.addSprite("status_rooted_back");
		rooted.Visible = false;
		rooted.Scale = 0.55;
		
		this.addSprite("socket").setBrush("bust_base_player");
		this.addSprite("miniboss");
		local body = this.addSprite("body");
		body.setBrush("bust_ghoulskin_body_01");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		local head = this.addSprite("head");
		head.setBrush("bust_ghoulskin_head_01");
		this.m.Head = this.Math.rand(1, 3);
		local injury = this.addSprite("injury");
		injury.setBrush("bust_ghoul_01_injured");
		injury.Visible = false;
		
		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		local v = -10;
		local v2 = 5;

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, this.createVec(v2, v));
		}
		
		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_body_bloodied_02");
		body_blood.Visible = false;
		
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
		charm_hair.setHorizontalFlipping(false);
		charm_hair.Visible = false;
		
		local hex = this.addSprite("status_hex");
		hex.Visible = false;
		local sweat = this.addSprite("status_sweat");
		local stunned = this.addSprite("status_stunned");
		stunned.setBrush(this.Const.Combat.StunnedBrush);
		stunned.Visible = false;
		local shield_icon = this.addSprite("shield_icon");
		shield_icon.Visible = false;
		local arms_icon = this.addSprite("arms_icon");
		arms_icon.Visible = false;
		local rooted = this.addSprite("status_rooted");
		rooted.Visible = false;
		rooted.Scale = this.getSprite("status_rooted_back").Scale;

		if (this.m.MoraleState != this.Const.MoraleState.Ignore)
		{
			local morale = this.addSprite("morale");
			morale.Visible = false;
		}
		this.getSprite("status_rooted").Scale = 0.45;
		this.setSpriteOffset("status_rooted", this.createVec(-4, 7));
		
		if (this.Const.DLC.Unhold)
		{
			this.m.Skills.add(this.new("scripts/skills/actives/wake_ally_skill"));
		}
		
		this.m.Skills.add(this.new("scripts/skills/actives/break_ally_free_skill"));
		this.m.Skills.add(this.new("scripts/skills/effects/captain_effect"));
		this.m.Skills.add(this.new("scripts/skills/special/stats_collector"));
		this.m.Skills.add(this.new("scripts/skills/special/mood_check"));
		this.m.Skills.add(this.new("scripts/skills/effects/battle_standard_effect"));
		this.m.Skills.add(this.new("scripts/skills/effects/realm_of_nightmares_effect"));
		this.m.Skills.add(this.new("scripts/skills/effects/legend_demon_hound_aura_effect"));
		this.m.Skills.add(this.new("scripts/skills/actives/break_ally_free_skill"));
		this.m.Skills.add(this.new("scripts/skills/spell_hexe/charm_spell"));
		this.m.Skills.add(this.new("scripts/skills/spell_hexe/charm_captive_spell"));
		
		this.setPreventOcclusion(true);
		this.setBlockSight(false);
		this.setVisibleInFogOfWar(false);
		this.m.Skills.update();
	}
	
	function onAfterInit()
	{
		this.setFaction(this.Const.Faction.Player);
		this.setDiscovered(true);
		this.updateOverlay();
		this.setSpriteOffset("status_rooted_back", this.getSpriteOffset("status_rooted"));
		this.getSprite("status_rooted_back").Scale = this.getSprite("status_rooted").Scale;
		this.onAppearanceChanged(this.m.Items.getAppearance());
		this.onFactionChanged();
		local p = this.new("scripts/skills/perks/perk_charm_enemy_ghoul");
		p.m.IsSerialized = false;
		this.m.Skills.add(p);
		this.m.Skills.add(this.new("scripts/skills/actives/patting_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/legend_skin_ghoul_claws"));
		this.m.Skills.add(this.new("scripts/skills/actives/legend_skin_ghoul_swallow_whole_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/gruesome_feast"));
		this.m.Skills.add(this.new("scripts/skills/effects/gruesome_feast_effect"));
		this.m.Skills.update();
	}
	
	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		
		flip = !this.isAlliedWithPlayer();
		this.getSprite("accessory").setHorizontalFlipping(flip);
		this.getSprite("accessory_special").setHorizontalFlipping(flip);
		this.getSprite("body_blood").setHorizontalFlipping(flip);

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.getSprite(a).setHorizontalFlipping(flip);
		}
	}
	
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		if (_appearance != null && _appearance.Helmet.len() != 0)
		{
			_appearance.HelmetDamage = "bust_helmet_86_damaged";
			_appearance.HelmetLayerVanityLower = "";
			_appearance.HelmetLayerVanity2Lower = "";
			_appearance.Helmet = "bust_helmet_86";
			_appearance.HelmetLayerHelm = "";
			_appearance.HelmetLayerTop = "";
		}

		local jesterHat = [
			"legendhelms_jester_hat_1",
			"legendhelms_jester_hat_2",
			"legendhelms_jester_hat_3",
			"legendhelms_jester_hat_4",
			"legendhelms_jester_hat_5",
			"legendhelms_jester_hat_6",
			"legendhelms_jester_hat_7",
			"legendhelms_jester_hat_8",
			"legendhelms_jester_hat_9",
			"legendhelms_jester_hat_10",
			"legendhelms_jester_hat_11",
			"legendhelms_jester_hat_12",
			"legendhelms_jester_hat_1_damaged",
			"legendhelms_jester_hat_2_damaged",
			"legendhelms_jester_hat_3_damaged",
			"legendhelms_jester_hat_4_damaged",
			"legendhelms_jester_hat_5_damaged",
			"legendhelms_jester_hat_6_damaged",
			"legendhelms_jester_hat_7_damaged",
			"legendhelms_jester_hat_8_damaged",
			"legendhelms_jester_hat_9_damaged",
			"legendhelms_jester_hat_10_damaged",
			"legendhelms_jester_hat_11_damaged",
			"legendhelms_jester_hat_12_damaged",
		];

		if (_appearance.HelmetLayerVanity.len() != 0)
		{
			if (jesterHat.find(_appearance.HelmetLayerVanity) == null)
			{
				_appearance.HelmetLayerVanity = "";
			}
		}

		if (_appearance.HelmetLayerVanity2.len() != 0)
		{
			if (jesterHat.find(_appearance.HelmetLayerVanity2) == null)
			{
				_appearance.HelmetLayerVanity2 = "";
			}
		}
		
		this.actor.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite();
	}
	
	function onAdjustingSprite()
	{
		local offSetX = [
			5,
			7,
			13
		];
		local offSetY = [
			-13,
			-10,
			-10
		];
		local s = this.getSize();
		local i = this.Math.max(0, s - 1);

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}
			
			this.setSpriteOffset(a, this.createVec(offSetX[i], offSetY[i]));
			this.getSprite(a).Scale = s == 3 ? 1.15 : 1.0;
		}
		
		this.setSpriteOffset("charm_hair", this.createVec(offSetX[i], offSetY[i]));
		this.getSprite("charm_hair").Scale = s == 3 ? 1.15 : 1.0;
		
		this.setAlwaysApplySpriteOffset(true);
	}

	function isReallyKilled( _fatalityType )
	{
		return true;
	}

	function checkMorale( _change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
	{	
		_difficulty = _difficulty + 15;

		return this.player.checkMorale(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
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
			hitpointsMax = 300,
			hitpointsIncrease = this.m.Attributes[this.Const.Attributes.Hitpoints][0],
			bravery = b.Bravery,
			braveryMax = 225,
			braveryIncrease = this.m.Attributes[this.Const.Attributes.Bravery][0],
			fatigue = b.Stamina,
			fatigueMax = 400,
			fatigueIncrease = this.m.Attributes[this.Const.Attributes.Fatigue][0],
			initiative = b.Initiative,
			initiativeMax = 350,
			initiativeIncrease = this.m.Attributes[this.Const.Attributes.Initiative][0],
			meleeSkill = b.MeleeSkill,
			meleeSkillMax = 120,
			meleeSkillIncrease = this.m.Attributes[this.Const.Attributes.MeleeSkill][0],
			rangeSkill = b.RangedSkill,
			rangeSkillMax = 50,
			rangeSkillIncrease = this.m.Attributes[this.Const.Attributes.RangedSkill][0],
			meleeDefense = b.MeleeDefense,
			meleeDefenseMax = 100,
			meleeDefenseIncrease = this.m.Attributes[this.Const.Attributes.MeleeDefense][0],
			rangeDefense = b.RangedDefense,
			rangeDefenseMax = 100,
			rangeDefenseIncrease = this.m.Attributes[this.Const.Attributes.RangedDefense][0]
		};
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
		local brush = "bust_boobas_ghoul_with_dress_0" + this.m.Size;
		local head_brush = this.m.Size == 1 ? "bust_ghoulskin_head_01" : "bust_ghoulskin_0" + this.m.Size + "_head_0" + this.Math.rand(1, 3);
		local hat_brush = "bust_helmet_86";
		local skill = this.getSkills().getSkillByID("actives.legend_skin_ghoul_swallow_whole");

		if (skill != null && skill.getSwallowedEntity() != null)
		{
			brush = "bust_boobas_ghoul_with_dress_04";
			head_brush = "bust_ghoulskin_04_head_0" + this.Math.rand(1, 3);
		}

		if (this.m.IsCharming)
		{
			local sprite;
			sprite = this.getSprite("charm_body");
			sprite.setBrush(brush);
			sprite.Visible = true;
			sprite.fadeIn(t);
			
			sprite = this.getSprite("charm_head");
			sprite.setBrush(head_brush);
			sprite.Visible = true;
			sprite.fadeIn(t);
			
			sprite= this.getSprite("charm_hair");
			sprite.setBrush(hat_brush);
			sprite.Visible = true;
			sprite.fadeIn(t);
			this.onAllSpritesHidden(true);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, t + 100, function ( _e )
			{
				if (!_e.isAlive())
				{
					return;
				}
				
				local sprite;
				sprite = _e.getSprite("charm_body");
				sprite.Visible = true;
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
		local sprite_head = this.getSprite("head");
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

				if (sprite_accessory.HasBrush)
				{
					decal = stub.addSprite("accessory");
					decal.setBrush(sprite_accessory.getBrush().Name + "_dead");
				}

				if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
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

					if (appearance.HelmetCorpse != "")
					{
						decal = stub.addSprite("helmet");
						decal.setBrush(this.getItems().getAppearance().HelmetCorpse);
					}
				}
			}
		}

		local flip = this.Math.rand(0, 100) < 50;

		if (_tile != null)
		{
			local decal;
			local skin = this.getSprite("body");
			this.m.IsCorpseFlipped = flip;
			decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = skin.Color;
			decal.Saturation = skin.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);

			if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [
					sprite_head.getBrush().Name + "_dead"
				];
				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-45, 10), 55.0, sprite_head.getBrush().Name + "_bloodpool");

				foreach( sprite in decap )
				{
					sprite.Color = skin.Color;
					sprite.Saturation = skin.Saturation;
					sprite.Scale = 0.9;
					sprite.setBrightness(0.9);
				}
			}
			else
			{
				decal = _tile.spawnDetail(sprite_head.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = skin.Color;
				decal.Saturation = skin.Saturation;
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.Tile = _tile;
			corpse.Value = 2.0;
			corpse.IsResurrectable = false;
			corpse.Armor = this.m.BaseProperties.Armor;
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);

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
	
	function onAfterDeath( _tile )
	{
		if (this.m.Size < 3)
		{
			return;
		}

		local skill = this.getSkills().getSkillByID("actives.legend_skin_ghoul_swallow_whole");

		if (skill == null)
		{
			return;
		}
		
		if (skill.getSwallowedEntity() == null)
		{
			return;
		}

		local e = skill.getSwallowedEntity();
		e.setIsAlive(true);
		this.Tactical.addEntityToMap(e, _tile.Coords.X, _tile.Coords.Y);
		
		if (!e.isPlayerControlled() && e.getType() != this.Const.EntityType.Serpent)
		{
			this.Tactical.getTemporaryRoster().remove(e);
		}
		
		e.getFlags().set("Devoured", false);
		
		if (e.hasSprite("dirt"))
		{
			local slime = e.getSprite("dirt");
			slime.setBrush("bust_slime");
			slime.Visible = true;
		}
		else
		{
			local slime = e.addSprite("dirt");
			slime.setBrush("bust_slime");
			slime.Visible = true;
		}
	}
	
	function grow( _instant = false )
	{
		if (this.m.Size == 3)
		{
			return;
		}

		if (!_instant && this.m.Sound[this.Const.Sound.ActorEvent.Other1].len() != 0)
		{
			this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Other1][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Other1].len() - 1)], this.Const.Sound.Volume.Actor, this.getPos());
		}

		this.m.Size = this.Math.min(3, this.m.Size + 1);
		
		if (this.m.Size == 2)
		{
			this.m.SoundPitch = 1.06;
			this.getSprite("body").setBrush("bust_ghoulskin_body_02");
			this.getSprite("head").setBrush("bust_ghoulskin_02_head_0" + this.m.Head);
			this.getSprite("injury").setBrush("bust_ghoulskin_02_injured");
			this.getSprite("injury").Visible = false;

			if (!_instant)
			{
				this.setRenderCallbackEnabled(true);
				this.m.ScaleStartTime = this.Time.getVirtualTimeF();
			}

			this.m.DecapitateSplatterOffset = this.createVec(33, -26);
			this.m.DecapitateBloodAmount = 1.0;
			this.m.BloodPoolScale = 1.0;
			this.getSprite("status_rooted").Scale = 0.5;
			this.getSprite("status_rooted_back").Scale = 0.5;
			this.setSpriteOffset("status_rooted", this.createVec(-4, 10));
			this.setSpriteOffset("status_rooted_back", this.createVec(-4, 10));
		}
		else if (this.m.Size == 3)
		{
			this.m.SoundPitch = 1.0;
			this.getSprite("body").setBrush("bust_ghoulskin_body_03");
			this.getSprite("head").setBrush("bust_ghoulskin_03_head_0" + this.m.Head);
			this.getSprite("injury").setBrush("bust_ghoulskin_03_injured");
			this.getSprite("injury").Visible = false;

			if (!_instant)
			{
				this.setRenderCallbackEnabled(true);
				this.m.ScaleStartTime = this.Time.getVirtualTimeF();
			}

			this.m.DecapitateSplatterOffset = this.createVec(35, -26);
			this.m.DecapitateBloodAmount = 1.5;
			this.m.BloodPoolScale = 1.33;
			this.getSprite("status_rooted").Scale = 0.6;
			this.getSprite("status_rooted_back").Scale = 0.6;
			this.setSpriteOffset("status_rooted", this.createVec(-7, 14));
			this.setSpriteOffset("status_rooted_back", this.createVec(-7, 14));
		}

		this.m.SoundPitch = 1.2 - this.m.Size * 0.1;
		this.onAdjustingSprite();
		this.m.Skills.update();
		this.setDirty(true);
	}

	function onRender()
	{
		this.actor.onRender();

		if (this.m.Size == 2)
		{
			this.getSprite("body").Scale = this.Math.minf(1.0, 0.96 + 0.04 * ((this.Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));
			this.getSprite("head").Scale = this.Math.minf(1.0, 0.96 + 0.04 * ((this.Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));
			this.moveSpriteOffset("body", this.createVec(0, -1), this.createVec(0, 0), 0.3, this.m.ScaleStartTime);

			if (this.moveSpriteOffset("head", this.createVec(0, -1), this.createVec(0, 0), 0.3, this.m.ScaleStartTime))
			{
				this.setRenderCallbackEnabled(false);
			}
		}
		else if (this.m.Size == 3)
		{
			this.getSprite("body").Scale = this.Math.minf(1.0, 0.94 + 0.06 * ((this.Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));
			this.getSprite("head").Scale = this.Math.minf(1.0, 0.94 + 0.06 * ((this.Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));
			this.moveSpriteOffset("body", this.createVec(0, -1), this.createVec(0, 0), 0.3, this.m.ScaleStartTime);

			if (this.moveSpriteOffset("head", this.createVec(0, -1), this.createVec(0, 0), 0.3, this.m.ScaleStartTime))
			{
				this.setRenderCallbackEnabled(false);
			}
		}
	}
	
	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
		local AttributesLevelUp = [
			{
				Min = 1,
				Max = 2
			},
			{
				Min = 2,
				Max = 3
			},
			{
				Min = 3,
				Max = 4
			},
			{
				Min = 3,
				Max = 4
			},
			{
				Min = 2,
				Max = 3
			},
			{
				Min = 1,
				Max = 1
			},
			{
				Min = 1,
				Max = 2
			},
			{
				Min = 1,
				Max = 2
			}
		];
		
		if (this.m.Attributes.len() == 0)
		{
			this.m.Attributes.resize(this.Const.Attributes.COUNT);

			for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
			{
				this.m.Attributes[i] = [];
			}
		}

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			for( local j = 0; j < _amount; j = ++j )
			{
				if (_minOnly)
				{
					this.m.Attributes[i].insert(0, this.Math.rand(1, this.Math.rand(1, 2)));
				}
				else if (_maxOnly)
				{
					this.m.Attributes[i].insert(0, AttributesLevelUp[i].Max);
				}
				else
				{
					this.m.Attributes[i].insert(0, this.Math.rand(AttributesLevelUp[i].Min + (this.m.Talents[i] == 3 ? 2 : this.m.Talents[i]), AttributesLevelUp[i].Max + (this.m.Talents[i] == 3 ? 1 : 0)));
				}
			}
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
	
	function updateInjuryVisuals( _setDirty = true )
	{
		this.setDirty(_setDirty);
	}
	
	function setScenarioValues()
	{
		local b = this.m.BaseProperties;
		b.setValues({
			XP = 250,
			ActionPoints = 12,
			Hitpoints = 200,
			Bravery = 50,
			Stamina = 130,
			MeleeSkill = 65,
			RangedSkill = 0,
			MeleeDefense = 10,
			RangedDefense = 7,
			Initiative = 115,
			FatigueEffectMult = 1.0,
			MoraleEffectMult = 1.0,
			Armor = [
				0,
				0
			],
		});
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setName("Luft");
		this.setTitle("The Rat Enjoyer");
		this.setVeteranPerks(2);
		this.m.Skills.add(this.new("scripts/skills/traits/ambitious_trait"));
		this.m.Skills.add(this.new("scripts/skills/traits/seductive_trait"));
		this.m.Skills.add(this.new("scripts/skills/traits/intensive_training_trait"));
		this.m.PerkPoints = 1;
		this.m.LevelUps = 0;
		this.m.Level = 1;
		
		local background = this.new("scripts/skills/backgrounds/luft_background");
		this.m.Skills.add(background);
		this.m.Background = background;
		background.resetPerkTree();
		background.onAddEquipment();
		
		this.m.Talents = [];
		this.m.Attributes = [];
		this.fillBeastTalentValues(this.Math.rand(6, 9), true);
		this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
	}
	
	function setStartValuesEx( _backgrounds, _addTraits = true, _gender = -1, _addEquipment = true )
	{
	}
	
	function fillBeastTalentValues( _stars = 0 , _force = false )
	{
		local helper = this.getroottable().TalentFiller;
		local info = {
			ExcludedTalents = [5],
			PrimaryTalents = [0, 2, 4],
			SecondaryTalents = [1, 3, 6, 7],
			StarsMax = 9,
			StarsMin = 9,
		};
		
		helper.fillModdedTalentValues(this , info , _stars , _force);
	}

	function fillTalentValues( _num, _force = false )
	{
		local stars = 0;
		
		if (_num == null)
		{
			stars = this.Math.rand(1, 9);
		}
		else
		{
			_num = this.Math.max(1, this.Math.min(_num, 3));
			stars = this.Math.rand(_num, _num * 3);
		}
		
		this.fillBeastTalentValues(stars, _force);
	}
	
	function TherianthropeInfection( _killer )
	{
	}
	
	function TherianthropeInfectionRandom()
	{
	}
	
	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}
	
	function getRiderID()
	{
		return "";
	}
	
	function setRider()
	{
	}
	
	function onTurnStart()
	{
		if (!this.isAlive())
		{
			return;
		}
		
		this.Tactical.spawnSpriteEffect("luft_idle_quote_" + this.Math.rand(1, 6), this.createColor("#ffffff"), this.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 105, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, 900, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
		this.actor.onTurnStart();
	}
	
	function onTurnResumed()
	{
		this.Tactical.spawnSpriteEffect("luft_idle_quote_" + this.Math.rand(1, 6), this.createColor("#ffffff"), this.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 105, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, 900, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
		this.actor.onTurnResumed();
	}
	
	function onAttacked( _attacker )
	{
		this.Tactical.spawnSpriteEffect("luft_damage_taken_quote_" + this.Math.rand(1, 3), this.createColor("#ffffff"), this.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 105, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
		this.actor.onAttacked(_attacker);
	}
	
	function onMovementFinish( _tile )
	{
		this.actor.onMovementFinish(_tile);
		
		if (!this.isAlive())
		{
			return;
		}
		
		this.Tactical.spawnSpriteEffect("luft_move_quote_" + this.Math.rand(1, 3), this.createColor("#ffffff"), _tile, this.Const.Tactical.Settings.SkillOverlayOffsetX, 105, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, 900, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
	}

	function onCombatFinished()
	{
		this.actor.resetRenderEffects();
		this.m.IsAlive = true;
		this.m.IsDying = false;
		this.m.IsAbleToDie = true;
		this.m.Hitpoints = this.Math.max(1, this.m.Hitpoints);
		this.m.MaxEnemiesThisTurn = 1;

		if (this.m.MoraleState != this.Const.MoraleState.Ignore)
		{
			this.setMoraleState(this.Const.MoraleState.Steady);
		}

		this.resetBloodied(false);
		this.getFlags().set("Devoured", false);
		this.getFlags().set("Charmed", false);
		this.getFlags().set("Sleeping", false);
		this.getFlags().set("Nightmare", false);
		this.m.Fatigue = 0;
		this.m.ActionPoints = 0;
		this.m.Items.onCombatFinished();
		this.m.Skills.onCombatFinished();

		if (this.m.IsAlive)
		{
			this.updateLevel();
			this.setDirty(true);
		}
	}
	
	function resetPerkTree()
	{
		return;

		if (this.getFlags().getAsInt("Hexe_Origin") >= this.HexeVersion)
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

	function getBarberSpriteChange()
	{
		return ["body", "head"];
	}

	function getPossibleSprites( _type )
	{
		local ret = [];
		local s = this.getSize();

		if (s == 1)
		{
			switch (_type) 
			{
		    case "body":
		        ret = [
		        	"bust_ghoul_body_01",
		        	"bust_ghoulskin_body_01",
		        ];
		        break;

		    case "head":
		        ret = [
		        	"bust_ghoul_head_01",
		        	"bust_ghoulskin_head_01",
		        ];
		        break;
			}
		}
		else 
		{
		    switch (_type) 
			{
		    case "body":
		        ret = [
		        	"bust_ghoul_body_0" + s,
		        	"bust_ghoulskin_body_0" + s,
		        ];
		        break;

		    case "head":
		        ret = [
		        	"bust_ghoul_0" + s + "_head_01",
		        	"bust_ghoul_0" + s + "_head_02",
		        	"bust_ghoul_0" + s + "_head_03",
		        	"bust_ghoulskin_0" + s + "_head_01",
		        	"bust_ghoulskin_0" + s + "_head_02",
		        	"bust_ghoulskin_0" + s + "_head_03",
		        ];
		        break;
			}
		}

		return ret;
	}
	
	function onSerialize( _out )
	{
		this.getFlags().set("size", this.m.Size);
		this.actor.onSerialize(_out);
		_out.writeU8(this.m.Level);
		_out.writeU8(this.m.PerkPoints);
		_out.writeU8(this.m.PerkPointsSpent);
		_out.writeU8(this.m.LevelUps);
		_out.writeF32(this.m.Mood);
		_out.writeU8(this.m.MoodChanges.len());

		for( local i = 0; i != this.m.MoodChanges.len(); i = i )
		{
			_out.writeBool(this.m.MoodChanges[i].Positive);
			_out.writeString(this.m.MoodChanges[i].Text);
			_out.writeF32(this.m.MoodChanges[i].Time);
			i = ++i;
		}

		_out.writeF32(this.m.HireTime);
		_out.writeF32(this.m.LastDrinkTime);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = i )
		{
			_out.writeU8(this.m.Talents[i]);
			i = ++i;
		}

		for( local i = 0; i != this.Const.Attributes.COUNT; i = i )
		{
			_out.writeU8(this.m.Attributes[i].len());

			foreach( a in this.m.Attributes[i] )
			{
				_out.writeU8(a);
			}

			i = ++i;
		}

		_out.writeU8(this.m.PlaceInFormation);
		_out.writeU32(this.m.LifetimeStats.Kills);
		_out.writeU32(this.m.LifetimeStats.Battles);
		_out.writeU32(this.m.LifetimeStats.BattlesWithoutMe);
		_out.writeU16(this.m.LifetimeStats.MostPowerfulVanquishedType);
		_out.writeString(this.m.LifetimeStats.MostPowerfulVanquished);
		_out.writeU16(this.m.LifetimeStats.MostPowerfulVanquishedXP);
		_out.writeString(this.m.LifetimeStats.FavoriteWeapon);
		_out.writeU32(this.m.LifetimeStats.FavoriteWeaponUses);
		_out.writeU32(this.m.LifetimeStats.CurrentWeaponUses);
		this.m.LifetimeStats.Tags.onSerialize(_out);
		_out.writeBool(this.m.IsTryoutDone);
		this.m.Formations.onSerialize(_out);
		_out.writeU8(this.m.VeteranPerks);
		_out.writeBool(this.m.IsCommander);
		_out.writeString(this.m.CampAssignment);
		_out.writeF32(this.m.LastCampTime);
		_out.writeBool(this.m.InReserves);
		_out.writeU8(this.m.CompanyID);
		_out.writeBool(this.m.IsCharming);
		_out.writeU8(this.m.Size);
		_out.writeU8(this.m.Head);
	}

	function onDeserialize( _in )
	{
		this.actor.onDeserialize(_in);
		this.m.Level = _in.readU8();
		this.m.PerkPoints = _in.readU8();
		this.m.PerkPointsSpent = _in.readU8();
		this.m.LevelUps = _in.readU8();
		this.m.Mood = _in.readF32();
		local numMoodChanges = _in.readU8();
		this.m.MoodChanges.resize(numMoodChanges, 0);

		for( local i = 0; i != numMoodChanges; i = i )
		{
			local moodChange = {};
			moodChange.Positive <- _in.readBool();
			moodChange.Text <- _in.readString();
			moodChange.Time <- _in.readF32();
			this.m.MoodChanges[i] = moodChange;
			i = ++i;
		}

		this.m.HireTime = _in.readF32();
		this.m.LastDrinkTime = _in.readF32();
		this.m.Talents.resize(this.Const.Attributes.COUNT, 0);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = i )
		{
			this.m.Talents[i] = _in.readU8();
			i = ++i;
		}

		this.m.Attributes.resize(this.Const.Attributes.COUNT);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = i )
		{
			this.m.Attributes[i] = [];
			local n = _in.readU8();
			this.m.Attributes[i].resize(n);

			for( local j = 0; j != n; j = j )
			{
				this.m.Attributes[i][j] = _in.readU8();
				j = ++j;
			}

			i = ++i;
		}

		local ret = this.m.Skills.query(this.Const.SkillType.Background);

		if (ret.len() != 0)
		{
			this.m.Background = ret[0];
			this.m.Background.adjustHiringCostBasedOnEquipment();
			this.m.Background.buildDescription(true);
		}

		this.m.PlaceInFormation = _in.readU8();
		this.m.LifetimeStats.Kills = _in.readU32();
		this.m.LifetimeStats.Battles = _in.readU32();
		this.m.LifetimeStats.BattlesWithoutMe = _in.readU32();

		if (_in.getMetaData().getVersion() >= 37)
		{
			this.m.LifetimeStats.MostPowerfulVanquishedType = _in.readU16();
		}

		this.m.LifetimeStats.MostPowerfulVanquished = _in.readString();
		this.m.LifetimeStats.MostPowerfulVanquishedXP = _in.readU16();
		this.m.LifetimeStats.FavoriteWeapon = _in.readString();
		this.m.LifetimeStats.FavoriteWeaponUses = _in.readU32();
		this.m.LifetimeStats.CurrentWeaponUses = _in.readU32();

		if (_in.getMetaData().getVersion() >= 57)
		{
			this.m.LifetimeStats.Tags.onDeserialize(_in);
		}

		this.m.IsTryoutDone = _in.readBool();

		if (_in.getMetaData().getVersion() >= 46)
		{
			this.m.Formations.onDeserialize(_in);
		}

		if (_in.getMetaData().getVersion() >= 47)
		{
			this.m.VeteranPerks = _in.readU8();

			if (this.m.VeteranPerks == 0)
			{
				this.m.VeteranPerks = 5;
			}
		}

		if (_in.getMetaData().getVersion() >= 48)
		{
			this.m.IsCommander = _in.readBool();
		}

		if (_in.getMetaData().getVersion() >= 52)
		{
			this.m.CampAssignment = _in.readString();
			this.m.LastCampTime = _in.readF32();
		}

		if (_in.getMetaData().getVersion() >= 54)
		{
			this.m.InReserves = _in.readBool();
		}

		this.m.CompanyID = _in.readU8();
		this.m.IsCharming = _in.readBool();
		this.m.Size = _in.readU8();
		this.m.Head = _in.readU8();
		this.setSize(this.m.Size);
		this.resetPerkTree();
		this.m.Skills.update();

		if (!this.World.Flags.get("IsLuftAdventure"))
		{
			this.World.Flags.set("IsLuftAdventure", true);
		}
	}

});

