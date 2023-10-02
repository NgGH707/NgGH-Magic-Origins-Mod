// the full table
local defaultTemplate =
{
	StatMod = { Hitpoints = [0, 0], Bravery = [-10, -5], Stamina = [0, 0], MeleeSkill = [-5, -5], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-25, -25] },
	Skills = ["actives/ghoul_claws", "actives/swallow_whole_skill"],
	Perks = ["HeadHunter", "Anticipation"],
	Requirements = ["NggHCharmEnemyGhoul"],
	Script = "player_beast/nggh_mod_ghoul_player",
	Background = "barbarian_background",
	PerkTree = "NachoTree",
	Difficulty = 15,

	Custom =  {
		ID = "background.legend_necromancer",
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 8, Stash = 9, Healing = 0.0, Injury = 0.0, Repair = 0.1, Salvage = 0.1, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.1, Gathering = 0.2, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		ExcludedTalents = [1, 5],
		Names = "NachoNames",
	},
	
	// all functions below will use '.call(background)'
	function onUpdate( _properties ) {}

	function onAdded() {}

	function onSetAppearance( _playerEntity, _enemyEntity ) {}

	function onBeforeBuildPerkTree() {}

	function onBuildPerkTree() {}

	function onBuildAttributes( _properties ) {}

	function onfillTalentsValues( _talents ) {}

	function onAddEquipment() {}

	function onSetup() {}

	function addTooltip( _tooltips ) {}
};


// example
// entry for necromancer entity type
local Necromancer = {
	StatMod = { Hitpoints = [0, 0], Bravery = [-10, -20], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Skills = [],
	Perks = ["LegendRaiseUndead"],
	Requirements = ["NggHCharmWords"],
	Background = "legend_necromancer_background",
	Difficulty = 33,

	function onBuildPerkTree() {
		this.addPerkGroup(::Const.Perks[::MSU.Array.rand(["ZombieMagicTree", "SkeletonMagicTree", "VampireMagicTree"])].Tree);
	}
};