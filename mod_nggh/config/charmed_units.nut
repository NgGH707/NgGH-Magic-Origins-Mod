
if (!("CharmedUnits" in ::Const))
	::Const.CharmedUnits <- {};

//Database of default entries (Legends version)
::Const.CharmedUnits <- {
	// Default database
	Data = [],

	// Database for new entries registered by ::nggh_registerCharmedEntries(_array)
	CustomEntries = [],

	// Database of all background icon directories, used to confirm if a background icon exists or not
	BackgroundIcons = [],

	function getIndex( _index )
	{
		if (_index < 0 || _index > this.Data.len() - 1)
			return null;

		return _index;
	}

	function getData( _type )
	{
		local find = this.getIndex(_type);

		if (find != null)
			return this.Data[find];

		find = ::nggh_findThisInArray(_type, this.CustomEntries, "Type");
		return find != null ? this.CustomEntries[find] : null;
	}

	function getBackgroundIcon( _type )
	{
		local find = ::nggh_findThisInArray(_type, this.CustomEntries, "Type");

		if (find != null && this.CustomEntries[find].rawin("Icon"))
			return this.CustomEntries[find].Icon;

		find = this.getIndex(_type);

		if (find != null && ::isThisBackgroundIconExist("background_charmed_" + _type + ".png"))
			return "background_charmed_" + _type + ".png";

		return "background_charmed_unknown.png";
	}

	function addBasicData( _data , _entity = null )
	{
		if (typeof _data != "table" || !("Type" in _data))
			return _data;

		local isHuman = _entity != null ? _entity.getFlags().has("human") : this.isHuman(_data.Type);

		if (!("Script" in _data))
			_data.Script <- this.getScript(_data.Type);

		if (!("Background" in _data))
			_data.Background <- this.getBackground(_data.Type);

		if (!("Requirements" in _data))
			_data.Requirements <- this.getRequirements(_data.Type, isHuman);

		if (!("IsHuman" in _data))
			_data.IsHuman <- isHuman;

		return _data;
	}

	function addAdditionalData( _data , _entity = null )
	{
		if (typeof _data != "table" || !("Type" in _data))
			return _data;

		if (("Entity" in _data) && ::MSU.isNull(_entity))
			_entity = _data.Entity;
		else if (!::MSU.isNull(_entity))
			_data.Entity = _entity;

		if (!("IsMiniboss" in _data))
			_data.IsMiniboss <- _entity == null ? false : _entity.getSkills().hasSkill("racial.champion");

		if (!("Custom" in _data))
			_data.Custom <- this.getCustom(_data.Type);

		if (::MSU.isNull(_entity))
			return _data;

		if (!("Items" in _data))
			_data.Items <- _entity.getItems();

		if (!("Stats" in _data))
			_data.Stats <- _entity.getBaseProperties();

		if (!("Appearance" in _data))
			_data.Appearance <- this.getAppearance(_entity);

		return _data;
	}

	function isHuman( _type )
	{
		return this.getScript(_type) == "player";
	}

	function isKeyExist( _key, _data )
	{
		return _data != null && _data.rawin(_key) && _data[_key] != null;
	}

	function getDataByKey( _type, _key, _defaultReturnValue = null )
	{
		local database = this.getData(_type);

		if (!this.isKeyExist(_key, database))
			return _defaultReturnValue;

		switch(typeof database[_key])
		{
		case "table":
		case "array":
			return ::nggh_deepCopy(database[_key]);

		default:
			return database[_key];
		}
	}

	function getScript( _type )
	{
		return this.getDataByKey(_type, "Script", "player");
	}

	function getRequirements( _type , _isFindingHuman = false )
	{
		return this.getDataByKey(_type, "Requirements", _isFindingHuman ? [] : null);
	}
	
	function getStatMod( _type )
	{
		return this.getDataByKey(_type, "StatMod", { Hitpoints = [-5, -5], Bravery = [-5, -5], Stamina = [-5, -5], MeleeSkill = [-5, -5], RangedSkill = [-5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-5, -5] });
	}

	function getBackground( _type )
	{
		return this.isHuman(_type) ? this.getDataByKey(_type, "Background") : null;
	}
	
	function getPerks( _type )
	{
		return this.getDataByKey(_type, "Perks", []);
	}

	function getSkills( _type )
	{
		return this.getDataByKey(_type, "Skills", []);
	}

	function getCustom( _type )
	{
		return this.getDataByKey(_type, "Custom", {});
	}
	
	function getDifficulty( _type )
	{
		return this.getDataByKey(_type, "Difficulty", 0);
	}
	
	function getPerkTree( _type )
	{
		local perkTreeName = this.getDataByKey(_type, "PerkTree");
		return perkTreeName != null && (perkTreeName in ::Const.PerksCharmedUnit) ? ::nggh_deepCopy(::Const.PerksCharmedUnit[perkTreeName]) : null;
	}

	function getNames( _type )
	{
		local key = this.getDataByKey(_type, "Names");
		return key != null && (key in ::Const.Strings) ? ::nggh_deepCopy(::Const.Strings[key]) : null;
	}

	function getEntityType( _type )
	{
		foreach (k, value in ::Const.EntityType)
		{
			if (typeof value == "integer" && value == _type)
				return k;
		}

		return "NULL";
	}
	
	function getAppearance( _entity )
	{
		local ret = [];
		::logInfo(format("Identifying charmed target: %s - %s - %s", _entity.ClassName, this.getEntityType(_entity.getType()), ::Const.Strings.EntityName[_entity.getType()]));
		::logInfo("Processing sprites need to be copied...");
		foreach (id in ::Const.CharmedUtilities.SpritesToClone)
		{
		    if (!_entity.hasSprite(id))
		    	continue;

		    ret.push(id);
		    ::logInfo("Sprite " + ret.len() + ": " + id);
		}

		return ret;
	}
	
	function addDefaultEntry( _index, _data )
	{
		if (_index >= this.Data.len()) {
			_data.Type <- _index;
			this.CustomEntries.push(_data);
			return;
		}

		this.Data[_index] = _data;
	}

};

local prefix = "gfx/ui/backgrounds/";
foreach (directory in ::IO.enumerateFiles(prefix))
{
	::Const.CharmedUnits.BackgroundIcons.push(directory.slice(prefix.len()) + ".png");
}

::isThisBackgroundIconExist <- function( _directory )
{
	local find = _directory.find("backgrounds/");

	if (find != null)
		_directory = _directory.slice(find, 12);

	return ::Const.CharmedUnits.BackgroundIcons.find(_directory) != null;
};

// fill slots
for (local i = 0; i < ::Const.EntityIcon.len(); ++i)
{
	::Const.CharmedUnits.Data.push({});
}

//Necromancer = 0,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Necromancer, {
	StatMod = { Hitpoints = [0, 0], Bravery = [-10, -20], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Skills = [],
	Perks = ["LegendRaiseUndead"],
	Requirements = ["NggHCharmWords"],
	Background = "legend_necromancer_background",
	Difficulty = 33,

	function onBuildPerkTree() {
		addPerkGroup(::Const.Perks[::MSU.Array.rand(["ZombieMagicTree", "SkeletonMagicTree", "VampireMagicTree"])].Tree);
	}

});

//Zombie = 1,

//ZombieYeoman = 2,

//ZombieKnight = 3,

//ZombieBoss = 4,

//SkeletonLight = 5,
		
//SkeletonMedium = 6,
		
//SkeletonHeavy = 7,
		
//SkeletonPriest = 8,
		
//SkeletonBoss = 9,
		
//Vampire = 10,
		
//Ghost = 11,

//Ghoul = 12,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Ghoul, {
	StatMod = { Hitpoints = [0, 0], Bravery = [-10, -5], Stamina = [0, 0], MeleeSkill = [-5, -5], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-25, -25] },
	Skills = ["actives/ghoul_claws", "actives/swallow_whole_skill"],
	Requirements = ["NggHCharmEnemyGhoul"],
	Script = "player_beast/nggh_mod_ghoul_player",
	PerkTree = "NachoTree", 
	Difficulty = 15,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 8, Stash = 9, Healing = 0.0, Injury = 0.0, Repair = 0.1, Salvage = 0.1, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.1, Gathering = 0.2, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [5,7],
		Names = "NachoNames",
	},

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		_playerEntity.setVariant(_enemyEntity.m.Head);
		_playerEntity.getFlags().set("has_eaten", true);
		_playerEntity.getFlags().set("Type", m.CharmID);
		for (local i = 0; i < ::Math.max(0, _enemyEntity.getSize() - 1); ++i) {
			_playerEntity.grow(true);
		}
	}

	function onSetup() {
		if (!::Tactical.isActive() && m.TempData != null && m.TempData.IsMiniboss)
			grow(true); // UwU champion nacho is always a big bear boi
	}

	function addTooltip( _tooltips ) {
		if (getContainer().getActor().getSize() > 1) {
			_tooltips.push({
				id = 10,
				type = "text",
				icon = "ui/icons/asset_food.png",
				text = "Needs to eat a [color=" + ::Const.UI.Color.NegativeValue + "]corpse[/color] every battle or will shrink in size"
			})
		}
	}

});

//OrcYoung = 13,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.OrcYoung, {
	StatMod = { Hitpoints = [-25, -15], Bravery = [-5, -5], Stamina = [-10, -10], MeleeSkill = [-2, -2], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-10, -10] },
	Skills = ["actives/charge"],
	Requirements = [],
	Script = "nggh_mod_player_orc",
	PerkTree = "OrcYoung", 
	Difficulty = 10,

	Custom =  {
		BgModifiers = {
			Ammo = 13, ArmorParts = 5, Meds = 8, Stash = 10, Healing = 0.0, Injury = 0.0, Repair = 0.05, Salvage = 0.1, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.05, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [7],
		Names = "OrcNames",
	},

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		if (::Math.rand(1, 100) <= 15) m.Titles.push("the Young");
	}

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
	}

});

//OrcBerserker = 14,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.OrcBerserker, {
	StatMod = { Hitpoints = [-75, -55], Bravery = [-35, -25], Stamina = [-40, -40], MeleeSkill = [-10, -10], RangedSkill = [5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-25, -15] },
	Skills = ["effects/berserker_rage_effect", "actives/charge"],
	Perks = ["LegendComposure"],
	Requirements = ["NggHCharmEnemyOrk"],
	Script = "nggh_mod_player_orc",
	PerkTree = "OrcBerserker", 
	Difficulty = 35,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 10, Meds = 5, Stash = 15, Healing = 0.05, Injury = 0.05, Repair = 0.0, Salvage = 0.1, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.1, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [5,7],
		Names = "OrcNames",
	},

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Titles.extend(::Const.Strings.BarbarianTitles);
	}

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			if (m.TempData != null && m.TempData.IsMiniboss) addPerkGroup(::Const.Perks.WildlingProfessionTree.Tree);

			addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
		} 

		addPerkGroup(::Const.Perks.ViciousTree.Tree);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] == 0) _talents[::Const.Attributes.MeleeSkill] = 1;
	}

});

//OrcWarrior = 15,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.OrcWarrior, {
	StatMod = { Hitpoints = [-50, -50], Bravery = [-15, -10], Stamina = [-80, -80], MeleeSkill = [-10, -10], RangedSkill = [0, 0], MeleeDefense = [-3, -3], RangedDefense = [-5, -5], Initiative = [-15, -10] },
	Skills = ["actives/line_breaker"],
	Perks = ["LegendComposure", "Stalwart", "ShieldBash"],
	Requirements = ["NggHCharmEnemyOrk"],
	Script = "nggh_mod_player_orc",
	PerkTree = "OrcWarrior", 
	Difficulty = 25,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 10, Meds = 8, Stash = 15, Healing = 0.0, Injury = 0.0, Repair = 0.05, Salvage = 0.1, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.1, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [3,5,7],
		Names = "OrcNames",
	},
	
	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);

		addPerkGroup(::Const.Perks.IndestructibleTree.Tree);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeDefense] < 3) _talents[::Const.Attributes.MeleeDefense] += 1;
	}

});

