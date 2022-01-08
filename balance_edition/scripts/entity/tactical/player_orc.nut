this.player_orc <- this.inherit("scripts/entity/tactical/player", {
	m = {
		IsWearingOrcArmor = false,
		OffsetArmor = [0, 0],
		ScaleArmor = 1.1,
		IsWearingOrcHelmet = false,
		OffsetHelmet = [4, 0],
		IsStengthen = false,
		OrcType = 0, //0- Young, 1- Berserker, 2- Warrior, 3-Elite, 4-Warlord, 5-Behemoth
		IsWarLord = false,
		IsBehemoth = false,
	},

	function getHealthRecoverMult()
	{
		return 3.0;
	}
	
	function setWarLord()
	{
		this.onWarLordSpriteChange();
	}
	
	function setBehemoth()
	{
		//this.m.IsBehemoth = this.getFlags().getAsInt("bewitched") == this.Const.EntityType.LegendOrcBehemoth;
	}
	
	function getImageOffsetY()
	{
		if (this.m.OrcType == 4)
		{
			return -5;
		}
		
		return 0;
	}
	
	function getStrength()
	{
		return 1.33;
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
		
		this.addSprite("background");
		this.addSprite("socket").setBrush("bust_base_player");
		
		local body = this.addSprite("body");
		body.setBrush("bust_orc_01_body");
		body.varySaturation(0.05);
		body.varyColor(0.07, 0.07, 0.07);
		
		this.addSprite("tattoo_body");
		
		local injury_body = this.addSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_01_body_injured");
		
		this.addSprite("armor");
		this.addSprite("armor_layer_chain");
		this.addSprite("armor_layer_plate");
		this.addSprite("armor_layer_tabbard");
		this.addSprite("surcoat");
		this.addSprite("armor_layer_cloak");
		this.addSprite("armor_upgrade_back");
		this.addSprite("shaft");
		
		local head = this.addSprite("head");
		head.setBrush("bust_orc_01_head_0" + this.Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		this.addSprite("tattoo_head");
		
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_01_head_injured");
		
		this.addSprite("armor_upgrade_front");

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}
		
		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_orc_01_body_bloodied");
		body_blood.Visible = false;
		
		local body_rage = this.addSprite("body_rage");
		body_rage.Visible = false;
		body_rage.Alpha = 220;
		
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		
		local body_dirt = this.addSprite("dirt");
		body_dirt.setBrush("bust_body_dirt_02");
		body_dirt.Visible = false;
		
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.6;

		if (this.Const.DLC.Unhold)
		{
			this.m.Skills.add(this.new("scripts/skills/actives/wake_ally_skill"));
		}
		
		this.m.Skills.add(this.new("scripts/skills/special/weapon_breaking_warning"));
		this.m.Skills.add(this.new("scripts/skills/special/no_ammo_warning"));
		this.m.Skills.add(this.new("scripts/skills/special/stats_collector"));
		this.m.Skills.add(this.new("scripts/skills/special/bag_fatigue"));
		this.m.Skills.add(this.new("scripts/skills/special/mood_check"));
		this.m.Skills.add(this.new("scripts/skills/special/double_grip"));
		this.m.Skills.add(this.new("scripts/skills/effects/captain_effect"));
		this.m.Skills.add(this.new("scripts/skills/effects/battle_standard_effect"));
		this.m.Skills.add(this.new("scripts/skills/actives/break_ally_free_skill"));
		this.m.Skills.add(this.new("scripts/skills/effects/realm_of_nightmares_effect"));
		this.m.Skills.add(this.new("scripts/skills/effects/legend_demon_hound_aura_effect"));
		this.m.Skills.add(this.new("scripts/skills/actives/hand_to_hand_orc"));
		this.m.Skills.add(this.new("scripts/skills/effects/legend_veteran_levels_effect"));
		this.setName("");
		this.setPreventOcclusion(true);
		this.setBlockSight(false);
		this.setVisibleInFogOfWar(false);
	}
	
	function onWarLordSpriteChange()
	{
		if (this.m.OrcType != 4)
		{
			return;
		}
		
		this.setSpriteOffset("arms_icon", this.createVec(-8, 0));
		this.setSpriteOffset("shield_icon", this.createVec(-5, 0));
		this.setSpriteOffset("stunned", this.createVec(0, 10));
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(0, 16));
		this.setSpriteOffset("status_stunned", this.createVec(-5, 30));
		this.setSpriteOffset("arrow", this.createVec(-5, 30));
	}
	
	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("background").setHorizontalFlipping(!flip);
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("tattoo_body").setHorizontalFlipping(flip);
		this.getSprite("injury_body").setHorizontalFlipping(flip);
		this.getSprite("shaft").setHorizontalFlipping(!flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("tattoo_head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("helmet").setHorizontalFlipping(flip);
		this.getSprite("body_blood").setHorizontalFlipping(flip);
		this.getSprite("body_rage").setHorizontalFlipping(flip);
		this.getSprite("accessory").setHorizontalFlipping(!flip);
		this.getSprite("accessory_special").setHorizontalFlipping(!flip);
		

		flip = !this.isAlliedWithPlayer();

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.getSprite(a).setHorizontalFlipping(flip);

			if (this.m.IsWearingOrcHelmet && a == "helmet")
			{
				this.getSprite(a).setHorizontalFlipping(!flip);
			}
		}

		flip = !this.isAlliedWithPlayer();
		this.getSprite("armor").setHorizontalFlipping(flip);
		this.getSprite("armor_layer_chain").setHorizontalFlipping(flip);
		this.getSprite("armor_layer_plate").setHorizontalFlipping(flip);
		this.getSprite("armor_layer_tabbard").setHorizontalFlipping(flip);
		this.getSprite("armor_layer_cloak").setHorizontalFlipping(flip);
		this.getSprite("armor_upgrade_back").setHorizontalFlipping(flip);
		this.getSprite("armor_upgrade_front").setHorizontalFlipping(flip);

		if (this.m.IsWearingOrcArmor)
		{
			this.getSprite("armor").setHorizontalFlipping(!flip);
		}
	}
	
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.actor.onAppearanceChanged(_appearance, _setDirty);
		local armors = ["armor", "armor_layer_chain", "armor_layer_plate", "armor_layer_tabbard", "armor_layer_cloak", "armor_upgrade_back", "armor_upgrade_front"];

		foreach ( a in armors )
		{
			if (a == "armor" && this.m.IsWearingOrcArmor)
			{
				this.setSpriteOffset(a, this.createVec(0, 0));
				this.getSprite(a).Scale = 1.0;
				continue;
			}

			this.setSpriteOffset(a, this.createVec(this.m.OffsetArmor[0], this.m.OffsetArmor[1]))
			this.getSprite(a).Scale = this.m.ScaleArmor;
		}

		foreach( h in this.Const.CharacterSprites.Helmets )
		{
			if (h == "helmet" && this.m.IsWearingOrcHelmet)
			{
				this.setSpriteOffset(h, this.createVec(0, 0));
				this.getSprite(h).Scale = 1.0;
				continue;
			}

			this.setSpriteOffset(h, this.createVec(this.m.OffsetHelmet[0], this.m.OffsetHelmet[1]))
		}

		this.setAlwaysApplySpriteOffset(true);
		this.onFactionChanged();
		this.setDirty(true);
	}
	
	function onUpdateInjuryLayer()
	{
		this.actor.onUpdateInjuryLayer();
	}
	
	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == this.Const.Sound.ActorEvent.Move && this.Math.rand(1, 100) <= 50)
		{
			return;
		}

		this.actor.playSound(_type, _volume, _pitch);
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
	
	function create()
	{
		this.actor.create();
		this.m.IsControlledByPlayer = true;
		this.m.IsGeneratingKillName = false;
		this.m.Type = this.Const.EntityType.Player;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(25, -25);
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/orc_idle_01.wav",
			"sounds/enemies/orc_idle_02.wav",
			"sounds/enemies/orc_idle_03.wav",
			"sounds/enemies/orc_idle_04.wav",
			"sounds/enemies/orc_idle_05.wav",
			"sounds/enemies/orc_idle_06.wav",
			"sounds/enemies/orc_idle_07.wav",
			"sounds/enemies/orc_idle_08.wav",
			"sounds/enemies/orc_idle_09.wav",
			"sounds/enemies/orc_idle_10.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/orc_hurt_01.wav",
			"sounds/enemies/orc_hurt_02.wav",
			"sounds/enemies/orc_hurt_03.wav",
			"sounds/enemies/orc_hurt_04.wav",
			"sounds/enemies/orc_hurt_05.wav",
			"sounds/enemies/orc_hurt_06.wav",
			"sounds/enemies/orc_hurt_07.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/orc_fatigue_01.wav",
			"sounds/enemies/orc_fatigue_02.wav",
			"sounds/enemies/orc_fatigue_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/orc_flee_01.wav",
			"sounds/enemies/orc_flee_02.wav",
			"sounds/enemies/orc_flee_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/orc_death_01.wav",
			"sounds/enemies/orc_death_02.wav",
			"sounds/enemies/orc_death_03.wav",
			"sounds/enemies/orc_death_04.wav",
			"sounds/enemies/orc_death_05.wav",
			"sounds/enemies/orc_death_06.wav",
			"sounds/enemies/orc_death_07.wav",
			"sounds/enemies/orc_death_08.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/orc_idle_11.wav",
			"sounds/enemies/orc_idle_12.wav",
			"sounds/enemies/orc_idle_13.wav",
			"sounds/enemies/orc_idle_14.wav",
			"sounds/enemies/orc_idle_15.wav",
			"sounds/enemies/orc_idle_16.wav",
			"sounds/enemies/orc_idle_17.wav",
			"sounds/enemies/orc_idle_18.wav",
			"sounds/enemies/orc_idle_19.wav",
			"sounds/enemies/orc_idle_20.wav",
			"sounds/enemies/orc_idle_21.wav",
			"sounds/enemies/orc_idle_22.wav",
			"sounds/enemies/orc_idle_23.wav",
			"sounds/enemies/orc_idle_24.wav",
			"sounds/enemies/orc_idle_25.wav",
			"sounds/enemies/orc_idle_26.wav",
			"sounds/enemies/orc_idle_27.wav",
			"sounds/enemies/orc_idle_28.wav",
			"sounds/enemies/orc_idle_29.wav",
		];
		this.m.SoundPitch = 1.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 0.9;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 0.9;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 1.25;
		this.m.Flags.add("orc");
		this.m.Flags.set("PotionLastUsed", 0.0);
		this.m.Flags.set("PotionsUsed", 0);
		this.m.Items = this.new("scripts/items/nggh707_item_container");
		this.m.Items.setActor(this);
		this.m.Formations = this.new("scripts/entity/tactical/formations_container");
		this.m.LifetimeStats.Tags = this.new("scripts/tools/tag_collection");
		this.m.AIAgent = this.new("scripts/ai/tactical/player_agent");
		this.m.AIAgent.setActor(this);
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
	
	function onAfterInit()
	{
		this.actor.onAfterInit();
		this.setAlwaysApplySpriteOffset(true);
		this.setFaction(this.Const.Faction.Player);
		this.setDiscovered(true);
	}
	
	function updateRageVisuals( _rage )
	{
		local body_rage = this.getSprite("body_rage");

		if (_rage <= 6)
		{
			body_rage.Visible = false;
			return;
		}
		else
		{
			body_rage.Visible = true;
		}

		if (_rage <= 12)
		{
			body_rage.setBrush("bust_orc_02_body_bloodied_00");
		}
		else if (_rage <= 18)
		{
			body_rage.setBrush("bust_orc_02_body_bloodied_01");
		}
		else if (_rage <= 24)
		{
			body_rage.setBrush("bust_orc_02_body_bloodied_02");
		}
		else
		{
			body_rage.setBrush("bust_orc_02_body_bloodied_03");
		}

		this.setDirty(true);
	}
	
	function isReallyKilled( _fatalityType )
	{
		this.m.CurrentProperties.SurvivesAsUndead = false;
		return this.player.isReallyKilled(_fatalityType);
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
				for( local i = 0; i != this.Const.CorpsePart.len(); i = ++i )
				{
					stub.addSprite("stuff_" + i).setBrush(this.Const.CorpsePart[i]);
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
					if (sprite_head.HasBrush)
					{
						if (!appearance.HideCorpseHead)
						{
							decal = stub.addSprite("head");
							decal.setBrush(sprite_head.getBrush().Name + "_dead");
							decal.Color = sprite_head.Color;
							decal.Saturation = sprite_head.Saturation;
						}
					}
					
					if (appearance.HelmetCorpse != "")
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
		
		local flip = this.Math.rand(1, 100) < 50;

		if (_tile != null)
		{
			this.m.IsCorpseFlipped = flip;
			this.spawnBloodPool(_tile, 1);
			local decal;
			local appearance = this.getItems().getAppearance();
			local sprite_body = this.getSprite("body");
			local sprite_head = this.getSprite("head");
			local tattoo_head = this.getSprite("tattoo_head");
			local tattoo_body = this.getSprite("tattoo_body");
			decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = sprite_body.Color;
			decal.Saturation = sprite_body.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);

			if (tattoo_body.HasBrush)
			{
				decal = _tile.spawnDetail(tattoo_body.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = tattoo_body.Color;
				decal.Saturation = tattoo_body.Saturation;
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			if (this.getItems().getAppearance().CorpseArmor != "")
			{
				decal = _tile.spawnDetail(appearance.CorpseArmor, this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				if (!appearance.HideCorpseHead)
				{
					decal = _tile.spawnDetail(sprite_head.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
					decal.Color = sprite_head.Color;
					decal.Saturation = sprite_head.Saturation;
					decal.Scale = 0.9;
					decal.setBrightness(0.9);

					if (tattoo_head.HasBrush)
					{
						decal = _tile.spawnDetail(tattoo_head.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
						decal.Color = tattoo_head.Color;
						decal.Saturation = tattoo_head.Saturation;
						decal.Scale = 0.9;
						decal.setBrightness(0.9);
					}
				}

				if (appearance.HelmetCorpse != "")
				{
					decal = _tile.spawnDetail(appearance.HelmetCorpse, this.Const.Tactical.DetailFlag.Corpse, flip);
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
				}
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [];

				if (!appearance.HideCorpseHead)
				{
					layers.push(sprite_head.getBrush().Name + "_dead");
				}

				if (!appearance.HideCorpseHead && tattoo_head.HasBrush)
				{
					layers.push(tattoo_head.getBrush().Name + "_dead");
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					layers.push(appearance.HelmetCorpse);
				}

				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-50, 30), 180.0, sprite_head.getBrush().Name + "_dead_bloodpool");
				local idx = 0;

				if (!appearance.HideCorpseHead)
				{
					decap[idx].Color = sprite_head.Color;
					decap[idx].Saturation = sprite_head.Saturation;
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					idx = ++idx;
				}

				if (!appearance.HideCorpseHead && tattoo_head.HasBrush)
				{
					decap[idx].Color = tattoo_head.Color;
					decap[idx].Saturation = tattoo_head.Saturation;
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					idx = ++idx;
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					idx = ++idx;
				}
			}

			if (_fatalityType == this.Const.FatalityType.Disemboweled)
			{
				if (appearance.CorpseArmor != "")
				{
					decal = _tile.spawnDetail(appearance.CorpseArmor + "_guts", this.Const.Tactical.DetailFlag.Corpse, flip);
				}
				else
				{
					decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_guts", this.Const.Tactical.DetailFlag.Corpse, flip);
				}

				decal.Scale = 0.9;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				if (appearance.CorpseArmor != "")
				{
					decal = _tile.spawnDetail(appearance.CorpseArmor + "_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				}
				else
				{
					decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				}

				decal.Scale = 0.9;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				if (appearance.CorpseArmor != "")
				{
					decal = _tile.spawnDetail(appearance.CorpseArmor + "_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				}
				else
				{
					decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				}

				decal.Scale = 0.9;
			}

			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.Tile = _tile;
			corpse.IsResurrectable = false;
			corpse.IsConsumable = true;
			corpse.Items = this.getItems();
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		this.getItems().dropAll(_tile, _killer, flip);
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
		
		if (!this.m.IsGuest)
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
	
	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
		local AttributesLevelUp = [
			{
				Min = 2,
				Max = 5
			},
			{
				Min = 3,
				Max = 4
			},
			{
				Min = 3,
				Max = 5
			},
			{
				Min = 1,
				Max = 3
			},
			{
				Min = 1,
				Max = 3
			},
			{
				Min = 1,
				Max = 3
			},
			{
				Min = 1,
				Max = 3
			},
			{
				Min = 1,
				Max = 3
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
					this.m.Attributes[i].insert(0, 2);
				}
				else if (_maxOnly)
				{
					this.m.Attributes[i].insert(0, AttributesLevelUp[i].Max);
				}
				else
				{
					this.m.Attributes[i].insert(0, this.Math.rand(AttributesLevelUp[i].Min + (this.m.Talents[i] == 3 ? 2 : this.m.Talents[i]), AttributesLevelUp[i].Max + (this.m.Talents[i] == 3 ? 3 : 0)));
				}
			}
		}
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
			hitpointsMax = 600,
			hitpointsIncrease = this.m.Attributes[this.Const.Attributes.Hitpoints][0],
			bravery = b.Bravery,
			braveryMax = 250,
			braveryIncrease = this.m.Attributes[this.Const.Attributes.Bravery][0],
			fatigue = b.Stamina,
			fatigueMax = 500,
			fatigueIncrease = this.m.Attributes[this.Const.Attributes.Fatigue][0],
			initiative = b.Initiative,
			initiativeMax = 200,
			initiativeIncrease = this.m.Attributes[this.Const.Attributes.Initiative][0],
			meleeSkill = b.MeleeSkill,
			meleeSkillMax = 150,
			meleeSkillIncrease = this.m.Attributes[this.Const.Attributes.MeleeSkill][0],
			rangeSkill = b.RangedSkill,
			rangeSkillMax = 150,
			rangeSkillIncrease = this.m.Attributes[this.Const.Attributes.RangedSkill][0],
			meleeDefense = b.MeleeDefense,
			meleeDefenseMax = 150,
			meleeDefenseIncrease = this.m.Attributes[this.Const.Attributes.MeleeDefense][0],
			rangeDefense = b.RangedDefense,
			rangeDefenseMax = 150,
			rangeDefenseIncrease = this.m.Attributes[this.Const.Attributes.RangedDefense][0]
		};
		return ret;
	}
	
	function updateInjuryVisuals( _setDirty = true )
	{
		this.setDirty(_setDirty);
	}
	
	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}
	
	function setScenarioValues( _isElite = false, _isWarrior = false, _isBerserker = false, _isWarlord = false )
	{
		local b = this.m.BaseProperties; 
		local variant = 0;
		local type = this.Const.EntityType.OrcYoung;

		if (!_isBerserker)
		{
			_isBerserker = this.Math.rand(1, 100) <= 10;
		}
		
		if (_isWarlord)
		{
			this.setActorIntoWarLord(_isElite);
			type = this.Const.EntityType.OrcWarlord;
			variant = 2;
		}
		else if (_isBerserker)
		{
			this.setActorIntoBerserker(_isElite);
			type = this.Const.EntityType.OrcBerserker;
			variant = 1;
		}
		else if (_isWarrior)
		{
			this.setActorIntoWarrior(_isElite);
			type = this.Const.EntityType.OrcWarrior;
		}
		else
		{
			this.setActorIntoYoung(_isElite);
		}
		
		local background = this.new("scripts/skills/backgrounds/charmed_orc_background");
		background.m.CustomPerkTree = null;
		background.setTo(type);
		this.m.Skills.add(background);
		background.onSetUp();
		background.buildDescription();
		
		this.m.CurrentProperties = clone b;
		local c = this.m.CurrentProperties;
		this.m.ActionPoints = c.ActionPoints;
		this.m.Hitpoints = c.Hitpoints;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.Talents = [];
		this.m.Attributes = [];
		this.fillModsTalentValues(9 , true);
		this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		this.m.Skills.update();
	}
	
	function setActorIntoWarLord( _isElite = false )
	{
		this.getFlags().add("isWarlord");
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.OrcWarlord);
		b.MeleeSkill += 5;
		b.DamageTotalMult += 0.1;
		
		this.m.Items.getAppearance().Body = "bust_orc_04_body";
		
		local body = this.getSprite("body");
		body.setBrush("bust_orc_04_body");
		body.varyColor(0.1, 0.1, 0.1);
		
		local injury_body = this.getSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_04_body_injured");
		
		local head = this.getSprite("head");
		head.setBrush("bust_orc_04_head_01");
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		local injury = this.getSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_04_head_injured");
		
		local body_blood = this.getSprite("body_blood");
		body_blood.setBrush("bust_orc_04_body_bloodied");
		body_blood.Visible = false;
		
		this.setSpriteOffset("arms_icon", this.createVec(-8, 0));
		this.setSpriteOffset("shield_icon", this.createVec(-5, 0));
		this.setSpriteOffset("stunned", this.createVec(0, 10));
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(0, 16));
		this.setSpriteOffset("status_stunned", this.createVec(-5, 30));
		this.setSpriteOffset("arrow", this.createVec(-5, 30));
		
		if (_isElite)
		{
			this.makeMiniboss(3);
		}
		
		this.assignRandomEquipment(3);
	}
	
	function setActorIntoBerserker( _isElite = false )
	{
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.OrcBerserker);
		b.MeleeSkill += 5;
		b.Bravery += 5;
		b.DamageTotalMult += 0.1;
		
		this.m.Items.getAppearance().Body = "bust_orc_02_body";
		
		local body = this.getSprite("body");
		body.setBrush("bust_orc_02_body");
		body.varySaturation(0.1);
		body.varyColor(0.08, 0.08, 0.08);
		
		local tattoo_body = this.getSprite("tattoo_body");
		if (this.Math.rand(1, 100) <= 50)
		{
			tattoo_body.setBrush("bust_orc_02_body_paint_0" + this.Math.rand(1, 3));
		}

		local injury_body = this.getSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_02_body_injured");
	
		local head = this.getSprite("head");
		head.setBrush("bust_orc_02_head_0" + this.Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		local tattoo_head = this.getSprite("tattoo_head");
		if (this.Math.rand(1, 100) <= 50)
		{
			tattoo_head.setBrush("bust_orc_02_head_paint_0" + this.Math.rand(1, 3));
		}

		local injury = this.getSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_02_head_injured");
		
		if (_isElite)
		{
			this.makeMiniboss(2);
		}
		
		this.assignRandomEquipment(2);
	}
	
	function setActorIntoWarrior( _isElite = false )
	{
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.OrcWarrior);
		b.MeleeSkill += 5;
		b.DamageTotalMult += 0.1;
		
		this.m.Items.getAppearance().Body = "bust_orc_03_body";
		
		local body = this.getSprite("body");
		body.setBrush("bust_orc_03_body");
		body.varyColor(0.09, 0.09, 0.09);
		
		local injury_body = this.getSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_03_body_injured");
		
		local head = this.getSprite("head");
		head.setBrush("bust_orc_03_head_0" + this.Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		local injury = this.getSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_03_head_injured");
		
		local body_blood = this.getSprite("body_blood");
		body_blood.setBrush("bust_orc_03_body_bloodied");
		body_blood.Visible = false;
		
		if (_isElite)
		{
			this.makeMiniboss(1);
		}
		
		this.assignRandomEquipment(1);
	}
	
	function setActorIntoYoung( _isElite = false )
	{
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.OrcYoung);
		b.RangedSkill += 5;
		
		this.m.Items.getAppearance().Body = "bust_orc_01_body";
		
		local body = this.getSprite("body");
		body.setBrush("bust_orc_01_body");
		body.varySaturation(0.05);
		body.varyColor(0.07, 0.07, 0.07);
		
		local injury_body = this.getSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_01_body_injured");
		
		local head = this.getSprite("head");
		head.setBrush("bust_orc_01_head_0" + this.Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		local injury = this.getSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_01_head_injured");
		
		local body_blood = this.getSprite("body_blood");
		body_blood.setBrush("bust_orc_01_body_bloodied");
		body_blood.Visible = false;
		this.assignRandomEquipment();
	}
	
	function assignRandomEquipment( _gearSet = 0 )
	{
		local r;
		local weapon;
		
		if (_gearSet == 0)
		{
			if (this.Math.rand(1, 100) <= 25)
			{
				this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/orc_javelin"));
			}

			if (this.Math.rand(1, 100) <= 75)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					local r = this.Math.rand(1, 2);

					if (r == 1)
					{
						weapon = this.new("scripts/items/weapons/greenskins/orc_axe");
					}
					else if (r == 2)
					{
						weapon = this.new("scripts/items/weapons/greenskins/orc_cleaver");
					}
				}
				else
				{
					local r = this.Math.rand(1, 2);

					if (r == 1)
					{
						weapon = this.new("scripts/items/weapons/greenskins/orc_wooden_club");
					}
					else if (r == 2)
					{
						weapon = this.new("scripts/items/weapons/greenskins/orc_metal_club");
					}
				}
			}
			else
			{
				r = this.Math.rand(1, 3);

				if (r == 1)
				{
					weapon = this.new("scripts/items/weapons/greenskins/goblin_falchion");
				}
				else if (r == 2)
				{
					weapon = this.new("scripts/items/weapons/hatchet");
				}
				else if (r == 3)
				{
					weapon = this.new("scripts/items/weapons/morning_star");
				}
			}

			if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
			{
				this.m.Items.equip(weapon);
			}
			else
			{
				this.m.Items.addToBag(weapon);
			}

			if (this.Math.rand(1, 100) <= 50)
			{
				this.m.Items.equip(this.new("scripts/items/shields/greenskins/orc_light_shield"));
			}

			r = this.Math.rand(1, 4);

			if (r == 1)
			{
				this.m.Items.equip(this.new("scripts/items/armor/greenskins/orc_young_very_light_armor"));
			}
			else if (r == 2)
			{
				this.m.Items.equip(this.new("scripts/items/armor/greenskins/orc_young_light_armor"));
			}
			else if (r == 3)
			{
				this.m.Items.equip(this.new("scripts/items/armor/greenskins/orc_young_medium_armor"));
			}
			else if (r == 4)
			{
				this.m.Items.equip(this.new("scripts/items/armor/greenskins/orc_young_heavy_armor"));
			}

			r = this.Math.rand(1, 3);

			if (r == 1)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/greenskins/orc_young_light_helmet"));
			}
			else if (r == 2)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/greenskins/orc_young_medium_helmet"));
			}
			else if (r == 3)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/greenskins/orc_young_heavy_helmet"));
			}
		}
		
		if (_gearSet == 1)
		{
			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
			{
				local weapons = [
					"weapons/greenskins/orc_axe",
					"weapons/greenskins/orc_cleaver"
				];
				this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
			{
				this.m.Items.equip(this.new("scripts/items/shields/greenskins/orc_heavy_shield"));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
			{
				local armor = [
					"armor/greenskins/orc_warrior_light_armor",
					"armor/greenskins/orc_warrior_medium_armor",
					"armor/greenskins/orc_warrior_heavy_armor",
					"armor/greenskins/orc_warrior_heavy_armor"
				];
				this.m.Items.equip(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				local helmet = [
					"helmets/greenskins/orc_warrior_light_helmet",
					"helmets/greenskins/orc_warrior_medium_helmet",
					"helmets/greenskins/orc_warrior_heavy_helmet"
				];
				this.m.Items.equip(this.new("scripts/items/" + helmet[this.Math.rand(0, helmet.len() - 1)]));
			}
		}
		
		if (_gearSet == 2)
		{
			local r = this.Math.rand(1, 4);

			if (r == 1)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_axe"));
			}
			else if (r == 2)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_cleaver"));
			}
			else if (r == 3)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_flail_2h"));
			}
			else if (r == 4)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_axe_2h"));
			}

			r = this.Math.rand(1, 5);

			if (r == 1)
			{
				this.m.Items.equip(this.new("scripts/items/armor/greenskins/orc_berserker_light_armor"));
			}
			else if (r == 2)
			{
				this.m.Items.equip(this.new("scripts/items/armor/greenskins/orc_berserker_medium_armor"));
			}

			r = this.Math.rand(1, 3);

			if (r == 1)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/greenskins/orc_berserker_helmet"));
			}

			if (this.Math.rand(1, 100) <= 10)
			{
				this.m.Items.addToBag(this.new("scripts/items/accessory/berserker_mushrooms_item"));
			}
		}
		
		if (_gearSet == 3)
		{
			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
			{
				local weapons = [
					"weapons/greenskins/orc_axe",
					"weapons/greenskins/orc_cleaver"
				];

				if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
				{
					weapons.extend([
						"weapons/greenskins/orc_axe_2h",
						"weapons/greenskins/orc_axe_2h"
					]);
				}

				this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
			{
				this.m.Items.equip(this.new("scripts/items/armor/greenskins/orc_warlord_armor"));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/greenskins/orc_warlord_helmet"));
			}
		}
	}

	function makeMiniboss( _type = 1 )
	{
		this.m.Skills.add(this.new("scripts/skills/racial/champion_racial"));
		this.m.IsMiniboss = true;
		
		if (_type == 2)
		{
			local weapons = [
				"weapons/named/named_orc_cleaver",
				"weapons/named/named_orc_axe"
			];
			
			this.m.Items.unequip(this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand));

			if (this.Math.rand(1, 100) <= 50)
			{
				this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
			}
			else
			{
				this.m.Items.equip(this.new("scripts/items/" + shields[this.Math.rand(0, shields.len() - 1)]));
			}
		}
		
		if (_type == 3 || _type == 1)
		{
			local weapons = [
				"weapons/named/named_orc_cleaver",
				"weapons/named/named_orc_axe"
			];
			local shields = [
				"shields/named/named_orc_heavy_shield"
			];

			if (this.Math.rand(1, 100) <= 50)
			{
				this.m.Items.unequip(this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
				this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
			}
			else
			{
				this.m.Items.unequip(this.m.Items.getItemAtSlot(this.Const.ItemSlot.Offhand));
				this.m.Items.equip(this.new("scripts/items/" + shields[this.Math.rand(0, shields.len() - 1)]));
			}
		}
	}
	
	function fillModsTalentValues( _stars = 0 , _force = false )
	{
		local helper = this.getroottable().TalentFiller;
		
		if (this.getBackground() != null && ("Custom" in this.getBackground().m.Info))
		{
			helper.fillModdedTalentValues(this , this.getBackground().m.Info.Custom.Talents , _stars , _force);
		}
	}

	function fillTalentValues( _num = null , _force = false )
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
		
		this.fillModsTalentValues(stars, _force);
	}

	function canEquipThis( _item )
	{
		if (_item.isItemType(this.Const.Items.ItemType.Armor))
		{
			local orc_armors = [
				"armor.body.legend_orc_behemoth_armor",
				"armor.body.orc_warlord_armor",
			];

			if (this.m.OrcType == 5)
			{
				return orc_armors[0] == _item.getID();
			}

			if (this.m.OrcType == 4)
			{
				return orc_armors[1] == _item.getID();
			}

			return orc_armors.find(_item.getID()) == null;
		}

		return true;
	}

	function canUnequipThis( _item )
	{
		return true;
	}

	function onActorEquip( _item )
	{
		if (_item.isItemType(this.Const.Items.ItemType.Helmet))
		{
			local orc_helmets = [
				"armor.head.orc_berserker_helmet",
				"armor.head.orc_warrior_heavy_helmet",
				"armor.head.orc_warrior_light_helmet",
				"armor.head.orc_warrior_medium_helmet",
				"armor.head.orc_young_heavy_helmet",
				"armor.head.orc_young_light_helmet",
				"armor.head.orc_young_medium_helmet",
				"armor.head.orc_elite_heavy_helmet",
				"armor.head.legend_orc_behemoth_helmet",
				"armor.head.orc_warlord_helmet",
			];

			this.m.IsWearingOrcHelmet = orc_helmets.find(_item.getID()) != null;
		}

		if (_item.isItemType(this.Const.Items.ItemType.Armor))
		{
			local orc_armors = [
				"armor.body.legend_orc_behemoth_armor",
				"armor.body.orc_berserker_light_armor",
				"armor.body.orc_berserker_medium_armor",
				"armor.body.orc_elite_heavy_armor",
				"armor.body.orc_warlord_armor",
				"armor.body.orc_warrior_heavy_armor",
				"armor.body.orc_warrior_light_armor",
				"armor.body.orc_warrior_medium_armor",
				"armor.body.orc_young_heavy_armor",
				"armor.body.orc_young_light_armor",
				"armor.body.orc_young_medium_armor",
				"armor.body.orc_young_very_light_armor"
			];

			this.m.IsWearingOrcArmor = orc_armors.find(_item.getID()) != null;
		}
	}

	function onActorUnequip( _item )
	{
	}

	function onActorAfterEquip( _item )
	{
		if (_item.isItemType(this.Const.Items.ItemType.Weapon)) this.m.IsStengthen = true;
	}

	function onActorAfterUnequip( _item )
	{
		if (_item.isItemType(this.Const.Items.ItemType.Weapon)) this.m.IsStengthen = false;
	}

	function getBarberSpriteChange()
	{
		return [
			"body",
			"head",
		];
	}

	function getPossibleSprites( _type )
	{
		local ret = [];

		switch (_type) 
		{
	    case "body":
	        ret = [
	        	"bust_orc_01_body",
	        ];
	        break;

	    case "head":
	        ret = [
	        	"bust_orc_01_head_01",
	        	"bust_orc_01_head_02",
	        	"bust_orc_01_head_03",
	        ];
	        break;
		}

		return ret;
	}
	
	function onSerialize( _out )
	{
		this.entity.onSerialize(_out);
		this.m.BaseProperties.onSerialize(_out);
		this.m.Items.onSerialize(_out);
		this.m.Skills.onSerialize(_out);
		_out.writeString(this.m.Name);
		_out.writeString(this.m.Title);
		_out.writeF32(this.getHitpointsPct());
		_out.writeI32(this.m.XP);
		_out.writeBool(this.m.IsWarLord);
		_out.writeBool(this.m.IsBehemoth);
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
	}

	function onDeserialize( _in )
	{
		this.entity.onDeserialize(_in);
		this.m.BaseProperties.onDeserialize(_in);
		this.m.Items.onDeserialize(_in);
		this.m.Skills.onDeserialize(_in);
		this.m.Name = _in.readString();
		this.m.Title = _in.readString();
		this.setHitpointsPct(this.Math.maxf(0.0, _in.readF32()));
		this.m.XP = _in.readI32();
		this.m.IsWarLord = _in.readBool();
		this.m.IsBehemoth = _in.readBool();
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
		this.m.Skills.update();

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
		this.m.Skills.update();
	}

});

