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

	function onBuildDescription()
	{
		if (this.isBackgroundType(this.Const.BackgroundType.Female))
		{
			return "{ %name% is a practicioner of the dark arts. |  %name% carries a slumped posture, as if weighted by otherworldly knowledge. | %name%\'s face is transformed from its natural withered form | Not much is known about %name%, but strange rumors of sorcery and dark arts follow. | Wherever animals mysteriously begin to die, %name% makes an appearance. | The brooches on %name%\'s cloak seem to swirl and dance like midnight in a jug. | %name%\'s hands are rare to see, only coming out as if to portray the feelings of a face which lies hidden deep in its hood. | %name%\'s eyes could be mistaken for a cat\'s one day and for a blind man\'s the next.} {Little is known of their history | their past i but a mystery to most. | Some say they traveled deep into the northern foothills, returning with unspoken knowledge. | Ostensibly, the dark arts are their heritage, or so it seems. | Their past is kept from all. Maybe it\'s just uninteresting, or maybe just the opposite. | One rumor  says she traveled the land as a spellweaver. | Rumors of magic surround the woman, though some incredulous cynics are hardly impressed. | One rumor is that she was a conman, and another is that she\'s a sorcerer. You\'re not sure which you prefer. | With rumors of dark arts being practiced once more, the woman\'s magical proclamation just might be true. | Some say she eats toads for breakfast and black cats for dinner.} {You ask %name% a lot of questions, but through some handwaves and nods, you realize you have forgotten her answers. Or did you ask the questions at all? | %name% produces a dove from her sleeve. An old trick that fancies no one - until it turns in the air, returning to her as a crow. | %name% has shown the ability to shoot smoke from her mouth. It\'s not fire, but it\'s close, and has people talking in hushed tones. | %name% floats a gold coin into the air. An amazing display that leaves the woman too tired to attempt it again. | Predictions of the weather are common, but %name% is unusually accurate with her own. | %name% asks to read your palms. You decline. Her presence alone is as close as you\'re willing to go. | %name% suggests that the stars are a roadmap to another world. She seems to know a lot about the heavens above. | %name% suggests that the heavens above are in fact just endless streams of beings, continuing on for eons. What a jest! | %name% points to one star in the sky and seems to suggest that is where she came from. You don\'t ask for a clarification on the matter.}";
		}
		else
		{
			return "{ %name% is a practicioner of the dark arts. |  %name% carries a slumped posture, as if weighted by otherworldly knowledge. | %name%\'s face is transformed from its natural withered form | Not much is known about %name%, but strange rumors of sorcery and dark arts follow. | Wherever animals mysteriously begin to die, %name% makes an appearance. | The brooches on %name%\'s cloak seem to swirl and dance like midnight in a jug. | %name%\'s hands are rare to see, only coming out as if to portray the feelings of a face which lies hidden deep in its hood. | %name%\'s eyes could be mistaken for a cat\'s one day and for a blind man\'s the next.} {Little is known of their history | their past i but a mystery to most. | Some say they traveled deep into the northern foothills, returning with unspoken knowledge. | Ostensibly, the dark arts are their heritage, or so it seems. | Their past is kept from all. Maybe it\'s just uninteresting, or maybe just the opposite. | One rumor  says he traveled the land as a spellweaver. | Rumors of magic surround the man, though some incredulous cynics are hardly impressed. | One rumor is that he was a conman, and another is that he\'s a sorcerer. You\'re not sure which you prefer. | With rumors of dark arts being practiced once more, the man\'s magical proclamation just might be true. | Some say he eats toads for breakfast and black cats for dinner.} {You ask %name% a lot of questions, but through some handwaves and nods, you realize you have forgotten his answers. Or did you ask the questions at all? | %name% produces a dove from his sleeve. An old trick that fancies no one - until it turns in the air, returning to him as a crow. | %name% has shown the ability to shoot smoke from his mouth. It\'s not fire, but it\'s close, and has people talking in hushed tones. | %name% floats a gold coin into the air. An amazing display that leaves the man too tired to attempt it again. | Predictions of the weather are common, but %name% is unusually accurate with his own. | %name% asks to read your palms. You decline. His presence alone is as close as you\'re willing to go. | %name% suggests that the stars are a roadmap to another world. He seems to know a lot about the heavens above. | %name% suggests that the heavens above are in fact just endless streams of beings, continuing on for eons. What a jest! | %name% points to one star in the sky and seems to suggest that is where he came from. You don\'t ask for a clarification on the matter.}";
		}
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

