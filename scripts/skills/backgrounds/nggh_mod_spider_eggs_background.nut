this.nggh_mod_spider_eggs_background <- ::inherit("scripts/skills/backgrounds/character_background", {
	m = {
		DayCount = 0,
		PerkGroupMultipliers = [],
		IsOnDeserializing = false,
	},
	
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.spider_eggs";
		this.m.Name = "Webknecht Eggs"
		this.m.Icon = "ui/backgrounds/background_spider_eggs.png";
		this.m.BackgroundDescription = "Please don\'t turn me into scrambled eggs.";
		this.m.HiringCost = 0;
		this.m.DailyCost = 0;
		this.m.Faces = null;
		this.m.Bodies = null;
		this.m.Hairs = null;
		this.m.HairColors = null;
		this.m.Beards = null;
		this.m.BeardChance = 0;
		
		this.m.Excluded = ::Const.Nggh_ExcludedTraits.SpiderEggs;
		this.m.AlignmentMin = ::Const.LegendMod.Alignment.NeutralMin;
		this.m.AlignmentMax = ::Const.LegendMod.Alignment.NeutralMax;
		this.m.Modifiers.Healing = ::Const.LegendMod.ResourceModifiers.Healing[1];
		this.m.Modifiers.Hunting = ::Const.LegendMod.ResourceModifiers.Hunting[0];
		this.m.Modifiers.Scout = ::Const.LegendMod.ResourceModifiers.Scout[0];
		
		this.m.CustomPerkTree = [
			[
				::Const.Perks.PerkDefs.Recover,
				::Const.Perks.PerkDefs.Student,
			],
			[
				::Const.Perks.PerkDefs.HoldOut,
			],
			[
				::Const.Perks.PerkDefs.Gifted,
			],
			[
				::Const.Perks.PerkDefs.NggHNachoFrenzy,
			],
			[
				::Const.Perks.PerkDefs.NggHSpiderVenom,
			],
			[],
			[
				::Const.Perks.PerkDefs.NggHSpiderBite, 
			],
			[],
			[],
			[],
			[]
		];

		foreach (i, row in ::Const.Perks.NggH_SpiderHiveTree.Tree )
		{
			foreach ( perkDef in row )
			{
				this.m.CustomPerkTree[i].push(perkDef);
			}
		}
	}

	function onBuildDescription()
	{
		return this.m.BackgroundDescription;
	}
	
	function onAdded()
	{
		if (this.m.IsNew)
		{
			this.getContainer().getActor().m.StarWeights = this.buildAttributes(null, null);
			this.addBonusAttributes(this.buildPerkTree());
		}
		
		this.character_background.onAdded();
	}

	function onUpdate( _properties )
	{
		_properties.TargetAttractionMult *= 2.0;
		_properties.IsContentWithBeingInReserve = true;
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
				icon = "ui/orientation/spider_01_orientation.png",
				text = "Spawns a [color=" + ::Const.UI.Color.NegativeValue + "]Webknecht[/color] every week, and add it to your roster"
			}
		];
		
		if (this.getContainer() == null || this.getContainer().getActor() == null)
		{
			return ret;
		}

		ret.extend(::Const.CharmedUtilities.getTooltip(this.getContainer().getActor()));
		ret.extend(this.getAttributesTooltip());
		return ret;
	}

	function addBonusAttributes( _attr )
	{
		local b = this.getContainer().getActor().getBaseProperties();
		b.Hitpoints += ::Math.rand(_attr.Hitpoints[0], _attr.Hitpoints[1]);
		b.Bravery += ::Math.rand(_attr.Bravery[0], _attr.Bravery[1]);
		b.Stamina += ::Math.rand(_attr.Stamina[0], _attr.Stamina[1]);
		b.MeleeSkill += ::Math.rand(_attr.MeleeSkill[0], _attr.MeleeSkill[1]);
		b.RangedSkill += ::Math.rand(_attr.RangedSkill[0], _attr.RangedSkill[1]);
		b.MeleeDefense += ::Math.rand(_attr.MeleeDefense[0], _attr.MeleeDefense[1]);
		b.RangedDefense += ::Math.rand(_attr.RangedDefense[0], _attr.RangedDefense[1]);
		b.Initiative += ::Math.rand(_attr.Initiative[0], _attr.Initiative[1]);
		this.getContainer().getActor().m.CurrentProperties = clone b;
	}

	function addTraits()
	{
		local maxTraits = 2;
		local traits = [this];

		if (this.m.IsGuaranteed.len() > 0)
		{
			maxTraits = maxTraits - this.m.IsGuaranteed.len();
			foreach(trait in this.m.IsGuaranteed)
			{
				traits.push(::new("scripts/skills/traits/" + trait));
			}
		}

		this.m.Excluded.extend(this.getContainer().getActor().getExcludedTraits());
		this.getContainer().getActor().pickTraits(traits, maxTraits);

		for( local i = 1; i < traits.len(); ++i )
		{
			this.getContainer().add(traits[i]);

			if (traits[i].getContainer() != null)
			{
				traits[i].addTitle();
			}
		}
	}
	
	function buildAttributes( _tag = null, _attrs = null )
	{
		this.addTraits();
		local b = this.getContainer().getActor().getBaseProperties();
		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.getContainer().getActor().setHitpoints(b.Hitpoints);
		return array(8, 50);
	}

	function buildPerkTree()
	{
		if (this.m.PerkTree != null)
		{
			return ::Const.DefaultChangeAttributes;
		}

		if (!this.m.IsOnDeserializing)
		{
			this.m.CustomPerkTree = ::Nggh_MagicConcept.PerkTreeBuilder.fillWithRandomPerk(this.m.CustomPerkTree, this.getContainer(), false, false, true);
		}

		local pT = ::Const.Perks.BuildCustomPerkTree(this.m.CustomPerkTree);
		this.m.PerkTree = pT.Tree;
		this.m.PerkTreeMap = pT.Map;
		local origin = ::World.Assets.getOrigin();

		if (origin != null)
		{
			origin.onBuildPerkTree(this);
		}

		return ::Const.DefaultChangeAttributes;
	}
	
	function onNewDay()
	{
		this.m.DayCount = ::Math.min(7, this.m.DayCount + 1);
		this.getContainer().getActor().improveMood(6.0, "Want an egg?");
		
		if (::World.getPlayerRoster().getSize() >= ::World.Assets.getBrothersMax() || this.m.DayCount < 7)
		{
			return;
		}
		
		local spider = ::World.getPlayerRoster().create("scripts/entity/tactical/player_beast/nggh_mod_spider_player");
		spider.improveMood(1.0, "Hatched a few minutes ago");
		spider.setStartValuesEx();
		spider.onHired();

		this.m.DayCount = 0;
	}
	
	function onCombatStarted()
	{
		local eggs = ::new("scripts/skills/eggs/nggh_mod_eggs_special");
		
		foreach (id in [
			"actives.spawn_spider",
			"actives.spawn_more_spider",
			"actives.add_egg"
		])
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
		this.m.IsOnDeserializing = true;
		this.character_background.onDeserialize(_in);
		this.m.DayCount = _in.readU8();
		//this.addPerk(::Const.Perks.PerkDefs.NggHEggAttachSpider, 3);
		this.m.IsOnDeserializing = false;
	}

});