//OrcWarlord = 16,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.OrcWarlord, {
	StatMod = { Hitpoints = [-90, -65], Bravery = [-35, -25], Stamina = [-110, -110], MeleeSkill = [-15, -9], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-5, -5] },
	Skills = ["actives/warcry", "actives/line_breaker", "perks/perk_captain"],
	Perks = ["LegendComposure", "Stalwart", "ShieldBash"],
	Requirements = ["NggHCharmEnemyOrk", "NggHCharmSpec"],
	Script = "nggh_mod_player_orc",
	PerkTree = "OrcWarlord", 
	Difficulty = 25,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 15, Meds = 10, Stash = 20, Healing = 0.05, Injury = 0.0, Repair = 0.0, Salvage = 0.2, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.1, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [3,5,7],
		Names = "OrcWarlordNames",
	},

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			if (::Math.rand(1, 100) <= 50) addPerkGroup(::Const.Perks.TacticianClassTree.Tree);

			addPerkGroup(::Const.Perks.SergeantClassTree.Tree);
			addPerkGroup(::Const.Perks.SoldierProfessionTree.Tree);
			addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
		}
		else {
			addPerkGroup(::Const.Perks.InspirationalTree.Tree);
			addPerkGroup(::Const.Perks.IndestructibleTree.Tree);
		}
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.Bravery] < 3) _talents[::Const.Attributes.Bravery] += 1;
		if (_talents[::Const.Attributes.MeleeSkill] == 0) _talents[::Const.Attributes.MeleeSkill] += 1;
		if (_talents[::Const.Attributes.MeleeDefense] == 0) _talents[::Const.Attributes.MeleeDefense] += 1;
	}

});

//Militia = 17,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Militia, {
	StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
	Background = "militia_background",
	Difficulty = -5,

});

//MilitiaRanged = 18,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.MilitiaRanged, {
	StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
	Background = "poacher_background",
	Difficulty = -5,

});

//MilitiaVeteran = 19,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.MilitiaVeteran, {
	StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
	Perks = ["LegendSpecialistMilitiaSkill"],
	Background = "retired_soldier_background",
	Difficulty = 0,

});

//MilitiaCaptain = 20,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.MilitiaCaptain, {
	StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
	Skills = ["perks/perk_captain"],
	Perks = ["LegendSpecialistMilitiaSkill"],
	Background = "retired_soldier_background",
	Difficulty = 10,

});

//BountyHunter = 21,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BountyHunter, {
	StatMod = { Hitpoints = [-25, -10], Bravery = [-20, -15], Stamina = [-5, -5], MeleeSkill = [-12, -8], RangedSkill = [-5, 0], MeleeDefense = [-8, -5], RangedDefense = [-5, 0], Initiative = [0, 0] },
	Perks = ["Rotation", "Footwork"],
	Requirements = ["NggHCharmWords"],
	Background = "sellsword_background",
	Difficulty = 15,

});

//Peasant = 22,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Peasant, {
	StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
	Background = "farmhand_background",
	Difficulty = -25,

});

//CaravanHand = 23,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.CaravanHand, {
	StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
	Background = "caravan_hand_background",
	Difficulty = 0,

});

//CaravanGuard = 24,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.CaravanGuard, {
	StatMod = { Hitpoints = [-12, -10], Bravery = [-15, -12], Stamina = [-25, -20], MeleeSkill = [-10, -8], RangedSkill = [0, 0], MeleeDefense = [-2, 0], RangedDefense = [-2, 0], Initiative = [-10, 0] },
	Perks = ["Recover"],
	Background = "sellsword_background",
	Difficulty = 10,
	Custom = {ID = "background.caravan_hand"},

});

//CaravanDonkey = 25,

//Footman = 26,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Footman, {
	StatMod = { Hitpoints = [-7, -15], Bravery = [-10, -10], Stamina = [-10, -10], MeleeSkill = [-8, -8], RangedSkill = [-5, -5], MeleeDefense = [0, -5], RangedDefense = [0, -3], Initiative = [-10, -10] },
	Perks = ["Rotation"],
	Background = "legend_noble_shield",
	Difficulty = 10,

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeDefense] < 2) _talents[::Const.Attributes.MeleeDefense] += 1;
	}

});

//Greatsword = 27,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Greatsword, {
	StatMod = { Hitpoints = [-25, -25], Bravery = [-15, -10], Stamina = [-15, -10], MeleeSkill = [-8, -8], RangedSkill = [0, 0], MeleeDefense = [-10, -5], RangedDefense = [0, 0], Initiative = [-5, 0] },
	Perks = ["Rotation", "LoneWolf"],
	Requirements = ["NggHCharmWords"],
	Background = "legend_noble_2h",
	Difficulty = 30,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.TwoHandedTree.Tree);

		addPerkGroup(::Const.Perks.GreatSwordTree.Tree);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 3) _talents[::Const.Attributes.MeleeSkill] += 1;
	}

});

//Billman = 28,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Billman, {
	StatMod = { Hitpoints = [-15, -15], Bravery = [-10, -10], Stamina = [-10, -10], MeleeSkill = [-8, -8], RangedSkill = [-5, -5], MeleeDefense = [0, -5], RangedDefense = [0, -3], Initiative = [-2, 0] },
	Perks = ["Rotation", "Backstabber"],
	Background = "beast_hunter_background",
	Difficulty = 10,
	Custom = {ID = "background.legend_noble_shield"},

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] == 0) _talents[::Const.Attributes.MeleeSkill] += 1;
	}

});

//Arbalester = 29,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Arbalester, {
	StatMod = { Hitpoints = [-12, -7], Bravery = [-10, -10], Stamina = [-10, -10], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [-2, -1], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = ["Rotation"],
	Background = "legend_noble_ranged",
	Difficulty = 10,

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.RangedSkill] < 2) _talents[::Const.Attributes.RangedSkill] += 1;
	}

});

//StandardBearer = 30,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.StandardBearer, {
	StatMod = { Hitpoints = [-20, -15], Bravery = [-12, -10], Stamina = [-30, -15], MeleeSkill = [-5, -5], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-5, -5] },
	Skills = ["perks/perk_captain"],
	Perks = ["Rotation", "InspiringPresence"],
	Requirements = ["NggHCharmWords"],
	Background = "legend_noble_event_background",
	Difficulty = 35,
	Custom = {ID = "background.legend_man_at_arms"},

	function onBuildPerkTree() {
		addPerkGroup(::Const.Perks.InspirationalTree.Tree);
	}

	function onfillTalentsValues( _talents ) {
		_talents[::Const.Attributes.Bravery] = 3;
	}

});

//Sergeant = 31,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Sergeant, {
	StatMod = { Hitpoints = [-30, -30], Bravery = [-20, -10], Stamina = [-15, -10], MeleeSkill = [-15, -10], RangedSkill = [0, 0], MeleeDefense = [-10, -7], RangedDefense = [0, 0], Initiative = [-15, -10] },
	Perks = ["Rotation", "Duelist", "RallyTheTroops"],
	Requirements = ["NggHCharmWords"],
	Background = "legend_noble_background",
	Difficulty = 45,

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		_playerEntity.setTitle("the Sergeant");
	}

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.SergeantClassTree.Tree);
			addPerkGroup(::Const.Perks.SoldierProfessionTree.Tree);
		}
		else {
			addPerkGroup(::Const.Perks.InspirationalTree.Tree);
			addPerkGroup(::Const.Perks.IndestructibleTree.Tree);
		}
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 2) _talents[::Const.Attributes.MeleeSkill] += 1;
		if (_talents[::Const.Attributes.Bravery] < 2) _talents[::Const.Attributes.Bravery] += 1;
	}

});

//Knight = 32,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Knight, {
	StatMod = { Hitpoints = [-35, -35], Bravery = [-25, -15], Stamina = [-20, -15], MeleeSkill = [-20, -20], RangedSkill = [0, 0], MeleeDefense = [-10, -7], RangedDefense = [0, 5], Initiative = [0, 5] },
	Skills = ["perks/perk_captain"],
	Perks = ["Rotation", "Brawny"],
	Requirements = ["NggHCharmWords"],
	Background = "hedge_knight_background",
	Difficulty = 45,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.TacticianClassTree.Tree);
			addPerkGroup(::Const.Perks.SoldierProfessionTree.Tree);
		}
		else {
			addPerkGroup(::Const.Perks.InspirationalTree.Tree);
			addPerkGroup(::Const.Perks.MartyrTree.Tree);
		}
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 3) _talents[::Const.Attributes.MeleeSkill] += 1;
		if (_talents[::Const.Attributes.MeleeDefense] < 3) _talents[::Const.Attributes.MeleeDefense] += 1;
	}

});

//MilitaryDonkey = 33,

//BanditThug = 34,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BanditThug, {
	StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
	Background = "beggar_background",
	Difficulty = -2,
});

//BanditPoacher = 35,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BanditPoacher, {
	StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
	Background = "poacher_background",
	Difficulty = -3,
});

//BanditMarksman = 36,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BanditMarksman, {
	StatMod = { Hitpoints = [-5, -5], Bravery = [-5, -5], Stamina = [-5, 0], MeleeSkill = [-2, 2], RangedSkill = [-5, 2], MeleeDefense = [0, 0], RangedDefense = [-2, 2], Initiative = [0, 0] },
	Background = "hunter_background",
	Difficulty = 5,
});

//BanditRaider = 37,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BanditRaider, {
	StatMod = { Hitpoints = [-15, -15], Bravery = [-20, -15], Stamina = [-25, -15], MeleeSkill = [-8, -5], RangedSkill = [-5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-15, -5] },
	Background = "raider_background",
	Difficulty = 5,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
	}

});

//BanditLeader = 38,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BanditLeader, {
	StatMod = { Hitpoints = [-30, -30], Bravery = [-30, -30], Stamina = [-30, -25], MeleeSkill = [-13, -10], RangedSkill = [-10, -8], MeleeDefense = [-15, -8], RangedDefense = [-8, -5], Initiative = [-20, -15] },
	Skills = ["perks/perk_captain"],
	Perks = ["NineLives"],
	Requirements = ["NggHCharmWords"],
	Background = "orc_slayer_background",
	Difficulty = 15,
	Custom = {ID = "background.raider"},

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			if (::Math.rand(1, 100) <= 33) addPerkGroup(::Const.Perks.TacticianClassTree.Tree);

			addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
		} 
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 3) _talents[::Const.Attributes.MeleeSkill] += 1;
	}

});

//GoblinAmbusher = 39,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.GoblinAmbusher, {
	StatMod = { Hitpoints = [0, 0], Bravery = [-11, -10], Stamina = [-10, 0], MeleeSkill = [-7, -5], RangedSkill = [-12, -9], MeleeDefense = [-5, -3], RangedDefense = [-10, -5], Initiative = [-32, -29] },
	Skills = ["racial/goblin_ambusher_racial"],
	Perks = ["QuickHands"],
	Requirements = [],
	Script = "nggh_mod_player_goblin",
	PerkTree = "GoblinAmbusher",
	Difficulty = 10,

	Custom = {
		BgModifiers = {
			Ammo = 20, ArmorParts = 3, Meds = 5, Stash = 0, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.1, Scout = 0.2, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [0,1],
		ID = "background.hunter",
		Names = "GoblinNames",
	},

	function onBuildPerkTree() {
		if (::Math.rand(1, 100) <= 50) addPerk(::Const.Perks.PerkDefs.LegendBigGameHunter, 6);
		if (::Math.rand(1, 100) <= 25) addPerkGroup(::Const.Perks.NggH_GoblinMountTree.Tree);
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		if (::Math.rand(1, 100) <= 40) m.Titles.extend(::Const.Strings.GoblinTitles);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.RangedSkill] < 3) _talents[::Const.Attributes.RangedSkill] += 1;
	}

});

