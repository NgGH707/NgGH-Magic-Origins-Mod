this.spider_eggs_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		DayCount = 0,
	},
	
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.spider_eggs";
		this.m.Name = "Webknecht Hive"
		this.m.Icon = "ui/backgrounds/background_spider_eggs.png";
		this.m.BackgroundDescription = "A spider hive that has been carefully nurtured and combined with black magic and weird potions. This abomination is the result of what a maddened witch would do.";
		this.m.Excluded = [
			"trait.eagle_eyes",
			"trait.short_sighted",
			"trait.hesitant",
			"trait.quick",
			"trait.cocky",
			"trait.clumsy",
			"trait.fearless",
			"trait.drunkard",
			"trait.fainthearted",
			"trait.bleeder",
			"trait.ailing",
			"trait.determined",
			"trait.dastard",
			"trait.deathwish",
			"trait.insecure",
			"trait.optimist",
			"trait.pessimist",
			"trait.superstitious",
			"trait.brave",
			"trait.dexterous",
			"trait.sure_footing",
			"trait.asthmatic",
			"trait.iron_lungs",
			"trait.craven",
			"trait.greedy",
			"trait.gluttonous",
			"trait.spartan",
			"trait.athletic",
			"trait.brute",
			"trait.irrational",
			"trait.clubfooted",
			"trait.loyal",
			"trait.disloyal",
			"trait.bloodthirsty",
			"trait.iron_jaw",
			"trait.survivor",
			"trait.swift",
			"trait.night_blind",
			"trait.night_owl",
			"trait.hate_nobles",
			"trait.hate_greenskins",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.fear_beasts",
			"trait.fear_nobles",
			"trait.fear_undead",
			"trait.fear_greenskins",
			"trait.teamplayer",
			"trait.weasel",
			"trait.huge",
			"trait.steady_hands",
			"trait.unpredictable",
			"trait.predictable",
			"trait.pragmatic",
			"trait.light",
			"trait.heavy",
			"trait.firm",
			"trait.aggressive",
			"trait.gift_of_people",
			"trait.double_tongued",
		];
		this.m.HiringCost = 0;
		this.m.DailyCost = 0;
		this.m.Faces = null;
		this.m.Bodies = null;
		this.m.Hairs = null;
		this.m.HairColors = null;
		this.m.Beards = null;
		this.m.BeardChance = 0;
		
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.NeutralMin;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.NeutralMax;
		this.m.Modifiers.Meds = this.Const.LegendMod.ResourceModifiers.Meds[1];
		this.m.Modifiers.Stash = 0;
		this.m.Modifiers.Healing = this.Const.LegendMod.ResourceModifiers.Healing[3];
		this.m.Modifiers.Injury = this.Const.LegendMod.ResourceModifiers.Injury[2];
		this.m.Modifiers.MedConsumption = this.Const.LegendMod.ResourceModifiers.MedConsumption[1];
		this.m.Modifiers.Hunting = this.Const.LegendMod.ResourceModifiers.Hunting[2];
		this.m.Modifiers.Scout = this.Const.LegendMod.ResourceModifiers.Scout[0];
		
		this.m.PerkTreeDynamic = {
			Weapon = [],
			Defense = [],
			Traits = [],
			Enemy = [],
			Class = [],
			Magic = [
				ID = "SpiderHive",
				Name = "SpiderHive",
				Descriptions = ["spider hive"],
				Tree = [
					[],
					[],
					[],
					[gt.Const.Perks.PerkDefs.SpiderVenom, gt.Const.Perks.PerkDefs.EggBreedingMachine, gt.Const.Perks.PerkDefs.EggAttachSpider],
					[gt.Const.Perks.PerkDefs.SpiderWeb],
					[gt.Const.Perks.PerkDefs.SpiderBite, gt.Const.Perks.PerkDefs.EggInherit],
					[gt.Const.Perks.PerkDefs.EggNaturalSelection]
				]			
			],
		};		
	}
	
	function onUpdate( _properties )
	{
		_properties.TargetAttractionMult *= 2.5;
		_properties.IsContentWithBeingInReserve = true;
	}
	
	function onAdded()
	{
		if (this.m.IsNew)
		{
			local attributes = this.buildPerkTree();
			this.getContainer().getActor().m.StarWeights = this.buildAttributes(null, attributes);

			if (!this.getContainer().hasSkill("racial.champion") && this.Math.rand(1, 100) == 33)
			{
				this.addPerk(this.Const.Perks.PerkDefs.HexenChampion, 6);
			}

			if (this.Math.rand(1, 100) >= 95)
			{
				this.addPerk(this.Const.Perks.PerkDefs.FairGame, 2);
			}
		}
		
		this.character_background.onAdded();
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
				id = 10,
				type = "text",
				icon = "ui/icons/unknown_traits.png",
				text = "Spawns a [color=" + this.Const.UI.Color.NegativeValue + "]Webknecht[/color] every week, and add it to your roster"
			}
		];
		
		if (this.getContainer() == null || this.getContainer().getActor() == null)
		{
			return ret;
		}

		local p = this.getContainer().getActor().getBaseProperties();
		ret.extend(this.Const.HexenOrigin.CharmedSlave.getTooltip(p));
		ret.extend(this.getAttributesTooltip());
		return ret;
	}

	function onBuildDescription()
	{
		return this.m.BackgroundDescription;
	}
	
	function buildAttributes( _tag = null, _attrs = null )
	{
		local maxTraits = this.Math.rand(this.Math.rand(0, 1) == 0 ? 0 : 1, 2);
		local traits = [this];

		for( local i = 0; i < maxTraits; i = ++i )
		{
			for( local j = 0; j < 10; j = ++j )
			{
				local trait = this.Const.CharacterTraits[this.Math.rand(0, this.Const.CharacterTraits.len() - 1)];
				local nextTrait = false;

				for( local k = 0; k < traits.len(); k = ++k )
				{
					if (traits[k].getID() == trait[0] || traits[k].isExcluded(trait[0]))
					{
						nextTrait = true;
						break;
					}
				}

				if (!nextTrait)
				{
					traits.push(this.new(trait[1]));
					break;
				}
			}
		}

		for( local i = 1; i < traits.len(); i = ++i )
		{
			this.getContainer().add(traits[i]);
		}

		local weighted = [];
		weighted.push(50);
		weighted.push(50);
		weighted.push(50);
		weighted.push(10);
		weighted.push(10);
		weighted.push(10);
		weighted.push(10);
		weighted.push(50);
		
		return weighted;
	}

	function onAddEquipment()
	{
	}
	
	function onNewDay()
	{
		this.m.DayCount = this.Math.min(7, this.m.DayCount + 1);
		this.getContainer().getActor().improveMood(6.0, ".......");
		
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax() || this.m.DayCount < 7)
		{
			return;
		}
		
		this.m.DayCount = 0;
		local spider = this.World.getPlayerRoster().create("scripts/entity/tactical/player_beast/spider_player");
		spider.improveMood(1.0, "Thrist for battle");
		spider.setScenarioValues();
		spider.onHired();
	}
	
	function onCombatStarted()
	{
		local actives = [
			"actives.spawn_spider",
			"actives.spawn_more_spider",
			"actives.add_egg"
		];
		local eggs = this.new("scripts/skills/eggs_actives/eggs_special");
		
		foreach ( id in actives )
		{
			local skill = this.getContainer().getSkillByID(id);
			
			if (skill != null)
			{
				skill.setEggsPool(eggs);
			}
		}
		
		this.getContainer().add(eggs);
	}
	
	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeU8(this.m.DayCount);
	}

	function onDeserialize( _in )
	{
		this.character_background.onDeserialize(_in);
		this.m.DayCount = _in.readU8();
		this.addPerk(this.Const.Perks.PerkDefs.EggAttachSpider, 3);
	}

});

