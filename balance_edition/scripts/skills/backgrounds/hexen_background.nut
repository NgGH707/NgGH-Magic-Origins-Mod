this.hexen_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		NewPerkTree = null,
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hexen_commander";
		this.m.Name = "Elder Hexe";
		this.m.Icon = "ui/backgrounds/background_hexe.png";
		this.m.HiringCost = 30000;
		this.m.DailyCost = 0;
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
		this.m.Faces = this.Const.HexenOrigin.FakeHead;
		this.m.Hairs = this.Const.HexenOrigin.FakeHair;
		this.m.Bodies = ["bust_hexen_fake_body_00"];
		this.m.Beards = null;
		this.m.BeardChance = 0;
		
		this.addBackgroundType(this.Const.BackgroundType.Educated);
		this.addBackgroundType(this.Const.BackgroundType.Female);

		this.m.AlignmentMin = this.Const.LegendMod.Alignment.Dreaded;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.Merciless;
		this.m.Modifiers.Meds = this.Const.LegendMod.ResourceModifiers.Meds[2];
		this.m.Modifiers.Stash = this.Const.LegendMod.ResourceModifiers.Stash[0];
		this.m.Modifiers.Healing = this.Const.LegendMod.ResourceModifiers.Healing[3];
		this.m.Modifiers.Crafting = this.Const.LegendMod.ResourceModifiers.Crafting[1];
		this.m.Modifiers.Barter = this.Const.LegendMod.ResourceModifiers.Barter[1];
		this.m.Modifiers.Enchanting = 1.0;
		
		this.m.CustomPerkTree = [
			[ // 0
				this.Const.Perks.PerkDefs.LegendMagicMissile,
				this.Const.Perks.PerkDefs.Bullseye,
				this.Const.Perks.PerkDefs.Pathfinder,
				this.Const.Perks.PerkDefs.HoldOut,
				this.Const.Perks.PerkDefs.Student,
				this.Const.Perks.PerkDefs.Recover,
				this.Const.Perks.PerkDefs.QuickHands,
				this.Const.Perks.PerkDefs.LegendAlert,
				this.Const.Perks.PerkDefs.LegendMealPreperation,
				this.Const.Perks.PerkDefs.LegendCheerOn,
				this.Const.Perks.PerkDefs.LegendSpecialistLuteSkill,
			],
			[ // 1
				this.Const.Perks.PerkDefs.Dodge,
				this.Const.Perks.PerkDefs.Gifted,
				this.Const.Perks.PerkDefs.LegendEntice,
				this.Const.Perks.PerkDefs.LegendDaze,
				this.Const.Perks.PerkDefs.LegendSpecStaffSkill,
				this.Const.Perks.PerkDefs.LegendFieldTreats,
				this.Const.Perks.PerkDefs.LegendMedIngredients,
				this.Const.Perks.PerkDefs.LegendCampCook,
				this.Const.Perks.PerkDefs.CharmBasic,
				this.Const.Perks.PerkDefs.CharmEnemySpider,
			],
			[ // 2
				this.Const.Perks.PerkDefs.LegendBalance,
				this.Const.Perks.PerkDefs.Anticipation,
				this.Const.Perks.PerkDefs.LegendMasteryStaves,
				this.Const.Perks.PerkDefs.LegendSpecialistLuteDamage,
				this.Const.Perks.PerkDefs.Ballistics,
				this.Const.Perks.PerkDefs.RallyTheTroops,
				this.Const.Perks.PerkDefs.Rotation,
				this.Const.Perks.PerkDefs.LegendAlcoholBrewing,
				this.Const.Perks.PerkDefs.CharmEnemyAlps,
				this.Const.Perks.PerkDefs.CharmEnemyDirewolf,
			],
			[ // 3
				this.Const.Perks.PerkDefs.MageLegendMasteryMagicMissileFocus,
				this.Const.Perks.PerkDefs.SpecMace,
				this.Const.Perks.PerkDefs.Nimble,
				this.Const.Perks.PerkDefs.LegendLithe,
				this.Const.Perks.PerkDefs.LegendSpecStaffStun,
				this.Const.Perks.PerkDefs.FortifiedMind,
				this.Const.Perks.PerkDefs.LegendTrueBeliever,
				this.Const.Perks.PerkDefs.LegendHerbcraft,
				this.Const.Perks.PerkDefs.LegendPotionBrewer,
				this.Const.Perks.PerkDefs.LegendValaInscribeShield,
				this.Const.Perks.PerkDefs.CharmWord,
				this.Const.Perks.PerkDefs.CharmEnemyGoblin,
			],
			[ // 4
				this.Const.Perks.PerkDefs.Inspire,
				this.Const.Perks.PerkDefs.Footwork,
				this.Const.Perks.PerkDefs.LegendPush,
				this.Const.Perks.PerkDefs.LegendClarity,
				this.Const.Perks.PerkDefs.LegendValaInscribeWeapon,
				this.Const.Perks.PerkDefs.LegendDistantVisions,
				this.Const.Perks.PerkDefs.LegendTerrifyingVisage,
				this.Const.Perks.PerkDefs.CharmEnemyGhoul,
				this.Const.Perks.PerkDefs.CharmEnemyOrk,
			],
			[ // 5
				this.Const.Perks.PerkDefs.LegendValaInscriptionMastery,	
				this.Const.Perks.PerkDefs.LegendValaInscribeHelmet,
				this.Const.Perks.PerkDefs.LegendValaInscribeArmor,
				this.Const.Perks.PerkDefs.InspiringPresence,
				this.Const.Perks.PerkDefs.LegendDrumsOfWar,
				this.Const.Perks.PerkDefs.LegendMindOverBody,
				this.Const.Perks.PerkDefs.LegendHeightenedReflexes,
				this.Const.Perks.PerkDefs.CharmEnemyUnhold,
				this.Const.Perks.PerkDefs.CharmEnemySchrat,
				
			],
			[ // 6
				this.Const.Perks.PerkDefs.MageLegendMasteryMagicMissileMastery,
				this.Const.Perks.PerkDefs.PerfectFocus,
				this.Const.Perks.PerkDefs.LegendDrumsOfLife,
				this.Const.Perks.PerkDefs.CharmSpec,
				this.Const.Perks.PerkDefs.CharmNudist,
				this.Const.Perks.PerkDefs.CharmAppearance,
				this.Const.Perks.PerkDefs.CharmEnemyLindwurm,
			],
			[],
			[],
			[],
			[]
		];

		if (this.Math.rand(1, 100) == 70)
		{
			this.m.CustomPerkTree[6].push(this.Const.Perks.PerkDefs.HexenChampion);
		}

		if (this.Math.rand(1, 100) >= 95)
		{
			this.m.CustomPerkTree[2].push(this.Const.Perks.PerkDefs.FairGame);
		}
		
		if (::mods_getRegisteredMod("mod_legends_PTR") != null)
		{
			this.addPerkTreesToCustomPerkTree(this.m.CustomPerkTree, [
				this.Const.Perks.HealerClassTree,
				this.Const.Perks.LightArmorTree,
				this.Const.Perks.MediumArmorTree,
				this.Const.Perks.TalentedTree,
				this.Const.Perks.TwoHandedTree,
				this.Const.Perks.StavesTree,
				this.Const.Perks.RangedTree
			]);
		}
		
		this.m.NewPerkTree = clone this.m.CustomPerkTree;
	}

	function addPerkTreesToCustomPerkTree(_customPerkTree, _treesToAdd)
	{
		foreach (tree in _treesToAdd)
		{
			for (local i = 0; i < tree.Tree.len(); i++)
			{
				foreach (perk in tree.Tree[i])
				{
					_customPerkTree[i].push(perk);
				}
			}
		}
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
			},
		];

		if (this.getContainer() == null || this.getContainer().getActor() == null)
		{
			return ret;
		}

		ret.extend(this.getAttributesTooltip());
		return ret;
	}

	function onBuildDescription()
	{
		return "Every since %name% was a child, she wanted everything, a greedy girl she was. Her plate was always fill with wonderous goodness, dressed in the finest outfit. But she can't have a charming looks or a true authority above others, that is why she stepped in the realm of dark art. \nShe was banished out of her home town for her dreadful deeds but at least she still kept her life, hiding herself in deep forest. With vengeance and greed powered her to seek more power, %name% has become a fearsome crone after years and years worth of practicing black magic and brewing strange potions. She brought waste to the town had banished her, not a single soul was spared, children was brewed into potions to return her youth, the adult were left to feed crows. \nBut soon something expectingly happened, %name% met a fools came to ruin her grand ritual. She was cursed in the end! Beautiful as goddess but powerless to the contract she has been eternally bounded.";
	}

	function buildAttributes( _tag = null, _attrs = null )
	{
		local b = this.getContainer().getActor().getBaseProperties();
		b.ActionPoints = 9;
		b.Hitpoints = this.Math.rand(48, 52);
		b.Bravery = this.Math.rand(45, 55);
		b.Stamina = this.Math.rand(70, 82);
		b.MeleeSkill = this.Math.rand(40, 45);
		b.RangedSkill = this.Math.rand(50, 62);
		b.MeleeDefense = this.Math.rand(0, 5);
		b.RangedDefense = 5;
		b.Initiative = this.Math.rand(90, 110);
		
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
		this.getContainer().getActor().getFlags().add("rank", 3);
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
		local r = this.Math.rand(1, 100);
		items.equip(this.new("scripts/items/weapons/greenskins/goblin_staff"));
		items.equip(this.Const.World.Common.pickArmor([
			[
				1,
				"thick_dark_tunic"
			]
		]));
		items.equip(this.Const.World.Common.pickHelmet([
			[
				1,
				""
			],
			[
				1,
				"dark_cowl"
			],
			[
				1,
				"hood"
			]
		]));
	}
	
	function onMakePlayerCharacter()
	{
		local a = {
			Hitpoints = [
				10,
				10
			],
			Bravery = [
				5,
				10
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				40,
				45
			],
			RangedSkill = [
				50,
				55
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				0,
				0
			]
		};
		local b = this.getContainer().getActor().getBaseProperties();
		b.Hitpoints += this.Math.rand(a.Hitpoints[0], a.Hitpoints[1]);
		b.Bravery += this.Math.rand(a.Bravery[0], a.Bravery[1]);
		b.Stamina += this.Math.rand(a.Stamina[0], a.Stamina[1]);
		b.MeleeSkill += this.Math.rand(a.MeleeSkill[0], a.MeleeSkill[1]);
		b.RangedSkill += this.Math.rand(a.RangedSkill[0], a.RangedSkill[1]);
		b.MeleeDefense += this.Math.rand(a.MeleeDefense[0], a.MeleeDefense[1]);
		b.RangedDefense += this.Math.rand(a.RangedDefense[0], a.RangedDefense[1]);
		b.Initiative += this.Math.rand(a.Initiative[0], a.Initiative[1]);
		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.getContainer().getActor().setHitpoints(b.Hitpoints);
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
	
	function onNewDay()
	{
		///
		local stash = this.World.Assets.getStash();

		if (stash.getNumberOfEmptySlots() > 0 && this.Math.rand(1, 100) <= 15)
		{
			local name = this.Math.rand(1, 3) == 3 ? "legend_witch_leader_hair_item" : "witch_hair_item";
			stash.add(this.new("scripts/items/misc/" + name));
		}

		local days = this.World.Flags.getAsInt("RitualTimer");

		if (days < 7)
		{
			this.logInfo("Ritual - Days passed: " + days);
			this.World.Flags.increment("RitualTimer");
			return;
		}
		
		local ritual = this.World.Events.fire("event.hexe_origin_ritual");
		
		if (ritual)
		{
			this.World.Flags.set("RitualTimer", 1);
			this.logInfo("Ritual - Has just perform");
			return;
		}
		
		this.logInfo("Ritual - Fails to start the events, something might have interruptted it");
	}

});