//GoblinFighter = 40,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.GoblinFighter, {
	StatMod = { Hitpoints = [0, 0], Bravery = [-14, -15], Stamina = [-5, -5], MeleeSkill = [-12, -15], RangedSkill = [-12, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-32, -29] },
	Perks = ["Backstabber"],
	Requirements = [],
	Script = "nggh_mod_player_goblin",
	PerkTree = "GoblinFighter",
	Difficulty = 10,

	Custom = {
		BgModifiers = {
			Ammo = 10, ArmorParts = 5, Meds = 5, Stash = 3, Healing = 0.0, Injury = 0.0, Repair = 0.1, Salvage = 0.0, Crafting = 0.075, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.2, Gathering = 0.05, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [0,1,2],
		ID = "background.raider",
		Names = "GoblinNames",
	},

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
		if (::Math.rand(1, 100) <= 33) addPerk(::Const.Perks.PerkDefs.LegendBigGameHunter, 6);
		if (::Math.rand(1, 100) <= 33) addPerkGroup(::Const.Perks.NggH_GoblinMountTree.Tree);
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		if (::Math.rand(1, 100) <= 40) m.Titles.extend(::Const.Strings.GoblinTitles);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 3 && _talents[::Const.Attributes.MeleeSkill] > 0) _talents[::Const.Attributes.MeleeSkill] += 1;
	}

});

//GoblinLeader = 41,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.GoblinLeader, {
	StatMod = { Hitpoints = [0, 0], Bravery = [-5, 0], Stamina = [-20, -20], MeleeSkill = [-17, -15], RangedSkill = [-15, -14], MeleeDefense = [-5, -5], RangedDefense = [-10, -10], Initiative = [-25, -23] },
	Skills = ["perks/perk_captain", "actives/goblin_whip"],
	Perks = ["LegendBackToBasics"],
	Requirements = ["NggHCharmEnemyGoblin"],
	Script = "nggh_mod_player_goblin",
	PerkTree = "GoblinLeader",
	Difficulty = 30,

	Custom =  {
		BgModifiers = {
			Ammo = 25, ArmorParts = 8, Meds = 10, Stash = 3, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.1, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.2, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [2],
		Names = "GoblinNames",
	},

	function onBuildPerkTree() {
		if (::Math.rand(1, 100) <= 25) addPerkGroup(::Const.Perks.NggH_GoblinMountTree.Tree);
		if (!::Is_PTR_Exist) return;
		addPerkGroup(::Const.Perks.TacticianClassTree.Tree);
		addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Titles.extend(::Const.Strings.GoblinTitles);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 3) _talents[::Const.Attributes.MeleeSkill] += 1;
		if (_talents[::Const.Attributes.RangedSkill] < 3) _talents[::Const.Attributes.RangedSkill] += 1;
	}

});

//GoblinShaman = 42,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.GoblinShaman, {
	StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [-2, 0], RangedSkill = [-2, 0], MeleeDefense = [-5, -5], RangedDefense = [-10, -10], Initiative = [-25, -20] },
	Skills = ["racial/goblin_shaman_racial", "actives/root_skill", "actives/insects_skill", "actives/grant_night_vision_skill"],
	Requirements = ["NggHCharmEnemyGoblin"],
	Script = "nggh_mod_player_goblin",
	PerkTree = "GoblinShaman",
	Difficulty = 45,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 25, Stash = 0, Healing = 0.25, Injury = 0.25, Repair = 0.0, Salvage = 0.0, Crafting = 0.1, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.0, Gathering = 0.1, Training = 0.0, Enchanting = 0.4,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [2,6,7],
		Names = "GoblinNames",
	},

	function onBuildPerkTree() {
		if (::Math.rand(1, 100) <= 20) addPerkGroup(::Const.Perks.NggH_GoblinMountTree.Tree);
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		if (::Math.rand(1, 100) <= 50) this.m.Titles.push(["the Shaman", "the Elder"]);
	}

});

//GoblinWolfrider = 43,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.GoblinWolfrider, {
	StatMod = { Hitpoints = [-20, -20], Bravery = [-15, -15], Stamina = [-55, -55], MeleeSkill = [-13, -13], RangedSkill = [-1, 1], MeleeDefense = [0, 0], RangedDefense = [-5, -5], Initiative = [-23, -27] },
	Perks = ["NggHGoblinMountTraining", "QuickHands"],
	Requirements = [],
	Script = "nggh_mod_player_goblin",
	PerkTree = "GoblinWolfrider",
	Difficulty = 12,

	Custom = {
		BgModifiers = {
			Ammo = 10, ArmorParts = 15, Meds = 0, Stash = 3, Healing = 0.0, Injury = 0.0, Repair = 0.15, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.3, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.05, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [1,7],
		ID = "background.raider",
		Names = "GoblinNames",
	},

	function onBuildAttributes( _properties ) {
		_properties.ActionPoints = 9;
	}

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
		if (::Math.rand(1, 100) <= 25) addPerk(::Const.Perks.PerkDefs.LegendBigGameHunter, 6);
		
		addPerkGroup(::Const.Perks.NggH_GoblinMountTree.Tree);
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		if (::Math.rand(1, 100) <= 50) m.Titles.extend(::Const.Strings.GoblinTitles);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeDefense] < 3 && _talents[::Const.Attributes.MeleeDefense] > 0) _talents[::Const.Attributes.MeleeSkill] += 1;
	}

	function onAddEquipment() {
		getContainer().getActor().getItems().equip(::new("scripts/items/accessory/wolf_item"));
	}

});

//Wolf = 44,
		
//Wardog = 45,
	
//ArmoredWardog = 46,

//Mercenary = 47,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Mercenary, {
	StatMod = { Hitpoints = [-35, -25], Bravery = [-20, -10], Stamina = [-25, -20], MeleeSkill = [-13, -8], RangedSkill = [-10, -5], MeleeDefense = [-8, -5], RangedDefense = [-10, 0], Initiative = [-20, -10] },
	Perks = ["Overwhelm"],
	Requirements = ["NggHCharmWords"],
	Background = "sellsword_background",
	Difficulty = 10,

	function onfillTalentsValues( _talents ) {
		if (::Math.rand(1, 100) <= 50) {
			if (_talents[::Const.Attributes.MeleeSkill] < 2) _talents[::Const.Attributes.MeleeSkill] += 1;
		}
		else {
			if (_talents[::Const.Attributes.MeleeDefense] < 2) _talents[::Const.Attributes.MeleeDefense] += 1;
		}
	}

});

//MercenaryRanged = 48,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.MercenaryRanged, {
	StatMod = { Hitpoints = [-10, -10], Bravery = [-20, -10], Stamina = [-20, -20], MeleeSkill = [-10, -10], RangedSkill = [0, 0], MeleeDefense = [-2, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = ["Overwhelm", "Footwork"],
	Requirements = ["NggHCharmWords"],
	Background = "sellsword_background",
	Difficulty = 12,
	Custom =  {ExcludedTalents = [4, 6]}

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.RangedTree.Tree);

		addPerkGroup(::Const.Perks.CrossbowTree.Tree);
		addPerkGroup(::Const.Perks.BowTree.Tree);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.RangedSkill] < 2) _talents[::Const.Attributes.RangedSkill] += 1;
	}

});

//Swordmaster = 49,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Swordmaster, {
	StatMod = { Hitpoints = [-30, -20], Bravery = [-30, -20], Stamina = [-15, -15], MeleeSkill = [-25, -15], RangedSkill = [-10, -10], MeleeDefense = [-35, -30], RangedDefense = [-15, -10], Initiative = [-5, -5] },
	Perks = ["Duelist", "SpecSword", "LegendSpecGreatSword"],
	Requirements = ["NggHCharmAppearance"],
	Background = "swordmaster_background",
	Difficulty = 75,
	Custom =  {ExcludedTalents = [0,5,7]}

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.SwordmasterProfessionTree.Tree);
			addPerkGroup(::Const.Perks.OneHandedTree.Tree);
			addPerkGroup(::Const.Perks.TwoHandedTree.Tree);
			addPerk(::Const.Perks.PerkDefs.BFFencer, 6);
		} 
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Titles = [];
		m.Titles.extend(::Const.Strings.SwordmasterTitles);
	}

	function onfillTalentsValues( _talents ) {
		_talents[::Const.Attributes.MeleeSkill] = 3;
	}
});

//HedgeKnight = 50,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.HedgeKnight, {
	StatMod = { Hitpoints = [-50, -30], Bravery = [-30, -20], Stamina = [-15, -15], MeleeSkill = [-25, -25], RangedSkill = [0, 0], MeleeDefense = [-15, -10], RangedDefense = [-12, -8], Initiative = [-15, -5] },
	Perks = ["DevastatingStrikes", "SteelBrow", "Brawny"],
	Requirements = ["NggHCharmAppearance"],
	Background = "hedge_knight_background",
	Difficulty = 60,
	Custom =  {ExcludedTalents = [3,5,7]},

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.SoldierProfessionTree.Tree);
			addPerkGroup(::Const.Perks.TwoHandedTree.Tree);
			addPerk(::Const.Perks.PerkDefs.PTRManOfSteel, 6);
		} 
		
		addPerkGroup(::Const.Perks.IndestructibleTree.Tree);
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Titles = [];
		m.Titles.extend(::Const.Strings.HedgeKnightTitles);
	}

	function onfillTalentsValues( _talents ) {
		_talents[::Const.Attributes.Hitpoints] = 3;
	}

});

//MasterArcher = 51,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.MasterArcher, {
	StatMod = { Hitpoints = [-20, -15], Bravery = [-10, 0], Stamina = [-15, -15], MeleeSkill = [-5, -5], RangedSkill = [-15, -5], MeleeDefense = [-5, -5], RangedDefense = [0, 0], Initiative = [-25, -10] },
	Perks = ["Bullseye", "QuickHands", "SpecCrossbow", "SpecBow"],
	Requirements = ["NggHCharmAppearance"],
	Background = "legend_master_archer_background",
	Difficulty = 70,
	Custom =  {ExcludedTalents = [3,4]},

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerk(::Const.Perks.PerkDefs.PTRMarksmanship, 6);
		
		addPerkGroup(::Const.Perks.FastTree.Tree);
		addPerk(::Const.Perks.PerkDefs.LegendBigGameHunter, 6);
	}

	function onfillTalentsValues( _talents ) {
		_talents[::Const.Attributes.RangedSkill] = 3;
	}

});

//GreenskinCatapult = 52,

//Cultist = 53,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Cultist, {
	StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = ["Nimble", "Backstabber"],
	Background = "cultist_background",
	Difficulty = 33,
});

//Direwolf = 54,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Direwolf, {
	StatMod = { Hitpoints = [-30, 0], Bravery = [-5, -5], Stamina = [-30, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [4, 6], RangedDefense = [1, 2], Initiative = [-15, 0] },
	Requirements = ["NggHCharmEnemyDirewolf"],
	Script = "player_beast/nggh_mod_direwolf_player",
	PerkTree = "WolfTree", 
	Difficulty = 25,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 3, Meds = 0, Stash = 6, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.3, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [2, 5],
		Names = "WolfNames",
	},

	function onBuildPerkTree() {
		if (::Math.rand(1, 100) <= 50) addPerk(::Const.Perks.PerkDefs.Dodge, 1);

		addPerk(::Const.Perks.PerkDefs.Nimble, 4);
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		if (_enemyEntity.getSprite("head_frenzy").HasBrush) {
			_playerEntity.getSprite("head_frenzy").setBrush(_playerEntity.getSprite("head").getBrush().Name + "_frenzy");
			_playerEntity.getFlags().add("frenzy");
			return;
		}
		
		addPerk(::Const.Perks.PerkDefs.NggHWolfRabies, 6);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 2) _talents[::Const.Attributes.MeleeSkill] += 1;
	}

	function onUpdate( _properties ) {
		_properties.MovementFatigueCostMult *= 0.67;
	}

	function addTooltip( _tooltips ) {
		_tooltips.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Builds up [color=" + ::Const.UI.Color.PositiveValue + "]33%[/color] less fatigue for each tile travelled"
		});
	}

});

