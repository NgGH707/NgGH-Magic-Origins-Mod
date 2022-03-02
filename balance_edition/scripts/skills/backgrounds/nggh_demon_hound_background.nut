this.nggh_demon_hound_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		ClassPerks = null
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.demon_hound";
		this.m.Name = "Höllenhund";
		this.m.Icon = "ui/backgrounds/background_undead_demon_hound.png";
		this.m.BackgroundDescription = "A corpse in varying forms of decay. While slow on the uptake, it makes for a frightning opponent to most. You can also pick any name you like!";
		this.m.GoodEnding = "There is no beginning or end for %name%. Like any feral animal they simply wander around - occasionally following hordes of like minded dead, being adopted by a new master and slain, only to get back up again and wander some more. %name% repeats this cycle until one day the blow will be fatal. Is this a curse of a blessing? To cheat death is such a manner many would kill for. But %name% does not care. There is only hunger.";
		this.m.BadEnding = "There is no beginning or end for %name%. Like any feral animal they simply wander around - occasionally following hordes of like minded dead, being adopted by a new master and slain, only to get back up again and wander some more. %name% repeats this cycle until one day the blow will be fatal. Is this a curse of a blessing? To cheat death is such a manner many would kill for. But %name% does not care. There is only hunger.";
		this.m.HiringCost = 0;
		this.m.DailyCost = 0;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.brave",
			"trait.bright",
			"trait.cocky",
			"trait.craven",
			"trait.dastard",
			"trait.deathwish",
			"trait.determined",
			"trait.disloyal",
			"trait.drunkard",
			"trait.dumb",
			"trait.fainthearted",
			"trait.fat",
			"trait.fear_undead",
			"trait.fear_greenskins",
			"trait.fear_beasts",
			"trait.fearless",
			"trait.eagle_eyes",
			"trait.greedy",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.hate_greenskins",
			"trait.insecure",
			"trait.iron_lungs",
			"trait.iron_jaw",
			"trait.irrational",
			"trait.loyal",
			"trait.night_owl",
			"trait.night_blind",
			"trait.optimist",
			"trait.paranoid",
			"trait.pessimist",
			"trait.spartan",
			"trait.superstitious",
			"trait.teamplayer",
			"trait.weasel",
			"trait.ambitious",
			"trait.fear_nobles",
			"trait.hate_nobles",
			"trait.flabby",
			"trait.steady_hands",
			"trait.talented",
			"trait.pragmatic",
			"trait.slack",
			"trait.sureshot",
			"trait.double_tongued",
			"trait.gift_of_people",
			"trait.seductive"
		];

		this.m.ExcludedTalents = [
			//this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue,
			this.Const.Attributes.Bravery,
			//this.Const.Attributes.Initiative,
			//this.Const.Attributes.MeleeSkill,
			this.Const.Attributes.RangedSkill,
			//this.Const.Attributes.MeleeDefense,
			//this.Const.Attributes.RangedDefense,
		];

		//apperance
		this.m.Faces = this.Const.Faces.AllWhiteMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		//---
		this.m.Names = this.Const.Strings.DemonHoundNames;
		this.m.BackgroundType = this.Const.BackgroundType.Combat | this.Const.BackgroundType.Outlaw;
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.Dreaded;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.Merciless;
		this.m.Modifiers.Stash = this.Const.LegendMod.ResourceModifiers.Stash[1];
		this.m.Modifiers.Hunting = this.Const.LegendMod.ResourceModifiers.Hunting[2];
		this.m.Modifiers.Terrain = [
			0.0, // ?
			0.0, //ocean
			0.1, //plains
			0.0, //swamp
			0.0, //hills
			0.1, //forest
			0.1, //forest
			0.1, //forest_leaves
			0.1, //autumn_forest
			0.0, //mountains
			0.0, // ?
			0.1, //farmland
			0.0, //snow
			0.0, //badlands
			0.0, //highlands
			0.0, //stepps
			0.0, //ocean
			0.0, //desert
			0.0 //oasis
		];
		this.m.CustomPerkTree = this.Const.PerksCharmedUnit.DemonHound;
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= 0.5;
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
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] Experience Gain"
			},
		];
		
		if (this.getContainer() == null || this.getContainer().getActor() == null)
		{
			return ret;
		}

		local actor = this.getContainer().getActor();
		ret.extend(this.Const.HexenOrigin.CharmedSlave.getTooltip(actor));
		ret.extend(this.getAttributesTooltip());
		return ret;
	}

	function onBuildDescription()
	{
		return "{Where %name% orginally comes from is a mystery - their orginal name has been lost to time or washed away on an ancient gravestone far, far away. | Who this creature one was matters little. They serve and obey. That is all that matters. | This one is marked with cuts and nail marks, and still surprisingly fresh. | Come rain, snow or sandstorm %name% happily goes where they please. A truely free soul in a world of toil and dispair. If the world had more people like %name%, it would be a much better place. | This one is marked with stab wounds and cuts across their whole body. Many of which seem ancient in origin. | %name% is marked with wounds, many of which are fatal but have been carefully stitched shut or cauterized - suggesting that at some point, someone cared for this poor fark after death. Who the caretaker was will forever be a mystery however. | This one seems a little older than most, with barely any forms of battle damage across its carcass. Maybe this one died in a peaceful manner? Such things are rare in this world. | This one bares little evidence of a violent death, save for the noose marks around its throat. | With the rampant war and famile across the land, corpses like %name% turn up in droves these days. Mass graves remain uncovered, graveyards barely watched over. Perfect marketplaces to hone the dark arts. | The war of many names created a treaure trove of unliving recruits for necromancers. %name% is one such product of the conflict, seeminly a little more astute and reactive to orders than the average corpse - not that expectations are set very high or anything... | This one was bound and thrown into a river, however the main cause of death seems to be the dozens of arrows pocked across its body. The work of poachers, bored brigands or a vengeful feud come to an end.}{ Don\'t let the exterior fool you, when fresh game is involved %name% acts with sudden alacrity unbecoming their form. | The presence of anything living will drive this animal into a frenzy, no matter the size. | This corpse also comes with a small satchel of rusted coins, which are going to waste in their current state. You are sure it won\'t miss them anyway... | %name% lazily swings a rusted shortsword around as they plod aimlessly. | %name% is a fitting name, don\'t you think? It captures the struggle of this creature well. | While undead, these creatures are more like wild animals than brutal killers. | You poke %name% on what remains of its arm. It turns to look at you, then moves past you to chase a stray dog. You like this one. | %name% is still covered in clods of earth, sand and what else. This also gives you an idea... | The lifeless stare still takes some getting used to. The harder you look the more it feels like something is still in there. Something still human...} {You wonder how long it would take to teach this corpse to best a knight in battle. On second thoughts you aren\'t sure if you have that much time. | A victim of violence, %name% seems eager to continue the cycle of suffering. Perfect. | While clumsy, this create will make a fine addition to any collector looking to bulk out their macabre hobby. | You get the impression %name% would\'ve been an interesting person to know when they were alive. Oh well. | A victim of murder, lyncing or witchcraft, maybe %name% was just in the wrong place at the wrong time? | %name% almost seems to enjoy their new existance in unlife. | After all, who needs tiring muscles, decent pay and moments of sheer panic? Not this one. | Weathered and beaten, this one will make a fine addition to the collection. | Sometimes you feel guilty to treat these creatures as personal servants.} {Despite everything, the body is willing and the flesh is weak. But you get the impression this won\'t be a problem. | You jokingly hand the corpse a contract, and it looks at the parchment with some familiarity... | While cheap labour, you really hope you don\'t need to scrub out any armour it might end up wearing. | You push %name% and it manages to stay standing, which is more impressive than it sounds by walking corpse standards. | But with sharp teeth like that, who needs weapons? | %name% drops to their knees and attempts to eat the critters crawling in the dirt. This will be a long and fruitful relationship. | If anything, %name% will make a decent pack mule for all the things you don\'t want to carry. | The poor thing looks hungry. | On second thought, maybe %name% isn\'t memorable enough. Surely you can do better...'}";
	}

	function buildPerkTree()
	{
		local a = {Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0]};
		
		if (this.m.PerkTree != null)
		{
			return a;
		}
		
		local isHumaniod = false;
		local hasAoE = false;
		local removeNimble = false;
		local origin = this.World.Assets.getOrigin();
		local helper = this.getroottable().PerkTreeBuilder;
		this.m.CustomPerkTree = helper.fillWithRandomPerk(this.m.CustomPerkTree, this.getContainer(), isHumaniod, hasAoE, removeNimble);

		if (origin != null)
		{
			this.World.Assets.getOrigin().onBuildPerkTree(this);
		}

		local pT = this.Const.Perks.BuildCustomPerkTree(this.m.CustomPerkTree);
		this.m.PerkTree = pT.Tree;
		this.m.PerkTreeMap = pT.Map;
		return a;
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [ // 100-125 hp
				50,
				65
			],
			Bravery = [ // 75-100 bra
				45,
				60
			],
			Stamina = [ // 90-100 bra
				0,
				0
			],
			MeleeSkill = [ // 50-57 melee
				3,
				0
			],
			RangedSkill = [ // 0-0 ranged
				-32,
				-42
			],
			MeleeDefense = [ // 5-12 mdef
				5,
				7
			],
			RangedDefense = [ // 5-18 rdef
				5,
				13
			],
			Initiative = [ // 95-105 ini
				-5,
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
	}

	function setAppearance(_tag = null)
	{
	}

	function addUniqueClassPerks()
	{
		if (this.m.ClassPerks != null) this.insertPerkGroup(this.m.ClassPerks);
	}

	function insertPerk( _perk, _row = 0, _index = 0, _isRefundable = true )
	{
		local perkDefObject = clone this.Const.Perks.PerkDefObjects[_perk];
        //Dont add dupes
        if (this.m.PerkTreeMap == null || perkDefObject.ID in this.m.PerkTreeMap)
        {
            return false;
        }

        perkDefObject.Row <- _row;
        perkDefObject.Unlocks <- _row;
        perkDefObject.IsRefundable <- _isRefundable;

        for (local i = this.getPerkTree().len(); i < _row + 1; i = ++i)
        {
            this.getPerkTree().push([]);
        }
        this.getPerkTree()[_row].insert(_index, perkDefObject);
		this.m.CustomPerkTree[_row].insert(_index, _perk);
        this.m.PerkTreeMap[perkDefObject.ID] <- perkDefObject;
        return true;
	}

	function insertPerkGroup(_Tree, _index = 0) 
	{
		foreach(row, arrAdd in _Tree)
		{
			foreach (perkAdd in arrAdd)
			{
				this.insertPerk(perkAdd, row, _index);
			}
		}
	}
});

