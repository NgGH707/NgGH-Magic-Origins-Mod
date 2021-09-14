this.diabolist_background <- this.inherit("scripts/skills/backgrounds/mc_mage_background", {
	m = {},
	function create()
	{
		this.mc_mage_background.create();
		this.m.ID = "background.diabolist";
		this.m.Name = "Diabolist";
		this.m.Icon = "ui/backgrounds/background_diabolist.png";
		this.m.GoodEnding = "Perhaps one of the sharpest men you\'ve ever met, %name% the apprentice was the quickest learner in the %companyname%. With plenty of crowns stored, he retired from fighting to take his talents to the business world. Last you heard he was doing very well for himself across multiple trades. If you ever have a son, this is the man you\'ll send him to for apprenticeship.";
		this.m.BadEnding = "%name% the apprentice was, by far, the quickest learner in the %companyname%. Little surprise then that he was also one of the quickest to recognize its inevitable downfall and leave while he still could. Had he been born in a different time he would have gone on to do great things. Instead, many wars, invasions, and plagues spreading across the land ultimately ensured %name% and many other talented men went to total waste.";
		this.m.HiringCost = 8000;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.cocky",
			"trait.fear_undead",
			"trait.greedy",
			"trait.tiny",
		];
		this.m.Names = [
			"Kezad", 
			"Britic",
			"Stazis", 
			"Vrizis",
			"Staekhar", 
			"Prakar",
			"Sexius",
			"Dobrum",
			"Kimien",
			"Cabrum",
			"Streirael", 
			"Feivras",
			"Zethik",
			"Wiodulus",
			"Hourius",
			"Yeivras",
			"Strezad",
			"Upriomon",
			"Groucular",
			"Wauqir",
			"Uvopent",
			"Vauzad",
		];
		this.m.Titles = [
			"the Fobbiden Seeker",
			"The Immortal",
			"The Tyrant",
			"The Haggard",
			"The Adept",
			"The Inquisitor",
			"The Defiler",
			"The Eternal",
			"The Corruptor",
			"The Corrupted"
		];
		this.m.Job = this.Const.MC_Job.Diabolist;
		this.m.Tier = this.Const.MC_MagicTier.Basic;
		this.m.AdditionalPerkGroup.push(this.Const.Perks.ValaRuneMagicTree.Tree);
		this.addBackgroundType(this.Const.BackgroundType.Performing);
		this.addBackgroundType(this.Const.BackgroundType.Educated);
		this.m.ExcludedTalents = [
			this.Const.Attributes.Initiative,
			this.Const.Attributes.Fatigue,
		];
		this.m.Faces = this.Const.Faces.NecromancerMale;
		this.m.Hairs = this.Const.Hair.Necromancer;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = this.Math.rand(2, 4);
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.Dreaded;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.Cruel;
		this.m.Modifiers.Meds = this.Const.LegendMod.ResourceModifiers.Meds[1];
		this.m.Modifiers.Healing = this.Const.LegendMod.ResourceModifiers.Healing[3];
		this.m.Modifiers.Injury = this.Const.LegendMod.ResourceModifiers.Injury[1];
		this.m.Modifiers.MedConsumption = this.Const.LegendMod.ResourceModifiers.MedConsumption[2];
		this.m.Modifiers.Gathering = this.Const.LegendMod.ResourceModifiers.Gather[2];
		this.m.Modifiers.Enchanting = 0.7;
		this.m.PerkTreeDynamic = {
			Weapon = [
				this.Const.Perks.StavesTree,
				this.Const.Perks.DaggerTree,
				this.Const.Perks.CleaverTree
			],
			Defense = [
				this.Const.Perks.LightArmorTree,
				this.Const.Perks.MediumArmorTree
			],
			Traits = [
				this.Const.Perks.IntelligentTree,
				this.Const.Perks.FastTree,
				this.Const.Perks.DeviousTree,
				this.Const.Perks.InspirationalTree
			],
			Enemy = [
				this.Const.Perks.MysticTree,
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
					[{Weight = 100, Tree = this.Const.Perks.LightArmorTree}],
					[{Weight = 50, Tree = this.Const.Perks.MediumArmorTree}]
				],
				Weapon = [
					[{Weight = 100, Tree = this.Const.Perks.StavesTree}],
					[{Weight = 100, Tree = this.Const.Perks.DaggerTree}],
					[{Weight = 50, Tree = this.Const.Perks.CleaverTree}],
				],
				Profession = [
					[{Weight = 100, Tree = this.Const.Perks.PauperProfessionTree}]
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

		this.m.Faces = this.Const.Faces.NecromancerFemale;
		this.m.Hairs = this.Const.Hair.Necromancer;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = null;
		this.m.BeardChance = 0;
		this.m.Bodies = this.Const.Bodies.FemaleSkinny;
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
				0,
				0
			],
			RangedDefense = [
				0,
				0
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
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can pass [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] of damage taken to summoned demon"
			}
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
				"cultist_hood"
			],
			[
				1,
				"dark_cowl"
			],
			[
				1,
				"dark_cowl"
			],
		]));
		items.equip(this.Const.World.Common.pickArmor([
			[
				1,
				"thick_dark_tunic"
			],
			[
				1,
				"legend_vala_cloak"
			],
		]));
		
		if (this.Math.rand(1, 2) == 1)
		{
			items.equip(this.new("scripts/items/weapons/legend_mystic_staff"));
		}
		else if (this.Math.rand(1, 2) == 1)
		{
			items.equip(this.new("scripts/items/weapons/legend_grisly_scythe"));
		}
		else 
		{
		    items.equip(this.new("scripts/items/weapons/legend_staff_gnarled"));
		}
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.DamageRegular <= 0)
		{
			return;
		}

		local _demon = this.getContainer().getSkillByID("actives.mc_shadow_demon");

		if (_demon == null || _demon.getEntity() == null)
		{
			return;
		}

		_hitInfo.DamageRegular = this.Math.floor(_hitInfo.DamageRegular * 0.5);
		_demon.applyDamage(_hitInfo.DamageRegular, _skill);
	}


});