//Lindwurm = 55,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Lindwurm, {
	StatMod = { Hitpoints = [-300, -300], Bravery = [-50, -50], Stamina = [-225, -200], MeleeSkill = [-10, -5], RangedSkill = [5, -5], MeleeDefense = [-3, -3], RangedDefense = [-3, -3], Initiative = [-10, -5] },
	Requirements = ["NggHCharmEnemyLindwurm"],
	Script = "player_beast/nggh_mod_lindwurm_player",
	PerkTree = "LindwurmTree", 
	Difficulty = 10,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 15, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.2, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [3,5,7],
		Names = "LindwurmNames",
	},

	function onBuildAttributes( _properties ) {
		// a bit bias for the green scalie, especially the alpha one OwO
		if (m.TempData != null && m.TempData.IsMiniboss && _properties.ActionPoints < 8) _properties.ActionPoints += 1; 
	}

	function onSetup() {
		if (m.TempData != null && m.TempData.IsMiniboss) getContainer().add(::new("scripts/skills/traits/fearless_trait"));
	}

});

//Unhold = 56,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Unhold, {
	StatMod = { Hitpoints = [-100, -100], Bravery = [-50, -50], Stamina = [-200, -200], MeleeSkill = [-8, -5], RangedSkill = [5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [0, 0] },
	Skills = ["racial/unhold_racial", "actives/sweep_skill", "actives/sweep_zoc_skill", "actives/fling_back_skill"],
	Requirements = ["NggHCharmEnemyUnhold"],
	Script = "player_beast/nggh_mod_unhold_player",
	PerkTree = "UnholdTree", 
	Difficulty = 10,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [5, 7],
		Names = "UnholdNames",
	},

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		_playerEntity.setVariant(2);
	}

});

//UnholdFrost = 57,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.UnholdFrost, {
	StatMod = { Hitpoints = [-150, -150], Bravery = [-50, -50], Stamina = [-200, -200], MeleeSkill = [-8, -5], RangedSkill = [5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [0, 0] },
	Skills = ["racial/unhold_racial", "actives/sweep_skill", "actives/sweep_zoc_skill", "actives/fling_back_skill"],
	Requirements = ["NggHCharmEnemyUnhold"],
	Script = "player_beast/nggh_mod_unhold_player",
	PerkTree = "UnholdTree", 
	Difficulty = 0,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.05, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [5, 7],
		Names = "UnholdNames",
	},

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		_playerEntity.getFlags().add("regen_armor");
		_playerEntity.setVariant(1);
	}

});

//UnholdBog = 58,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.UnholdBog, {
	StatMod = { Hitpoints = [-100, -100], Bravery = [-50, -50], Stamina = [-200, -200], MeleeSkill = [-8, -5], RangedSkill = [5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [0, 0] },
	Skills = ["racial/legend_bog_unhold_racial", "actives/sweep_skill", "actives/sweep_zoc_skill", "actives/fling_back_skill"],
	Requirements = ["NggHCharmEnemyUnhold"],
	Script = "player_beast/nggh_mod_unhold_player",
	PerkTree = "UnholdTree", 
	Difficulty = 15,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.05, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [5, 7],
		Names = "UnholdNames",
	},

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		_playerEntity.setVariant(3);
	}

});

//Spider = 59,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Spider, {
	StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [-2, 2], RangedDefense = [-3, 0], Initiative = [-22, -12] },
	Skills = ["actives/spider_bite_skill", "racial/spider_racial"],
	Requirements = ["NggHCharmEnemySpider"],
	Script = "player_beast/nggh_mod_spider_player",
	PerkTree = "SpiderTree", 
	Difficulty = -5,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.1, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.3, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.01, 0.01, 0.01, 0.05, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01],
		},
		ExcludedTalents = [1, 5],
		Names = "SpiderNames",
	},

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		_playerEntity.setSize(_enemyEntity.m.Size);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeDefense] < 2) _talents[::Const.Attributes.MeleeDefense] += 1;
	}

	function onBuildAttributes( _properties ) {
		if (m.TempData != null && m.TempData.IsMiniboss && _properties.ActionPoints < 12) _properties.ActionPoints += 1; 
	}

});

//SpiderEggs = 60,

//Alp = 61,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Alp, {
	StatMod = { Hitpoints = [0, 0], Bravery = [-25, -15], Stamina = [0, 0], MeleeSkill = [-5, 5], RangedSkill = [-5, 5], MeleeDefense = [-2, 0], RangedDefense = [-2, 0], Initiative = [0, 0] },
	Skills = ["actives/sleep_skill", "actives/nightmare_skill", "actives/alp_teleport_skill"],
	Perks = ["Underdog"],
	Requirements = ["NggHCharmEnemyAlp"],
	Script = "player_beast/nggh_mod_alp_player",
	PerkTree = "AlpTree", 
	Difficulty = 12,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 5, Stash = 3, Healing = 0.1, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.1, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.2, Gathering = 0.1, Training = 0.0, Enchanting = 0.1,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [2],
		Names = "GoblinNames",
	}

});

//Hexe = 62,

//Schrat = 63,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Schrat, {
	StatMod = { Hitpoints = [-200, -200], Bravery = [0, 0], Stamina = [-100, -100], MeleeSkill = [-10, -5], RangedSkill = [5, -5], MeleeDefense = [-3, -3], RangedDefense = [-3, -3], Initiative = [-5, 0] },
	Skills = ["racial/schrat_racial", "actives/grow_shield_skill"],
	Requirements = ["NggHCharmEnemySchrat"],
	Script = "player_beast/nggh_mod_schrat_player",
	PerkTree = "SchratTree", 
	Difficulty = 25,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 10, Stash = 12, Healing = 0.2, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.1, Gathering = 0.3, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05],
		},
		ExcludedTalents = [3, 5],
		Names = "SchratNames",
	}

});

//SchratSmall = 64,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.SchratSmall, {
	StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [-10, -8], RangedSkill = [0, 0], MeleeDefense = [-3, 0], RangedDefense = [-3, 0], Initiative = [0, 0] },
	Requirements = [],
	Script = "player_beast/nggh_mod_schrat_small_player",
	PerkTree = "SmallSchratTree", 
	Difficulty = -50,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 4, Stash = 5, Healing = 0.2, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.1, Gathering = 0.2, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.025],
		},
		ExcludedTalents = [0, 5],
		Names = "SchratNames",
	}

});

//Wildman = 65,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Wildman, {
	StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
	Background = "wildman_background",
	Difficulty = 0,
});

//Kraken = 66,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Kraken, {
	StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Requirements = ["NggHCharmSpec"],
	Script = "player_beast/nggh_mod_kraken_player",
	PerkTree = "KrakenTree", 
	Difficulty = -689,

	Custom =  {
		BgModifiers = {
			Ammo = 100, ArmorParts = 100, Meds = 100, Stash = 300, Healing = 0.1, Injury = 0.1, Repair = 0.1, Salvage = 0.1, Crafting = 0.1, Barter = 0.1, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 1.0, Fletching = 0.1, Scout = 0.1, Gathering = 1.0, Training = 0.1, Enchanting = 50.0,
			Terrain = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5],
		},
		ExcludedTalents = [0,1,2,3,4,5,6,7],
		Names = "KrakenNamesOnly",
	},
});

//KrakenTentacle = 67,
		
//ZombieBetrayer = 68,
		
//AlpShadow = 69,

//BarbarianThrall = 70,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BarbarianThrall, {
	StatMod = { Hitpoints = [-10, -5], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-2, 2] },
	Skills = ["actives/barbarian_fury_skill"],
	Background = "barbarian_background",
	Difficulty = 0,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.WildlingProfessionTree.Tree);
			addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
		}
	}

});

//BarbarianMarauder = 71,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BarbarianMarauder, {
	StatMod = { Hitpoints = [-40, -40], Bravery = [-20, -15], Stamina = [-10, -10], MeleeSkill = [-5, -5], RangedSkill = [-7, -5], MeleeDefense = [-5, -5], RangedDefense = [-3, -3], Initiative = [-15, -5] },
	Skills = ["actives/barbarian_fury_skill"],
	Background = "barbarian_background",
	Difficulty = 5,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.WildlingProfessionTree.Tree);
			addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
		}
	}

});

//BarbarianChampion = 72,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BarbarianChampion, {
	StatMod = { Hitpoints = [-50, -50], Bravery = [-20, -20], Stamina = [-25, -25], MeleeSkill = [-15, -10], RangedSkill = [-8, -8], MeleeDefense = [-10, -5], RangedDefense = [0, 0], Initiative = [-15, -5] },
	Skills = ["actives/barbarian_fury_skill"],
	Perks = ["Brawny", "DevastatingStrikes"],
	Requirements = ["NggHCharmWords"],
	Background = "barbarian_background",
	Difficulty = 42,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.WildlingProfessionTree.Tree);
			addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
		}
	}

});

//BarbarianDrummer = 73,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BarbarianDrummer, {
	StatMod = { Hitpoints = [-20, -20], Bravery = [-30, -20], Stamina = [-20, -10], MeleeSkill = [-5, -5], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [0, 0], Initiative = [-5, -5] },
	Skills = ["actives/barbarian_fury_skill"],
	Background = "minstrel_background",
	Difficulty = 0,
	Custom = {ID = "background.barbarian"},

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.WildlingProfessionTree.Tree);
			addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
		}
	}

});

//BarbarianBeastmaster = 74,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BarbarianBeastmaster, {
	StatMod = { Hitpoints = [-20, -20], Bravery = [-30, -20], Stamina = [-20, -10], MeleeSkill = [-5, -5], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [0, 0], Initiative = [-5, -5] },
	Skills = ["actives/barbarian_fury_skill", "actives/crack_the_whip_skill"],
	Requirements = ["NggHCharmWords"],
	Background = "cultist_background",
	Difficulty = 10,
	Custom = {ID = "background.houndmaster"},

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.WildlingProfessionTree.Tree);
			addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
		}
	}

});

//BarbarianUnhold = 75,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BarbarianUnhold, {
	StatMod = { Hitpoints = [-100, -100], Bravery = [-50, -50], Stamina = [-200, -200], MeleeSkill = [-8, -5], RangedSkill = [5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [0, 0] },
	Skills = ["racial/unhold_racial", "actives/sweep_skill", "actives/sweep_zoc_skill", "actives/fling_back_skill"],
	Requirements = ["NggHCharmEnemyUnhold"],
	Script = "player_beast/nggh_mod_unhold_player",
	PerkTree = "UnholdTree", 
	Difficulty = 10,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [5, 7],
		Names = "UnholdNames",
	},

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		_playerEntity.setVariant(2);
	}

});

//BarbarianUnholdFrost = 76,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BarbarianUnholdFrost, {
	StatMod = { Hitpoints = [-150, -150], Bravery = [-50, -50], Stamina = [-200, -200], MeleeSkill = [-8, -5], RangedSkill = [5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [0, 0] },
	Skills = ["racial/unhold_racial", "actives/sweep_skill", "actives/sweep_zoc_skill", "actives/fling_back_skill"],
	Requirements = ["NggHCharmEnemyUnhold"],
	Script = "player_beast/nggh_mod_unhold_player",
	PerkTree = "UnholdTree", 
	Difficulty = 0,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.05, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [5, 7],
		Names = "UnholdNames",
	},

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		_playerEntity.getFlags().add("regen_armor");
		_playerEntity.setVariant(1);
	}

});

//BarbarianChosen = 77,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BarbarianChosen, {
	StatMod = { Hitpoints = [-50, -50], Bravery = [-20, -15], Stamina = [-25, -25], MeleeSkill = [-10, -10], RangedSkill = [-8, -8], MeleeDefense = [-10, 0], RangedDefense = [0, 0], Initiative = [-15, -5] },
	Skills = ["actives/barbarian_fury_skill"],
	Perks = ["DevastatingStrikes", "Brawny", "SteelBrow"],
	Requirements = ["NggHCharmAppearance"],
	Background = "orc_slayer_background",
	Difficulty = 40,
	Custom = {ID = "background.barbarian"},

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.WildlingProfessionTree.Tree);
			addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
			addPerkGroup(::Const.Perks.TwoHandedTree.Tree);
		} 
		
		addPerkGroup(::Const.Perks.ViciousTree.Tree);
	},

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 2) _talents[::Const.Attributes.MeleeSkill] = 2;
		if (_talents[::Const.Attributes.MeleeDefense] < 2) _talents[::Const.Attributes.MeleeDefense] = 2;
	}

});

