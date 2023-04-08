// these files need to be loaded in a specific order
::include("mod_nggh/config/names.nut")
::include("mod_nggh/config/config.nut")
::include("mod_nggh/config/ai.nut")
::include("mod_nggh/config/character.nut")
::include("mod_nggh/config/corpse.nut")
::include("mod_nggh/config/mount.nut")
::include("mod_nggh/config/hex.nut")
::include("mod_nggh/config/hexe_origin.nut")
::include("mod_nggh/config/simp_levels.nut")
::include("mod_nggh/config/charmed_utilities.nut")
::include("mod_nggh/config/charmed_units.nut")
::include("mod_nggh/config/excluded_traits.nut")
::include("mod_nggh/config/attributes_levelup.nut")
::include("mod_nggh/config/lucky_rune_loot_table.nut")

// perk stuffs
::include("mod_nggh/config/perk_strings.nut")
::include("mod_nggh/config/perk_defs.nut")
::include("mod_nggh/config/perk_trees.nut")
::include("mod_nggh/config/perk_tree_templates.nut")

// update the perk tooltips
::Const.Perks.updatePerkGroupTooltips()

// load the hooks
::include("mod_nggh/hook_helper.nut")
foreach (file in ::IO.enumerateFiles("mod_nggh/hooks"))
{
	::include(file);
}

if (::Is_PTR_Exist)
{
	foreach (file in ::IO.enumerateFiles("mod_nggh/tweak_ptr"))
	{
		::include(file);
	}
}

if (::Is_AccessoryCompanions_Exist)
{
	foreach (file in ::IO.enumerateFiles("mod_nggh/tweak_ac"))
	{
		::include(file);
	}
}