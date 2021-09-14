this.battlemage_background <- this.inherit("scripts/skills/backgrounds/mc_mage_background", {
	m = {},
	function create()
	{
		this.mc_mage_background.create();
		this.m.ID = "background.battlemage";
		this.m.Name = "Battlemage";
		this.m.Icon = "ui/backgrounds/background_battlemage.png";
		this.m.GoodEnding = "Perhaps one of the sharpest men you\'ve ever met, %name% the apprentice was the quickest learner in the %companyname%. With plenty of crowns stored, he retired from fighting to take his talents to the business world. Last you heard he was doing very well for himself across multiple trades. If you ever have a son, this is the man you\'ll send him to for apprenticeship.";
		this.m.BadEnding = "%name% the apprentice was, by far, the quickest learner in the %companyname%. Little surprise then that he was also one of the quickest to recognize its inevitable downfall and leave while he still could. Had he been born in a different time he would have gone on to do great things. Instead, many wars, invasions, and plagues spreading across the land ultimately ensured %name% and many other talented men went to total waste.";
		this.m.HiringCost = 8000;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.dumb",
			"trait.huge",
			"trait.tiny",
			"trait.superstitious",
		];
		this.m.Names = [
			"Itorn",
			"Unzaquam",
			"Jutaz",
			"Ulaqiohr",
			"Otarum",
			"Oraxium",
			"Uqiohr",
			"Anotorn",
			"Qenorim",
			"Ildor",
			"Aqiohr",
			"Olezin",
			"Udalf",
			"Everhan",
			"Elogrus",
			"Ekey",
			"Urubahn",
			"Grumarim",
			"Unumonar",
			"Osior",
			"Virnas",
			"Ebus",
			"Ulvidus",
			"Agroqor",
			"Kabeus",
			"Griwix",
			"Irumaex",
			"Ikius",
			"Ulzidalf",
			"Olrageor",
			"Gandalf"
		];
		this.m.Titles = [
			"Tri-arts",
			"The Wise",
			"The Illuminator",
			"The Conjurer",
			"The Invoker",
			"The Stargazer",
			"The Brave",
			"The Gladiator",
			"The Magician",
			"The Sorcerer",
			"The Spellbreaker",
			"The Mystic",
			"The Slayer",
			"The Gray",
			"The Powerful",
			"The Legend"
		];
		this.m.Job = this.Const.MC_Job.BattleMage;
		this.m.Tier = this.Const.MC_MagicTier.Basic;
		this.addBackgroundType(this.Const.BackgroundType.Combat);
		this.addBackgroundType(this.Const.BackgroundType.Performing);
		this.addBackgroundType(this.Const.BackgroundType.Educated);
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue,
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = this.Math.rand(2, 4);
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.NeutralMin;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.NeutralMax;
		this.m.Modifiers.Meds = this.Const.LegendMod.ResourceModifiers.Meds[1];
		this.m.Modifiers.Healing = this.Const.LegendMod.ResourceModifiers.Healing[3];
		this.m.Modifiers.Injury = this.Const.LegendMod.ResourceModifiers.Injury[3];
		this.m.Modifiers.MedConsumption = this.Const.LegendMod.ResourceModifiers.MedConsumption[1];
		this.m.Modifiers.Gathering = this.Const.LegendMod.ResourceModifiers.Gather[1];
		this.m.Modifiers.Enchanting = 0.5;
		this.m.PerkTreeDynamic = {
			Weapon = [
				this.Const.Perks.StavesTree,
				this.Const.Perks.DaggerTree,
			],
			Defense = [
				this.Const.Perks.LightArmorTree
			],
			Traits = [
				this.Const.Perks.IntelligentTree,
				this.Const.Perks.CalmTree,
				this.Const.Perks.TrainedTree,
				this.Const.Perks.OrganisedTree,
			],
			Enemy = [
				this.Const.Perks.OrcsTree,
				this.Const.Perks.UnholdTree,
			],
			Class = [
				this.Const.Perks.FistsClassTree,
			],
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
					[{Weight = 100, Tree = this.Const.Perks.SoldierProfessionTree}]
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

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				3
			],
			Bravery = [
				13,
				10
			],
			Stamina = [
				5,
				7
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				11,
				7
			],
			MeleeDefense = [
				5,
				5
			],
			RangedDefense = [
				5,
				5
			],
			Initiative = [
				7,
				5
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
				text = "Can enhance attacks from [color=" + this.Const.UI.Color.PositiveValue + "]Staff[/color] with additional armor piercing damage"
			},
		];

		ret.extend(this.getAttributesTooltip());
		return ret;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
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
		items.equip(this.Const.World.Common.pickArmor([
			[
				1,
				"legend_seer_robes"
			]
		]));
		items.equip(this.new("scripts/items/weapons/legend_mystic_staff"));
	}

	function onTurnStart()
	{
		local effect = this.getContainer().getSkillByID("effects.mc_stored_energy");

		if (effect == null)
		{
			effect = this.new("scripts/skills/mc_effects/mc_stored_energy_effect");
			this.getContainer().add(effect);
		}
		
		local ret = effect.addEnergy(10);

		if (!this.getContainer().getActor().isHiddenToPlayer() && ret != 0)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " store [b]" + ret + "[/b] energy");
		}
	}
	
});

