::mods_registerMod("mod_nggh_magic_concept", 2.2, "It\'s magic");
::mods_registerMod("mod_nggh_assets", 2.2);
::mods_registerMod("mod_nggh_skills", 2.2);
::mods_registerMod("mod_nggh_accessory_dog", 2.2);
::mods_registerCSS("camp_screen_butcher_dialog_module.css");
::mods_registerJS("camp_screen_butcher_dialog_module.js");
::mods_registerJS("mod_nggh_origins.js");

::mods_queue("mod_nggh_magic_concept", "mod_legends,>mod_legends_PTR", function()
{
	if ("accelvariant" in this.getroottable().Const)
	{
		this.logError("Mod mod_nggh_magic_concept is incompatible with zzz_horsemod_legend.");
	}
	else 
	{
	    this.Nggh_MagicConcept.hookAddRunes();
		this.Nggh_MagicConcept.hookAddSituation();
		this.Nggh_MagicConcept.hookHexeOrigin();
		this.Nggh_MagicConcept.hookEvents();
		this.Nggh_MagicConcept.hookWorldScenarios();
		this.Nggh_MagicConcept.hookAddCorpseDatabase();
		this.Const.CharacterBackgroundsRandom.extend([
			"geomancer_background",
			"battlemage_background",
			"elementalist_background",
			"diabolist_background",
		]);
	}
});

::mods_queue("mod_nggh_assets", "<mod_AC", function()
{
	this.HexenHooks.hookPlayerPartyAndAssets();
});

::mods_queue("mod_nggh_skills", "<mod_MSU", function()
{
	this.Nggh_MagicConcept.hookSkills();
	this.Nggh_MagicConcept.hookActives();
	this.Nggh_MagicConcept.hookEffects();
	this.Nggh_MagicConcept.hookRacial();
	this.Nggh_MagicConcept.hookTraits();
	this.Nggh_MagicConcept.hookPerks();
});

::mods_queue("mod_nggh_accessory_dog", ">mod_AC", function()
{
	this.Nggh_MagicConcept.hookAccessoryDog();
});


