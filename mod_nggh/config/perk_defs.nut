
::Const.Perks.addPerkDefObjects([
// hexe
	// charm enemy perks
	{
		ID = "perk.charm_enemy_spider",
		Script = "scripts/skills/perks/perk_nggh_charm_enemy_spider",
		Name = ::Const.Strings.PerkName.NggHCharmEnemySpider,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmEnemySpider,
		Icon = "ui/perks/charmed_spider_01.png",
		IconDisabled = "ui/perks/charmed_spider_01_sw.png",
		Const = "NggHCharmEnemySpider"
	},
	{
		ID = "perk.charm_enemy_direwolf",
		Script = "scripts/skills/perks/perk_nggh_charm_enemy_direwolf",
		Name = ::Const.Strings.PerkName.NggHCharmEnemyDirewolf,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmEnemyDirewolf,
		Icon = "ui/perks/charmed_direwolf_01.png",
		IconDisabled = "ui/perks/charmed_direwolf_01_sw.png",
		Const = "NggHCharmEnemyDirewolf" 
	},
	{
		ID = "perk.charm_enemy_alp",
		Script = "scripts/skills/perks/perk_nggh_charm_enemy_alp",
		Name = ::Const.Strings.PerkName.NggHCharmEnemyAlp,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmEnemyAlp,
		Icon = "ui/perks/charmed_alps_01.png",
		IconDisabled = "ui/perks/charmed_alps_01_sw.png",
		Const = "NggHCharmEnemyAlp" 
	},
	{
		ID = "perk.charm_enemy_ghoul",
		Script = "scripts/skills/perks/perk_nggh_charm_enemy_ghoul",
		Name = ::Const.Strings.PerkName.NggHCharmEnemyGhoul,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmEnemyGhoul,
		Icon = "ui/perks/charmed_ghoul_01.png",
		IconDisabled = "ui/perks/charmed_ghoul_01_sw.png",
		Const = "NggHCharmEnemyGhoul"
	},
	{
		ID = "perk.charm_enemy_unhold",
		Script = "scripts/skills/perks/perk_nggh_charm_enemy_unhold",
		Name = ::Const.Strings.PerkName.NggHCharmEnemyUnhold,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmEnemyUnhold,
		Icon = "ui/perks/charmed_unhold_01.png",
		IconDisabled = "ui/perks/charmed_unhold_01_sw.png",
		Const = "NggHCharmEnemyUnhold"
	},
	{
		ID = "perk.charm_enemy_schrat",
		Script = "scripts/skills/perks/perk_nggh_charm_enemy_schrat",
		Name = ::Const.Strings.PerkName.NggHCharmEnemySchrat,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmEnemySchrat,
		Icon = "ui/perks/charmed_schrat_01.png",
		IconDisabled = "ui/perks/charmed_schrat_01_sw.png",
		Const = "NggHCharmEnemySchrat"
	},
	{
		ID = "perk.charm_enemy_lindwurm",
		Script = "scripts/skills/perks/perk_nggh_charm_enemy_lindwurm",
		Name = ::Const.Strings.PerkName.NggHCharmEnemyLindwurm,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmEnemyLindwurm,
		Icon = "ui/perks/charmed_lindwurm_01.png",
		IconDisabled = "ui/perks/charmed_lindwurm_01_sw.png",
		Const = "NggHCharmEnemyLindwurm"
	},
	{
		ID = "perk.charm_enemy_ork",
		Script = "scripts/skills/perks/perk_nggh_charm_enemy_ork",
		Name = ::Const.Strings.PerkName.NggHCharmEnemyOrk,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmEnemyOrk,
		Icon = "ui/perks/charmed_ork_01.png",
		IconDisabled = "ui/perks/charmed_ork_01_sw.png",
		Const = "NggHCharmEnemyOrk" 
	},
	{
		ID = "perk.charm_enemy_goblin",
		Script = "scripts/skills/perks/perk_nggh_charm_enemy_goblin",
		Name = ::Const.Strings.PerkName.NggHCharmEnemyGoblin,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmEnemyGoblin,
		Icon = "ui/perks/charmed_goblin_01.png",
		IconDisabled = "ui/perks/charmed_goblin_01_sw.png",
		Const = "NggHCharmEnemyGoblin"
	},

	// charm humans and better charm perks
	{
		ID = "perk.boobas_charm",
		Script = "scripts/skills/perks/perk_nggh_charm_basic",
		Name = ::Const.Strings.PerkName.NggHCharmBasic,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmBasic,
		Icon = "ui/perks/perk_basic_charm.png",
		IconDisabled = "ui/perks/perk_basic_charm_sw.png", 
		Const = "NggHCharmBasic",
	},
	{
		ID = "perk.words_charm",
		Script = "scripts/skills/perks/perk_nggh_charm_words",
		Name = ::Const.Strings.PerkName.NggHCharmWords,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmWords,
		Icon = "ui/perks/perk_words_charm.png",
		IconDisabled = "ui/perks/perk_words_charm_sw.png",
		Const = "NggHCharmWords"
	},
	{
		ID = "perk.appearance_charm",
		Script = "scripts/skills/perks/perk_nggh_charm_apppearance",
		Name = ::Const.Strings.PerkName.NggHCharmAppearance,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmAppearance,
		Icon = "ui/perks/perk_apppearance_charm.png",
		IconDisabled = "ui/perks/perk_apppearance_charm_sw.png",
		Const = "NggHCharmAppearance"
	},
	{
		ID = "perk.mastery_charm",
		Script = "scripts/skills/perks/perk_nggh_charm_mastery",
		Name = ::Const.Strings.PerkName.NggHCharmSpec,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmSpec,
		Icon = "ui/perks/perk_charm.png",
		IconDisabled = "ui/perks/perk_charm_sw.png",
		Const = "NggHCharmSpec",
	},
	{
		ID = "perk.charm_nudist",
		Script = "scripts/skills/perks/perk_nggh_charm_nudist",
		Name = ::Const.Strings.PerkName.NggHCharmNudist,
		Tooltip = ::Const.Strings.PerkDescription.NggHCharmNudist,
		Icon = "ui/perks/perk_charm_nudist.png",
		IconDisabled = "ui/perks/perk_charm_nudist_sw.png",
		Const = "NggHCharmNudist"
	},

	// hex stuffs
	{
		ID = "perk.hex_hexer",
		Script = "scripts/skills/perks/perk_nggh_hex_hexer",
		Name = ::Const.Strings.PerkName.NggHHexHexer,
		Tooltip = ::Const.Strings.PerkDescription.NggHHexHexer,
		Icon = "ui/perks/perk_hexer.png",
		IconDisabled = "ui/perks/perk_hexer_sw.png",
		Const = "NggHHexHexer"
	},
	{
		ID = "perk.hex_mastery",
		Script = "scripts/skills/perks/perk_nggh_hex_mastery",
		Name = ::Const.Strings.PerkName.NggHHexMastery,
		Tooltip = ::Const.Strings.PerkDescription.NggHHexMastery,
		Icon = "ui/perks/perk_hex_mastery.png",
		IconDisabled = "ui/perks/perk_hex_mastery_sw.png",
		Const = "NggHHexMastery"
	},
	{
		ID = "perk.hex_share_the_pain",
		Script = "scripts/skills/perks/perk_nggh_hex_share_the_pain",
		Name = ::Const.Strings.PerkName.NggHHexSharePain,
		Tooltip = ::Const.Strings.PerkDescription.NggHHexSharePain,
		Icon = "ui/perks/perk_share_the_pain.png",
		IconDisabled = "ui/perks/perk_share_the_pain_sw.png",
		Const = "NggHHexSharePain"
	},
	{
		ID = "perk.hex_suffering",
		Script = "scripts/skills/perks/perk_nggh_hex_suffering",
		Name = ::Const.Strings.PerkName.NggHHexSuffering,
		Tooltip = ::Const.Strings.PerkDescription.NggHHexSuffering,
		Icon = "ui/perks/perk_hex_cyan.png", ///// cyan
		IconDisabled = "ui/perks/perk_hex_mastery_sw.png",
		Const = "NggHHexSuffering"
	},
	{
		ID = "perk.hex_weakening",
		Script = "scripts/skills/perks/perk_nggh_hex_weakening",
		Name = ::Const.Strings.PerkName.NggHHexWeakening,
		Tooltip = ::Const.Strings.PerkDescription.NggHHexWeakening,
		Icon = "ui/perks/perk_hex_yellow.png", ///// yellow
		IconDisabled = "ui/perks/perk_hex_mastery_sw.png",
		Const = "NggHHexWeakening"
	},
	{
		ID = "perk.hex_vulnerability",
		Script = "scripts/skills/perks/perk_nggh_hex_vulnerability",
		Name = ::Const.Strings.PerkName.NggHHexVulnerability,
		Tooltip = ::Const.Strings.PerkDescription.NggHHexVulnerability,
		Icon = "ui/perks/perk_hex_purple.png", ///// purple
		IconDisabled = "ui/perks/perk_hex_mastery_sw.png",
		Const = "NggHHexVulnerability"
	},
	{
		ID = "perk.hex_misfortune",
		Script = "scripts/skills/perks/perk_nggh_hex_misfortune",
		Name = ::Const.Strings.PerkName.NggHHexMisfortune,
		Tooltip = ::Const.Strings.PerkDescription.NggHHexMisfortune,
		Icon = "ui/perks/perk_hex_green.png", ///// green
		IconDisabled = "ui/perks/perk_hex_mastery_sw.png",
		Const = "NggHHexMisfortune"
	},

// luft
	{
		ID = "perk.patting",
		Script = "scripts/skills/perks/perk_nggh_luft_patting_mastery",
		Name = ::Const.Strings.PerkName.NggHLuftPattingSpec,
		Tooltip = ::Const.Strings.PerkDescription.NggHLuftPattingSpec,
		Icon = "ui/perks/perk_patting.png",
		IconDisabled = "ui/perks/perk_patting_sw.png",
		Const = "NggHLuftPattingSpec", 
	},
	{
		ID = "perk.boobas_charm",
		Script = "scripts/skills/perks/perk_nggh_luft_unholy_fruits",
		Name = ::Const.Strings.PerkName.NggHLuftUnholyFruits,
		Tooltip = ::Const.Strings.PerkDescription.NggHLuftUnholyFruits,
		Icon = "ui/perks/perk_unholy_fruits.png",
		IconDisabled = "ui/perks/perk_unholy_fruits_sw.png",
		Const = "NggHLuftUnholyFruits",
	},
	{
		ID = "perk.words_charm",
		Script = "scripts/skills/perks/perk_nggh_luft_innocent_look",
		Name = ::Const.Strings.PerkName.NggHLuftInnocentLook,
		Tooltip = ::Const.Strings.PerkDescription.NggHLuftInnocentLook,
		Icon = "ui/perks/perk_innocent_look.png",
		IconDisabled = "ui/perks/perk_innocent_look_sw.png",
		Const = "NggHLuftInnocentLook",
	},
	{
		ID = "perk.appearance_charm",
		Script = "scripts/skills/perks/perk_nggh_luft_ghoulish_beauty",
		Name = ::Const.Strings.PerkName.NggHLuftGhoulBeauty,
		Tooltip = ::Const.Strings.PerkDescription.NggHLuftGhoulBeauty,
		Icon = "ui/perks/perk_ghoulish_beauty.png",
		IconDisabled = "ui/perks/perk_ghoulish_beauty_sw.png",
		Const = "NggHLuftGhoulBeauty",
	},

// eggs
	{
		ID = "perk.breeding_machine",
		Script = "scripts/skills/perks/perk_nggh_egg_breeding_machine",
		Name = ::Const.Strings.PerkName.NggHEggBreedingMachine,
		Tooltip = ::Const.Strings.PerkDescription.NggHEggBreedingMachine,
		Icon = "ui/perks/perk_breeding_machine.png",
		IconDisabled = "ui/perks/perk_breeding_machine_sw.png",
		Const = "NggHEggBreedingMachine"
	},
	{
		ID = "perk.inherit",
		Script = "scripts/skills/perks/perk_nggh_egg_inherit",
		Name = ::Const.Strings.PerkName.NggHEggInherit,
		Tooltip = ::Const.Strings.PerkDescription.NggHEggInherit,
		Icon = "ui/perks/perk_inherit.png",
		IconDisabled = "ui/perks/perk_inherit_sw.png",
		Const = "NggHEggInherit"
	},
	{
		ID = "perk.natural_selection",
		Script = "scripts/skills/perks/perk_nggh_egg_natural_selection",
		Name = ::Const.Strings.PerkName.NggHEggNaturalSelection,
		Tooltip = ::Const.Strings.PerkDescription.NggHEggNaturalSelection,
		Icon = "ui/perks/perk_natural_selection.png",
		IconDisabled = "ui/perks/perk_natural_selection_sw.png",
		Const = "NggHEggNaturalSelection"
	},
	{
		ID = "perk.attach_egg",
		Script = "scripts/skills/perks/perk_nggh_egg_attach",
		Name = ::Const.Strings.PerkName.NggHEggAttachSpider,
		Tooltip = ::Const.Strings.PerkDescription.NggHEggAttachSpider,
		Icon = "ui/perks/perk_attach_egg.png",
		IconDisabled = "ui/perks/perk_attach_egg_sw.png",
		Const = "NggHEggAttachSpider"
	},

// spider
	{
		ID = "perk.spider_bite",
		Script = "scripts/skills/perks/perk_nggh_spider_bite",
		Name = ::Const.Strings.PerkName.NggHSpiderBite,
		Tooltip = ::Const.Strings.PerkDescription.NggHSpiderBite,
		Icon = "ui/perks/perk_spider_bite.png",
		IconDisabled = "ui/perks/perk_spider_bite_sw.png",
		Const = "NggHSpiderBite",
	},
	{
		ID = "perk.spider_venom",
		Script = "scripts/skills/perks/perk_nggh_spider_venom",
		Name = ::Const.Strings.PerkName.NggHSpiderVenom,
		Tooltip = ::Const.Strings.PerkDescription.NggHSpiderVenom,
		Icon = "ui/perks/perk_venomous.png",
		IconDisabled = "ui/perks/perk_venomous_sw.png",
		Const = "NggHSpiderVenom",
	},
	{
		ID = "perk.spider_web",
		Script = "scripts/skills/perks/perk_nggh_spider_web",
		Name = ::Const.Strings.PerkName.NggHSpiderWeb,
		Tooltip = ::Const.Strings.PerkDescription.NggHSpiderWeb,
		Icon = "ui/perks/perk_spider_web.png",
		IconDisabled = "ui/perks/perk_spider_web_sw.png",
		Const = "NggHSpiderWeb",
	},

// serpent
	{
		ID = "perk.serpent_bite",
		Script = "scripts/skills/perks/perk_nggh_serpent_bite",
		Name = ::Const.Strings.PerkName.NggHSerpentBite,
		Tooltip = ::Const.Strings.PerkDescription.NggHSerpentBite,
		Icon = "ui/perks/perk_serpent_bite.png",
		IconDisabled = "ui/perks/perk_serpent_bite_sw.png",
		Const = "NggHSerpentBite",
	},
	{
		ID = "perk.serpent_drag",
		Script = "scripts/skills/perks/perk_nggh_serpent_drag",
		Name = ::Const.Strings.PerkName.NggHSerpentDrag,
		Tooltip = ::Const.Strings.PerkDescription.NggHSerpentDrag,
		Icon = "ui/perks/perk_serpent_drag.png",
		IconDisabled = "ui/perks/perk_serpent_drag_sw.png",
		Const = "NggHSerpentDrag",
	},
	{
		ID = "perk.serpent_venom",
		Script = "scripts/skills/perks/perk_nggh_serpent_venom",
		Name = ::Const.Strings.PerkName.NggHSerpentVenom,
		Tooltip = ::Const.Strings.PerkDescription.NggHSerpentVenom,
		Icon = "ui/perks/perk_venomous.png",
		IconDisabled = "ui/perks/perk_venomous_sw.png",
		Const = "NggHSerpentVenom",
	},
	{
		ID = "perk.serpent_giant",
		Script = "scripts/skills/perks/perk_nggh_serpent_giant",
		Name = ::Const.Strings.PerkName.NggHSerpentGiant,
		Tooltip = ::Const.Strings.PerkDescription.NggHSerpentGiant,
		Icon = "ui/perks/perk_giant_serpent.png",
		IconDisabled = "ui/perks/perk_giant_serpent_sw.png",
		Const = "NggHSerpentGiant",
	},

// hyena
	{
		ID = "perk.hyena_bite",
		Script = "scripts/skills/perks/perk_nggh_hyena_bite",
		Name = ::Const.Strings.PerkName.NggHHyenaBite,
		Tooltip = ::Const.Strings.PerkDescription.NggHHyenaBite,
		Icon = "ui/perks/perk_hyena_bite.png",
		IconDisabled = "ui/perks/perk_hyena_bite_sw.png",
		Const = "NggHHyenaBite",
	},

// wolf
	{
		ID = "perk.wolf_bite",
		Script = "scripts/skills/perks/perk_nggh_wolf_bite",
		Name = ::Const.Strings.PerkName.NggHWolfBite,
		Tooltip = ::Const.Strings.PerkDescription.NggHWolfBite,
		Icon = "ui/perks/perk_wolf_bite.png",
		IconDisabled = "ui/perks/perk_wolf_bite_sw.png",
		Const = "NggHWolfBite",
	},
	{
		ID = "perk.thick_hide",
		Script = "scripts/skills/perks/perk_nggh_wolf_thick_hide",
		Name = ::Const.Strings.PerkName.NggHWolfThickHide,
		Tooltip = ::Const.Strings.PerkDescription.NggHWolfThickHide,
		Icon = "ui/perks/perk_thick_hide.png",
		IconDisabled = "ui/perks/perk_thick_hide_sw.png",
		Const = "NggHWolfThickHide",
	},
	{
		ID = "perk.enrage_wolf",
		Script = "scripts/skills/perks/perk_nggh_wolf_enrage",
		Name = ::Const.Strings.PerkName.NggHWolfEnrage,
		Tooltip = ::Const.Strings.PerkDescription.NggHWolfEnrage,
		Icon = "ui/perks/perk_enrage_wolf.png",
		IconDisabled = "ui/perks/perk_enrage_wolf_sw.png",
		Const = "NggHWolfEnrage",
	},
	{
		ID = "perk.rabies",
		Script = "scripts/skills/perks/perk_nggh_wolf_rabies",
		Name = ::Const.Strings.PerkName.NggHWolfRabies,
		Tooltip = ::Const.Strings.PerkDescription.NggHWolfRabies,
		Icon = "ui/perks/perk_rabies.png",
		IconDisabled = "ui/perks/perk_rabies_sw.png",
		Const = "NggHWolfRabies",
	},

// alp
	{
		ID = "perk.mastery_nightmare",
		Script = "scripts/skills/perks/perk_nggh_alp_nightmare_mastery",
		Name = ::Const.Strings.PerkName.NggHAlpNightmareSpec,
		Tooltip = ::Const.Strings.PerkDescription.NggHAlpNightmareSpec,
		Icon = "ui/perks/perk_mastery_nightmare.png",
		IconDisabled = "ui/perks/perk_mastery_nightmare_sw.png",
		Const = "NggHAlpNightmareSpec",
	},
	{
		ID = "perk.mastery_sleep",
		Script = "scripts/skills/perks/perk_nggh_alp_sleep_mastery",
		Name = ::Const.Strings.PerkName.NggHAlpSleepSpec,
		Tooltip = ::Const.Strings.PerkDescription.NggHAlpSleepSpec,
		Icon = "ui/perks/perk_mastery_sleep.png",
		IconDisabled = "ui/perks/perk_mastery_sleep_sw.png",
		Const = "NggHAlpSleepSpec",
	},
	{
		ID = "perk.after_wake",
		Script = "scripts/skills/perks/perk_nggh_alp_after_wake",
		Name = ::Const.Strings.PerkName.NggHAlpAfterWake,
		Tooltip = ::Const.Strings.PerkDescription.NggHAlpAfterWake,
		Icon = "ui/perks/perk_after_wake.png",
		IconDisabled = "ui/perks/perk_after_wake_sw.png",
		Const = "NggHAlpAfterWake",
	},
	{
		ID = "perk.afterimage",
		Script = "scripts/skills/perks/perk_nggh_alp_afterimage",
		Name = ::Const.Strings.PerkName.NggHAlpAfterimage,
		Tooltip = ::Const.Strings.PerkDescription.NggHAlpAfterimage,
		Icon = "ui/perks/perk_afterimage.png",
		IconDisabled = "ui/perks/perk_afterimage_sw.png",
		Const = "NggHAlpAfterimage"
	},
	{
		ID = "perk.alp_living_nightmare",
		Script = "scripts/skills/perks/perk_nggh_alp_living_nightmare",
		Name = ::Const.Strings.PerkName.NggHAlpLivingNightmare,
		Tooltip = ::Const.Strings.PerkDescription.NggHAlpLivingNightmare,
		Icon = "ui/perks/perk_alp_living_nightmare.png",
		IconDisabled = "ui/perks/perk_alp_living_nightmare_sw.png",
		Const = "NggHAlpLivingNightmare"
	},
	{
		ID = "perk.mind_break",
		Script = "scripts/skills/perks/perk_nggh_alp_mind_break",
		Name = ::Const.Strings.PerkName.NggHAlpMindBreak,
		Tooltip = ::Const.Strings.PerkDescription.NggHAlpMindBreak,
		Icon = "ui/perks/perk_mind_break.png",
		IconDisabled = "ui/perks/perk_mind_break_sw.png",
		Const = "NggHAlpMindBreak"
	},

// demon alp
	{
		ID = "perk.control_flame",
		Script = "scripts/skills/perks/perk_nggh_alp_control_flame",
		Name = ::Const.Strings.PerkName.NggHAlpControlFlame,
		Tooltip = ::Const.Strings.PerkDescription.NggHAlpControlFlame,
		Icon = "ui/perks/perk_hellish_flame.png",
		IconDisabled = "ui/perks/perk_hellish_flame_sw.png",
		Const = "NggHAlpControlFlame"
	},
	{
		ID = "perk.fiece_flame",
		Script = "scripts/skills/perks/perk_nggh_alp_fiece_flame",
		Name = ::Const.Strings.PerkName.NggHAlpFieceFlame,
		Tooltip = ::Const.Strings.PerkDescription.NggHAlpFieceFlame,
		Icon = "ui/perks/perk_hellish_flame.png",
		IconDisabled = "ui/perks/perk_hellish_flame_sw.png",
		Const = "NggHAlpFieceFlame"
	},
	{
		ID = "perk.hellish_flame",
		Script = "scripts/skills/perks/perk_nggh_alp_hellish_flame",
		Name = ::Const.Strings.PerkName.NggHAlpHellishFlame,
		Tooltip = ::Const.Strings.PerkDescription.NggHAlpHellishFlame,
		Icon = "ui/perks/perk_hellish_flame.png",
		IconDisabled = "ui/perks/perk_hellish_flame_sw.png",
		Const = "NggHAlpHellishFlame"
	},
	{
		ID = "perk.shadow_copy",
		Script = "scripts/skills/perks/perk_nggh_alp_shadow_copy",
		Name = ::Const.Strings.PerkName.NggHAlpShadowCopy,
		Tooltip = ::Const.Strings.PerkDescription.NggHAlpShadowCopy,
		Icon = "ui/perks/perk_afterimage.png",
		IconDisabled = "ui/perks/perk_afterimage_sw.png",
		Const = "NggHAlpShadowCopy"
	},

// nacho
	{
		ID = "perk.nacho",
		Script = "scripts/skills/perks/perk_nggh_nacho",
		Name = ::Const.Strings.PerkName.NggHNacho,
		Tooltip = ::Const.Strings.PerkDescription.NggHNacho,
		Icon = "ui/perks/perk_nacho.png",
		IconDisabled = "ui/perks/perk_nacho_sw.png",
		Const = "NggHNacho"
	},
	{
		ID = "perk.nacho_eat",
		Script = "scripts/skills/perks/perk_nggh_nacho_eat",
		Name = ::Const.Strings.PerkName.NggHNachoEat,
		Tooltip = ::Const.Strings.PerkDescription.NggHNachoEat,
		Icon = "ui/perks/perk_energize_meal.png",
		IconDisabled = "ui/perks/perk_energize_meal_sw.png",
		Const = "NggHNachoEat"
	},
	{
		ID = "perk.frenzy",
		Script = "scripts/skills/perks/perk_nggh_nacho_frenzy",
		Name = ::Const.Strings.PerkName.NggHNachoFrenzy,
		Tooltip = ::Const.Strings.PerkDescription.NggHNachoFrenzy,
		Icon = "ui/perks/perk_madden.png",
		IconDisabled = "ui/perks/perk_madden_sw.png",
		Const = "NggHNachoFrenzy"
	},
	{
		ID = "perk.nacho_vomit",
		Script = "scripts/skills/perks/perk_nggh_nacho_vomit",
		Name = ::Const.Strings.PerkName.NggHNachoVomit,
		Tooltip = ::Const.Strings.PerkDescription.NggHNachoVomit,
		Icon = "ui/perks/perk_nacho_vomiting.png",
		IconDisabled = "ui/perks/perk_nacho_vomiting_sw.png",
		Const = "NggHNachoVomit"
	},
	{
		ID = "perk.nacho_big_tummy",
		Script = "scripts/skills/perks/perk_nggh_nacho_big_tummy",
		Name = ::Const.Strings.PerkName.NggHNachoBigTummy,
		Tooltip = ::Const.Strings.PerkDescription.NggHNachoBigTummy,
		Icon = "ui/perks/perk_nacho_big_tummy.png",
		IconDisabled = "ui/perks/perk_nacho_big_tummy_sw.png",
		Const = "NggHNachoBigTummy"
	},
	{
		ID = "perk.nacho_scavenger",
		Script = "scripts/skills/perks/perk_nggh_nacho_scavenger",
		Name = ::Const.Strings.PerkName.NggHNachoScavenger,
		Tooltip = ::Const.Strings.PerkDescription.NggHNachoScavenger,
		Icon = "ui/perks/perk_scavenger.png",
		IconDisabled = "ui/perks/perk_scavenger_sw.png",
		Const = "NggHNachoScavenger"
	},

// unhold
	{
		ID = "perk.unhold_hand_to_hand",
		Script = "scripts/skills/perks/perk_nggh_unhold_hand_to_hand",
		Name = ::Const.Strings.PerkName.NggHUnholdUnarmedAttack,
		Tooltip = ::Const.Strings.PerkDescription.NggHUnholdUnarmedAttack,
		Icon = "ui/perks/perk_unhold_hand_to_hand.png",
		IconDisabled = "ui/perks/perk_unhold_hand_to_hand_sw.png",
		Const = "NggHUnholdUnarmedAttack"
	},
	{
		ID = "perk.unhold_fling",
		Script = "scripts/skills/perks/perk_nggh_unhold_fling",
		Name = ::Const.Strings.PerkName.NggHUnholdFling,
		Tooltip = ::Const.Strings.PerkDescription.NggHUnholdFling,
		Icon = "ui/perks/perk_unhold_fling.png",
		IconDisabled = "ui/perks/perk_unhold_fling_sw.png",
		Const = "NggHUnholdFling"
	},

// schrat
	{
		ID = "perk.grow_shield",
		Script = "scripts/skills/perks/perk_nggh_schrat_grow_shield",
		Name = ::Const.Strings.PerkName.NggHSchratShield,
		Tooltip = ::Const.Strings.PerkDescription.NggHSchratShield,
		Icon = "ui/perks/perk_grow_shield.png",
		IconDisabled = "ui/perks/perk_grow_shield_sw.png",
		Const = "NggHSchratShield"
	},
	{
		ID = "perk.sapling",
		Script = "scripts/skills/perks/perk_nggh_schrat_sapling",
		Name = ::Const.Strings.PerkName.NggHSchratSapling,
		Tooltip = ::Const.Strings.PerkDescription.NggHSchratSapling,
		Icon = "ui/perks/perk_sapling.png",
		IconDisabled = "ui/perks/perk_sapling_sw.png",
		Const = "NggHSchratSapling"
	},
	{
		ID = "perk.uproot",
		Script = "scripts/skills/perks/perk_nggh_schrat_uproot",
		Name = ::Const.Strings.PerkName.NggHSchratUproot,
		Tooltip = ::Const.Strings.PerkDescription.NggHSchratUproot,
		Icon = "ui/perks/perk_uproot.png",
		IconDisabled = "ui/perks/perk_uproot_sw.png",
		Const = "NggHSchratUproot"
	},
	{
		ID = "perk.uproot_aoe",
		Script = "scripts/skills/perks/perk_nggh_schrat_uproot_aoe",
		Name = ::Const.Strings.PerkName.NggHSchratUprootAoE,
		Tooltip = ::Const.Strings.PerkDescription.NggHSchratUprootAoE,
		Icon = "ui/perks/perk_uproot_aoe.png",
		IconDisabled = "ui/perks/perk_uproot_aoe_sw.png",
		Const = "NggHSchratUprootAoE"
	},

// lindwurm
	{
		ID = "perk.lindwurm_acid",
		Script = "scripts/skills/perks/perk_nggh_lindwurm_acid",
		Name = ::Const.Strings.PerkName.NggHLindwurmAcid,
		Tooltip = ::Const.Strings.PerkDescription.NggHLindwurmAcid,
		Icon = "ui/perks/perk_lindwurm_acid.png",
		IconDisabled = "ui/perks/perk_lindwurm_acid_sw.png",
		Const = "NggHLindwurmAcid"
	},
	{
		ID = "perk.intimidate",
		Script = "scripts/skills/perks/perk_nggh_lindwurm_intimidate",
		Name = ::Const.Strings.PerkName.NggHLindwurmIntimidate,
		Tooltip = ::Const.Strings.PerkDescription.NggHLindwurmIntimidate,
		Icon = "ui/perks/perk_intimidate.png",
		IconDisabled = "ui/perks/perk_intimidate_sw.png",
		Const = "NggHLindwurmIntimidate"
	},
	{
		ID = "perk.lindwurm_body",
		Script = "scripts/skills/perks/perk_nggh_lindwurm_body",
		Name = ::Const.Strings.PerkName.NggHLindwurmBody,
		Tooltip = ::Const.Strings.PerkDescription.NggHLindwurmBody,
		Icon = "ui/perks/perk_lindwurm_body.png",
		IconDisabled = "ui/perks/perk_lindwurm_body_sw.png",
		Const = "NggHLindwurmBody"
	},

// kraken
	{
		ID = "perk.kraken_bite",
		Script = "scripts/skills/perks/perk_nggh_kraken_bite",
		Name = ::Const.Strings.PerkName.NggHKrakenBite,
		Tooltip = ::Const.Strings.PerkDescription.NggHKrakenBite,
		Icon = "ui/perks/perk_kraken_bite.png",
		IconDisabled = "ui/perks/perk_kraken_bite_sw.png",
		Const = "NggHKrakenBite"
	},
	{
		ID = "perk.kraken_devour",
		Script = "scripts/skills/perks/perk_nggh_kraken_devour",
		Name = ::Const.Strings.PerkName.NggHKrakenDevour,
		Tooltip = ::Const.Strings.PerkDescription.NggHKrakenDevour,
		Icon = "ui/perks/perk_kraken_devour.png",
		IconDisabled = "ui/perks/perk_kraken_devour_sw.png",
		Const = "NggHKrakenDevour"
	},
	{
		ID = "perk.kraken_ensnare",
		Script = "scripts/skills/perks/perk_nggh_kraken_ensnare",
		Name = ::Const.Strings.PerkName.NggHKrakenEnsnare,
		Tooltip = ::Const.Strings.PerkDescription.NggHKrakenEnsnare,
		Icon = "ui/perks/perk_kraken_ensnare.png",
		IconDisabled = "ui/perks/perk_kraken_ensnare_sw.png",
		Const = "NggHKrakenEnsnare"
	},
	{
		ID = "perk.kraken_move",
		Script = "scripts/skills/perks/perk_nggh_kraken_move",
		Name = ::Const.Strings.PerkName.NggHKrakenMove,
		Tooltip = ::Const.Strings.PerkDescription.NggHKrakenMove,
		Icon = "ui/perks/perk_kraken_move.png",
		IconDisabled = "ui/perks/perk_kraken_move_sw.png",
		Const = "NggHKrakenMove"
	},
	{
		ID = "perk.kraken_swing",
		Script = "scripts/skills/perks/perk_nggh_kraken_swing",
		Name = ::Const.Strings.PerkName.NggHKrakenSwing,
		Tooltip = ::Const.Strings.PerkDescription.NggHKrakenSwing,
		Icon = "ui/perks/perk_kraken_sweep.png",
		IconDisabled = "ui/perks/perk_kraken_sweep_sw.png",
		Const = "NggHKrakenSwing"
	},
	{
		ID = "perk.kraken_tentacle",
		Script = "scripts/skills/perks/perk_nggh_kraken_tentacle",
		Name = ::Const.Strings.PerkName.NggHKrakenTentacle,
		Tooltip = ::Const.Strings.PerkDescription.NggHKrakenTentacle,
		Icon = "ui/perks/perk_kraken_tentacle.png",
		IconDisabled = "ui/perks/perk_kraken_tentacle_sw.png",
		Const = "NggHKrakenTentacle"
	},

// goblin
	{
		ID = "perk.mount_training",
		Script = "scripts/skills/perks/perk_nggh_goblin_mount_training",
		Name = ::Const.Strings.PerkName.NggHGoblinMountTraining,
		Tooltip = ::Const.Strings.PerkDescription.NggHGoblinMountTraining,
		Icon = "ui/perks/impulse_perk.png",
		IconDisabled = "ui/perks/impulse_perk_bw.png",
		Const = "NggHGoblinMountTraining"
	},
	{
		ID = "perk.mounted_archery",
		Script = "scripts/skills/perks/perk_nggh_goblin_mounted_archery",
		Name = ::Const.Strings.PerkName.NggHGoblinMountedArchery,
		Tooltip = ::Const.Strings.PerkDescription.NggHGoblinMountedArchery,
		Icon = "ui/perks/partian_shot_perk.png",
		IconDisabled = "ui/perks/partian_shot_perk_bw.png",
		Const = "NggHGoblinMountedArchery"
	},
	{
		ID = "perk.mounted_charge",
		Script = "scripts/skills/perks/perk_nggh_goblin_mounted_charge",
		Name = ::Const.Strings.PerkName.NggHGoblinMountedCharge,
		Tooltip = ::Const.Strings.PerkDescription.NggHGoblinMountedCharge,
		Icon = "ui/perks/charge_perk.png",
		IconDisabled = "ui/perks/charge_perk_bw.png",
		Const = "NggHGoblinMountedCharge"
	},

// ghost
	{
		ID = "perk.ghost_ghastly_touch",
		Script = "scripts/skills/perks/perk_nggh_ghost_ghastly_touch",
		Name = ::Const.Strings.PerkName.NggHGhostGhastlyTouch,
		Tooltip = ::Const.Strings.PerkDescription.NggHGhostGhastlyTouch,
		Icon = "ui/perks/perk_ghost_ghastly_touch.png",
		IconDisabled = "ui/perks/perk_ghost_ghastly_touch_sw.png",
		Const = "NggHGhostGhastlyTouch"
	},
	{
		ID = "perk.ghost_spectral_body",
		Script = "scripts/skills/perks/perk_nggh_ghost_spectral_body",
		Name = ::Const.Strings.PerkName.NggHGhostSpectralBody,
		Tooltip = ::Const.Strings.PerkDescription.NggHGhostSpectralBody,
		Icon = "ui/perks/legend_vala_warden.png",
		IconDisabled = "ui/perks/legend_vala_warden_sw.png",
		Const = "NggHGhostSpectralBody"
	},
	{
		ID = "perk.ghost_vanish",
		Script = "scripts/skills/perks/perk_nggh_ghost_vanish",
		Name = ::Const.Strings.PerkName.NggHGhostVanish,
		Tooltip = ::Const.Strings.PerkDescription.NggHGhostVanish,
		Icon = "ui/perks/perk_ghost_vanish.png",
		IconDisabled = "ui/perks/perk_ghost_vanish_sw.png",
		Const = "NggHGhostVanish"
	},
	{
		ID = "perk.ghost_phase",
		Script = "scripts/skills/perks/perk_nggh_ghost_phase_through",
		Name = ::Const.Strings.PerkName.NggHGhostPhase,
		Tooltip = ::Const.Strings.PerkDescription.NggHGhostPhase,
		Icon = "ui/perks/perk_ghost_phase.png",
		IconDisabled = "ui/perks/PiercingBoltPerk_bw.png",
		Const = "NggHGhostPhase"
	},
	{
		ID = "perk.ghost_soul_eater",
		Script = "scripts/skills/perks/perk_nggh_ghost_soul_eater",
		Name = ::Const.Strings.PerkName.NggHGhostSoulEater,
		Tooltip = ::Const.Strings.PerkDescription.NggHGhostSoulEater,
		Icon = "ui/perks/siphon_circle.png",
		IconDisabled = "ui/perks/siphon_circle_bw.png",
		Const = "NggHGhostSoulEater"
	},

// misc
	{
		ID = "perk.line_breaker",
		Script = "scripts/skills/perks/perk_nggh_misc_line_breaker",
		Name = ::Const.Strings.PerkName.NggHMiscLineBreaker,
		Tooltip = ::Const.Strings.PerkDescription.NggHMiscLineBreaker,
		Icon = "ui/perks/perk_line_breaker.png",
		IconDisabled = "ui/perks/perk_line_breaker_sw.png",
		Const = "NggHMiscLineBreaker"
	},
	{
		ID = "perk.champion",
		Script = "scripts/skills/perks/perk_nggh_misc_champion",
		Name = ::Const.Strings.PerkName.NggHMiscChampion,
		Tooltip = ::Const.Strings.PerkDescription.NggHMiscChampion,
		Icon = "ui/perks/perk_champion.png",
		IconDisabled = "ui/perks/perk_champion_sw.png",
		Const = "NggHMiscChampion"
	},
	{
		ID = "perk.daytime",
		Script = "scripts/skills/perks/perk_nggh_misc_daytime",
		Name = ::Const.Strings.PerkName.NggHMiscDaytime,
		Tooltip = ::Const.Strings.PerkDescription.NggHMiscDaytime,
		Icon = "skills/status_effect_daytime.png",
		IconDisabled = "ui/perks/perk_daytime_sw.png",
		Const = "NggHMiscDaytime"
	},
	{
		ID = "perk.nighttime",
		Script = "scripts/skills/perks/perk_nggh_misc_nighttime",
		Name = ::Const.Strings.PerkName.NggHMiscNighttime,
		Tooltip = ::Const.Strings.PerkDescription.NggHMiscNighttime,
		Icon = "skills/status_effect_35.png",
		IconDisabled = "skills/status_effect_35_sw.png",
		Const = "NggHMiscNighttime"
	},
	{
		ID = "perk.fair_game",
		Script = "scripts/skills/perks/perk_nggh_misc_fair_game",
		Name = ::Const.Strings.PerkName.NggHMiscFairGame,
		Tooltip = ::Const.Strings.PerkDescription.NggHMiscFairGame,
		Icon = "ui/perks/perk_fair_game.png",
		IconDisabled = "ui/perks/perk_fair_game_sw.png",
		Const = "NggHMiscFairGame"
	},

// bdsm
	{
		ID = "perk.bdsm_whip_lash",
		Script = "scripts/skills/perks/perk_nggh_bdsm_whip_lash",
		Name = ::Const.Strings.PerkName.NggH_BDSM_WhipLash,
		Tooltip = ::Const.Strings.PerkDescription.NggH_BDSM_WhipLash,
		Icon = "ui/perks/perk_bdsm_whip.png",
		IconDisabled = "ui/perks/perk_bdsm_whip_sw.png",
		Const = "NggH_BDSM_WhipLash"
	},
	{
		ID = "perk.bdsm_whip_mastery",
		Script = "scripts/skills/perks/perk_nggh_bdsm_whip_mastery",
		Name = ::Const.Strings.PerkName.NggH_BDSM_WhipMastery,
		Tooltip = ::Const.Strings.PerkDescription.NggH_BDSM_WhipMastery,
		Icon = "ui/perks/perk_whip_mastery.png",
		IconDisabled = "ui/perks/perk_whip_mastery_sw.png",
		Const = "NggH_BDSM_WhipMastery"
	},
	{
		ID = "perk.bdsm_mask_on",
		Script = "scripts/skills/perks/perk_nggh_bdsm_mask_on",
		Name = ::Const.Strings.PerkName.NggH_BDSM_MaskOn,
		Tooltip = ::Const.Strings.PerkDescription.NggH_BDSM_MaskOn,
		Icon = "ui/perks/perk_bdsm_mask_on.png",
		IconDisabled = "ui/perks/perk_bdsm_mask_on_sw.png",
		Const = "NggH_BDSM_MaskOn"
	},
	{
		ID = "perk.bdsm_bondage",
		Script = "scripts/skills/perks/perk_nggh_bdsm_bondage",
		Name = ::Const.Strings.PerkName.NggH_BDSM_Bondage,
		Tooltip = ::Const.Strings.PerkDescription.NggH_BDSM_Bondage,
		Icon = "ui/perks/perk_bdsm_bondage.png",
		IconDisabled = "ui/perks/perk_bdsm_bondage_sw.png",
		Const = "NggH_BDSM_Bondage"
	},
	{
		ID = "perk.bdsm_whip_punish",
		Script = "scripts/skills/perks/perk_nggh_bdsm_whip_punish",
		Name = ::Const.Strings.PerkName.NggH_BDSM_WhipPunish,
		Tooltip = ::Const.Strings.PerkDescription.NggH_BDSM_WhipPunish,
		Icon = "ui/perks/perk_bdsm_bad_boy_must_be_punished.png",
		IconDisabled = "ui/perks/perk_bdsm_bad_boy_must_be_punished_sw.png",
		Const = "NggH_BDSM_WhipPunish"
	},
	{
		ID = "perk.bdsm_whip_love",
		Script = "scripts/skills/perks/perk_nggh_bdsm_whip_love",
		Name = ::Const.Strings.PerkName.NggH_BDSM_WhipLove,
		Tooltip = ::Const.Strings.PerkDescription.NggH_BDSM_WhipLove,
		Icon = "ui/perks/perk_bdsm_love_is_pain.png",
		IconDisabled = "ui/perks/perk_bdsm_love_is_pain_sw.png",
		Const = "NggH_BDSM_WhipLove"
	},
	{
		ID = "perk.bdsm_dommy_mommy",
		Script = "scripts/skills/perks/perk_nggh_bdsm_dommy_mommy",
		Name = ::Const.Strings.PerkName.NggH_BDSM_DommyMommy,
		Tooltip = ::Const.Strings.PerkDescription.NggH_BDSM_DommyMommy,
		Icon = "ui/perks/perk_bdsm_dommy_mommy.png",
		IconDisabled = "ui/perks/perk_bdsm_dommy_mommy_sw.png",
		Const = "NggH_BDSM_DommyMommy"
	},

]);

