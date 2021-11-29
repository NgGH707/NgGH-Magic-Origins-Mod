this.elementalist_background <- this.inherit("scripts/skills/backgrounds/mc_mage_background", {
	m = {},
	function create()
	{
		this.mc_mage_background.create();
		this.m.ID = "background.elementalist";
		this.m.Name = "Elementalist";
		this.m.Icon = "ui/backgrounds/background_elementalist.png";
		this.m.GoodEnding = "Perhaps one of the sharpest men you\'ve ever met, %name% the apprentice was the quickest learner in the %companyname%. With plenty of crowns stored, he retired from fighting to take his talents to the business world. Last you heard he was doing very well for himself across multiple trades. If you ever have a son, this is the man you\'ll send him to for apprenticeship.";
		this.m.BadEnding = "%name% the apprentice was, by far, the quickest learner in the %companyname%. Little surprise then that he was also one of the quickest to recognize its inevitable downfall and leave while he still could. Had he been born in a different time he would have gone on to do great things. Instead, many wars, invasions, and plagues spreading across the land ultimately ensured %name% and many other talented men went to total waste.";
		this.m.HiringCost = 9000;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.fear_beasts",
			"trait.hate_undead",
			"trait.insecure",
			"trait.hesitant",
			"trait.asthmatic",
			"trait.greedy",
			"trait.fragile",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.cocky",
			"trait.dastard",
			"trait.drunkard",
			"trait.disloyal",
			"trait.loyal"
			"trait.superstitious",
		];
		this.m.Names = [
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
		];
		this.m.Titles = [
			"the All-Powerful"
		];
		this.m.Job = this.Const.MC_Job.Elementalist;
		this.m.Tier = this.Const.MC_MagicTier.Basic;
		this.addBackgroundType(this.Const.BackgroundType.Performing);
		this.addBackgroundType(this.Const.BackgroundType.Educated);
		this.addBackgroundType(this.Const.BackgroundType.Druid);
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = this.Math.rand(2, 4);
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.NeutralMin;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.NeutralMax;
		this.m.Modifiers.Stash = this.Const.LegendMod.ResourceModifiers.Stash[1];
		this.m.Modifiers.Healing = this.Const.LegendMod.ResourceModifiers.Healing[2];
		this.m.Modifiers.Gathering = this.Const.LegendMod.ResourceModifiers.Gather[3];
		this.m.Modifiers.Enchanting = 0.25;
		this.m.PerkTreeDynamic = {
			Weapon = [
				this.Const.Perks.DaggerTree,
				this.Const.Perks.StavesTree,
			],
			Defense = [
				this.Const.Perks.LightArmorTree,
			],
			Traits = [
				this.Const.Perks.IntelligentTree,
				this.Const.Perks.ViciousTree,
				this.Const.Perks.OrganisedTree,
				this.Const.Perks.CalmTree,
			],
			Enemy = [
				this.Const.Perks.BeastsTree,
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
					{Multiplier = 100, Tree = this.Const.Perks.TalentedTree},
					{Multiplier = 100, Tree = this.Const.Perks.OrganisedTree},
					{Multiplier = 100, Tree = this.Const.Perks.CalmTree}
				],
				Defense = [
					[{Weight = 100, Tree = this.Const.Perks.LightArmorTree}]
				],
				Weapon = [
					[{Weight = 100, Tree = this.Const.Perks.StavesTree}],
					[{Weight = 100, Tree = this.Const.Perks.DaggerTree}]
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

		this.m.Faces = this.Const.Faces.AllWhiteFemale;
		this.m.Hairs = this.Const.Hair.AllFemale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.BeardChance = 0;
		this.m.Bodies = this.Const.Bodies.AllFemale;
		this.addBackgroundType(this.Const.BackgroundType.Female);
	}

	function onBuildDescription()
	{
		return "{ The air around %name% seems thicker, almost charged. It makes breathing itself difficult. %name% doesn't seem to mind though. Instead, %name%'s eyes reflects a strength of spirit able to bind the laws of nature themselves. }";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-5
			],
			Bravery = [
				5,
				10
			],
			Stamina = [
				-5,
				5
			],
			MeleeSkill = [
				-5,
				5
			],
			RangedSkill = [
				5,
				15
			],
			MeleeDefense = [
				0,
				-5
			],
			RangedDefense = [
				0,
				-5
			],
			Initiative = [
				5,
				10
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
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Fire[/color]"
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
				"legend_seer_robes"
			]
		]));
		items.equip(this.new("scripts/items/weapons/legend_mystic_staff"));
		items.equip(this.Const.World.Common.pickHelmet([
			[
				1,
				"legend_seer_hat"
			],
			[
				1,
				"magician_hat"
			]
		]));
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.IsImmuneToFire = true;
	}

});

