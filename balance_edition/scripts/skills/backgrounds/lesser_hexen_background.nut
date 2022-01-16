this.lesser_hexen_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		NewPerkTree = null,
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hexen";
		this.m.Name = "Hexe";
		this.m.Icon = "ui/backgrounds/background_hexe.png";
		this.m.HiringCost = 30000;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.strong",
			"trait.tough",
			"trait.dumb",
			"trait.superstitious",
			"trait.brute",
			"trait.fear_beasts",
			"trait.huge",
			"trait.heavy",
			"trait.aggressive",
		];
		this.m.Names = [
			"Vest",
			"Arwen",
			"Ingrid",
			"Azula",
			"Adaire",
			"Sophie",
			"Artemis",
			"Minerva",
			"Annette",
			"Norae",
			"Agnes",
			"Armina",
			"Indigo",
			"Tiara",
			"Silvaria",
			"Indigo",
			"Cornelia",
			"Rowena",
			"Jinx",
			"Lydia",
			"Delia",
			"River",
			"Wendy",
			"Saffron",
			"Shearah",
			"Winter",
			"Cyrena",
			"Beth",
			"Peony",
			"Theodora",
			"Azalea",
			"Sapphire",
			"Tatiana",
			"Euphenia",
			"Fiona",
			"Edna",
			"Rue",
			"Opal",
			"Fawn",
			"Jasmine"
		];
		this.m.Titles = [];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue,
			this.Const.Attributes.MeleeSkill,
			this.Const.Attributes.MeleeDefense
		];
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Faces = this.Const.HexenOrigin.TrueHead;
		this.m.Hairs = this.Const.HexenOrigin.TrueHair;
		this.m.Bodies = ["bust_hexen_true_body"];
		this.m.Beards = null;
		this.m.BeardChance = 0;

		this.addBackgroundType(this.Const.BackgroundType.Educated);
		this.addBackgroundType(this.Const.BackgroundType.Female);
		this.addBackgroundType(this.Const.BackgroundType.Outlaw);

		this.m.Level = this.Math.rand(2, 5);
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.Dreaded;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.Merciless;
		this.m.Modifiers.Meds = this.Const.LegendMod.ResourceModifiers.Meds[2];
		this.m.Modifiers.Stash = this.Const.LegendMod.ResourceModifiers.Stash[0];
		this.m.Modifiers.Healing = this.Const.LegendMod.ResourceModifiers.Healing[3];
		this.m.Modifiers.Crafting = this.Const.LegendMod.ResourceModifiers.Crafting[0];
		this.m.Modifiers.Barter = this.Const.LegendMod.ResourceModifiers.Barter[1];
		this.m.Modifiers.Enchanting = 0.75;
		
		this.m.PerkTreeDynamic = {
			Weapon = [
				this.Const.Perks.DaggerTree,
				this.Const.Perks.StavesTree,
				this.Const.Perks.PolearmTree,
			],
			Defense = [
				this.Const.Perks.LightArmorTree
			],
			Traits = [
				this.Const.Perks.IntelligentTree,
				this.Const.Perks.CalmTree,
				this.Const.Perks.InspirationalTree,
			],
			Enemy = [],
			Class = [
				this.Const.Perks.HealerClassTree,
			],
			Magic = []
		};

		this.m.PerkTreeDynamic.Class.push(this.Math.rand(1, 2) == 1 ? this.Const.Perks.ChefClassTree : this.Const.Perks.BardClassTree);

		if (::mods_getRegisteredMod("mod_legends_PTR") != null)
		{
			this.m.PerkTreeDynamic = {
				ExpertiseMultipliers = [
				],
				WeightMultipliers = [
				],
				Traits = [
					[{Weight = 100, Tree = this.Const.Perks.TalentedTree}],
					[{Weight = 100, Tree = this.Const.Perks.CalmTree}]
				],
				Defense = [
					[{Weight = 100, Tree = this.Const.Perks.LightArmorTree}]
				],
				Weapon = [
					[{Weight = 100, Tree = this.Const.Perks.StavesTree}],
					[{Weight = 25 , Tree = this.Const.Perks.SlingsTree}],
				],
				Profession = [
					[{Weight = 100, Tree = this.Const.Perks.ApothecaryProfessionTree}],
					[{Weight = 100, Tree = this.Const.Perks.ServiceProfessionTree}],
				],
				Styles = [
					[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}],
				],
				Magic = []
			};
		}
	}
	
	function onAdded()
	{
		if (this.m.IsNew)
		{
			this.getContainer().getActor().getFlags().add("isBonus");
		}
		
		this.getContainer().removeByID("spells.sleep");
		this.character_background.onAdded();
	}

	function onFinishingPerkTree()
	{
		this.addPerk(this.Const.Perks.PerkDefs.LegendMagicMissile);
		this.addPerk(this.Const.Perks.PerkDefs.MageLegendMasteryMagicMissileFocus, 3);
		this.addPerk(this.Const.Perks.PerkDefs.MageLegendMasteryMagicMissileMastery, 6);
		this.addPerk(this.Const.Perks.PerkDefs.LegendPotionBrewer, 3);
		this.addPerk(this.Const.Perks.PerkDefs.CharmBasic);
		this.addPerk(this.Const.Perks.PerkDefs.CharmWord, 3);
		this.addPerk(this.Const.Perks.PerkDefs.CharmNudist, 4);
		this.addPerk(this.Const.Perks.PerkDefs.CharmSpec, 6);

		if (this.Math.rand(1, 100) <= 15)
		{
			this.addPerk(this.Const.Perks.PerkDefs.CharmAppearance, 6);
		}

		local tier_1 = [
			"CharmEnemySpider",
			"CharmEnemyAlps",
			"CharmEnemyDirewolf",
		];
		local tier_2 = [
			"CharmEnemyGoblin",
			"CharmEnemyOrk",
			"CharmEnemyGhoul",
		];
		local tier_3 = [
			"CharmEnemyUnhold",
			"CharmEnemySchrat",
			"CharmEnemyLindwurm",
		];
		this.addPerk(this.Const.Perks.PerkDefs[::mc_randArray(tier_1)], 1);
		this.addPerk(this.Const.Perks.PerkDefs[::mc_randArray(tier_2)], 3);
		this.addPerk(this.Const.Perks.PerkDefs[::mc_randArray(tier_3)], 5);

		local rune = [
			"LegendValaInscribeShield",
			"LegendValaInscribeWeapon",
			"LegendValaInscribeHelmet",
			"LegendValaInscribeArmor",
		];
		this.addPerk(this.Const.Perks.PerkDefs[::mc_randArray(rune)], 2);

		if (this.Math.rand(1, 100) >= 95)
		{
			this.addPerk(this.Const.Perks.PerkDefs.FairGame, 2);
		}

		this.getContainer().getActor().getFlags().add("perk_finished");
	}
	
	function resetPerkTree()
	{
		local pT = this.Const.Perks.BuildCustomPerkTree(this.m.NewPerkTree);
		this.m.PerkTree = pT.Tree;
		this.m.PerkTreeMap = pT.Map;
		this.m.CustomPerkTree = this.m.NewPerkTree;
	}

	function onUpdate( _properties )
	{
		_properties.IsImmuneToDamageReflection = true;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Charm[/color] and [color=" + this.Const.UI.Color.NegativeValue + "]Hex[/color]"
			}
		];

		if (this.getContainer() == null || this.getContainer().getActor() == null)
		{
			return ret;
		}

		if (this.World.Flags.get("IsLuftAdventure"))
		{
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Member of Nacho fanclub[/color]"
			});
		}

		ret.extend(this.getAttributesTooltip());
		return ret;
	}

	function onBuildDescription()
	{
		return "The Hexe is a malevolent old crone living in swamps and forests outside of villages alone or in a coven with other Hexen. They’re human, but have long sacrificed their humanity for otherworldly powers. They’re feared, but also worshiped by some. They’re burned at the stake, and yet people seek them out to plead for miracles. They lure and abduct little children to make broth and concoctions out of, they strike terrible pacts with villagers to receive their firstborn, they weave curses and cast hexes. Their huts may or may not be made of candy. With her sorcery, a Hexe can enthrall wild beasts, and even warp the mind of humans, and so will often be found in the company of creatures that serve her";
	}

	function buildAttributes( _tag = null, _attrs = null )
	{
		local b = this.getContainer().getActor().getBaseProperties();
		b.ActionPoints = 9;
		b.Hitpoints = this.Math.rand(50, 55);
		b.Bravery = this.Math.rand(51, 65);
		b.Stamina = this.Math.rand(83, 98);
		b.MeleeSkill = this.Math.rand(48, 53);
		b.RangedSkill = this.Math.rand(50, 63);
		b.MeleeDefense = this.Math.rand(0, 5);
		b.RangedDefense = 5;
		b.Initiative = this.Math.rand(91, 111);
		
		if (_attrs != null)
		{
			b.Hitpoints += _attrs.Hitpoints[1];
			b.Bravery += _attrs.Bravery[1];
			b.Stamina += _attrs.Stamina[1];
			b.MeleeSkill += _attrs.MeleeSkill[1];
			b.MeleeDefense += _attrs.MeleeDefense[1];
			b.RangedSkill += _attrs.RangedSkill[1];
			b.RangedDefense += _attrs.RangedDefense[1];
			b.Initiative += _attrs.Initiative[1];
		}
		
		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.getContainer().getActor().setHitpoints(b.Hitpoints);
		this.getContainer().getActor().getFlags().add("rank", 1);
		this.getContainer().getActor().setName(this.m.Names[this.Math.rand(0, this.m.Names.len() - 1)]);
		
		local weighted = [];
		weighted.push(50);
		weighted.push(50);
		weighted.push(50);
		weighted.push(50);
		weighted.push(50);
		weighted.push(50);
		weighted.push(50);
		weighted.push(50);

		return weighted;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(this.Const.World.Common.pickHelmet([
			[
				1,
				""
			],
			[
				5,
				"dark_cowl"
			],
			[
				4,
				"witchhunter_hat"
			]
		]));
		items.equip(this.Const.World.Common.pickArmor([
			[
				1,
				"thick_dark_tunic"
			]
		]));
	}

	function onNewDay()
	{
		local stash = this.World.Assets.getStash();

		if (stash.getNumberOfEmptySlots() > 0 && this.Math.rand(1, 100) <= 10)
		{
			stash.add(this.new("scripts/items/misc/witch_hair_item"));
		}
	}
	
	function setAppearance()
	{
		if (this.m.HairColors == null)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (this.m.Faces != null)
		{
			local sprite = actor.getSprite("head");
			sprite.setBrush(this.m.Faces[this.Math.rand(0, this.m.Faces.len() - 1)]);
			sprite.Color = this.createColor("#fbffff");
			sprite.varyColor(0.05, 0.05, 0.05);
			sprite.varySaturation(0.1);
			local body = actor.getSprite("body");
			body.Color = sprite.Color;
			body.Saturation = sprite.Saturation;
		}

		if (this.m.Hairs != null)
		{
			local sprite = actor.getSprite("hair");
			sprite.setBrush(this.m.Hairs[this.Math.rand(0, this.m.Hairs.len() - 1)]);
			sprite.varyBrightness(0.1);
		}

		if (this.m.Bodies != null)
		{
			local body = this.m.Bodies[this.Math.rand(0, this.m.Bodies.len() - 1)];
			actor.getSprite("body").setBrush(body);
			actor.getSprite("injury_body").setBrush(body + "_injured");
		}

		this.onSetAppearance();
	}

	function buildPerkTree()
	{
		local a = this.character_background.buildPerkTree();

		if (this.getContainer().getActor().getFlags().has("perk_finished"))
		{
			this.onFinishingPerkTree();
		}

		return a;
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();
		actor.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/dlc2/hexe_idle_06.wav",
			"sounds/enemies/dlc2/hexe_idle_07.wav",
			"sounds/enemies/dlc2/hexe_idle_08.wav",
			"sounds/enemies/dlc2/hexe_idle_09.wav",
			"sounds/enemies/dlc2/hexe_idle_05.wav",
			"sounds/enemies/dlc2/hexe_idle_10.wav",
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
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
		actor.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/hexe_death_01.wav",
			"sounds/enemies/dlc2/hexe_death_02.wav",
			"sounds/enemies/dlc2/hexe_death_03.wav",
			"sounds/enemies/dlc2/hexe_death_04.wav",
			"sounds/enemies/dlc2/hexe_death_05.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/dlc2/hexe_idle_01.wav",
			"sounds/enemies/dlc2/hexe_idle_02.wav",
			"sounds/enemies/dlc2/hexe_idle_03.wav",
			"sounds/enemies/dlc2/hexe_idle_04.wav",
			"sounds/enemies/dlc2/hexe_idle_05.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/dlc2/hexe_flee_01.wav",
			"sounds/enemies/dlc2/hexe_flee_02.wav",
			"sounds/enemies/dlc2/hexe_flee_03.wav",
			"sounds/enemies/dlc2/hexe_flee_04.wav",
			"sounds/enemies/dlc2/hexe_flee_05.wav",
			"sounds/enemies/dlc2/hexe_flee_06.wav",
			"sounds/enemies/dlc2/hexe_flee_07.wav",
			"sounds/enemies/dlc2/hexe_flee_08.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
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
		actor.m.SoundPitch = this.Math.rand(105, 115) * 0.01;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 5.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Fatigue] = 5.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Other1] = 2.5;
	}

});

