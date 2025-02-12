::Nggh_MagicConcept <- {
	ID = "mod_nggh_magic_concept",
	Name = "NgGH\'s Magic Concept",
	Version = "3.0.0-beta.83",
	ForceWhipPerk = false,
	Class = {},
};

::Nggh_MagicConcept.HooksMod <- ::Hooks.register(::Nggh_MagicConcept.ID, ::Nggh_MagicConcept.Version, "NecrOwO\'s Forbidden Magic");

// mods need to run this mod
::Nggh_MagicConcept.HooksMod.require(["mod_msu >= 1.2.7", "mod_legends >= 19.0.0"]);

// this queue is to load the mod
::Nggh_MagicConcept.HooksMod.queue([">mod_msu", ">mod_legends"], function() {
	// define mod class of this mod
	::Nggh_MagicConcept.Mod <- ::MSU.Class.Mod(::Nggh_MagicConcept.ID, ::Nggh_MagicConcept.Version, ::Nggh_MagicConcept.Name);

	// add GitHub mod source
	::Nggh_MagicConcept.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, "https://github.com/NgGH707/NgGH-Magic-Origins-Mod");
	::Nggh_MagicConcept.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

	// add NexusMods mod source (for an easy link)
	//::Nggh_MagicConcept.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.NexusMods, "https://www.nexusmods.com/battlebrothers/mods/207");
	// nexus api is closed, so can't really check update from it
	//::Nggh_MagicConcept.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.NexusMods);

	// important consts and objects
	::Is_PTR_Exist <- ::Hooks.hasMod("mod_legends_PTR");
	::Is_PlanYourPerks_Exist <- ::Hooks.hasMod("mod_plan_perks");
	::Is_AccessoryCompanions_Exist <- ::Hooks.hasMod("mod_AC");

	// set up mod settings 
	::Nggh_MagicConcept.mod_settings();
	::Nggh_MagicConcept.secret_contents();

	// load hook files
	::include("mod_nggh/load.nut");
});

::Nggh_MagicConcept.HooksMod.queue([">mod_msu", ">mod_legends"], function() {
	::include("mod_nggh/config/charmed_units.nut"); // read this last
	//::nggh_processingEntries();
	//::nggh_overwriteEntries();
}, ::Hooks.QueueBucket.AfterHooks);