//Warhound = 78,

//TricksterGod = 79,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.TricksterGod, {
	StatMod = { Hitpoints = [5, -5], Bravery = [5, -5], Stamina = [5, -5], MeleeSkill = [5, -5], RangedSkill = [5, -5], MeleeDefense = [3, -3], RangedDefense = [3, -3], Initiative = [10, -10] },
	Requirements = ["NggHCharmSpec"],
	Script = "player_beast/nggh_mod_trickster_god_player",
	PerkTree = "UnholdTree",
	Difficulty = -799,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 50, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.5, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.5, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05],
		},
		ExcludedTalents = [5,7],
	}

});

//BarbarianMadman = 80,

//Serpent = 81,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Serpent, {
	StatMod = { Hitpoints = [-10, -10], Bravery = [-15, -10], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [25, 25] },
	Requirements = [],
	Script = "player_beast/nggh_mod_serpent_player",
	PerkTree = "SerpentTree", 
	Difficulty = -15,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.2, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.025],
		},
		ExcludedTalents = [2,5],
		Names = "SerpentNames",
	},
	
	function onBuildPerkTree() {
		addPerk(::Const.Perks.PerkDefs.Dodge, 1);
		addPerk(::Const.Perks.PerkDefs.Nimble, 4);
	}

	function onBuildAttributes( _properties ) {
		// i like scalie. ok? ok? ok!
		if (m.TempData != null && m.TempData.IsMiniboss && _properties.ActionPoints < 10) _properties.ActionPoints += 1; 
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		_playerEntity.setVariant(_enemyEntity.m.Variant);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.RangedDefense] < 3) _talents[::Const.Attributes.RangedDefense] += 1;
	}

});

//SandGolem = 82,

//Hyena = 83,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Hyena, {
	StatMod = { Hitpoints = [-20, 0], Bravery = [-5, -5], Stamina = [-30, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [4, 6], RangedDefense = [0, 0], Initiative = [0, 5] },
	Requirements = ["NggHCharmEnemyDirewolf"],
	Script = "player_beast/nggh_mod_hyena_player",
	PerkTree = "HyenaTree", 
	Difficulty = 5,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 3, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.3, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.025],
		},
		ExcludedTalents = [2, 5],
		Names = "WolfNames",
	},

	function onBuildAttributes( _properties ) {
		if (m.TempData != null && m.TempData.IsMiniboss && _properties.ActionPoints < 16) _properties.ActionPoints += 2; 
	}

	function onBuildPerkTree() {
		if (::Math.rand(1, 100) <= 67) addPerk(::Const.Perks.PerkDefs.Dodge, 1);

		addPerk(::Const.Perks.PerkDefs.Nimble, 4);
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		if (_enemyEntity.m.IsHigh) _playerEntity.getFlags().add("frenzy");
		else addPerk(::Const.Perks.PerkDefs.NggHWolfRabies, 6);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeDefense] < 2) _talents[::Const.Attributes.MeleeDefense] += 1;
	}

	function onUpdate( _properties ) {
		_properties.MovementFatigueCostMult *= 0.67;
	}

	function addTooltip( _tooltips ) {
		_tooltips.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Builds up [color=" + ::Const.UI.Color.PositiveValue + "]33%[/color] less fatigue for each tile travelled"
		});
	}

});

//Conscript = 84,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Conscript, {
	StatMod = { Hitpoints = [-7, -10], Bravery = [-10, -10], Stamina = [-10, -10], MeleeSkill = [-8, -8], RangedSkill = [-5, -5], MeleeDefense = [0, -5], RangedDefense = [0, -3], Initiative = [-10, -10] },
	Perks = ["Rotation"],
	Background = "legend_conscript_background",
	Difficulty = 10,

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Names.extend(::Const.Strings.SouthernNames);
		m.LastNames.extend(::Const.Strings.SouthernNamesLast);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeDefense] < 2) _talents[::Const.Attributes.MeleeDefense] += 1;
	}

});

//Gunner = 85,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Gunner, {
	StatMod = { Hitpoints = [-10, -10], Bravery = [-15, -10], Stamina = [-10, -10], MeleeSkill = [-5, -5], RangedSkill = [-8, -5], MeleeDefense = [-2, -1], RangedDefense = [-2, 0], Initiative = [0, 0] },
	Perks = ["Rotation", "SpecCrossbow"],
	Background = "legend_conscript_ranged_background",
	Difficulty = 10,

	function onBuildPerkTree() {
		addPerkGroup(::Const.Perks.CrossbowTree.Tree);
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Names.extend(::Const.Strings.SouthernNames);
		m.LastNames.extend(::Const.Strings.SouthernNamesLast);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.RangedSkill] < 2) _talents[::Const.Attributes.RangedSkill] += 1;
	}

});

//Officer = 86,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Officer, {
	StatMod = { Hitpoints = [-35, -30], Bravery = [-20, -10], Stamina = [-17, -12], MeleeSkill = [-17, -12], RangedSkill = [0, 0], MeleeDefense = [-10, -7], RangedDefense = [0, 0], Initiative = [-15, -10] },
	Skills = ["perks/perk_captain"],
	Perks = ["QuickHands", "Rotation", "Duelist", "RallyTheTroops"],
	Requirements = ["NggHCharmWords"],
	Background = "legend_noble_background",
	Difficulty = 45,

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Names.extend(::Const.Strings.SouthernNames);
		m.LastNames.extend(::Const.Strings.SouthernNamesLast);
		m.Titles.extend(::Const.Strings.SouthernOfficerTitles);
	}

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.TacticianClassTree.Tree);
			addPerkGroup(::Const.Perks.SergeantClassTree.Tree);
			addPerkGroup(::Const.Perks.SoldierProfessionTree.Tree);
		}
		else {
			addPerkGroup(::Const.Perks.InspirationalTree.Tree);
			addPerkGroup(::Const.Perks.MartyrTree.Tree);
		}
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 2) _talents[::Const.Attributes.MeleeSkill] += 1;
		if (_talents[::Const.Attributes.Bravery] < 2) _talents[::Const.Attributes.Bravery] += 1;
	}

});

//Engineer = 87,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Engineer, {
	StatMod = { Hitpoints = [-10, -10], Bravery = [-15, -15], Stamina = [-20, -10], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = ["Rotation"],
	Requirements = ["NggHCharmWords"],
	Background = "legend_noble_ranged",
	Difficulty = 30,
	Custom = {ID = "background.legend_inventor"},

	function onBuildPerkTree() {
		addPerkGroup(::Const.Perks.InventorMagicTree.Tree);
	}
	
	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Names.extend(::Const.Strings.SouthernNames);
		m.LastNames.extend(::Const.Strings.SouthernNamesLast);
	}

});

//Assassin = 88,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Assassin, {
	StatMod = { Hitpoints = [-15, -10], Bravery = [-20, -10], Stamina = [-30, -10], MeleeSkill = [-10, -7], RangedSkill = [-5, -5], MeleeDefense = [0, 2], RangedDefense = [0, 0], Initiative = [-10, -5] },
	Perks = ["QuickHands", "Backstabber", "SpecDagger"],
	Requirements = ["NggHCharmWords"],
	Background = "assassin_southern_background",
	Difficulty = 45,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.AssassinProfessionTree.Tree);
			addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
			addPerkGroup(::Const.Perks.OneHandedTree.Tree);
		}
		
		addPerkGroup(::Const.Perks.DaggerTree.Tree);
		addPerkGroup(::Const.Perks.ThrowingTree.Tree);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 2) _talents[::Const.Attributes.MeleeSkill] += 1;
		if (_talents[::Const.Attributes.Initiative] < 3) _talents[::Const.Attributes.Initiative] += 1;
	}

});

//Slave = 89,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Slave, {
	StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
	Background = "slave_background",
	Difficulty = -25,

});

//Gladiator = 90,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Gladiator, {
	StatMod = { Hitpoints = [-40, -28], Bravery = [-30, -30], Stamina = [-15, -10], MeleeSkill = [-8, -8], RangedSkill = [-3, -3], MeleeDefense = [-10, -8], RangedDefense = [0, 0], Initiative = [-15, -15] },
	Perks = ["Footwork", "Underdog"],
	Background = "gladiator_background",
	Requirements = ["NggHCharmWords"],
	Difficulty = 15,

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Names.extend(::Const.Strings.SouthernNames);
		m.LastNames.extend(::Const.Strings.SouthernNamesLast);
		m.Titles.extend(::Const.Strings.GladiatorTitles);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeDefense] < 2) _talents[::Const.Attributes.MeleeDefense] == 2;
	}

});

//Mortar = 91,

//NomadCutthroat = 92,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.NomadCutthroat, {
	StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
	Skills = ["actives/throw_dirt_skill"],
	Background = "nomad_background",
	Difficulty = 0,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
	}

});

//NomadOutlaw = 93,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.NomadOutlaw, {
	StatMod = { Hitpoints = [-15, -15], Bravery = [-20, -15], Stamina = [-25, -15], MeleeSkill = [-8, -5], RangedSkill = [-5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-15, -5] },
	Skills = ["actives/throw_dirt_skill"],
	Background = "nomad_background",
	Difficulty = 10,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
	}

});

//NomadSlinger = 94,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.NomadSlinger, {
	StatMod = { Hitpoints = [-5, -5], Bravery = [-5, -5], Stamina = [-5, 0], MeleeSkill = [-5, 2], RangedSkill = [-10, -8], MeleeDefense = [0, 0], RangedDefense = [-2, 2], Initiative = [0, 0] },
	Skills = ["actives/throw_dirt_skill"],
	Background = "nomad_ranged_background",
	Difficulty = 5,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
	}

});

//NomadArcher = 95,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.NomadArcher, {
	StatMod = { Hitpoints = [-5, -5], Bravery = [-5, -5], Stamina = [-5, 0], MeleeSkill = [-5, 2], RangedSkill = [-10, -8], MeleeDefense = [0, 0], RangedDefense = [-2, 2], Initiative = [0, 0] },
	Skills = ["actives/throw_dirt_skill"],
	Background = "nomad_ranged_background",
	Difficulty = 10,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
	}

});

//NomadLeader = 96,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.NomadLeader, {
	StatMod = { Hitpoints = [-30, -20], Bravery = [-20, -20], Stamina = [-25, -15], MeleeSkill = [-13, -8], RangedSkill = [-8, -8], MeleeDefense = [-13, -8], RangedDefense = [-8, -5], Initiative = [-20, -15] },
	Skills = ["actives/throw_dirt_skill", "perks/perk_captain"],
	Perks = ["NineLives"],
	Background = "orc_slayer_background",
	Requirements = ["NggHCharmWords"],
	Difficulty = 15,
	Custom = {ID = "background.nomad"}

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			if (::Math.rand(1, 100) <= 33) addPerkGroup(::Const.Perks.TacticianClassTree.Tree);

			addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
		} 
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Names.extend(::Const.Strings.SouthernNames);
		m.LastNames.extend(::Const.Strings.SouthernNamesLast);
		m.Titles.extend(::Const.Strings.NomadChampionTitles);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 3) _talents[::Const.Attributes.MeleeSkill] += 1;
	}

});

