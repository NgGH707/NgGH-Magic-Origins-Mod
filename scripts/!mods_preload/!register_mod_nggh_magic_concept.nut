::Nggh_MagicConcept <- {
	ID = "mod_nggh_magic_concept",
	Name = "NgGH Magic Concept",
	Version = "3.0.0-beta.60",
	ForceWhipPerk = false,
	Class = {},
};

::mods_registerMod(::Nggh_MagicConcept.ID, ::Nggh_MagicConcept.Version, "NecrOwO\'s Forbidden Magic");
::mods_queue(::Nggh_MagicConcept.ID, "mod_legends, mod_msu(>=1.2.4), >mod_legends_PTR", function()
{
	// define mod class of this mod
	::Nggh_MagicConcept.Mod <- ::MSU.Class.Mod(::Nggh_MagicConcept.ID, ::Nggh_MagicConcept.Version, ::Nggh_MagicConcept.Name);

	// add GitHub mod source
	::Nggh_MagicConcept.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, "https://github.com/NgGH707/NgGH-Magic-Origins-Mod");
	::Nggh_MagicConcept.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

	// add NexusMods mod source (for an easy link)
	::Nggh_MagicConcept.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.NexusMods, "https://www.nexusmods.com/battlebrothers/mods/207");
	// nexus api is closed, so can't really check update from it
	//::Nggh_MagicConcept.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.NexusMods);

	// important consts and objects
	::Is_PTR_Exist <- ::mods_getRegisteredMod("mod_legends_PTR") != null;
	::Is_PlanYourPerks_Exist <- ::mods_getRegisteredMod("mod_plan_perks") != null;
	::Is_AccessoryCompanions_Exist <- ::mods_getRegisteredMod("mod_AC") != null;

	// will probably put these to a callback after the new UI is connected
	::Nggh_MagicConcept.PerkTreeBuilder <- ::new("scripts/mods/perk_tree_builder");
	::Nggh_MagicConcept.TalentFiller <- ::new("scripts/mods/talent_filler");

	// set up mod settings 
	::Nggh_MagicConcept.mod_settings();
	::Nggh_MagicConcept.secret_contents();

	// load hook files
	::include("mod_nggh/load.nut");

	// register JS and CSS
	::mods_registerJS("nggh_hooks/character_screen_paperdoll_module.js");
	::mods_registerJS("nggh_hooks/turnsequencebar_module.js");
	::mods_registerCSS("nggh_hooks/turnsequencebar_module.css");
	
	//::nggh_processingEntries();
	//::nggh_overwriteEntries();

});

