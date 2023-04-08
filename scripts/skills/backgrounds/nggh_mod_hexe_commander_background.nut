this.nggh_mod_hexe_commander_background <- ::inherit("scripts/skills/backgrounds/nggh_mod_hexe_background", {
	m = {
		RealHead = null,
		RealHair = null,
		RealBody = null,
		CharmHead = null,
		CharmHair = null,
		CharmBody = null,
	},
	function create()
	{
		this.nggh_mod_hexe_background.create();
		this.m.ID = "background.hexe_commander";
		this.m.Name = "Elder Hexe";
		this.m.Bodies = ["bust_hexen_fake_body_00"];
		this.m.Faces = ::Const.HexeOrigin.FakeHead;
		this.m.Hairs = ::Const.HexeOrigin.FakeHair;
		this.m.Modifiers.Enchanting = 1.0;
		
		this.m.CustomPerkTree = [
			[ // 0
				::Const.Perks.PerkDefs.LegendMagicMissile,
				::Const.Perks.PerkDefs.Bullseye,
				::Const.Perks.PerkDefs.Pathfinder,
				::Const.Perks.PerkDefs.HoldOut,
				::Const.Perks.PerkDefs.Student,
				::Const.Perks.PerkDefs.Recover,
				::Const.Perks.PerkDefs.QuickHands,
				::Const.Perks.PerkDefs.LegendAlert,
				::Const.Perks.PerkDefs.LegendMealPreperation,
				::Const.Perks.PerkDefs.LegendCheerOn,
				::Const.Perks.PerkDefs.LegendSpecialistLuteSkill,
			],
			[ // 1
				::Const.Perks.PerkDefs.Dodge,
				::Const.Perks.PerkDefs.Gifted,
				::Const.Perks.PerkDefs.LegendEntice,
				::Const.Perks.PerkDefs.LegendDaze,
				::Const.Perks.PerkDefs.LegendSpecStaffSkill,
				::Const.Perks.PerkDefs.LegendFieldTreats,
				::Const.Perks.PerkDefs.LegendMedIngredients,
				::Const.Perks.PerkDefs.LegendCampCook,
				::Const.Perks.PerkDefs.NggHCharmBasic,
				::Const.Perks.PerkDefs.NggHCharmEnemySpider,
			],
			[ // 2
				::Const.Perks.PerkDefs.LegendBalance,
				::Const.Perks.PerkDefs.Anticipation,
				::Const.Perks.PerkDefs.LegendMasteryStaves,
				::Const.Perks.PerkDefs.LegendSpecialistLuteDamage,
				::Const.Perks.PerkDefs.Ballistics,
				::Const.Perks.PerkDefs.RallyTheTroops,
				::Const.Perks.PerkDefs.Rotation,
				::Const.Perks.PerkDefs.LegendAlcoholBrewing,
				::Const.Perks.PerkDefs.NggHHexHexer,
				::Const.Perks.PerkDefs.NggHCharmEnemyAlp,
				::Const.Perks.PerkDefs.NggHCharmEnemyDirewolf,
			],
			[ // 3
				::Const.Perks.PerkDefs.MageLegendMasteryMagicMissileFocus,
				::Const.Perks.PerkDefs.SpecMace,
				::Const.Perks.PerkDefs.Nimble,
				::Const.Perks.PerkDefs.LegendLithe,
				::Const.Perks.PerkDefs.LegendSpecStaffStun,
				::Const.Perks.PerkDefs.FortifiedMind,
				::Const.Perks.PerkDefs.LegendTrueBeliever,
				::Const.Perks.PerkDefs.LegendHerbcraft,
				::Const.Perks.PerkDefs.LegendPotionBrewer,
				::Const.Perks.PerkDefs.LegendValaInscribeShield,
				::Const.Perks.PerkDefs.NggHHexMastery,
				::Const.Perks.PerkDefs.NggHCharmWords,
				::Const.Perks.PerkDefs.NggHCharmEnemyGoblin,
			],
			[ // 4
				::Const.Perks.PerkDefs.Inspire,
				::Const.Perks.PerkDefs.Footwork,
				::Const.Perks.PerkDefs.LegendPush,
				::Const.Perks.PerkDefs.LegendClarity,
				::Const.Perks.PerkDefs.LegendValaInscribeWeapon,
				::Const.Perks.PerkDefs.LegendDistantVisions,
				::Const.Perks.PerkDefs.LegendTerrifyingVisage,
				::Const.Perks.PerkDefs.NggHHexSuffering,
				::Const.Perks.PerkDefs.NggHHexWeakening,
				::Const.Perks.PerkDefs.NggHHexVulnerability,
				::Const.Perks.PerkDefs.NggHHexMisfortune,
				::Const.Perks.PerkDefs.NggHCharmEnemyGhoul,
				::Const.Perks.PerkDefs.NggHCharmEnemyOrk,
			],
			[ // 5
				::Const.Perks.PerkDefs.LegendValaInscriptionMastery,	
				::Const.Perks.PerkDefs.LegendValaInscribeHelmet,
				::Const.Perks.PerkDefs.LegendValaInscribeArmor,
				::Const.Perks.PerkDefs.InspiringPresence,
				::Const.Perks.PerkDefs.LegendDrumsOfWar,
				::Const.Perks.PerkDefs.LegendMindOverBody,
				::Const.Perks.PerkDefs.LegendHeightenedReflexes,
				::Const.Perks.PerkDefs.NggHCharmEnemyUnhold,
				::Const.Perks.PerkDefs.NggHCharmEnemySchrat,
				
			],
			[ // 6
				::Const.Perks.PerkDefs.MageLegendMasteryMagicMissileMastery,
				::Const.Perks.PerkDefs.PerfectFocus,
				::Const.Perks.PerkDefs.LegendDrumsOfLife,
				::Const.Perks.PerkDefs.NggHHexSharePain,
				::Const.Perks.PerkDefs.NggHCharmSpec,
				::Const.Perks.PerkDefs.NggHCharmNudist,
				::Const.Perks.PerkDefs.NggHCharmAppearance,
				::Const.Perks.PerkDefs.NggHCharmEnemyLindwurm,
			],
			[],
			[],
			[],
			[]
		];
		
		if (::Is_PTR_Exist)
		{
			this.addPerkTreesToCustomPerkTree(this.m.CustomPerkTree, [
				::Const.Perks.HealerClassTree,
				::Const.Perks.LightArmorTree,
				::Const.Perks.MediumArmorTree,
				::Const.Perks.TalentedTree,
				::Const.Perks.TwoHandedTree,
				::Const.Perks.StaffTree,
				::Const.Perks.RangedTree
			]);
		}
	}

	function onAdded()
	{
		if (this.m.IsNew)
		{
			this.m.RealHead = ::MSU.Array.rand(::Const.HexeOrigin.TrueHead);
			this.m.RealHair = ::MSU.Array.rand(::Const.HexeOrigin.TrueHair);
			this.m.RealBody = ::Const.HexeOrigin.Body[2];
			this.m.CharmHead = ::MSU.Array.rand(::Const.HexeOrigin.FakeHead);
			this.m.CharmHair = ::MSU.Array.rand(::Const.HexeOrigin.FakeHair);
			this.m.CharmBody = ::Const.HexeOrigin.Body[1];

			this.getContainer().add(::new("scripts/skills/traits/player_character_trait"));
			this.getContainer().getActor().getSprite("miniboss").setBrush("bust_miniboss_lone_wolf");
			this.getContainer().getActor().getFlags().set("IsPlayerCharacter", true);
		}

		this.nggh_mod_hexe_background.onAdded();
	}

	function setupSpriteLayers()
	{
		this.nggh_mod_hexe_background.setupSpriteLayers();
		local actor = this.getContainer().getActor().get();
		local true_body = this.m.RealBody
		local true_head = this.m.RealHead
		local true_hair = this.m.RealHair
		local old_onDeath = actor.onDeath;
		actor.onDeath = function( _killer, _skill, _tile, _fatalityType )
		{
			local sprite_body = this.getSprite("body");
			sprite_body.setBrush(true_body);
			local sprite_head = this.getSprite("head");
			sprite_head.setBrush(true_head);
			local sprite_hair = this.getSprite("hair");
			sprite_hair.setBrush(true_hair);
			old_onDeath(_killer, _skill, _tile, _fatalityType);
		}
	}

	function setupDefaultSkills()
	{
		//local mind_break = ::new("scripts/skills/actives/mod_mind_break_skill");
		//mind_break.m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
		//this.getContainer().add(mind_break);
		this.getContainer().add(::new("scripts/skills/hexe/nggh_mod_sleep_spell"));
		this.getContainer().add(::new("scripts/skills/hexe/nggh_mod_hex_spell"));
		this.getContainer().add(::new("scripts/skills/hexe/nggh_mod_charm_spell"));
		this.getContainer().add(::new("scripts/skills/hexe/nggh_mod_charm_captive_spell"));
	}

	function onBuildDescription()
	{
		return "Every since %name% was a child, she wanted everything, a greedy girl she was. Her plate was always fill with wonderous goodness, dressed in the finest outfit. But she can't have a charming looks or a true authority above others, that is why she stepped in the realm of dark art. \nShe was banished out of her home town for her dreadful deeds but at least she still kept her life, hiding herself in deep forest. With vengeance and greed powered her to seek more power, %name% has become a fearsome crone after years and years worth of practicing black magic and brewing strange potions. She brought waste to the town had banished her, not a single soul was spared, children was brewed into potions to return her youth, the adult were left to feed crows. \nBut soon something expectingly happened, %name% met a fools came to ruin her grand ritual. She was cursed in the end! Beautiful as goddess but powerless to the contract she has been eternally bounded.";
	}

	function randomizeStartingStats( _properties )
	{
		_properties.ActionPoints = 9;
		_properties.Hitpoints = ::Math.rand(48, 52);
		_properties.Bravery = ::Math.rand(45, 55);
		_properties.Stamina = ::Math.rand(70, 82);
		_properties.MeleeSkill = ::Math.rand(40, 45);
		_properties.RangedSkill = ::Math.rand(50, 62);
		_properties.MeleeDefense = ::Math.rand(0, 5);
		_properties.RangedDefense = 5;
		_properties.Initiative = ::Math.rand(90, 110);
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(::new("scripts/items/weapons/greenskins/goblin_staff"));
		items.equip(::Const.World.Common.pickArmor([
			[1, "thick_dark_tunic"]
		]));
		items.equip(::Const.World.Common.pickHelmet([
			[1, "dark_cowl"],
			[1, "hood"],
			[1, ""]
		]));
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();
		local cursed = this.getContainer().hasSkill("effects.cursed");
		local lesserCursed = this.getContainer().hasSkill("effects.lesser_cursed");

		if (cursed || lesserCursed)
		{
			actor.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
				"sounds/enemies/dlc2/hexe_idle_06.wav",
				"sounds/enemies/dlc2/hexe_idle_07.wav",
				"sounds/enemies/dlc2/hexe_idle_08.wav",
				"sounds/enemies/dlc2/hexe_idle_09.wav",
				"sounds/enemies/dlc2/hexe_idle_05.wav",
				"sounds/enemies/dlc2/hexe_idle_10.wav",
			];
			actor.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
				"sounds/enemies/dlc2/hexe_hurt_01.wav",
				"sounds/enemies/dlc2/hexe_hurt_02.wav",
				"sounds/enemies/dlc2/hexe_hurt_03.wav",
				"sounds/enemies/dlc2/hexe_hurt_04.wav",
				"sounds/enemies/dlc2/hexe_hurt_05.wav",
				"sounds/enemies/dlc2/hexe_hurt_06.wav",
				"sounds/enemies/dlc2/hexe_hurt_07.wav",
				"sounds/enemies/dlc2/hexe_hurt_08.wav",
				"sounds/enemies/dlc2/hexe_hurt_09.wav",
				"sounds/enemies/dlc2/hexe_hurt_10.wav",
				"sounds/enemies/dlc2/hexe_hurt_11.wav",
				"sounds/enemies/dlc2/hexe_hurt_12.wav",
				"sounds/enemies/dlc2/hexe_hurt_13.wav"
			];
			actor.m.Sound[::Const.Sound.ActorEvent.Death] = [
				"sounds/enemies/dlc2/hexe_death_01.wav",
				"sounds/enemies/dlc2/hexe_death_02.wav",
				"sounds/enemies/dlc2/hexe_death_03.wav",
				"sounds/enemies/dlc2/hexe_death_04.wav",
				"sounds/enemies/dlc2/hexe_death_05.wav"
			];
			actor.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
				"sounds/enemies/dlc2/hexe_idle_01.wav",
				"sounds/enemies/dlc2/hexe_idle_02.wav",
				"sounds/enemies/dlc2/hexe_idle_03.wav",
				"sounds/enemies/dlc2/hexe_idle_04.wav",
				"sounds/enemies/dlc2/hexe_idle_05.wav"
			];
			actor.m.Sound[::Const.Sound.ActorEvent.Flee] = [
				"sounds/enemies/dlc2/hexe_flee_01.wav",
				"sounds/enemies/dlc2/hexe_flee_02.wav",
				"sounds/enemies/dlc2/hexe_flee_03.wav",
				"sounds/enemies/dlc2/hexe_flee_04.wav",
				"sounds/enemies/dlc2/hexe_flee_05.wav",
				"sounds/enemies/dlc2/hexe_flee_06.wav",
				"sounds/enemies/dlc2/hexe_flee_07.wav",
				"sounds/enemies/dlc2/hexe_flee_08.wav"
			];
			actor.m.Sound[::Const.Sound.ActorEvent.Other1] = [
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
			actor.m.SoundPitch = ::Math.rand(105, 115) * 0.01;
			actor.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 5.0;
			actor.m.SoundVolume[::Const.Sound.ActorEvent.Fatigue] = 5.0;
			actor.m.SoundVolume[::Const.Sound.ActorEvent.Other1] = 2.5;
			return;
		}

		actor.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/humans/legends/woman_light_01.wav",
			"sounds/humans/legends/woman_light_02.wav",
			"sounds/humans/legends/woman_light_03.wav",
			"sounds/humans/legends/woman_light_04.wav",
			"sounds/humans/legends/woman_light_05.wav"
		];
		actor.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/humans/legends/woman_injury_01.wav",
			"sounds/humans/legends/woman_injury_02.wav",
			"sounds/humans/legends/woman_injury_03.wav"
		];
		actor.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/hexe_death_01.wav",
			"sounds/enemies/dlc2/hexe_death_02.wav",
			"sounds/enemies/dlc2/hexe_death_03.wav",
			"sounds/enemies/dlc2/hexe_death_04.wav",
			"sounds/enemies/dlc2/hexe_death_05.wav"
		];
		actor.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/humans/legends/woman_fatigue_01.wav",
			"sounds/humans/legends/woman_fatigue_02.wav",
			"sounds/humans/legends/woman_fatigue_03.wav",
			"sounds/humans/legends/woman_fatigue_04.wav",
			"sounds/humans/legends/woman_fatigue_05.wav",
			"sounds/humans/legends/woman_fatigue_06.wav",
			"sounds/humans/legends/woman_fatigue_07.wav"
		];
		actor.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/humans/legends/woman_flee_01.wav",
			"sounds/humans/legends/woman_flee_02.wav",
			"sounds/humans/legends/woman_flee_03.wav",
			"sounds/humans/legends/woman_flee_04.wav",
			"sounds/humans/legends/woman_flee_05.wav",
			"sounds/humans/legends/woman_flee_06.wav"
		];
		actor.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc2/hexe_idle_01.wav",
			"sounds/enemies/dlc2/hexe_idle_02.wav",
			"sounds/enemies/dlc2/hexe_idle_03.wav",
			"sounds/enemies/dlc2/hexe_idle_04.wav",
			"sounds/enemies/dlc2/hexe_idle_05.wav"
		];
		actor.m.Sound[::Const.Sound.ActorEvent.Other1] = [
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
		actor.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] = 1.5;
		actor.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 5.0;
		actor.m.SoundVolume[::Const.Sound.ActorEvent.Other1] = 2.5;
	}
	
	function onNewDay()
	{
		local stash = ::World.Assets.getStash();
		local days = ::World.Flags.getAsInt("RitualTimer");

		// witch can shred hair a lot XD
		if (stash.getNumberOfEmptySlots() > 0 && ::Math.rand(1, 100) <= 10)
		{
			stash.add(::new("scripts/items/misc/" + (::Math.rand(1, 3) == 3 ? "legend_witch_leader_hair_item" : "witch_hair_item")));
		}

		// check for the ritual event
		::logInfo("Hexe Origin Ritual - Checking the conditions");

		if (days < ::Nggh_MagicConcept.HexeOriginRitual.Cooldown)
		{
			::logInfo("Hexe Origin Ritual - Days passed: " + days);
			::World.Flags.increment("RitualTimer");
			return;
		}
		
		if (!::World.Events.canFireEvent(true, true))
		{
			::logInfo("Hexe Origin Ritual - Failed to start the event. \'::World.Events.canFireEvent\' returns false.");
			return;
		}
		
		if (!::World.Events.fire("event.hexe_origin_ritual"))
		{
			::logInfo("Hexe Origin Ritual - Failed to start the event. Can not fire the event.");
			return;
		}
		
		::logInfo("Hexe Origin Ritual - Successfully started the event. The timer reset.");
		::World.Flags.set("RitualTimer", 1);
	}

	function onFinishingPerkTree()
	{
		if (::Math.rand(1, 100) == 100)
		{
			this.addPerk(::Const.Perks.PerkDefs.NggHMiscChampion, 6);
		}

		if (::Math.rand(1, 100) >= 95)
		{
			this.addPerk(::Const.Perks.PerkDefs.NggHMiscFairGame, 2);
		}
	}

	function onSerialize( _out )
	{
		this.nggh_mod_hexe_background.onSerialize(_out);
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
		this.nggh_mod_hexe_background.onDeserialize(_in);
		this.m.IsCharming = _in.readBool();
		this.m.RealHead = _in.readString();
		this.m.RealBody = _in.readString();
		this.m.RealHair = _in.readString();
		this.m.CharmHead = _in.readString();
		this.m.CharmHair = _in.readString();
		this.m.CharmBody = _in.readString();
	}

});