//DesertStalker = 97,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.DesertStalker, {
	StatMod = { Hitpoints = [-20, -15], Bravery = [-10, 0], Stamina = [-15, -15], MeleeSkill = [-5, -5], RangedSkill = [-15, -10], MeleeDefense = [-5, -5], RangedDefense = [0, 0], Initiative = [-25, -10] },
	Skills = ["actives/throw_dirt_skill"],
	Perks = ["Bullseye", "QuickHands", "SpecCrossbow", "SpecBow"],
	Requirements = ["NggHCharmAppearance"],
	Background = "legend_master_archer_background",
	Difficulty = 70,
	Custom =  {ExcludedTalents = [4, 6]}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Names.extend(::Const.Strings.SouthernNames);
		m.LastNames.extend(::Const.Strings.SouthernNamesLast);
		m.Titles.extend(::Const.Strings.DesertStalkerChampionTitles);
	}

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) this.addPerk(::Const.Perks.PerkDefs.PTRMarksmanship, 6);

		addPerkGroup(::Const.Perks.FastTree.Tree);
		addPerk(::Const.Perks.PerkDefs.LegendBigGameHunter, 6);
	}

	function onfillTalentsValues( _talents ) {
		_talents[::Const.Attributes.RangedSkill] = 3;
	}

});

//Executioner = 98,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Executioner, {
	StatMod = { Hitpoints = [-50, -25], Bravery = [-20, -15], Stamina = [-10, -10], MeleeSkill = [-15, -5], RangedSkill = [0, 0], MeleeDefense = [-5, 0], RangedDefense = [-12, -8], Initiative = [-15, -5] },
	Skills = ["actives/throw_dirt_skill"],
	Perks = ["DevastatingStrikes", "SteelBrow", "Brawny"],
	Requirements = ["NggHCharmAppearance"],
	Background = "hedge_knight_background",
	Difficulty = 50,
	Custom =  {ExcludedTalents = [3, 7]}

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.SoldierProfessionTree.Tree);
			addPerkGroup(::Const.Perks.TwoHandedTree.Tree);
			addPerk(::Const.Perks.PerkDefs.PTRManOfSteel, 6);
		} 
		
		addPerkGroup(::Const.Perks.IndestructibleTree.Tree);
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Names.extend(::Const.Strings.SouthernNames);
		m.LastNames.extend(::Const.Strings.SouthernNamesLast);
		m.Titles.extend(["The Executioner","the Silver Mace","the Plunderer","the Traders\' Bane","the Scourge","the Cursed","the Sand Giant","the Gilder\'s Chosen","the Mountain","the Scimitar","the Gilded","the Raging Nomad","the Immortal","the Headcollector","the Giant","the Rock","the Sandstorm","the Headcrusher","the Ifrit","the Lion"]);
	}

	function onfillTalentsValues( _talents ) {
		_talents[::Const.Attributes.Hitpoints] = 3;
	}

});

//DesertDevil = 99,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.DesertDevil, {
	StatMod = { Hitpoints = [-20, -20], Bravery = [-20, -15], Stamina = [-15, -15], MeleeSkill = [-25, -25], RangedSkill = [-10, -10], MeleeDefense = [-15, -10], RangedDefense = [-10, -10], Initiative = [-5, -5] },
	Perks = ["Duelist", "SpecSword", "LegendSpecGreatSword"],
	Skill = ["actives/throw_dirt_skill"],
	Requirements = ["NggHCharmAppearance"],
	Background = "swordmaster_background",
	Difficulty = 50,
	Custom =  {ExcludedTalents = [0, 5]}

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.SwordmasterProfessionTree.Tree);
			addPerkGroup(::Const.Perks.OneHandedTree.Tree);
			addPerkGroup(::Const.Perks.TwoHandedTree.Tree);
		} 
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Names.extend(::Const.Strings.SouthernNames);
		m.LastNames.extend(::Const.Strings.SouthernNamesLast);
		m.Titles.extend(["the Scorpion","the Ghost of the Sands","the Viper","the Blademaster","the Desert Devil","the Elusive","the Shadow","the Snake","the Whirlwind","the Sand Devil","the Sandviper","the Exiled","the Blade Dancer","the Swift","the Undefeated","the Dust Dancer","the Glistening Edge","the Crimson Edge","the Flying Blade","the Dust Devil","the Striking Wind","the Black Hawk"]);
	}

	function onfillTalentsValues( _talents ) {
		_talents[::Const.Attributes.MeleeSkill] = 3;
	}

});

//PeasantSouthern = 100,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.PeasantSouthern, {
	StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
	Background = "farmhand_background",
	Difficulty = -25,

});

//SkeletonLich = 101,
	
//SkeletonLichMirrorImage = 102,

//SkeletonPhylactery = 103,
	
//ZombieTreasureHunter = 104,
	
//FlyingSkull = 105,

//Oathbringer = 106,
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.Oathbringer, {
	StatMod = { Hitpoints = [-50, -30], Bravery = [-30, -20], Stamina = [-15, -15], MeleeSkill = [-25, -25], RangedSkill = [0, 0], MeleeDefense = [-15, -10], RangedDefense = [-12, -8], Initiative = [-15, -5] },
	Perks = ["DevastatingStrikes", "SteelBrow", "Brawny"],
	Requirements = ["NggHCharmAppearance"],
	Background = "paladin_background",
	Difficulty = 70,
	Custom =  {ExcludedTalents = [3,5,7]},

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.SoldierProfessionTree.Tree);
			addPerkGroup(::Const.Perks.TwoHandedTree.Tree);
			addPerk(::Const.Perks.PerkDefs.PTRManOfSteel, 6);
		} 
		
		addPerkGroup(::Const.Perks.IndestructibleTree.Tree);
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		m.Titles = [];
		m.Titles.extend(::Const.Strings.HedgeKnightTitles);
	}

	function onfillTalentsValues( _talents ) {
		_talents[::Const.Attributes.Hitpoints] = 3;
	}

});

//BanditRabble
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BanditRabble, {
	StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
	Background = "beggar_background",
	Difficulty = -10,

});

//BanditRabblePoacher
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BanditRabblePoacher, {
	StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Background = "poacher_background",
	Difficulty = -15,
	Custom = {ID = "background.beggar"}

});

//BanditVeteran
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BanditVeteran, {
	StatMod = { Hitpoints = [-28, -20], Bravery = [-15, -10], Stamina = [-18, -10], MeleeSkill = [-8, -8], RangedSkill = [-5, -5], MeleeDefense = [-10, -5], RangedDefense = [-5, -5], Initiative = [-15, -15] },
	Perks = ["Brawny", "Relentless"],
	Requirements = ["NggHCharmWords"],
	Background = "raider_background",
	Difficulty = 55,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 3) _talents[::Const.Attributes.MeleeSkill] += 1;
	}

});

//BanditWarlord
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.BanditWarlord, {
	StatMod = { Hitpoints = [-60, -60], Bravery = [-70, -60], Stamina = [-50, -50], MeleeSkill = [-30, -30], RangedSkill = [-25, -15], MeleeDefense = [-18, -15], RangedDefense = [-25, -20], Initiative = [-50, -30] },
	Skills = ["perks/perk_captain"],
	Perks = ["NineLives", "SunderingStrikes"],
	Requirements = ["NggHCharmAppearance"],
	Background = "orc_slayer_background",
	Difficulty = -10,
	Custom = {ID = "background.raider"},

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.TacticianClassTree.Tree);
			addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);
		} 
	},

	function onfillTalentsValues( _talents ) {
		if (::Math.rand(1, 100) <= 50) _talents[::Const.Attributes.MeleeSkill] = 3;
		else _talents[::Const.Attributes.MeleeDefense] = 3;
	}

});

//LegendCat

//LegendBear
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendBear, {
	StatMod = { Hitpoints = [-125, -125], Bravery = [0, 0], Stamina = [-150, -150], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Skills = ["actives/legend_bear_bite_skill", "actives/legend_bear_claws_skill", "actives/unstoppable_charge_skill"],
	Perks = ["Stalwart", "LegendComposure"],
	Requirements = ["NggHCharmEnemyDirewolf"],
	Script = "player_beast/nggh_mod_unhold_player",
	PerkTree = "BearTree", 
	Difficulty = 50,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [5, 7],
		Names = "BearNames",
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		_playerEntity.getFlags().add("regen_armor")
		_playerEntity.setVariant(5);
	}

});

//LegendOrcElite
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendOrcElite, {
	StatMod = { Hitpoints = [-100, -70], Bravery = [-35, -35], Stamina = [-120, -120], MeleeSkill = [-17, -9], RangedSkill = [-5, -2], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-25, -20] },
	Skills = ["actives/line_breaker"],
	Perks = ["LegendComposure", "Stalwart", "ShieldBash"],
	Requirements = ["NggHCharmEnemyOrk"],
	Script = "nggh_mod_player_orc",
	PerkTree = "LegendOrcElite", 
	Difficulty = 55,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 10, Meds = 10, Stash = 15, Healing = 0.0, Injury = 0.1, Repair = 0.0, Salvage = 0.30, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.15, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.1, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [3,5,7],
		Names = "OrcNames",
	}
	
	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);

		addPerkGroup(::Const.Perks.IndestructibleTree.Tree);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 3) _talents[::Const.Attributes.MeleeSkill] += 1;
	}

});

//LegendOrcBehemoth
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendOrcBehemoth, {
	StatMod = { Hitpoints = [-420, -400], Bravery = [-20, -15], Stamina = [-200, -200], MeleeSkill = [-12, -10], RangedSkill = [0, 0], MeleeDefense = [-7, -5], RangedDefense = [-5, -5], Initiative = [-7, 1] },
	Skills = ["actives/line_breaker", "perks/perk_legend_taste_the_pain"],
	Perks = ["Stalwart"]
	Requirements = ["NggHCharmEnemyOrk", "NggHCharmSpec"],
	Script = "nggh_mod_player_orc",
	PerkTree = "LegendOrcBehemoth", 
	Difficulty = 105,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 20, Meds = 0, Stash = 30, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [5,7],
		Names = "OrcNames",
	},
	
	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.RaiderProfessionTree.Tree);

		addPerkGroup(::Const.Perks.LargeTree.Tree);
	}

});

//LegendWhiteDirewolf
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendWhiteDirewolf, {
	StatMod = { Hitpoints = [-200, -150], Bravery = [-40, -25], Stamina = [-80, -40], MeleeSkill = [-12, -10], RangedSkill = [0, 0], MeleeDefense = [-8, -8], RangedDefense = [-8, -8], Initiative = [-45, -35] },
	Skills = ["racial/legend_werewolf_racial", "actives/legend_white_wolf_bite_skill", "actives/legend_white_wolf_howl_skill"],
	Perks = ["Footwork", "Rotation"],
	Requirements = ["NggHCharmEnemyDirewolf", "NggHCharmSpec"],
	Script = "player_beast/nggh_mod_direwolf_player",
	PerkTree = "WhiteWolfTree", 
	Difficulty = 25,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 3, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.3, Gathering = 0.1, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.03, 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.03, 0.03, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [2, 5],
		Names = "WolfNames",
	},

	function onBuildPerkTree() {
		if (::Math.rand(1, 100) <= 67) addPerk(::Const.Perks.PerkDefs.Dodge, 1);

		addPerk(::Const.Perks.PerkDefs.Nimble, 4);
	}

	function onfillTalentsValues( _talents ) {
		_talents[::Const.Attributes.MeleeSkill] = 3;
		if (_talents[::Const.Attributes.Initiative] < 3) _talents[::Const.Attributes.Initiative] += 1;
	}

	function onUpdate( _properties ) {
		_properties.MovementFatigueCostMult *= 0.6;
	}

	function addTooltip( _tooltips ) {
		_tooltips.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Builds up [color=" + ::Const.UI.Color.PositiveValue + "]40%[/color] less fatigue for each tile travelled"
		});
	}

});

