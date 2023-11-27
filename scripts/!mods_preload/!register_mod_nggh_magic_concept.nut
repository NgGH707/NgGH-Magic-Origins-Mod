::Nggh_MagicConcept <- {
	ID = "mod_nggh_magic_concept",
	Name = "NgGH Magic Concept",
	Version = "3.0.0-beta.72",
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

	// set up mod settings 
	::Nggh_MagicConcept.mod_settings();
	::Nggh_MagicConcept.secret_contents();

	// load hook files
	::include("mod_nggh/load.nut");
	
	//::nggh_processingEntries();
	//::nggh_overwriteEntries();
});


