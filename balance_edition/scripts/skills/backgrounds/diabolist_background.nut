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
		this.m.Modifiers.Healing = this.Const.LegendMod.ResourceModifiers.Healing[3];
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
				Profession = [],
				Styles = [
					[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}],
				],
				Magic = []
			};
		}
	}

	function onBuildDescription()
	{
		return "{Clothed in strange black robes, %name% appears to be more of an ambassador of the dark than a man of flesh and blood. | A curious fellow, %name% carries a slumped posture, as if he is weighted by otherworldly knowledge. | %name%\'s face is hidden well inside the dark of his cowl, a crescent of yellow teeth the only notion that a man dwells within. | Not much is known about %name%, but strange rumors of sorcery and dark arts follow him. | Wherever animals mysteriously begin to die, %name% makes an appearance. | The brooches on %name%\'s cloak seem to swirl and dance like midnight in a jug. | %name%\'s hands are rare to see, only coming out as if to portray the feelings of his face which lies hidden deep in his hood. | %name%\'s eyes could be mistaken for a cat\'s one day and for a blind man\'s the next.} {Little is known about whence he came. | From where he hails is but a mystery to most. | Some say he traveled deep into the northern foothills, returning with unspoken knowledge. | Ostensibly, the dark arts are his heritage, or so he puts on. | The man\'s past is kept from all. Maybe it\'s just uninteresting, or maybe just the opposite. | One rumor of the man says he traveled the land as a magician. | Rumors of magic surround the man, though some incredulous cynics are hardly impressed. | One rumor is that he was a conman, and another is that he\'s a sorcerer. You\'re not sure which you prefer. | With rumors of dark arts being practiced once more, the man\'s magical proclamation just might be true. | Some say he eats toads for breakfast and black cats for dinner.} {You ask %name% a lot of questions, but through some handwaves and nods, you realize you have forgotten his answers. Or did you ask the questions at all? | %name% produces a dove from his sleeve. An old trick that fancies no one - until it turns in the air, returning to him as a crow. | %name% has shown the ability to shoot smoke from his mouth. It\'s not fire, but it\'s close, and has people talking in hushed tones. | %name% floats a gold coin into the air. An amazing display that leaves the man too tired to attempt it again. | Predictions of the weather are common, but %name% is unusually accurate with his own. | %name% asks to read your palms. You decline. His presence alone is as close as you\'re willing to go. | %name% suggests that the stars are a roadmap to another world. He seems to know a lot about the heavens above. | %name% suggests that the heavens above are in fact just endless streams of beings, continuing on for eons. What a jest! | %name% points to one star in the sky and seems to suggest that is where he came from. You don\'t ask for a clarification on the matter.}";
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
				7,
				15
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
				text = "Share [color=" + this.Const.UI.Color.PositiveValue + "]34%[/color] of any damage taken to summoned demon"
			}
		];

		ret.extend(this.getAttributesTooltip());
		return ret;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(this.Const.World.Common.pickHelmet([
			[1, "cultist_hood"],
			[1, "dark_cowl"],
			[1, "dark_cowl"],
			[1, "hood", 63]
		]));
		items.equip(this.Const.World.Common.pickArmor([
			[1, "ragged_dark_surcoat"],
			[1, "thick_dark_tunic"]
		]));
		
		if (this.Math.rand(1, 2) == 1)
		{
			items.equip(this.new("scripts/items/weapons/greenskins/goblin_staff"));
		}
		else if (this.Math.rand(1, 2) == 1)
		{
			items.equip(this.new("scripts/items/weapons/legend_mystic_staff"));
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

		local pass_damage = this.Math.floor(_hitInfo.DamageRegular * 0.34)
		_demon.applyDamage(pass_damage, _skill);
		_hitInfo.DamageRegular = this.Math.floor(_hitInfo.DamageRegular * 0.66);
		_hitInfo.DamageArmor = this.Math.floor(_hitInfo.DamageArmor * 0.66);
	}

});

