// new troop
local inquisitor_titles = [];
inquisitor_titles.extend(::Const.Strings.WitchhunterTitles);
inquisitor_titles.extend(::Const.Strings.PilgrimTitles);

::Const.World.Spawn.Troops.Inquisitor <- {
	ID = ::Const.EntityType.Knight,
	Variant = 2,
	Strength = 40,
	Cost = 40,
	Row = 0,
	Script = "scripts/entity/tactical/humans/nggh_mod_inquisitor",
	NameList = ::Const.Strings.KnightNames,
	TitleList = inquisitor_titles
};