//LegendSkinGhoul
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendSkinGhoul, {
	StatMod = { Hitpoints = [-80, -60], Bravery = [-30, -15], Stamina = [-10, -10], MeleeSkill = [-20, -15], RangedSkill = [0, 0], MeleeDefense = [-12, -10], RangedDefense = [-7, -7], Initiative = [-25, -25] },
	Skills = ["actives/legend_skin_ghoul_claws", "actives/legend_skin_ghoul_swallow_whole_skill", "traits/fearless_trait"],
	Requirements = ["NggHCharmEnemyGhoul", "NggHCharmSpec"],
	Script = "player_beast/nggh_mod_ghoul_player",
	PerkTree = "NachoTree", 
	Difficulty = 20,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 8, Stash = 9, Healing = 0.0, Injury = 0.0, Repair = 0.1, Salvage = 0.1, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.1, Gathering = 0.2, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [5,7],
		Names = "NachoNames",
	},

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		_playerEntity.setVariant(_enemyEntity.m.Head);
		_playerEntity.getFlags().set("has_eaten", true);
		_playerEntity.getFlags().set("Type", this.m.CharmID);
		for (local i = 0; i < ::Math.max(0, _enemyEntity.getSize() - 1); ++i) {
			_playerEntity.grow(true);
		}
	}

	function onSetup() {
		if (!::Tactical.isActive() && m.TempData != null && m.TempData.IsMiniboss)
			grow(true); // UwU champion nacho is always a big bear boi
	}

	function addTooltip( _tooltips ) {
		if (getContainer().getActor().getSize() > 1)
			_tooltips.push({
				id = 10,
				type = "text",
				icon = "ui/icons/asset_food.png",
				text = "Needs to eat a [color=" + ::Const.UI.Color.NegativeValue + "]corpse[/color] every battle or will shrink in size"
			});
	}

});

//LegendStollwurm 
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendStollwurm, {
	StatMod = { Hitpoints = [-750, -550], Bravery = [-80, -50], Stamina = [-225, -200], MeleeSkill = [-10, -10], RangedSkill = [0, 0], MeleeDefense = [-10, -10], RangedDefense = [-5, -5], Initiative = [0, 0] },
	Skills = ["actives/legend_stollwurm_move_skill"],
	Perks = ["LegendMuscularity"],
	Requirements = ["NggHCharmEnemyLindwurm", "NggHCharmSpec"],
	Script = "player_beast/nggh_mod_lindwurm_player",
	PerkTree = "LindwurmTree", 
	Difficulty = 75,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 15, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.2, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.1, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [3,5,7],
		Names = "LindwurmNames",
	},

	function onSetup() {
		if (m.TempData != null && m.TempData.IsMiniboss) getContainer().add(::new("scripts/skills/traits/fearless_trait"));
	}

});

//LegendRockUnhold
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendRockUnhold, {
	StatMod = { Hitpoints = [-500, -500], Bravery = [-100, -100], Stamina = [-200, -200], MeleeSkill = [-10, -10], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-5, -5] },
	Skills = ["racial/unhold_racial", "racial/legend_rock_unhold_racial", "actives/sweep_skill", "actives/sweep_zoc_skill", "actives/fling_back_skill"],
	Requirements = ["NggHCharmEnemyUnhold", "NggHCharmSpec"],
	Script = "player_beast/nggh_mod_unhold_player",
	PerkTree = "UnholdTree", 
	Difficulty = -60,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [5, 7],
		Names = "UnholdNames",
	},

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		_playerEntity.getFlags().add("regen_armor")
		_playerEntity.setVariant(4);
	}

});

//LegendRedbackSpider
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendRedbackSpider, {
	StatMod = { Hitpoints = [-50, -50], Bravery = [-20, -20], Stamina = [-30, -20], MeleeSkill = [-20, -10], RangedSkill = [0, 0], MeleeDefense = [-10, -10], RangedDefense = [-10, -10], Initiative = [-45, -35] },
	Skills = ["actives/legend_redback_spider_bite_skill", "racial/legend_redback_spider_racial"],
	Perks = ["BattleForged"],
	Requirements = ["NggHCharmEnemySpider", "NggHCharmSpec"],
	Script = "player_beast/nggh_mod_spider_player",
	PerkTree = "SpiderTree", 
	Difficulty = 25,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.1, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.3, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.015, 0.015, 0.015, 0.05, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015],
		},
		ExcludedTalents = [1, 5],
		Names = "SpiderNames",
	},

	function onBuildAttributes( _properties ) {
		if (!::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue()) return;
		
		_properties.ArmorMax[0] = 120;
		_properties.ArmorMax[1] = 120;
		_properties.Armor[0] = ::Math.floor(_properties.Armor[0] / 2);
		_properties.Armor[1] = ::Math.floor(_properties.Armor[1] / 2);
	}

	function onSetAppearance( _playerEntity, _enemyEntity ) {
		_playerEntity.setSize(_enemyEntity.m.Size);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeDefense] < 2) _talents[::Const.Attributes.MeleeDefense] == 2;
		if (_talents[::Const.Attributes.RangedDefense] < 2) _talents[::Const.Attributes.RangedDefense] += 1;
	}

	function onUpdate( _properties ) {
		_properties.MovementFatigueCostMult *= 0.75;
	}

	function addTooltip( _tooltips ) {
		_tooltips.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Builds up [color=" + ::Const.UI.Color.PositiveValue + "]25%[/color] less fatigue for each tile travelled"
		});
	}

});

//LegendDemonAlp
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendDemonAlp, {
	StatMod = { Hitpoints = [0, 0], Bravery = [-50, -50], Stamina = [-50, -25], MeleeSkill = [-5, 5], RangedSkill = [-5, 5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [0, 0] },
	Skills = ["actives/legend_demon_shadows_skill", "actives/horrific_scream"],
	Perks = ["Footwork"],
	Requirements = ["NggHCharmEnemyAlp", "NggHCharmSpec"],
	Script = "player_beast/nggh_mod_alp_player",
	PerkTree = "DemonAlpTree", 
	Difficulty = 0,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 5, Stash = 3, Healing = 0.1, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.1, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.2, Gathering = 0.1, Training = 0.0, Enchanting = 0.5,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [2],
		Names = "GoblinNames",
	}

});

//LegendHexeLeader

//LegendGreenwoodSchrat
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendGreenwoodSchrat, {
	StatMod = { Hitpoints = [-300, -300], Bravery = [0, 0], Stamina = [-200, -150], MeleeSkill = [-15, -15], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-10, 0] },
	Skills = ["racial/legend_greenwood_schrat_racial", "actives/legend_grow_greenwood_shield_skill"],
	Perks = ["SteelBrow"],
	Requirements = ["NggHCharmEnemySchrat", "NggHCharmSpec"],
	Script = "player_beast/nggh_mod_schrat_player",
	PerkTree = "SchratTree", 
	Difficulty = -10,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 10, Stash = 12, Healing = 0.2, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.1, Gathering = 0.3, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.075, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05],
		},
		ExcludedTalents = [3, 5],
		Names = "SchratNames",
	}

});

//LegendGreenwoodSchratSmall
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendGreenwoodSchratSmall, {
	StatMod = { Hitpoints = [-25, -25], Bravery = [-25, -25], Stamina = [-100, -100], MeleeSkill = [-10, -10], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-5, 5] },
	Skills = ["racial/schrat_racial"],
	Requirements = [],
	Script = "player_beast/nggh_mod_schrat_small_player",
	PerkTree = "SmallSchratTree", 
	Difficulty = -50,

	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 4, Stash = 5, Healing = 0.2, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.1, Gathering = 0.2, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05],
		},
		ExcludedTalents = [0, 5],
		Names = "SchratNames",
	}

});

//LegendWhiteWarwolf

//LegendBanshee
		
//LegendDemonHound

//LegendVampireLord

//LegendPeasantButcher
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendPeasantButcher, {
	StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = ["LegendSpecialistButcherSkill"],
	Background = "butcher_background",
	Difficulty = 0,

});

//LegendPeasantBlacksmith
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendPeasantBlacksmith, {
	StatMod = { Hitpoints = [-20, -10], Bravery = [-5, 0], Stamina = [-40, -25], MeleeSkill = [-20, -10], RangedSkill = [10, 10], MeleeDefense = [-10, -10], RangedDefense = [-10, -5], Initiative = [-5, 0] },
	Perks = ["LegendSpecialistHammerSkill"],
	Background = "legend_blacksmith_background",
	Difficulty = 0,

});

//LegendPeasantMonk
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendPeasantMonk, {
	StatMod = { Hitpoints = [-5, 0], Bravery = [-35, -10], Stamina = [-5, -5], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [-12, -10], RangedDefense = [-10, 0], Initiative = [0, 0] },
	Perks = ["LegendSpecBandage"],
	Background = "monk_background",
	Difficulty = 24,

});

//LegendPeasantFarmhand
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendPeasantFarmhand, {
	StatMod = { Hitpoints = [-5, -5], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [-5, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = ["LegendSpecialistPitchforkSkill"],
	Background = "farmhand_background",
	Difficulty = 10,

});

//LegendPeasantMinstrel
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendPeasantMinstrel, {
	StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = ["LegendCheerOn", "LegendSpecialistLuteSkill"],
	Background = "minstrel_background",
	Difficulty = 25,

});

//LegendPeasantPoacher
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendPeasantPoacher, {
	StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = ["LegendSpecialistShortbowSkill"],
	Background = "poacher_background",
	Difficulty = 0,

});

//LegendPeasantWoodsman
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendPeasantWoodsman, {
	StatMod = { Hitpoints = [-40, -30], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = ["LegendSpecialistWoodaxeSkill"],
	Background = "lumberjack_background",
	Difficulty = 22,

});

//LegendPeasantMiner
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendPeasantMiner, {
	StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = ["LegendSpecialistPickaxeSkill"],
	Background = "miner_background",
	Difficulty = 13,

});

//LegendPeasantSquire
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendPeasantSquire, {
	StatMod = { Hitpoints = [-30, -10], Bravery = [-25, -15], Stamina = [0, 0], MeleeSkill = [-20, -15], RangedSkill = [0, 0], MeleeDefense = [-15, -10], RangedDefense = [-10, -5], Initiative = [-20, -20] },
	Perks = ["LegendBackToBasics"],
	Requirements = ["NggHCharmWords"],
	Background = "squire_background",
	Difficulty = 21,

});

//LegendPeasantWitchHunter
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendPeasantWitchHunter, {
	StatMod = { Hitpoints = [-25, -10], Bravery = [-15, -10], Stamina = [-5, -5], MeleeSkill = [-2, 0], RangedSkill = [-10, -5], MeleeDefense = [-10, -10], RangedDefense = [-10, -5], Initiative = [-10, -10] },
	Perks = ["Ballistics"],
	Requirements = ["NggHCharmAppearance"],
	Background = "witchhunter_background",
	Difficulty = 27,

	function onBeforeBuildPerkTree() {
		if (m.TempData.Entity == null || m.TempData.Entity == null || !m.TempData.Entity.m.IsMeleeWitchHunter) return;

		if (::Is_PTR_Exist) {
			foreach (perkGroup in m.PerkGroupMultipliers)
			{
				if (perkGroup[1].ID == "Bow")
				{
					perkGroup[1] = ::Const.Perks.PolearmTree;
					break;
				}
			}

			m.PerkTreeDynamic.Class = [::Const.Perks.BeastClassTree];
			m.PerkTreeDynamic.Weapon = [::Const.Perks.SpearTree, ::Const.Perks.ThrowingTree];
			m.PerkTreeDynamic.Styles =  [::Const.Perks.TwoHandedTree];
		}
		else
		{
			m.PerkTreeDynamic.Class = [::Const.Perks.BeastClassTree];
			m.PerkTreeDynamic.Weapon = [::Const.Perks.SpearTree, ::Const.Perks.ThrowingTree, ::Const.Perks.SwordTree, ::Const.Perks.PolearmTree];
		}
	},

	function onBuildPerkTree() {
		if (m.TempData == null || m.TempData.Entity == null || !m.TempData.Entity.getFlags().get("WitchHunters")) return;

		if (m.TempData.Entity.m.IsMeleeWitchHunter) {
			::World.Assets.getOrigin().addScenarioPerk(this, ::Const.Perks.PerkDefs.LegendNetCasting, 2);
			::World.Assets.getOrigin().addScenarioPerk(this, ::Const.Perks.PerkDefs.QuickHands, 2);
		}
		else {
			::World.Assets.getOrigin().addScenarioPerk(this, ::Const.Perks.PerkDefs.LegendBigGameHunter, 6);
			::World.Assets.getOrigin().addScenarioPerk(this, ::Const.Perks.PerkDefs.Footwork, 4);
		}
	}

	function onBuildAttributes( _properties ) {
		if (m.TempData == null || m.TempData.Entity == null || !m.TempData.Entity.m.IsMeleeWitchHunter) return;

		_properties.MeleeSkill -= ::Math.rand(5, 8);
		_properties.RangedSkill += ::Math.rand(1, 3);
		_properties.MeleeDefense += ::Math.rand(1, 8);
		_properties.RangedDefense -= ::Math.rand(8, 12);
	}

	function onUpdate( _properties ) {
		_properties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack] += 20;
	}

	function addTooltip( _tooltips ) {
		_tooltips.puss({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+20[/color] Resolve at morale checks against fear, panic or mind control effects"
		});
	}

});

