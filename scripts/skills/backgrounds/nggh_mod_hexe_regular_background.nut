this.nggh_mod_hexe_regular_background <- ::inherit("scripts/skills/backgrounds/nggh_mod_hexe_background", {
	m = {},
	function create()
	{
		this.nggh_mod_hexe_background.create();
		this.m.ID = "background.hexe";
		this.m.Name = "Hexe";
		this.m.Bodies = ["bust_hexen_true_body"];
		this.m.Faces = ::Const.HexeOrigin.TrueHead;
		this.m.Hairs = ::Const.HexeOrigin.TrueHair;
		this.m.Level = ::Math.rand(2, 5);
		this.addBackgroundType(::Const.BackgroundType.Outlaw);
		this.m.Modifiers.Enchanting = 0.67;
		
		this.m.PerkTreeDynamic = {
			Weapon = [
				::Const.Perks.DaggerTree,
				::Const.Perks.StaffTree,
			],
			Defense = [
				::Const.Perks.LightArmorTree
			],
			Traits = [
				::Const.Perks.IntelligentTree,
				::Const.Perks.CalmTree,
				::Const.Perks.InspirationalTree,
			],
			Enemy = [],
			Class = [],
			Magic = []
		};

		this.m.PerkTreeDynamic.Class.push(::MSU.Array.rand([::Const.Perks.ChefClassTree, ::Const.Perks.BardClassTree]));

		if (::Is_PTR_Exist)
		{
			this.m.PerkTreeDynamic = {
				//ExpertiseMultipliers = [],
				//WeightMultipliers = [],
				Traits = [
					::Const.Perks.TalentedTree,
					::Const.Perks.CalmTree
				],
				Defense = [
					::Const.Perks.LightArmorTree
				],
				Weapon = [
					::Const.Perks.StaffTree,
				],
				Profession = [
					::Const.Perks.ApothecaryProfessionTree,
					::Const.Perks.ServiceProfessionTree,
				],
				Styles = [
					::Const.Perks.TwoHandedTree,
				],
				Magic = []
			};

			if (::Math.rand(1, 100) <= 25)
			{
				this.m.PerkTreeDynamic.Weapon.push(::Const.Perks.SlingTree);
			}
		}
	}
	
	function onAdded()
	{
		if (this.m.IsNew)
		{
			this.getContainer().getActor().getFlags().add("isBonus");
		}
		
		this.nggh_mod_hexe_background.onAdded();
	}

	function setupSoundSettings()
	{
		local actor = this.getContainer().getActor();
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

		this.nggh_mod_hexe_background.setupSoundSettings();
	}

	function setupDefaultSkills()
	{
		this.getContainer().add(::new("scripts/skills/hexe/nggh_mod_hex_spell"));
		this.getContainer().add(::new("scripts/skills/hexe/nggh_mod_charm_spell"));
		this.getContainer().add(::new("scripts/skills/hexe/nggh_mod_charm_captive_spell"));
	}

	function getMagicalDefense()
	{
		return ::Math.max(1, this.nggh_mod_hexe_background.getMagicalDefense() / 2);
	}

	function getTooltip()
	{
		local ret = this.nggh_mod_hexe_background.getTooltip();

		if (::World.Flags.get("IsLuftAdventure"))
		{
			ret.insert(3, {
				id = 4,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Member of Nacho fanclub[/color]"
			});
		}

		return ret;
	}

	function onBuildDescription()
	{
		return "The Hexe is a malevolent old crone living in swamps and forests outside of villages alone or in a coven with other Hexen. They’re human, but have long sacrificed their humanity for otherworldly powers. They’re feared, but also worshiped by some. They’re burned at the stake, and yet people seek them out to plead for miracles. They lure and abduct little children to make broth and concoctions out of, they strike terrible pacts with villagers to receive their firstborn, they weave curses and cast hexes. Their huts may or may not be made of candy. With her sorcery, a Hexe can enthrall wild beasts, and even warp the mind of humans, and so will often be found in the company of creatures that serve her";
	}

	function randomizeStartingStats( _properties )
	{
		_properties.ActionPoints = 9;
		_properties.Hitpoints = ::Math.rand(50, 55);
		_properties.Bravery = ::Math.rand(51, 65);
		_properties.Stamina = ::Math.rand(83, 98);
		_properties.MeleeSkill = ::Math.rand(48, 53);
		_properties.RangedSkill = ::Math.rand(50, 63);
		_properties.MeleeDefense = ::Math.rand(0, 5);
		_properties.RangedDefense = 5;
		_properties.Initiative = ::Math.rand(91, 111);
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(::Const.World.Common.pickArmor([
			[1, "thick_dark_tunic"]
		]));
		items.equip(::Const.World.Common.pickHelmet([
			[1, "witchhunter_hat"],
			[1, "dark_cowl"],
			[1, "hood"],
			[1, ""]
		]));
	}

	function onNewDay()
	{
		local stash = ::World.Assets.getStash();

		if (stash.getNumberOfEmptySlots() > 0 && ::Math.rand(1, 100) <= 10)
		{
			stash.add(::new("scripts/items/misc/witch_hair_item"));
		}
	}

	function onFinishingPerkTree()
	{
		this.addPerk(::Const.Perks.PerkDefs.LegendMagicMissile);
		this.addPerk(::Const.Perks.PerkDefs.MageLegendMasteryMagicMissileFocus, 3);
		this.addPerk(::Const.Perks.PerkDefs.MageLegendMasteryMagicMissileMastery, 6);
		this.addPerk(::Const.Perks.PerkDefs.LegendPotionBrewer, 3);

		this.addPerkGroup(::Const.Perks.HexeHexTree.Tree);
		this.addPerkGroup(::Const.Perks.HexeSpecializedHexTree.Tree);

		this.addPerk(::Const.Perks.PerkDefs.NggHCharmBasic);
		this.addPerk(::Const.Perks.PerkDefs.NggHCharmWords, 3);
		this.addPerk(::Const.Perks.PerkDefs.NggHCharmNudist, 4);
		this.addPerk(::Const.Perks.PerkDefs.NggHCharmSpec, 6);


		if (::Math.rand(1, 100) <= 15)
		{
			this.addPerk(::Const.Perks.PerkDefs.NggHCharmAppearance, 6);
		}

		this.addPerk(::MSU.Array.rand([
			::Const.Perks.PerkDefs.NggHCharmEnemySpider,
			::Const.Perks.PerkDefs.NggHCharmEnemyAlp,
			::Const.Perks.PerkDefs.NggHCharmEnemyDirewolf
		]), 1);
		this.addPerk(::MSU.Array.rand([
			::Const.Perks.PerkDefs.NggHCharmEnemyGoblin,
			::Const.Perks.PerkDefs.NggHCharmEnemyOrk,
			::Const.Perks.PerkDefs.NggHCharmEnemyGhoul
		]), 3);
		this.addPerk(::MSU.Array.rand([
			::Const.Perks.PerkDefs.NggHCharmEnemyUnhold,
			::Const.Perks.PerkDefs.NggHCharmEnemySchrat,
			::Const.Perks.PerkDefs.NggHCharmEnemyLindwurm
		]), 5);
		this.addPerk(::MSU.Array.rand([
			::Const.Perks.PerkDefs.LegendValaInscribeShield,
			::Const.Perks.PerkDefs.LegendValaInscribeWeapon,
			::Const.Perks.PerkDefs.LegendValaInscribeHelmet,
			::Const.Perks.PerkDefs.LegendValaInscribeArmor
		]), 2);

		if (::Math.rand(1, 100) >= 95)
		{
			this.addPerk(::Const.Perks.PerkDefs.NggHMiscFairGame, 2);
		}
	}

});

