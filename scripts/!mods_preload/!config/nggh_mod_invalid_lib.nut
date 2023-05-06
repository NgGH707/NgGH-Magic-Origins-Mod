// stuffs that must be excluded from mod_item_spawner processing

if (!("Invalid" in ::Const))
{
	::Const.Invalid <- {};
}

local backgrounds = [
	"scripts/skills/backgrounds/nggh_mod_charmed_background",
	"scripts/skills/backgrounds/nggh_mod_charmed_human_background",
	"scripts/skills/backgrounds/nggh_mod_hexe_background",
	"scripts/skills/backgrounds/nggh_mod_luft_background",
	"scripts/skills/backgrounds/nggh_mod_spider_eggs_background",
	"scripts/skills/backgrounds/charmed_human_engineer_background",
];

// backgrounds
if (!("Backgrounds" in ::Const.Invalid))
{
	::Const.Invalid.Backgrounds <- backgrounds;
}
else
{
	::Const.Invalid.Backgrounds.extend(backgrounds);
}


local items = [
	"scripts/items/weapons/nggh707_skull_of_the_dead",
	"scripts/items/helmets/nggh707_headgear",
	"scripts/items/tools/catapult_item",
	"scripts/items/tools/mortar_item",
	"scripts/items/ammo/bomb_bag",
	"scripts/items/accessory/nggh_mod_accessory_spider",
	"scripts/items/accessory/named/nggh_mod_named_accessory"
];

if (!("Invalid" in ::Const))
{
	::Const.Invalid <- {};
}

// items
if (!("Items" in ::Const.Invalid))
{
	::Const.Invalid.Items <- items;
}
else
{
	::Const.Invalid.Items.extend(items);
}