//LegendHalberdier
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendHalberdier, {
	StatMod = { Hitpoints = [-23, -20], Bravery = [-25, -18], Stamina = [-10, -10], MeleeSkill = [-20, -15], RangedSkill = [0, 0], MeleeDefense = [-10, -10], RangedDefense = [-5, -5], Initiative = [-10, 0] },
	Perks = ["Rotation", "Backstabber"],
	Requirements = ["NggHCharmWords"],
	Background = "legend_noble_2h",
	Difficulty = 42,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.TwoHandedTree.Tree);

		addPerkGroup(::Const.Perks.PolearmTree.Tree);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 3) _talents[::Const.Attributes.MeleeSkill] += 1;
	}

});

//LegendSlinger
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendSlinger, {
	StatMod = { Hitpoints = [-12, -12], Bravery = [-5, 0], Stamina = [-20, -15], MeleeSkill = [0, 0], RangedSkill = [-3, 1], MeleeDefense = [-2, -1], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = ["Rotation", "LegendMasterySlings"],
	Background = "nomad_background",
	Difficulty = 27,
	Custom = {ID = "background.legend_noble_ranged"},

	function onBuildPerkTree() {
		if (::Math.rand(1, 100) <= 50) addPerk(::Const.Perks.PerkDefs.LegendBigGameHunter, 6);
	}
	
	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.RangedSkill] < 2) _talents[::Const.Attributes.RangedSkill] += 1;
	}

});

//LegendFencer
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendFencer, {
	StatMod = { Hitpoints = [-35, -25], Bravery = [-25, -15], Stamina = [-15, -15], MeleeSkill = [-15, -10], RangedSkill = [0, 0], MeleeDefense = [-20, -15], RangedDefense = [-8, -5], Initiative = [-25, -20] },
	Perks = ["Rotation", "Feint", "Duelist"],
	Requirements = ["NggHCharmWords"],
	Background = "adventurous_noble_background",
	Difficulty = 53,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) {
			addPerkGroup(::Const.Perks.OneHandedTree.Tree);
			addPerk(::Const.Perks.PerkDefs.BFFencer, 6);
		}

		addPerkGroup(::Const.Perks.GreatSwordTree.Tree);
		addPerkGroup(::Const.Perks.SwordTree.Tree);
	},

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeDefense] < 3) _talents[::Const.Attributes.MeleeSkill] += 1;
	}
});

//LegendNobleGuard
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendNobleGuard, {
	StatMod = { Hitpoints = [-75, -100], Bravery = [-15, -15], Stamina = [-10, -15], MeleeSkill = [-10, -12], RangedSkill = [-10, -10], MeleeDefense = [-15, -25], RangedDefense = [-15, -25], Initiative = [-5, -10] },
	Perks = ["Rotation", "LegendBackToBasics"],
	Requirements = ["NggHCharmWords"],
	Background = "legend_noble_shield",
	Difficulty = 35,

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeDefense] < 2) _talents[::Const.Attributes.MeleeDefense] += 1;
	}

});

//LegendManAtArms
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendManAtArms, {
	StatMod = { Hitpoints = [-75, -100], Bravery = [-25, -35], Stamina = [-20, -30], MeleeSkill = [-10, -12], RangedSkill = [-10, -10], MeleeDefense = [-15, -25], RangedDefense = [-15, -25], Initiative = [-10, -10] },
	Perks = ["Rotation", "ShieldExpert", "LegendBackToBasics"],
	Requirements = ["NggHCharmWords"],
	Background = "legend_man_at_arms_background",
	Difficulty = 45,

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeDefense] < 2) _talents[::Const.Attributes.MeleeDefense] += 1;
	}

});

//NobleEliteFootman
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.NobleEliteFootman, {
	StatMod = { Hitpoints = [-7, -15], Bravery = [-10, -10], Stamina = [-10, -10], MeleeSkill = [-8, -8], RangedSkill = [-5, -5], MeleeDefense = [0, -5], RangedDefense = [0, -3], Initiative = [-10, -10] },
	Perks = ["Rotation"],
	Background = "legend_noble_shield",
	Difficulty = 10,

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeDefense] < 2) _talents[::Const.Attributes.MeleeDefense] += 1;
	}

});

//NoblePollax
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.NoblePollax, {
	StatMod = { Hitpoints = [-23, -20], Bravery = [-25, -18], Stamina = [-10, -10], MeleeSkill = [-20, -15], RangedSkill = [0, 0], MeleeDefense = [-10, -10], RangedDefense = [-5, -5], Initiative = [-10, 0] },
	Perks = ["Rotation", "Backstabber"],
	Requirements = ["NggHCharmWords"],
	Background = "legend_noble_2h",
	Difficulty = 42,

	function onBuildPerkTree() {
		if (::Is_PTR_Exist) addPerkGroup(::Const.Perks.TwoHandedTree.Tree);

		addPerkGroup(::Const.Perks.PolearmTree.Tree);
	}

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.MeleeSkill] < 3) _talents[::Const.Attributes.MeleeSkill] += 1;
	}

});

//NobleSureshot
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.NobleSureshot, {
	StatMod = { Hitpoints = [-12, -7], Bravery = [-10, -10], Stamina = [-10, -10], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [-2, -1], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = ["Rotation"],
	Background = "legend_noble_ranged",
	Difficulty = 10,

	function onfillTalentsValues( _talents ) {
		if (_talents[::Const.Attributes.RangedSkill] < 2) _talents[::Const.Attributes.RangedSkill] += 1;
	}

});

//LegendCaravanPolearm
::Const.CharmedUnits.addDefaultEntry(::Const.EntityType.LegendCaravanPolearm, {
	StatMod = { Hitpoints = [-12, -10], Bravery = [-15, -12], Stamina = [-25, -20], MeleeSkill = [-10, -8], RangedSkill = [0, 0], MeleeDefense = [-2, 0], RangedDefense = [-2, 0], Initiative = [-10, 0] },
	Perks = ["Recover"],
	Background = "sellsword_background",
	Difficulty = 10,
	Custom = {ID = "background.caravan_hand"},

});

//LegendBasiliskDrone
{

}

//LegendBasiliskDroneLow
{

}

//LegendBasiliskSentry
{

}

//BanditOutrider
		
//LegendCatapult
	
//LegendHorse
	
//SkeletonGladiator
		
//BanditVermes
		
//SatoManhunter
		
//SatoManhunterVeteran

//SatoManhunterRanged

//SatoManhunterVeteranRanged
		
//LegendMummyLight
		
//LegendMummyMedium
	
//LegendMummyHeavy
		
//LegendMummyQueen
	
//KoboldFighter
	
//KoboldWolfrider

//LegendMummyPriest

/*
	//FreeCompanySpearman = 154,
		{
			StatMod = { Hitpoints = [-20, -8], Bravery = [-5, -5], Stamina = [-15, -15], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [-5, 0], RangedDefense = [0, 0], Initiative = [15, 35] },
			Perks = ["LegendSpecialistMilitiaSkill", "LegendSpecialistMilitiaDamage"],
			Background = "militia_background",
			Difficulty = 5,
		},

	//FreeCompanySlayer = 155,
		{
			StatMod = { Hitpoints = [-15, -10], Bravery = [0, 0], Stamina = [-10, -10], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [15, 25] },
			Perks = ["LegendBigGameHunter"],
			Background = "beast_hunter_background",
			Difficulty = 5,
		},

	//FreeCompanyFootman = 156,
		{
			StatMod = { Hitpoints = [-12, -10], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [-5, 0], RangedSkill = [-5, -5], MeleeDefense = [0, 0], RangedDefense = [-5, -5], Initiative = [5, 25] },
			Perks = ["BattleForged"],
			Background = "legend_noble_shield",
			Difficulty = 5,
		},

	//FreeCompanyArcher = 157,
		{
			StatMod = { Hitpoints = [-10, -5], Bravery = [0, 0], Stamina = [-10, -0], MeleeSkill = [0, 0], RangedSkill = [-5, -0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-10, -5] },
			Perks = ["Bullseye", "Anticipation"],
			Background = "hunter_background",
			Difficulty = 5,
		},

	//FreeCompanyCrossbow = 158,
		{
			StatMod = { Hitpoints = [-10, -5], Bravery = [0, 0], Stamina = [-10, -0], MeleeSkill = [0, 0], RangedSkill = [-5, -0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-10, -5] },
			Perks = ["Ballistics", "Anticipation"],
			Background = "legend_nightwatch_background",
			Difficulty = 5,
		},

	//FreeCompanyLongbow = 159,
		{
			StatMod = { Hitpoints = [-10, -5], Bravery = [0, 0], Stamina = [-10, -0], MeleeSkill = [0, 0], RangedSkill = [-5, -0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-10, -5] },
			Perks = ["HeadHunter", "Anticipation"],
			Requirements = ["NggHCharmWords"],
			Background = "hunter_background",
			Difficulty = 25,
		},

	//FreeCompanyBillman = 160,
		{
			StatMod = { Hitpoints = [-20, -15], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [-5, 0], RangedSkill = [-5, -5], MeleeDefense = [0, 0], RangedDefense = [-5, -5], Initiative = [5, 25] },
			Perks = ["Footwork", "Backstabber"],
			Requirements = ["NggHCharmWords"],
			Background = "beast_hunter_background",
			Difficulty = 25,
		},

	//FreeCompanyPikeman = 161,
		{
			StatMod = { Hitpoints = [-20, -15], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [-5, 0], RangedSkill = [-5, -5], MeleeDefense = [0, 0], RangedDefense = [-5, -5], Initiative = [5, 25] },
			Perks = ["Backstabber"],
			Background = "beast_hunter_background",
			Difficulty = 13,
		},

	//FreeCompanyInfantry = 162,
		{
			StatMod = { Hitpoints = [-25, -25], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [-10, -10], RangedSkill = [-5, -5], MeleeDefense = [0, 0], RangedDefense = [-5, -5], Initiative = [5, 25] },
			Perks = ["BattleForged", "SteelBrow"],
			Requirements = ["NggHCharmWords"],
			Background = "legend_noble_shield",
			Difficulty = 36,
		},

	//FreeCompanyLeader = 163,
		{
			StatMod = { Hitpoints = [-15, -15], Bravery = [-40, -40], Stamina = [-15, -5], MeleeSkill = [-10, -5], RangedSkill = [-5, -5], MeleeDefense = [-5, 0], RangedDefense = [0, 0], Initiative = [5, 15] },
			Perks = ["RallyTheTroops", "SunderingStrikes", "Footwork"],
			Requirements = ["NggHCharmWords"],
			Background = "orc_slayer_background",
			Difficulty = 37,
		},

	//FreeCompanyLeaderLow = 164,
		{
			StatMod = { Hitpoints = [-15, -15], Bravery = [-40, -40], Stamina = [-15, -5], MeleeSkill = [-10, -5], RangedSkill = [-5, -5], MeleeDefense = [-5, 0], RangedDefense = [0, 0], Initiative = [5, 15] },
			Perks = ["RallyTheTroops", "SunderingStrikes"],
			Requirements = ["NggHCharmWords"],
			Background = "orc_slayer_background",
			Difficulty = 25,
		},
*/