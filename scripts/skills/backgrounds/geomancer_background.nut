this.geomancer_background <- this.inherit("scripts/skills/backgrounds/mc_mage_background", {
	m = {},
	function create()
	{
		this.mc_mage_background.create();
		this.m.ID = "background.geomancer";
		this.m.Name = "Geomancer";
		this.m.Icon = "ui/backgrounds/background_geomancer.png";
		this.m.GoodEnding = "Perhaps one of the sharpest men you\'ve ever met, %name% the apprentice was the quickest learner in the %companyname%. With plenty of crowns stored, he retired from fighting to take his talents to the business world. Last you heard he was doing very well for himself across multiple trades. If you ever have a son, this is the man you\'ll send him to for apprenticeship.";
		this.m.BadEnding = "%name% the apprentice was, by far, the quickest learner in the %companyname%. Little surprise then that he was also one of the quickest to recognize its inevitable downfall and leave while he still could. Had he been born in a different time he would have gone on to do great things. Instead, many wars, invasions, and plagues spreading across the land ultimately ensured %name% and many other talented men went to total waste.";
		this.m.HiringCost = 8000;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.athletic",
			"trait.brute",
			"trait.superstitious",
			"trait.tiny",
		];
		/*this.m.Names = [
			"Ureforn",
			"Uzin",
			"Stokalis",
			"Igoldor",
			"Imorn",
			"Uvozahl",
			"Iprix",
			"Udel",
			"Adruleus",
			"Iqihr",
			"Ufaris",
			"Edrixius",
			"Dokore",
			"Iforn",
			"Ulin",
			"Izonorim",
			"Kophiar",
			"Urnas",
			"Toxar",
			"Utorn",
			"Huricus",
			"Malefis",
			"Disaris",
			"Firn",
			"Saeclum",
			"Ashe",
			"Necos",
			"Elan",
			"Ozone",
			"Aeros"
		];*/
		this.m.Titles = [
			"the Earth Raiser",
			"the Mountain Maker",
			"the Geomancer",
			"the Nature Wraith",
			"the Stone",
			"the Druid",
			"the Stone Puppeteer",
			"the Rock Breaker",
			"the Stoney Mage",
			"the Earthen Caster",
			"the Gray",
			"Golem Smith",
			"the Nature Sculptor",
			"the Sand Conjurer",
			"the Earthen Sorcerer",
			"Earthshaker",
			"Bottomless Hole",
			"MountainRage"
		];
		this.m.Job = this.Const.MC_Job.Geomancer;
		this.m.Tier = this.Const.MC_MagicTier.Basic;
		this.addBackgroundType(this.Const.BackgroundType.Performing);
		this.addBackgroundType(this.Const.BackgroundType.Educated);
		this.m.ExcludedTalents = [
			this.Const.Attributes.MeleeSkill,
			this.Const.Attributes.RangedSkill
		];
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.SouthernYoung;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.Ethnicity = 1;
		this.m.Level = this.Math.rand(2, 4);
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.NeutralMin;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.NeutralMax;
		this.m.Modifiers.Healing = this.Const.LegendMod.ResourceModifiers.Healing[1];
		this.m.Modifiers.Crafting = this.Const.LegendMod.ResourceModifiers.Crafting[3];
		this.m.Modifiers.ToolConsumption = this.Const.LegendMod.ResourceModifiers.ToolConsumption[1];
		this.m.Modifiers.MedConsumption = this.Const.LegendMod.ResourceModifiers.MedConsumption[2];
		this.m.Modifiers.Enchanting = 0.5;
		this.m.PerkTreeDynamic = {
			Weapon = [
				this.Const.Perks.DaggerTree,
				this.Const.Perks.StavesTree,
				this.Const.Perks.ThrowingTree,
			],
			Defense = [
				this.Const.Perks.LightArmorTree,
			],
			Traits = [
				this.Const.Perks.IntelligentTree,
				this.Const.Perks.FastTree,
				this.Const.Perks.ViciousTree
				this.Const.Perks.CalmTree
			],
			Enemy = [
				this.Const.Perks.MysticTree,
				this.Const.Perks.CivilizationTree,
			],
			Class = [],
			Magic = []
		};

		if (::mods_getRegisteredMod("mod_legends_PTR") != null)
		{
			this.m.PerkTreeDynamic = {
				ExpertiseMultipliers = [
				],
				WeightMultipliers = [
				],
				Traits = [
					[{Weight = 100, Tree = this.Const.Perks.TalentedTree}],
					[{Weight = 100, Tree = this.Const.Perks.CalmTree}],
					[{Weight = 100, Tree = this.Const.Perks.ViciousTree}],
				],
				Defense = [
					[{Weight = 100, Tree = this.Const.Perks.LightArmorTree}]
				],
				Weapon = [
					[{Weight = 100, Tree = this.Const.Perks.StavesTree}],
					[{Weight = 100, Tree = this.Const.Perks.DaggerTree}]
				],
				Profession = [
					[{Weight = 100, Tree = this.Const.Perks.LaborerProfessionTree}]
				],
				Styles = [
					[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}],
				],
				Magic = []
			};
		}
	}

	function setGender( _gender = -1 )
	{
		local r = _gender;

		if (_gender == -1)
		{
			r = 0;

			if (this.LegendsMod.Configs().LegendGenderEnabled())
			{
				r = this.Math.rand(0, 1);
			}
		}

		if (r == 0)
		{
			return;
		}

		this.m.Faces = this.Const.Faces.SouthernFemale;
		this.m.Hairs = this.Const.Hair.AllFemale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = null;
		this.m.BeardChance = 0;
		this.m.Bodies = this.Const.Bodies.SouthernFemale;
		this.addBackgroundType(this.Const.BackgroundType.Female);
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				0
			],
			Bravery = [
				0,
				15
			],
			Stamina = [
				-5,
				0
			],
			MeleeSkill = [
				-5,
				5
			],
			RangedSkill = [
				5,
				10
			],
			MeleeDefense = [
				-5,
				-5
			],
			RangedDefense = [
				5,
				5
			],
			Initiative = [
				-5,
				0
			]
		};
		return c;
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
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Deal [color=" + this.Const.UI.Color.PositiveValue + "]double[/color] damage against to Rock Unhold and Ifrit"
			},
		];

		ret.extend(this.getAttributesTooltip());
		return ret;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(this.Const.World.Common.pickArmor([
			[
				1,
				"oriental/thick_nomad_robe"
			],
			[
				1,
				"oriental/stitched_nomad_armor"
			],
			[
				1,
				"oriental/leather_nomad_robe"
			]
		]));
		items.equip(this.Const.World.Common.pickHelmet([
			[
				1,
				"oriental/assassin_head_wrap"
			],
			[
				1,
				"legend_headband_coin"
			],
			[
				1,
				"legend_headress_coin"
			],
			[
				1,
				"legend_noble_southern_hat"
			],
		]));
		items.equip(this.new("scripts/items/weapons/legend_staff_vala"));
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity != null)
		{
			local counter = [
				this.Const.EntityType.SandGolem,
				this.Const.EntityType.LegendRockUnhold,
			];

			if (counter.find(_targetEntity.getType()) != null)
			{
				_properties.DamageTotalMult *= 2.0;
			}
		}
	}

});

