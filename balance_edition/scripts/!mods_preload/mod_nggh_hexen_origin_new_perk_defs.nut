this.getroottable().HexenHooks.hookPerkDefs <- function ()
{
	local gt = this.getroottable();
	
	gt.Const.Perks.addPerkDefObjects([
	//Hexe
		{
			ID = "perk.charm_enemy_ghoul",
			Script = "scripts/skills/perks/perk_charm_enemy_ghoul",
			Name = this.Const.Strings.PerkName.CharmEnemyGhoul,
			Tooltip = this.Const.Strings.PerkDescription.CharmEnemyGhoul,
			Icon = "ui/perks/charmed_ghoul_01.png",
			IconDisabled = "ui/perks/charmed_ghoul_01_sw.png",
			Const = "CharmEnemyGhoul"
		},
		{
			ID = "perk.charm_enemy_alps",
			Script = "scripts/skills/perks/perk_charm_enemy_alps",
			Name = this.Const.Strings.PerkName.CharmEnemyAlps,
			Tooltip = this.Const.Strings.PerkDescription.CharmEnemyAlps,
			Icon = "ui/perks/charmed_alps_01.png",
			IconDisabled = "ui/perks/charmed_alps_01_sw.png",
			Const = "CharmEnemyAlps" 
		},
		{
			ID = "perk.charm_enemy_unhold",
			Script = "scripts/skills/perks/perk_charm_enemy_unhold",
			Name = this.Const.Strings.PerkName.CharmEnemyUnhold,
			Tooltip = this.Const.Strings.PerkDescription.CharmEnemyUnhold,
			Icon = "ui/perks/charmed_unhold_01.png",
			IconDisabled = "ui/perks/charmed_unhold_01_sw.png",
			Const = "CharmEnemyUnhold"
		},
		{
			ID = "perk.charm_enemy_lindwurm",
			Script = "scripts/skills/perks/perk_charm_enemy_lindwurm",
			Name = this.Const.Strings.PerkName.CharmEnemyLindwurm,
			Tooltip = this.Const.Strings.PerkDescription.CharmEnemyLindwurm,
			Icon = "ui/perks/charmed_lindwurm_01.png",
			IconDisabled = "ui/perks/charmed_lindwurm_01_sw.png",
			Const = "CharmEnemyLindwurm"
		},
		{
			ID = "perk.charm_enemy_direwolf",
			Script = "scripts/skills/perks/perk_charm_enemy_direwolf",
			Name = this.Const.Strings.PerkName.CharmEnemyDirewolf,
			Tooltip = this.Const.Strings.PerkDescription.CharmEnemyDirewolf,
			Icon = "ui/perks/charmed_direwolf_01.png",
			IconDisabled = "ui/perks/charmed_direwolf_01_sw.png",
			Const = "CharmEnemyDirewolf" 
		},
		{
			ID = "perk.charm_enemy_spider",
			Script = "scripts/skills/perks/perk_charm_enemy_spider",
			Name = this.Const.Strings.PerkName.CharmEnemySpider,
			Tooltip = this.Const.Strings.PerkDescription.CharmEnemySpider,
			Icon = "ui/perks/charmed_spider_01.png",
			IconDisabled = "ui/perks/charmed_spider_01_sw.png",
			Const = "CharmEnemySpider"
		},
		{
			ID = "perk.charm_enemy_schrat",
			Script = "scripts/skills/perks/perk_charm_enemy_schrat",
			Name = this.Const.Strings.PerkName.CharmEnemySchrat,
			Tooltip = this.Const.Strings.PerkDescription.CharmEnemySchrat,
			Icon = "ui/perks/charmed_schrat_01.png",
			IconDisabled = "ui/perks/charmed_schrat_01_sw.png",
			Const = "CharmEnemySchrat"
		},
		{
			ID = "perk.charm_enemy_ork",
			Script = "scripts/skills/perks/perk_charm_enemy_ork",
			Name = this.Const.Strings.PerkName.CharmEnemyOrk,
			Tooltip = this.Const.Strings.PerkDescription.CharmEnemyOrk,
			Icon = "ui/perks/charmed_ork_01.png",
			IconDisabled = "ui/perks/charmed_ork_01_sw.png",
			Const = "CharmEnemyOrk" 
		},
		{
			ID = "perk.charm_enemy_goblin",
			Script = "scripts/skills/perks/perk_charm_enemy_goblin",
			Name = this.Const.Strings.PerkName.CharmEnemyGoblin,
			Tooltip = this.Const.Strings.PerkDescription.CharmEnemyGoblin,
			Icon = "ui/perks/charmed_goblin_01.png",
			IconDisabled = "ui/perks/charmed_goblin_01_sw.png",
			Const = "CharmEnemyGoblin"
		},
		{
			ID = "perk.boobas_charm",
			Script = "scripts/skills/perks/perk_basic_charm",
			Name = this.Const.Strings.PerkName.CharmBasic,
			Tooltip = this.Const.Strings.PerkDescription.CharmBasic,
			Icon = "ui/perks/perk_basic_charm.png",
			IconDisabled = "ui/perks/perk_basic_charm_sw.png", 
			Const = "CharmBasic",
		},
		{
			ID = "perk.words_charm",
			Script = "scripts/skills/perks/perk_words_charm",
			Name = this.Const.Strings.PerkName.CharmWord,
			Tooltip = this.Const.Strings.PerkDescription.CharmWord,
			Icon = "ui/perks/perk_words_charm.png",
			IconDisabled = "ui/perks/perk_words_charm_sw.png",
			Const = "CharmWord"
		},
		{
			ID = "perk.appearance_charm",
			Script = "scripts/skills/perks/perk_apppearance_charm",
			Name = this.Const.Strings.PerkName.CharmAppearance,
			Tooltip = this.Const.Strings.PerkDescription.CharmAppearance,
			Icon = "ui/perks/perk_apppearance_charm.png",
			IconDisabled = "ui/perks/perk_apppearance_charm_sw.png",
			Const = "CharmAppearance"
		},
		{
			ID = "perk.mastery_charm",
			Script = "scripts/skills/perks/perk_mastery_charm",
			Name = this.Const.Strings.PerkName.CharmSpec,
			Tooltip = this.Const.Strings.PerkDescription.CharmSpec,
			Icon = "ui/perks/perk_charm.png",
			IconDisabled = "ui/perks/perk_charm_sw.png",
			Const = "CharmSpec",
		},
		{
			ID = "perk.charm_nudist",
			Script = "scripts/skills/perks/perk_charm_nudist",
			Name = this.Const.Strings.PerkName.CharmNudist,
			Tooltip = this.Const.Strings.PerkDescription.CharmNudist,
			Icon = "ui/perks/perk_charm_nudist.png",
			IconDisabled = "ui/perks/perk_charm_nudist_sw.png",
			Const = "CharmNudist"
		},
		
	//Luft
		{
			ID = "perk.patting",
			Script = "scripts/skills/perks/perk_patting",
			Name = this.Const.Strings.PerkName.PattingSpec,
			Tooltip = this.Const.Strings.PerkDescription.PattingSpec,
			Icon = "ui/perks/perk_patting.png",
			IconDisabled = "ui/perks/perk_patting_sw.png",
			Const = "PattingSpec", 
		},
		{
			ID = "perk.boobas_charm",
			Script = "scripts/skills/perks/perk_unholy_fruits",
			Name = this.Const.Strings.PerkName.UnholyFruits,
			Tooltip = this.Const.Strings.PerkDescription.UnholyFruits,
			Icon = "ui/perks/perk_unholy_fruits.png",
			IconDisabled = "ui/perks/perk_unholy_fruits_sw.png",
			Const = "UnholyFruits",
		},
		{
			ID = "perk.words_charm",
			Script = "scripts/skills/perks/perk_innocent_look",
			Name = this.Const.Strings.PerkName.InnocentLook,
			Tooltip = this.Const.Strings.PerkDescription.InnocentLook,
			Icon = "ui/perks/perk_innocent_look.png",
			IconDisabled = "ui/perks/perk_innocent_look_sw.png",
			Const = "InnocentLook",
		},
		{
			ID = "perk.appearance_charm",
			Script = "scripts/skills/perks/perk_ghoulish_beauty",
			Name = this.Const.Strings.PerkName.GhoulBeauty,
			Tooltip = this.Const.Strings.PerkDescription.GhoulBeauty,
			Icon = "ui/perks/perk_ghoulish_beauty.png",
			IconDisabled = "ui/perks/perk_ghoulish_beauty_sw.png",
			Const = "GhoulBeauty",
		},

	//Egg
		{
			ID = "perk.inherit",
			Script = "scripts/skills/perks/perk_inherit",
			Name = this.Const.Strings.PerkName.EggInherit,
			Tooltip = this.Const.Strings.PerkDescription.EggInherit,
			Icon = "ui/perks/perk_inherit.png",
			IconDisabled = "ui/perks/perk_inherit_sw.png",
			Const = "EggInherit"
		},
		{
			ID = "perk.breeding_machine",
			Script = "scripts/skills/perks/perk_breeding_machine",
			Name = this.Const.Strings.PerkName.EggBreedingMachine,
			Tooltip = this.Const.Strings.PerkDescription.EggBreedingMachine,
			Icon = "ui/perks/perk_breeding_machine.png",
			IconDisabled = "ui/perks/perk_breeding_machine_sw.png",
			Const = "EggBreedingMachine"
		},
		{
			ID = "perk.natural_selection",
			Script = "scripts/skills/perks/perk_natural_selection",
			Name = this.Const.Strings.PerkName.EggNaturalSelection,
			Tooltip = this.Const.Strings.PerkDescription.EggNaturalSelection,
			Icon = "ui/perks/perk_natural_selection.png",
			IconDisabled = "ui/perks/perk_natural_selection_sw.png",
			Const = "EggNaturalSelection"
		},
		{
			ID = "perk.attach_egg",
			Script = "scripts/skills/perks/perk_attach_egg",
			Name = this.Const.Strings.PerkName.EggAttachSpider,
			Tooltip = this.Const.Strings.PerkDescription.EggAttachSpider,
			Icon = "ui/perks/perk_attach_egg.png",
			IconDisabled = "ui/perks/perk_attach_egg_sw.png",
			Const = "EggAttachSpider"
		},
		
	//Spider
		{
			ID = "perk.spider_bite",
			Script = "scripts/skills/perks/perk_spider_bite",
			Name = this.Const.Strings.PerkName.SpiderBite,
			Tooltip = this.Const.Strings.PerkDescription.SpiderBite,
			Icon = "ui/perks/perk_spider_bite.png",
			IconDisabled = "ui/perks/perk_spider_bite_sw.png",
			Const = "SpiderBite",
		},
		{
			ID = "perk.spider_venom",
			Script = "scripts/skills/perks/perk_spider_venom",
			Name = this.Const.Strings.PerkName.SpiderVenom,
			Tooltip = this.Const.Strings.PerkDescription.SpiderVenom,
			Icon = "ui/perks/perk_venomous.png",
			IconDisabled = "ui/perks/perk_venomous_sw.png",
			Const = "SpiderVenom",
		},
		{
			ID = "perk.spider_web",
			Script = "scripts/skills/perks/perk_spider_web",
			Name = this.Const.Strings.PerkName.SpiderWeb,
			Tooltip = this.Const.Strings.PerkDescription.SpiderWeb,
			Icon = "ui/perks/perk_spider_web.png",
			IconDisabled = "ui/perks/perk_spider_web_sw.png",
			Const = "SpiderWeb",
		},

	//Serpent
		{
			ID = "perk.serpent_bite",
			Script = "scripts/skills/perks/perk_serpent_bite",
			Name = this.Const.Strings.PerkName.SerpentBite,
			Tooltip = this.Const.Strings.PerkDescription.SerpentBite,
			Icon = "ui/perks/perk_serpent_bite.png",
			IconDisabled = "ui/perks/perk_serpent_bite_sw.png",
			Const = "SerpentBite",
		},
		{
			ID = "perk.serpent_drag",
			Script = "scripts/skills/perks/perk_serpent_drag",
			Name = this.Const.Strings.PerkName.SerpentDrag,
			Tooltip = this.Const.Strings.PerkDescription.SerpentDrag,
			Icon = "ui/perks/perk_serpent_drag.png",
			IconDisabled = "ui/perks/perk_serpent_drag_sw.png",
			Const = "SerpentDrag",
		},
		{
			ID = "perk.snake_venom",
			Script = "scripts/skills/perks/perk_snake_venom",
			Name = this.Const.Strings.PerkName.SerpentVenom,
			Tooltip = this.Const.Strings.PerkDescription.SerpentVenom,
			Icon = "ui/perks/perk_venomous.png",
			IconDisabled = "ui/perks/perk_venomous_sw.png",
			Const = "SerpentVenom",
		},
		{
			ID = "perk.serpent_giant",
			Script = "scripts/skills/perks/perk_giant_serpent",
			Name = this.Const.Strings.PerkName.SerpentGiant,
			Tooltip = this.Const.Strings.PerkDescription.SerpentGiant,
			Icon = "ui/perks/perk_giant_serpent.png",
			IconDisabled = "ui/perks/perk_giant_serpent_sw.png",
			Const = "SerpentGiant",
		},

	//Wolf and Hyena
		{
			ID = "perk.wolf_bite",
			Script = "scripts/skills/perks/perk_wolf_bite",
			Name = this.Const.Strings.PerkName.WolfBite,
			Tooltip = this.Const.Strings.PerkDescription.WolfBite,
			Icon = "ui/perks/perk_wolf_bite.png",
			IconDisabled = "ui/perks/perk_wolf_bite_sw.png",
			Const = "WolfBite",
		},
		{
			ID = "perk.hyena_bite",
			Script = "scripts/skills/perks/perk_hyena_bite",
			Name = this.Const.Strings.PerkName.HyenaBite,
			Tooltip = this.Const.Strings.PerkDescription.HyenaBite,
			Icon = "ui/perks/perk_hyena_bite.png",
			IconDisabled = "ui/perks/perk_hyena_bite_sw.png",
			Const = "HyenaBite",
		},
		{
			ID = "perk.thick_hide",
			Script = "scripts/skills/perks/perk_thick_hide",
			Name = this.Const.Strings.PerkName.ThickHide,
			Tooltip = this.Const.Strings.PerkDescription.ThickHide,
			Icon = "ui/perks/perk_thick_hide.png",
			IconDisabled = "ui/perks/perk_thick_hide_sw.png",
			Const = "ThickHide",
		},
		{
			ID = "perk.enrage_wolf",
			Script = "scripts/skills/perks/perk_enrage_wolf",
			Name = this.Const.Strings.PerkName.EnrageWolf,
			Tooltip = this.Const.Strings.PerkDescription.EnrageWolf,
			Icon = "ui/perks/perk_enrage_wolf.png",
			IconDisabled = "ui/perks/perk_enrage_wolf_sw.png",
			Const = "EnrageWolf",
		},
		{
			ID = "perk.rabies",
			Script = "scripts/skills/perks/perk_rabies",
			Name = this.Const.Strings.PerkName.Rabies,
			Tooltip = this.Const.Strings.PerkDescription.Rabies,
			Icon = "ui/perks/perk_rabies.png",
			IconDisabled = "ui/perks/perk_rabies_sw.png",
			Const = "Rabies",
		},

	//Alp
		{
			ID = "perk.mastery_nightmare",
			Script = "scripts/skills/perks/perk_mastery_nightmare",
			Name = this.Const.Strings.PerkName.NightmareSpec,
			Tooltip = this.Const.Strings.PerkDescription.NightmareSpec,
			Icon = "ui/perks/perk_mastery_nightmare.png",
			IconDisabled = "ui/perks/perk_mastery_nightmare_sw.png",
			Const = "NightmareSpec",
		},
		{
			ID = "perk.mastery_sleep",
			Script = "scripts/skills/perks/perk_mastery_sleep",
			Name = this.Const.Strings.PerkName.SleepSpec,
			Tooltip = this.Const.Strings.PerkDescription.SleepSpec,
			Icon = "ui/perks/perk_mastery_sleep.png",
			IconDisabled = "ui/perks/perk_mastery_sleep_sw.png",
			Const = "SleepSpec",
		},
		{
			ID = "perk.after_wake",
			Script = "scripts/skills/perks/perk_after_wake",
			Name = this.Const.Strings.PerkName.AfterWake,
			Tooltip = this.Const.Strings.PerkDescription.AfterWake,
			Icon = "ui/perks/perk_after_wake.png",
			IconDisabled = "ui/perks/perk_after_wake_sw.png",
			Const = "AfterWake",
		},
		{
			ID = "perk.afterimage",
			Script = "scripts/skills/perks/perk_afterimage",
			Name = this.Const.Strings.PerkName.Afterimage,
			Tooltip = this.Const.Strings.PerkDescription.Afterimage,
			Icon = "ui/perks/perk_afterimage.png",
			IconDisabled = "ui/perks/perk_afterimage_sw.png",
			Const = "Afterimage"
		},
		{
			ID = "perk.alp_living_nightmare",
			Script = "scripts/skills/perks/perk_alp_living_nightmare",
			Name = this.Const.Strings.PerkName.AlpLivingNightmare,
			Tooltip = this.Const.Strings.PerkDescription.AlpLivingNightmare,
			Icon = "ui/perks/perk_alp_living_nightmare.png",
			IconDisabled = "ui/perks/perk_alp_living_nightmare_sw.png",
			Const = "AlpLivingNightmare"
		},
		{
			ID = "perk.mind_break",
			Script = "scripts/skills/perks/perk_mind_break",
			Name = this.Const.Strings.PerkName.AlpMindBreak,
			Tooltip = this.Const.Strings.PerkDescription.AlpMindBreak,
			Icon = "ui/perks/perk_mind_break.png",
			IconDisabled = "ui/perks/perk_mind_break_sw.png",
			Const = "AlpMindBreak"
		},

	//Demon alp
		{
			ID = "perk.control_flame",
			Script = "scripts/skills/perks/perk_control_flame",
			Name = this.Const.Strings.PerkName.AlpControlFlame,
			Tooltip = this.Const.Strings.PerkDescription.AlpControlFlame,
			Icon = "ui/perks/perk_hellish_flame.png",
			IconDisabled = "ui/perks/perk_hellish_flame_sw.png",
			Const = "AlpControlFlame"
		},
		{
			ID = "perk.fiece_flame",
			Script = "scripts/skills/perks/perk_fiece_flame",
			Name = this.Const.Strings.PerkName.AlpFieceFlame,
			Tooltip = this.Const.Strings.PerkDescription.AlpFieceFlame,
			Icon = "ui/perks/perk_hellish_flame.png",
			IconDisabled = "ui/perks/perk_hellish_flame_sw.png",
			Const = "AlpFieceFlame"
		},
		{
			ID = "perk.hellish_flame",
			Script = "scripts/skills/perks/perk_hellish_flame",
			Name = this.Const.Strings.PerkName.AlpHellishFlame,
			Tooltip = this.Const.Strings.PerkDescription.AlpHellishFlame,
			Icon = "ui/perks/perk_hellish_flame.png",
			IconDisabled = "ui/perks/perk_hellish_flame_sw.png",
			Const = "AlpHellishFlame"
		},
		{
			ID = "perk.shadow_copy",
			Script = "scripts/skills/perks/perk_shadow_copy",
			Name = this.Const.Strings.PerkName.AlpShadowCopy,
			Tooltip = this.Const.Strings.PerkDescription.AlpShadowCopy,
			Icon = "ui/perks/perk_afterimage.png",
			IconDisabled = "ui/perks/perk_afterimage_sw.png",
			Const = "AlpShadowCopy"
		},

	//Nacho
		{
			ID = "perk.nacho",
			Script = "scripts/skills/perks/perk_nacho",
			Name = this.Const.Strings.PerkName.Nacho,
			Tooltip = this.Const.Strings.PerkDescription.Nacho,
			Icon = "ui/perks/perk_nacho.png",
			IconDisabled = "ui/perks/perk_nacho_sw.png",
			Const = "Nacho"
		},
		{
			ID = "perk.nacho_eat",
			Script = "scripts/skills/perks/perk_nacho_eat",
			Name = this.Const.Strings.PerkName.NachoEat,
			Tooltip = this.Const.Strings.PerkDescription.NachoEat,
			Icon = "ui/perks/perk_energize_meal.png",
			IconDisabled = "ui/perks/perk_energize_meal_sw.png",
			Const = "NachoEat"
		},
		{
			ID = "perk.frenzy",
			Script = "scripts/skills/perks/perk_frenzy",
			Name = this.Const.Strings.PerkName.NachoFrenzy,
			Tooltip = this.Const.Strings.PerkDescription.NachoFrenzy,
			Icon = "ui/perks/perk_madden.png",
			IconDisabled = "ui/perks/perk_madden_sw.png",
			Const = "NachoFrenzy"
		},
		{
			ID = "perk.nacho_big_tummy",
			Script = "scripts/skills/perks/perk_nacho_big_tummy",
			Name = this.Const.Strings.PerkName.NachoBigTummy,
			Tooltip = this.Const.Strings.PerkDescription.NachoBigTummy,
			Icon = "ui/perks/perk_nacho_big_tummy.png",
			IconDisabled = "ui/perks/perk_nacho_big_tummy_sw.png",
			Const = "NachoBigTummy"
		},
		{
			ID = "perk.nacho_vomiting",
			Script = "scripts/skills/perks/perk_nacho_vomiting",
			Name = this.Const.Strings.PerkName.NachoVomiting,
			Tooltip = this.Const.Strings.PerkDescription.NachoVomiting,
			Icon = "ui/perks/perk_nacho_vomiting.png",
			IconDisabled = "ui/perks/perk_nacho_vomiting_sw.png",
			Const = "NachoVomiting"
		},

	//Unhold
		{
			ID = "perk.unhold_hand_to_hand",
			Script = "scripts/skills/perks/perk_unhold_hand_to_hand",
			Name = this.Const.Strings.PerkName.UnholdUnarmedAttack,
			Tooltip = this.Const.Strings.PerkDescription.UnholdUnarmedAttack,
			Icon = "ui/perks/perk_unhold_hand_to_hand.png",
			IconDisabled = "ui/perks/perk_unhold_hand_to_hand_sw.png",
			Const = "UnholdUnarmedAttack"
		},
		{
			ID = "perk.unhold_fling",
			Script = "scripts/skills/perks/perk_unhold_fling",
			Name = this.Const.Strings.PerkName.UnholdFling,
			Tooltip = this.Const.Strings.PerkDescription.UnholdFling,
			Icon = "ui/perks/perk_unhold_fling.png",
			IconDisabled = "ui/perks/perk_unhold_fling_sw.png",
			Const = "UnholdFling"
		},

	//Schrat
		{
			ID = "perk.grow_shield",
			Script = "scripts/skills/perks/perk_grow_shield",
			Name = this.Const.Strings.PerkName.SchratShield,
			Tooltip = this.Const.Strings.PerkDescription.SchratShield,
			Icon = "ui/perks/perk_grow_shield.png",
			IconDisabled = "ui/perks/perk_grow_shield_sw.png",
			Const = "SchratShield"
		},
		{
			ID = "perk.sapling",
			Script = "scripts/skills/perks/perk_sapling",
			Name = this.Const.Strings.PerkName.SchratSapling,
			Tooltip = this.Const.Strings.PerkDescription.SchratSapling,
			Icon = "ui/perks/perk_sapling.png",
			IconDisabled = "ui/perks/perk_sapling_sw.png",
			Const = "SchratSapling"
		},
		{
			ID = "perk.uproot",
			Script = "scripts/skills/perks/perk_uproot",
			Name = this.Const.Strings.PerkName.SchratUproot,
			Tooltip = this.Const.Strings.PerkDescription.SchratUproot,
			Icon = "ui/perks/perk_uproot.png",
			IconDisabled = "ui/perks/perk_uproot_sw.png",
			Const = "SchratUproot"
		},
		{
			ID = "perk.uproot_aoe",
			Script = "scripts/skills/perks/perk_uproot_aoe",
			Name = this.Const.Strings.PerkName.SchratUprootAoE,
			Tooltip = this.Const.Strings.PerkDescription.SchratUprootAoE,
			Icon = "ui/perks/perk_uproot_aoe.png",
			IconDisabled = "ui/perks/perk_uproot_aoe_sw.png",
			Const = "SchratUprootAoE"
		},

	//Lindwurm
		{
			ID = "perk.lindwurm_acid",
			Script = "scripts/skills/perks/perk_lindwurm_acid",
			Name = this.Const.Strings.PerkName.LindwurmAcid,
			Tooltip = this.Const.Strings.PerkDescription.LindwurmAcid,
			Icon = "ui/perks/perk_lindwurm_acid.png",
			IconDisabled = "ui/perks/perk_lindwurm_acid_sw.png",
			Const = "LindwurmAcid"
		},
		{
			ID = "perk.intimidate",
			Script = "scripts/skills/perks/perk_intimidate",
			Name = this.Const.Strings.PerkName.LindwurmIntimidate,
			Tooltip = this.Const.Strings.PerkDescription.LindwurmIntimidate,
			Icon = "ui/perks/perk_intimidate.png",
			IconDisabled = "ui/perks/perk_intimidate_sw.png",
			Const = "LindwurmIntimidate"
		},
		{
			ID = "perk.lindwurm_body",
			Script = "scripts/skills/perks/perk_lindwurm_body",
			Name = this.Const.Strings.PerkName.LindwurmBody,
			Tooltip = this.Const.Strings.PerkDescription.LindwurmBody,
			Icon = "ui/perks/perk_lindwurm_body.png",
			IconDisabled = "ui/perks/perk_lindwurm_body_sw.png",
			Const = "LindwurmBody"
		},

	//Goblin
		{
			ID = "perk.wolf_rider",
			Script = "scripts/skills/perks/perk_wolf_rider",
			Name = this.Const.Strings.PerkName.GoblinWolfRider,
			Tooltip = this.Const.Strings.PerkDescription.GoblinWolfRider,
			Icon = "ui/perks/impulse_perk.png",
			IconDisabled = "ui/perks/impulse_perk_bw.png",
			Const = "GoblinWolfRider"
		},
		{
			ID = "perk.mounted_archery",
			Script = "scripts/skills/perks/perk_mounted_archery",
			Name = this.Const.Strings.PerkName.GoblinMountedArchery,
			Tooltip = this.Const.Strings.PerkDescription.GoblinMountedArchery,
			Icon = "ui/perks/partian_shot_perk.png",
			IconDisabled = "ui/perks/partian_shot_perk_bw.png",
			Const = "GoblinMountedArchery"
		},

	//Orc
		{
			ID = "perk.line_breaker",
			Script = "scripts/skills/perks/perk_line_breaker",
			Name = this.Const.Strings.PerkName.BearLineBreaker,
			Tooltip = this.Const.Strings.PerkDescription.BearLineBreaker,
			Icon = "ui/perks/perk_line_breaker.png",
			IconDisabled = "ui/perks/perk_line_breaker_sw.png",
			Const = "BearLineBreaker"
		},

	//Others
		{
			ID = "perk.champion",
			Script = "scripts/skills/perks/perk_champion",
			Name = this.Const.Strings.PerkName.HexenChampion,
			Tooltip = this.Const.Strings.PerkDescription.HexenChampion,
			Icon = "ui/perks/perk_champion.png",
			IconDisabled = "ui/perks/perk_champion_sw.png",
			Const = "HexenChampion"
		},
		{
			ID = "perk.daytime",
			Script = "scripts/skills/perks/perk_daytime",
			Name = this.Const.Strings.PerkName.Daytime,
			Tooltip = this.Const.Strings.PerkDescription.Daytime,
			Icon = "skills/status_effect_daytime.png",
			IconDisabled = "ui/perks/perk_daytime_sw.png",
			Const = "Daytime"
		},
		{
			ID = "perk.nighttime",
			Script = "scripts/skills/perks/perk_nighttime",
			Name = this.Const.Strings.PerkName.Nighttime,
			Tooltip = this.Const.Strings.PerkDescription.Nighttime,
			Icon = "skills/status_effect_35.png",
			IconDisabled = "skills/status_effect_35_sw.png",
			Const = "Nighttime"
		},
		{
			ID = "perk.fair_game",
			Script = "scripts/skills/perks/perk_fair_game",
			Name = this.Const.Strings.PerkName.FairGame,
			Tooltip = this.Const.Strings.PerkDescription.FairGame,
			Icon = "ui/perks/perk_fair_game.png",
			IconDisabled = "ui/perks/perk_fair_game_sw.png",
			Const = "FairGame"
		},
		{
			ID = "perk.perk_mounted_charge",
			Script = "scripts/skills/perks/perk_mounted_charge",
			Name = this.Const.Strings.PerkName.LegendHorseCharge,
			Tooltip = this.Const.Strings.PerkDescription.LegendHorseCharge,
			Icon = "ui/perks/charge_perk.png",
			IconDisabled = "ui/perks/charge_perk_bw.png",
			Const = "GoblinMountedCharge"
		},

		//Kraken
		{
			ID = "perk.kraken_bite",
			Script = "scripts/skills/perks/perk_kraken_bite",
			Name = this.Const.Strings.PerkName.KrakenBite,
			Tooltip = this.Const.Strings.PerkDescription.KrakenBite,
			Icon = "ui/perks/perk_kraken_bite.png",
			IconDisabled = "ui/perks/perk_kraken_bite_sw.png",
			Const = "KrakenBite"
		},
		{
			ID = "perk.kraken_devour",
			Script = "scripts/skills/perks/perk_kraken_devour",
			Name = this.Const.Strings.PerkName.KrakenDevour,
			Tooltip = this.Const.Strings.PerkDescription.KrakenDevour,
			Icon = "ui/perks/perk_kraken_devour.png",
			IconDisabled = "ui/perks/perk_kraken_devour_sw.png",
			Const = "KrakenDevour"
		},
		{
			ID = "perk.kraken_ensnare",
			Script = "scripts/skills/perks/perk_kraken_ensnare",
			Name = this.Const.Strings.PerkName.KrakenEnsnare,
			Tooltip = this.Const.Strings.PerkDescription.KrakenEnsnare,
			Icon = "ui/perks/perk_kraken_ensnare.png",
			IconDisabled = "ui/perks/perk_kraken_ensnare_sw.png",
			Const = "KrakenEnsnare"
		},
		{
			ID = "perk.kraken_move",
			Script = "scripts/skills/perks/perk_kraken_move",
			Name = this.Const.Strings.PerkName.KrakenMove,
			Tooltip = this.Const.Strings.PerkDescription.KrakenMove,
			Icon = "ui/perks/perk_kraken_move.png",
			IconDisabled = "ui/perks/perk_kraken_move_sw.png",
			Const = "KrakenMove"
		},
		{
			ID = "perk.kraken_swing",
			Script = "scripts/skills/perks/perk_kraken_swing",
			Name = this.Const.Strings.PerkName.KrakenSwing,
			Tooltip = this.Const.Strings.PerkDescription.KrakenSwing,
			Icon = "ui/perks/perk_kraken_sweep.png",
			IconDisabled = "ui/perks/perk_kraken_sweep_sw.png",
			Const = "KrakenSwing"
		},
		{
			ID = "perk.kraken_tentacle",
			Script = "scripts/skills/perks/perk_kraken_tentacle",
			Name = this.Const.Strings.PerkName.KrakenTentacle,
			Tooltip = this.Const.Strings.PerkDescription.KrakenTentacle,
			Icon = "ui/perks/perk_kraken_tentacle.png",
			IconDisabled = "ui/perks/perk_kraken_tentacle_sw.png",
			Const = "KrakenTentacle"
		},

		// zombie
		{
			ID = "perk.zombie_undying",
			Script = "scripts/skills/perks/perk_zombie_undying",
			Name = this.Const.Strings.PerkName.ZombieUndying,
			Tooltip = this.Const.Strings.PerkDescription.ZombieUndying,
			Icon = "ui/perks/perk_zombie_undying.png",
			IconDisabled = "ui/perks/perk_zombie_undying_sw.png",
			Const = "ZombieUndying"
		},
		{
			ID = "perk.zombie_feasting_bite",
			Script = "scripts/skills/perks/perk_zombie_feasting_bite",
			Name = this.Const.Strings.PerkName.ZombieFeasting,
			Tooltip = this.Const.Strings.PerkDescription.ZombieFeasting,
			Icon = "ui/perks/perk_zombie_feasting_bite.png",
			IconDisabled = "ui/perks/perk_zombie_feasting_bite_sw.png",
			Const = "ZombieFeasting"
		},
		{
			ID = "perk.zombie_infectious_bite",
			Script = "scripts/skills/perks/perk_zombie_infectious_bite",
			Name = this.Const.Strings.PerkName.ZombieInfectious,
			Tooltip = this.Const.Strings.PerkDescription.ZombieInfectious,
			Icon = "ui/perks/violent_decomposition_circle.png",
			IconDisabled = "ui/perks/violent_decomposition_circle_bw.png",
			Const = "ZombieInfectious"
		},
		{
			ID = "perk.zombie_puppet",
			Script = "scripts/skills/perks/perk_zombie_puppet",
			Name = this.Const.Strings.PerkName.ZombiePuppet,
			Tooltip = this.Const.Strings.PerkDescription.ZombiePuppet,
			Icon = "ui/perks/possession_circle_56.png",
			IconDisabled = "ui/perks/possession_circle_56_bw.png",
			Const = "ZombiePuppet"
		},
		{
			ID = "perk.zombie_fallen_hero",
			Script = "scripts/skills/perks/perk_zombie_puppet",
			Name = this.Const.Strings.PerkName.ZombieFallenHero,
			Tooltip = this.Const.Strings.PerkDescription.ZombieFallenHero,
			Icon = "ui/perks/perk_zombie_fallen_hero.png",
			IconDisabled = "ui/perks/perk_zombie_fallen_hero_sw.png",
			Const = "ZombieFallenHero"
		},

		// skeleton
		{
			ID = "perk.skeleton_reconstruction",
			Script = "scripts/skills/perks/perk_skeleton_reconstruction",
			Name = this.Const.Strings.PerkName.SkeletonReconstruction,
			Tooltip = this.Const.Strings.PerkDescription.SkeletonReconstruction,
			Icon = "ui/perks/perk_skeleton_reconstruction.png",
			IconDisabled = "ui/perks/perk_skeleton_reconstruction_sw.png",
			Const = "SkeletonReconstruction"
		},
		{
			ID = "perk.skeleton_harden_bone",
			Script = "scripts/skills/perks/perk_skeleton_harden_bone",
			Name = this.Const.Strings.PerkName.SkeletonHarden,
			Tooltip = this.Const.Strings.PerkDescription.SkeletonHarden,
			Icon = "ui/perks/perk_skeleton_harden_bone.png",
			IconDisabled = "ui/perks/perk_skeleton_harden_bone_sw.png",
			Const = "SkeletonHarden"
		},

		// mummy
		{
			ID = "perk.mummy_cursed_body",
			Script = "scripts/skills/perks/perk_mummy_cursed_body",
			Name = this.Const.Strings.PerkName.MummyCursedBody,
			Tooltip = this.Const.Strings.PerkDescription.MummyCursedBody,
			Icon = "ui/perks/perk_mummy_cursed_body.png",
			IconDisabled = "ui/perks/perk_mummy_cursed_body_sw.png",
			Const = "MummyCursedBody"
		},
		{
			ID = "perk.mummy_ancient_knowledge",
			Script = "scripts/skills/perks/perk_mummy_ancient_knowledge",
			Name = this.Const.Strings.PerkName.MummyAncientKnowledge,
			Tooltip = this.Const.Strings.PerkDescription.MummyAncientKnowledge,
			Icon = "ui/perks/perk_inherit.png",
			IconDisabled = "ui/perks/perk_inherit_sw.png",
			Const = "MummyAncientKnowledge"
		},
		{
			ID = "perk.mummy_insect_breath",
			Script = "scripts/skills/perks/perk_mummy_insect_breath",
			Name = this.Const.Strings.PerkName.MummyInsectBreath,
			Tooltip = this.Const.Strings.PerkDescription.MummyInsectBreath,
			Icon = "ui/perks/insects_circle.png",
			IconDisabled = "ui/perks/insects_circle_bw.png",
			Const = "MummyInsectBreath"
		},

		// vampire
		{
			ID = "perk.vampire_long_fangs",
			Script = "scripts/skills/perks/perk_mummy_cursed_body",
			Name = this.Const.Strings.PerkName.VampireLongFangs,
			Tooltip = this.Const.Strings.PerkDescription.VampireLongFangs,
			Icon = "ui/perks/perk_mummy_cursed_body.png",
			IconDisabled = "ui/perks/perk_mummy_cursed_body_sw.png",
			Const = "VampireLongFangs"
		},
		{
			ID = "perk.vampire_blood_frenzy",
			Script = "scripts/skills/perks/perk_mummy_ancient_knowledge",
			Name = this.Const.Strings.PerkName.VampireBloodFrenzy,
			Tooltip = this.Const.Strings.PerkDescription.VampireBloodFrenzy,
			Icon = "ui/perks/perk_inherit.png",
			IconDisabled = "ui/perks/perk_inherit_sw.png",
			Const = "VampireBloodFrenzy"
		},
		{
			ID = "perk.dub",
			Script = "scripts/skills/perks/perk_mummy_insect_breath",
			Name = this.Const.Strings.PerkName.VampireDub,
			Tooltip = this.Const.Strings.PerkDescription.VampireDub,
			Icon = "ui/perks/insects_circle.png",
			IconDisabled = "ui/perks/insects_circle_bw.png",
			Const = "VampireDub"
		},
		{
			ID = "perk.dub",
			Script = "scripts/skills/perks/perk_mummy_insect_breath",
			Name = this.Const.Strings.PerkName.VampireDub2,
			Tooltip = this.Const.Strings.PerkDescription.VampireDub,
			Icon = "ui/perks/insects_circle.png",
			IconDisabled = "ui/perks/insects_circle_bw.png",
			Const = "VampireDub2"
		},

		// ghost
		{
			ID = "perk.ghost_ghastly_touch",
			Script = "scripts/skills/perks/perk_ghost_ghastly_touch",
			Name = this.Const.Strings.PerkName.GhostGhastlyTouch,
			Tooltip = this.Const.Strings.PerkDescription.GhostGhastlyTouch,
			Icon = "ui/perks/perk_ghost_ghastly_touch.png",
			IconDisabled = "ui/perks/perk_ghost_ghastly_touch_sw.png",
			Const = "GhostGhastlyTouch"
		},
		{
			ID = "perk.ghost_spectral_body",
			Script = "scripts/skills/perks/perk_ghost_spectral_body",
			Name = this.Const.Strings.PerkName.GhostSpectralBody,
			Tooltip = this.Const.Strings.PerkDescription.GhostSpectralBody,
			Icon = "ui/perks/legend_vala_warden.png",
			IconDisabled = "ui/perks/legend_vala_warden_sw.png",
			Const = "GhostSpectralBody"
		},
		{
			ID = "perk.ghost_vanish",
			Script = "scripts/skills/perks/perk_ghost_vanish",
			Name = this.Const.Strings.PerkName.GhostVanish,
			Tooltip = this.Const.Strings.PerkDescription.GhostVanish,
			Icon = "ui/perks/perk_ghost_vanish.png",
			IconDisabled = "ui/perks/perk_ghost_vanish_sw.png",
			Const = "GhostVanish"
		},
		{
			ID = "perk.ghost_phase",
			Script = "scripts/skills/perks/perk_ghost_phase",
			Name = this.Const.Strings.PerkName.GhostPhase,
			Tooltip = this.Const.Strings.PerkDescription.GhostPhase,
			Icon = "ui/perks/perk_ghost_phase.png",
			IconDisabled = "ui/perks/PiercingBoltPerk_bw.png",
			Const = "GhostPhase"
		},
		{
			ID = "perk.ghost_soul_eater",
			Script = "scripts/skills/perks/perk_ghost_soul_eater",
			Name = this.Const.Strings.PerkName.GhostSoulEater,
			Tooltip = this.Const.Strings.PerkDescription.GhostSoulEater,
			Icon = "ui/perks/siphon_circle.png",
			IconDisabled = "ui/perks/siphon_circle_bw.png",
			Const = "GhostSoulEater"
		},
	]);
	gt.Const.Perks.updatePerkGroupTooltips();

//-----------------------------------------------------------------------------------------------------------------
	gt.Const.Perks.HexeCharmAdvancedTree <- {
		ID = "Charm 2",
		Name = "Charm 2",
		Descriptions = ["charm 2"],
		Tree = [
			[],
			[],
			[],
			[],
			[
				gt.Const.Perks.PerkDefs.CharmEnemyGhoul,
				gt.Const.Perks.PerkDefs.CharmEnemyOrk
			],
			[
				gt.Const.Perks.PerkDefs.CharmEnemyUnhold,
				gt.Const.Perks.PerkDefs.CharmEnemySchrat
			],
			[
				gt.Const.Perks.PerkDefs.CharmEnemyLindwurm
			],
		]
	};

	gt.Const.Perks.HexeCharmSimpleTree <- {
		ID = "Charm 1",
		Name = "Charm 1",
		Descriptions = ["charm 1"],
		Tree = [
			[],
			[
				gt.Const.Perks.PerkDefs.CharmEnemySpider
			],
			[
				gt.Const.Perks.PerkDefs.CharmEnemyAlps
				gt.Const.Perks.PerkDefs.CharmEnemyDirewolf
			],
			[
				gt.Const.Perks.PerkDefs.CharmEnemyGoblin
			],
			[],
			[],
			[],
		]
	};

	gt.Const.Perks.HexeBasicTree <- {
		ID = "Charm Basic",
		Name = "Charm Basic",
		Descriptions = ["hexe basic"],
		Tree = [
			[],
			[
				gt.Const.Perks.PerkDefs.CharmBasic,
			],
			[],
			[
				gt.Const.Perks.PerkDefs.CharmWord
			],
			[],
			[],
			[
				gt.Const.Perks.PerkDefs.CharmAppearance,
				gt.Const.Perks.PerkDefs.CharmSpec,
				gt.Const.Perks.PerkDefs.CharmNudist,
			],
		]
	};

	gt.Const.Perks.LuftTree <- {
		ID = "Luft Charm",
		Name = "Luft",
		Descriptions = ["Luft"],
		Tree = [
			[],
			[
				gt.Const.Perks.PerkDefs.UnholyFruits,
			],
			[],
			[
				gt.Const.Perks.PerkDefs.PattingSpec,
				gt.Const.Perks.PerkDefs.InnocentLook
			],
			[],
			[],
			[
				gt.Const.Perks.PerkDefs.GhoulBeauty,
			],
		]
	};


////////////////////////////////////////////////////
	gt.Const.Perks.CharmArtTrees <- [
		gt.Const.Perks.HexeBasicTree,
		gt.Const.Perks.HexeCharmSimpleTree,
		gt.Const.Perks.HexeCharmAdvancedTree,
		gt.Const.Perks.LuftTree,
	];
////////////////////////////////////////////////////


	gt.Const.Perks.MC_MiscTree <- {
		ID = "Misc",
		Name = "MC_Misc",
		Descriptions = ["MC_Misc"],
		Tree = [
			[
				gt.Const.Perks.PerkDefs.BoondockBlade,
				gt.Const.Perks.PerkDefs.Daytime
			],
			[],
			[
				gt.Const.Perks.PerkDefs.Nighttime,
				gt.Const.Perks.PerkDefs.FairGame
			],
			[],
			[],
			[],
			[
				gt.Const.Perks.PerkDefs.HexenChampion
			],
		]
	};

	gt.Const.Perks.GoblinMountTree <- {     
		ID = "Goblin Mount",
		Name = "GoblinMount",
		Descriptions = ["goblin mount"],
		Tree = [
			[],
			[
				gt.Const.Perks.PerkDefs.GoblinWolfRider
			],
			[
				gt.Const.Perks.PerkDefs.GoblinMountedCharge
			],
			[
				gt.Const.Perks.PerkDefs.LegendHorseLiberty
			],
			[],
			[
				gt.Const.Perks.PerkDefs.GoblinMountedArchery
			],
			[],
		]
	};

	gt.Const.Perks.AlpTree <- {
		ID = "Alp",
		Name = "Alp",
		Descriptions = ["alp"],
		Tree = [
			[
				//gt.Const.Perks.PerkDefs.Daytime,
			],
			[
				gt.Const.Perks.PerkDefs.AlpMindBreak,
			],
			[],
			[
				gt.Const.Perks.PerkDefs.Afterimage,
				gt.Const.Perks.PerkDefs.SleepSpec,
			],
			[
				gt.Const.Perks.PerkDefs.AfterWake,
			],
			[
				gt.Const.Perks.PerkDefs.NightmareSpec,
			],
			[
				gt.Const.Perks.PerkDefs.AlpLivingNightmare,
			],
		]
	};

	gt.Const.Perks.DemonAlpTree <- {
		ID = "Demon Alp",
		Name = "DemonAlp",
		Descriptions = ["demon alp"],
		Tree = [
			[
				gt.Const.Perks.PerkDefs.AlpFieceFlame,
			],
			[
				gt.Const.Perks.PerkDefs.AlpMindBreak,
			],
			[],
			[
				gt.Const.Perks.PerkDefs.AlpControlFlame,
			],
			[
				gt.Const.Perks.PerkDefs.AlpHellishFlame,
			],
			[
				gt.Const.Perks.PerkDefs.AlpShadowCopy,
			],
			[],
		]
	};

	gt.Const.Perks.WolfTree <- {
		ID = "Wolf",
		Name = "Wolf",
		Descriptions = ["wolf"],
		Tree = [
			[],
			[],
			[],
			[
				gt.Const.Perks.PerkDefs.WolfBite,
			],
			[],
			[
				gt.Const.Perks.PerkDefs.ThickHide,
				gt.Const.Perks.PerkDefs.EnrageWolf,
			],
			[
				gt.Const.Perks.PerkDefs.Rabies
			],
		]
	};

	gt.Const.Perks.HyenaTree <- {
		ID = "Hyena",
		Name = "Hyena",
		Descriptions = ["hyena"],
		Tree = [
			[],
			[],
			[],
			[
				gt.Const.Perks.PerkDefs.HyenaBite,
			],
			[],
			[
				gt.Const.Perks.PerkDefs.ThickHide,
				gt.Const.Perks.PerkDefs.EnrageWolf,
			],
			[
				gt.Const.Perks.PerkDefs.Rabies
			],
		]
	};

	gt.Const.Perks.NachoTree <- {
		ID = "Nacho",
		Name = "Nacho",
		Descriptions = ["nacho"],
		Tree = [
			[],
			[
				gt.Const.Perks.PerkDefs.NachoFrenzy,
			],
			[],
			[
				gt.Const.Perks.PerkDefs.Nacho,
			],
			[
				gt.Const.Perks.PerkDefs.NachoEat,
				gt.Const.Perks.PerkDefs.BearLineBreaker,
			],
			[
				gt.Const.Perks.PerkDefs.NachoBigTummy,
			],
			[
				//gt.Const.Perks.PerkDefs.NachoVomiting,
			],
		]
	};

	gt.Const.Perks.LindwurmTree <- {
		ID = "Lindwurm",
		Name = "Lindwurm",
		Descriptions = ["lindwurm"],
		Tree = [
			[],
			[
				gt.Const.Perks.PerkDefs.LindwurmIntimidate
			],
			[],
			[
				gt.Const.Perks.PerkDefs.LindwurmBody,
			],
			[
				gt.Const.Perks.PerkDefs.BearLineBreaker,
			],
			[
				gt.Const.Perks.PerkDefs.LindwurmAcid,
			],
			[],
		]
	};

	gt.Const.Perks.SchratTree <- {
		ID = "Schrat",
		Name = "Schrat",
		Descriptions = ["schrat"],
		Tree = [
			[
				gt.Const.Perks.PerkDefs.SchratUprootAoE,
			],
			[],
			[
				gt.Const.Perks.PerkDefs.SchratShield,
				gt.Const.Perks.PerkDefs.BearLineBreaker,
			],
			[
				gt.Const.Perks.PerkDefs.SchratUproot,
			],
			[
				gt.Const.Perks.PerkDefs.SchratSapling,
			],
			[],
			[
				gt.Const.Perks.PerkDefs.LegendRoots,
			],
		]
	};

	gt.Const.Perks.SmallSchratTree <- {
		ID = "SmallSchrat",
		Name = "Sapling",
		Descriptions = ["small schrat"],
		Tree = [
			[],
			[],
			[],
			[],
			[],
			[],
			[
				gt.Const.Perks.PerkDefs.LegendRoots,
			],
		]
	};

	gt.Const.Perks.SerpentTree <- {
		ID = "Serpent",
		Name = "Serpent",
		Descriptions = ["serpent"],
		Tree = [
			[],
			[
				gt.Const.Perks.PerkDefs.LegendEntice,
			],
			[],
			[
				gt.Const.Perks.PerkDefs.SerpentVenom,
				gt.Const.Perks.PerkDefs.SerpentDrag,
			],
			[
				gt.Const.Perks.PerkDefs.SerpentBite,
			],
			[],
			[	
				gt.Const.Perks.PerkDefs.SerpentGiant,
			],
		]
	};

	gt.Const.Perks.SpiderTree <- {
		ID = "Webknecht",
		Name = "Spider",
		Descriptions = ["spider"],
		Tree = [
			[
				gt.Const.Perks.PerkDefs.BoondockBlade,
			],
			[],
			[],
			[
				gt.Const.Perks.PerkDefs.SpiderVenom,	
			],
			[
				gt.Const.Perks.PerkDefs.SpiderWeb,
			],
			[
				gt.Const.Perks.PerkDefs.SpiderBite,
			],
			[],
		]
	};

	gt.Const.Perks.UnholdTree <- {
		ID = "Unhold",
		Name = "Unhold",
		Descriptions = ["unhold"],
		Tree = [
			[
				gt.Const.Perks.PerkDefs.UnholdUnarmedAttack,
			],
			[],
			[],
			[
				gt.Const.Perks.PerkDefs.UnholdFling,
				gt.Const.Perks.PerkDefs.BearLineBreaker,
			],
			[],
			[],
			[],
		]
	};

	gt.Const.Perks.SpiderHiveTree <- {
		ID = "Webknecht Eggs",
		Name = "SpiderHive",
		Descriptions = ["spider hive"],
		Tree = [
			[],
			[],
			[],
			[
				gt.Const.Perks.PerkDefs.EggBreedingMachine, 
				gt.Const.Perks.PerkDefs.EggAttachSpider
			],
			[],
			[
				gt.Const.Perks.PerkDefs.EggInherit
			],
			[
				gt.Const.Perks.PerkDefs.EggNaturalSelection
			]
		]			
	};

	gt.Const.Perks.KrakenTree <- {
		ID = "Kraken",
		Name = "Kraken",
		Descriptions = ["beast of beasts"],
		Tree = [
			[],
			[
				gt.Const.Perks.PerkDefs.KrakenDevour, 
			],
			[
				gt.Const.Perks.PerkDefs.KrakenMove, 
			],
			[
				gt.Const.Perks.PerkDefs.KrakenBite,
			],
			[
				gt.Const.Perks.PerkDefs.KrakenSwing,
			],
			[ 
				gt.Const.Perks.PerkDefs.KrakenEnsnare,
			],
			[
				gt.Const.Perks.PerkDefs.KrakenTentacle,
			]
		]
	};


////////////////////////////////////////////////////
	gt.Const.Perks.HexenBeastTrees <- [
		gt.Const.Perks.NachoTree,
		gt.Const.Perks.UnholdTree,
		gt.Const.Perks.SchratTree,
		gt.Const.Perks.SerpentTree,
		gt.Const.Perks.LindwurmTree,
		gt.Const.Perks.WolfTree,
		gt.Const.Perks.HyenaTree,
		gt.Const.Perks.AlpTree,
		gt.Const.Perks.DemonAlpTree,
		gt.Const.Perks.SpiderTree,
		gt.Const.Perks.SpiderHiveTree,
		gt.Const.Perks.GoblinMountTree,
		gt.Const.Perks.KrakenTree,
		gt.Const.Perks.MC_MiscTree,
	];
////////////////////////////////////////////////////

//------------------------------
// undead perk group

	gt.Const.Perks.ZombieClassTree <- {
		ID = "Zombie",
		Name = "Zombie",
		Descriptions = ["Zombie abilities"],
		Tree = [
			[
				gt.Const.Perks.PerkDefs.ZombieUndying,
			],
			[],
			[],
			[
				gt.Const.Perks.PerkDefs.ZombieFeasting,
				gt.Const.Perks.PerkDefs.ZombiePuppet,
			],
			[],
			[
				gt.Const.Perks.PerkDefs.ZombieInfectious
			],
			[
				gt.Const.Perks.PerkDefs.ZombieFallenHero,
			]
		]
	};
	gt.Const.Perks.SkeletonClassTree <- {
		ID = "Skeleton",
		Name = "Skeleton",
		Descriptions = ["Skeleton abilities"],
		Tree = [
			[],
			[],
			[
				gt.Const.Perks.PerkDefs.Rotation,
			],
			[
				gt.Const.Perks.PerkDefs.SkeletonHarden,
			],
			[],
			[
				gt.Const.Perks.PerkDefs.SkeletonReconstruction,
			],
			[
				gt.Const.Perks.PerkDefs.Indomitable,
			]
		]
	};
	gt.Const.Perks.MummyClassTree <- {
		ID = "Mummy",
		Name = "Mummy",
		Descriptions = ["Mummy abilities"],
		Tree = [
			[],
			[],
			[],
			[
				gt.Const.Perks.PerkDefs.MummyAncientKnowledge,
			],
			[
				gt.Const.Perks.PerkDefs.MummyCursedBody,
			],
			[
				gt.Const.Perks.PerkDefs.MummyInsectBreath,
			],
			[
				gt.Const.Perks.PerkDefs.Indomitable,
			]
		]
	};
	gt.Const.Perks.GhostClassTree <- {
		ID = "Ghost",
		Name = "Ghost",
		Descriptions = ["ghastly abilities"],
		Tree = [
			[],
			[
				gt.Const.Perks.PerkDefs.GhostSpectralBody,
			],
			[],
			[
				gt.Const.Perks.PerkDefs.GhostPhase,
				gt.Const.Perks.PerkDefs.GhostGhastlyTouch,
			],
			[
				gt.Const.Perks.PerkDefs.GhostVanish
			],
			[],
			[
				gt.Const.Perks.PerkDefs.GhostSoulEater,
			]
		]
	};

////////////////////////////////////////////////////
	gt.Const.Perks.NggH_UndeadTrees <- [
		gt.Const.Perks.ZombieClassTree,
		gt.Const.Perks.SkeletonClassTree,
		gt.Const.Perks.MummyClassTree,
		gt.Const.Perks.GhostClassTree,
	];
////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------

	if (!("PerksCharmedUnit" in gt.Const))
	{
		gt.Const.PerksCharmedUnit <- {};
	}

	gt.Const.PerksCharmedUnit.AlpTree <- [
		[
			gt.Const.Perks.PerkDefs.FortifiedMind,
			gt.Const.Perks.PerkDefs.Daytime,
		],
		[
			gt.Const.Perks.PerkDefs.AlpMindBreak,
			gt.Const.Perks.PerkDefs.Dodge,
		],
		[
			gt.Const.Perks.PerkDefs.Anticipation,
			gt.Const.Perks.PerkDefs.Footwork,
			gt.Const.Perks.PerkDefs.Underdog,
		],
		[
			gt.Const.Perks.PerkDefs.PushTheAdvantage,
			gt.Const.Perks.PerkDefs.Afterimage,
			gt.Const.Perks.PerkDefs.SleepSpec,
		],
		[
			gt.Const.Perks.PerkDefs.Overwhelm,
			gt.Const.Perks.PerkDefs.Nighttime,
			gt.Const.Perks.PerkDefs.AfterWake,
		],
		[
			gt.Const.Perks.PerkDefs.ReturnFavor,
			gt.Const.Perks.PerkDefs.NightmareSpec,
			gt.Const.Perks.PerkDefs.LegendMindOverBody,
		],
		[
			gt.Const.Perks.PerkDefs.LegendLevitate,
			gt.Const.Perks.PerkDefs.AlpLivingNightmare,
		],
		[],
		[],
		[],
		[]
	];

	gt.Const.PerksCharmedUnit.DemonAlpTree <- [
		[
			gt.Const.Perks.PerkDefs.AlpFieceFlame,
			gt.Const.Perks.PerkDefs.Daytime,
		],
		[
			gt.Const.Perks.PerkDefs.AlpMindBreak,
			gt.Const.Perks.PerkDefs.Dodge,
		],
		[
			gt.Const.Perks.PerkDefs.Anticipation,
			gt.Const.Perks.PerkDefs.Footwork,
			gt.Const.Perks.PerkDefs.Underdog,
		],
		[
			gt.Const.Perks.PerkDefs.PushTheAdvantage,
			gt.Const.Perks.PerkDefs.AlpControlFlame,
		],
		[
			gt.Const.Perks.PerkDefs.FortifiedMind,
			gt.Const.Perks.PerkDefs.Overwhelm,
			gt.Const.Perks.PerkDefs.AlpHellishFlame,
			gt.Const.Perks.PerkDefs.Nighttime,
		],
		[
			gt.Const.Perks.PerkDefs.ReturnFavor,
			gt.Const.Perks.PerkDefs.AlpShadowCopy,
			gt.Const.Perks.PerkDefs.LegendMindOverBody,
		],
		[
			gt.Const.Perks.PerkDefs.LegendLevitate,
			gt.Const.Perks.PerkDefs.LegendDistantVisions,
		],
		[],
		[],
		[],
		[]
	];

	gt.Const.PerksCharmedUnit.KrakenTree <- [
		[
			gt.Const.Perks.PerkDefs.SunderingStrikes,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyCaravan,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyBandit,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyGhoul,
		],
		[
			gt.Const.Perks.PerkDefs.KrakenDevour,
			gt.Const.Perks.PerkDefs.Backstabber,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyZombie,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyGoblin,
		],
		[
			gt.Const.Perks.PerkDefs.KrakenMove,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemySkeleton,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyDirewolf,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemySpider,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyNoble,
		],
		[
			gt.Const.Perks.PerkDefs.KrakenBite,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemySoutherner,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyNomad,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyOrk,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyVampire,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyAlps,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyUnhold,
		],
		[
			gt.Const.Perks.PerkDefs.KrakenSwing,
			gt.Const.Perks.PerkDefs.Fearsome,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyBarbarian,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyMercenary,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyArcher,
		],
		[ 
			gt.Const.Perks.PerkDefs.KrakenEnsnare,
			gt.Const.Perks.PerkDefs.DevastatingStrikes,
			gt.Const.Perks.PerkDefs.Berserk,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyHexen,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemySchrat,
		],
		[
			gt.Const.Perks.PerkDefs.KrakenTentacle,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemyLindwurm,
			gt.Const.Perks.PerkDefs.LegendFavouredEnemySwordmaster,
		],
		[],
		[],
		[],
		[]
	];

	gt.Const.PerksCharmedUnit.WolfTree <- [
		[
			gt.Const.Perks.PerkDefs.FastAdaption,
			gt.Const.Perks.PerkDefs.Pathfinder,
			gt.Const.Perks.PerkDefs.CoupDeGrace,
			gt.Const.Perks.PerkDefs.Recover,
		],
		[
			gt.Const.Perks.PerkDefs.Backstabber,
			gt.Const.Perks.PerkDefs.Overwhelm,
			gt.Const.Perks.PerkDefs.Nighttime,
		],
		[
			gt.Const.Perks.PerkDefs.Relentless,
			gt.Const.Perks.PerkDefs.Fearsome,
			gt.Const.Perks.PerkDefs.Footwork,
			gt.Const.Perks.PerkDefs.Rotation,
		],
		[
			gt.Const.Perks.PerkDefs.Berserk,
			gt.Const.Perks.PerkDefs.BattleForged,
			gt.Const.Perks.PerkDefs.WolfBite,
		],
		[
			gt.Const.Perks.PerkDefs.LegendGruesomeFeast,
			gt.Const.Perks.PerkDefs.LoneWolf,
			gt.Const.Perks.PerkDefs.LegendTrueBeliever,
			gt.Const.Perks.PerkDefs.DevastatingStrikes
		],
		[
			gt.Const.Perks.PerkDefs.LegendSecondWind,
			gt.Const.Perks.PerkDefs.ThickHide,
			gt.Const.Perks.PerkDefs.EnrageWolf,
		],
		[
			gt.Const.Perks.PerkDefs.KillingFrenzy,
			gt.Const.Perks.PerkDefs.BattleFlow,
		],
		[],
		[],
		[],
		[]
	];

	gt.Const.PerksCharmedUnit.WhiteWolfTree <- [
		[
			gt.Const.Perks.PerkDefs.FastAdaption,
			gt.Const.Perks.PerkDefs.Pathfinder,
			gt.Const.Perks.PerkDefs.CoupDeGrace,
			gt.Const.Perks.PerkDefs.Recover,
		],
		[
			gt.Const.Perks.PerkDefs.Backstabber,
			gt.Const.Perks.PerkDefs.Overwhelm,
			gt.Const.Perks.PerkDefs.Nighttime,
		],
		[
			gt.Const.Perks.PerkDefs.Relentless,
			gt.Const.Perks.PerkDefs.Fearsome,
			gt.Const.Perks.PerkDefs.Footwork,
			gt.Const.Perks.PerkDefs.Rotation,
		],
		[
			gt.Const.Perks.PerkDefs.Berserk,
			gt.Const.Perks.PerkDefs.BattleForged,
			gt.Const.Perks.PerkDefs.WolfBite,
		],
		[
			gt.Const.Perks.PerkDefs.LegendGruesomeFeast,
			gt.Const.Perks.PerkDefs.LoneWolf,
			gt.Const.Perks.PerkDefs.BearLineBreaker,
			gt.Const.Perks.PerkDefs.DevastatingStrikes
		],
		[
			gt.Const.Perks.PerkDefs.LegendTerrifyingVisage,
			gt.Const.Perks.PerkDefs.LegendSecondWind,
			gt.Const.Perks.PerkDefs.LastStand,
			gt.Const.Perks.PerkDefs.InspiringPresence,
			gt.Const.Perks.PerkDefs.EnrageWolf,
		],
		[
			gt.Const.Perks.PerkDefs.KillingFrenzy,
			gt.Const.Perks.PerkDefs.BattleFlow,
		],
		[],
		[],
		[],
		[]
	];

	gt.Const.PerksCharmedUnit.NachoTree <- [
		[
			gt.Const.Perks.PerkDefs.FastAdaption,
			gt.Const.Perks.PerkDefs.Pathfinder,
			gt.Const.Perks.PerkDefs.SunderingStrikes,
		],
		[
			gt.Const.Perks.PerkDefs.NachoFrenzy,
		],
		[
			gt.Const.Perks.PerkDefs.Anticipation,
			gt.Const.Perks.PerkDefs.Footwork,
		],
		[
			gt.Const.Perks.PerkDefs.Nacho,
			gt.Const.Perks.PerkDefs.Nighttime,
		],
		[
			gt.Const.Perks.PerkDefs.NachoEat,
			gt.Const.Perks.PerkDefs.BearLineBreaker,
			gt.Const.Perks.PerkDefs.DevastatingStrikes,
		],
		[
			gt.Const.Perks.PerkDefs.NachoBigTummy,
		],
		[
			gt.Const.Perks.PerkDefs.BattleFlow,
			//gt.Const.Perks.PerkDefs.NachoVomiting,
		],
		[],
		[],
		[],
		[]
	];


	gt.Const.PerksCharmedUnit.HyenaTree <- [
		[
			gt.Const.Perks.PerkDefs.FastAdaption,
			gt.Const.Perks.PerkDefs.Pathfinder,
			gt.Const.Perks.PerkDefs.Recover,
			gt.Const.Perks.PerkDefs.SunderingStrikes,
		],
		[
			gt.Const.Perks.PerkDefs.CoupDeGrace,
			gt.Const.Perks.PerkDefs.Backstabber,
			gt.Const.Perks.PerkDefs.Nighttime,
		],
		[
			gt.Const.Perks.PerkDefs.Relentless,
			gt.Const.Perks.PerkDefs.Footwork,
			gt.Const.Perks.PerkDefs.Rotation,
			gt.Const.Perks.PerkDefs.Overwhelm,
		],
		[
			gt.Const.Perks.PerkDefs.Berserk,
			gt.Const.Perks.PerkDefs.LoneWolf,
			gt.Const.Perks.PerkDefs.HyenaBite,
		],
		[
			gt.Const.Perks.PerkDefs.LegendGruesomeFeast,
			gt.Const.Perks.PerkDefs.DevastatingStrikes,
			gt.Const.Perks.PerkDefs.Fearsome,
		],
		[
			gt.Const.Perks.PerkDefs.LegendTerrifyingVisage,
			gt.Const.Perks.PerkDefs.LegendSecondWind,
			gt.Const.Perks.PerkDefs.ThickHide,
			gt.Const.Perks.PerkDefs.EnrageWolf,
		],
		[
			gt.Const.Perks.PerkDefs.LegendSlaughter,
			gt.Const.Perks.PerkDefs.KillingFrenzy,
			gt.Const.Perks.PerkDefs.BattleFlow,
		],
		[],
		[],
		[],
		[]
	];

	gt.Const.PerksCharmedUnit.LindwurmTree <- [
		[
			gt.Const.Perks.PerkDefs.Pathfinder,
			gt.Const.Perks.PerkDefs.SunderingStrikes,
		],
		[
			gt.Const.Perks.PerkDefs.HoldOut,
			gt.Const.Perks.PerkDefs.LindwurmIntimidate
		],
		[
			gt.Const.Perks.PerkDefs.Fearsome,
			gt.Const.Perks.PerkDefs.ReachAdvantage,
		],
		[
			gt.Const.Perks.PerkDefs.Underdog,
			gt.Const.Perks.PerkDefs.LindwurmBody,
		],
		[
			gt.Const.Perks.PerkDefs.LegendGruesomeFeast,
			gt.Const.Perks.PerkDefs.LegendComposure,
			gt.Const.Perks.PerkDefs.DevastatingStrikes,
			gt.Const.Perks.PerkDefs.BearLineBreaker,
		],
		[
			gt.Const.Perks.PerkDefs.LindwurmAcid,
		],
		[
			gt.Const.Perks.PerkDefs.KillingFrenzy,
		],
		[],
		[],
		[],
		[]
	];

	gt.Const.PerksCharmedUnit.SchratTree <- [
		[
			gt.Const.Perks.PerkDefs.ShieldBash,
			gt.Const.Perks.PerkDefs.CripplingStrikes,
			gt.Const.Perks.PerkDefs.Pathfinder,
			gt.Const.Perks.PerkDefs.SunderingStrikes,
			gt.Const.Perks.PerkDefs.SchratUprootAoE,
		],
		[
			gt.Const.Perks.PerkDefs.CoupDeGrace,
			gt.Const.Perks.PerkDefs.HoldOut,
			gt.Const.Perks.PerkDefs.SteelBrow,
		],
		[
			gt.Const.Perks.PerkDefs.LegendLacerate,
			gt.Const.Perks.PerkDefs.ShieldExpert,
			gt.Const.Perks.PerkDefs.SchratShield,
			gt.Const.Perks.PerkDefs.BearLineBreaker,
		],
		[
			gt.Const.Perks.PerkDefs.LegendSpecialistShieldSkill,
			gt.Const.Perks.PerkDefs.LegendSpecialistShieldPush,
			gt.Const.Perks.PerkDefs.SchratUproot,
		],
		[
			gt.Const.Perks.PerkDefs.DevastatingStrikes,
			gt.Const.Perks.PerkDefs.SchratSapling,
		],
		[],
		[
			gt.Const.Perks.PerkDefs.LegendRoots,
		],
		[],
		[],
		[],
		[]
	];

	gt.Const.PerksCharmedUnit.SmallSchratTree <- [
		[
			gt.Const.Perks.PerkDefs.ShieldBash,
			gt.Const.Perks.PerkDefs.CripplingStrikes,
			gt.Const.Perks.PerkDefs.Pathfinder,
			gt.Const.Perks.PerkDefs.SunderingStrikes,
		],
		[
			gt.Const.Perks.PerkDefs.CoupDeGrace,
			gt.Const.Perks.PerkDefs.HoldOut,
			gt.Const.Perks.PerkDefs.SteelBrow,
		],
		[
			gt.Const.Perks.PerkDefs.LegendLacerate,
			gt.Const.Perks.PerkDefs.ShieldExpert,
			
		],
		[
			gt.Const.Perks.PerkDefs.LegendSpecialistShieldSkill,
			gt.Const.Perks.PerkDefs.LegendSpecialistShieldPush,
		],
		[
			gt.Const.Perks.PerkDefs.DevastatingStrikes
		],
		[],
		[
			gt.Const.Perks.PerkDefs.LegendRoots,
		],
		[],
		[],
		[],
		[]
	];

	gt.Const.PerksCharmedUnit.SerpentTree <- [
		[
			gt.Const.Perks.PerkDefs.LegendAlert,
			gt.Const.Perks.PerkDefs.Pathfinder,
			gt.Const.Perks.PerkDefs.BoondockBlade,
			gt.Const.Perks.PerkDefs.SunderingStrikes,
		],
		[
			gt.Const.Perks.PerkDefs.Backstabber,
			gt.Const.Perks.PerkDefs.Dodge,
			gt.Const.Perks.PerkDefs.LegendEntice,
		],
		[
			gt.Const.Perks.PerkDefs.Anticipation,
			gt.Const.Perks.PerkDefs.Relentless,
		],
		[
			gt.Const.Perks.PerkDefs.SerpentVenom,
			gt.Const.Perks.PerkDefs.SerpentDrag,
		],
		[
			gt.Const.Perks.PerkDefs.Nimble,
			gt.Const.Perks.PerkDefs.SerpentBite,
			gt.Const.Perks.PerkDefs.LegendClarity,
		],
		[
			gt.Const.Perks.PerkDefs.LegendGruesomeFeast,
			gt.Const.Perks.PerkDefs.DevastatingStrikes,
		],
		[	
			gt.Const.Perks.PerkDefs.SerpentGiant,
			gt.Const.Perks.PerkDefs.LegendPoisonImmunity,
		],
		[],
		[],
		[],
		[]
	];

	gt.Const.PerksCharmedUnit.SpiderTree <- [
		[
			gt.Const.Perks.PerkDefs.FastAdaption,
			gt.Const.Perks.PerkDefs.Pathfinder,
			gt.Const.Perks.PerkDefs.Recover,
			gt.Const.Perks.PerkDefs.BoondockBlade,
			gt.Const.Perks.PerkDefs.SunderingStrikes,
		],
		[
			gt.Const.Perks.PerkDefs.Backstabber,
			gt.Const.Perks.PerkDefs.LegendLeap,
			gt.Const.Perks.PerkDefs.Nighttime,
		],
		[
			gt.Const.Perks.PerkDefs.Dodge,
			gt.Const.Perks.PerkDefs.Footwork,
			gt.Const.Perks.PerkDefs.Rotation,
		],
		[
			gt.Const.Perks.PerkDefs.Nimble,
			gt.Const.Perks.PerkDefs.InspiringPresence,
			gt.Const.Perks.PerkDefs.SpiderVenom,
			
		],
		[
			gt.Const.Perks.PerkDefs.PushTheAdvantage,
			gt.Const.Perks.PerkDefs.Underdog,
			gt.Const.Perks.PerkDefs.DevastatingStrikes,
			gt.Const.Perks.PerkDefs.SpiderWeb,
		],
		[
			gt.Const.Perks.PerkDefs.SpiderBite,
			gt.Const.Perks.PerkDefs.LegendGruesomeFeast,
			gt.Const.Perks.PerkDefs.KillingFrenzy,
			gt.Const.Perks.PerkDefs.BattleForged,
		],
		[
			gt.Const.Perks.PerkDefs.LegendFreedomOfMovement,
		],
		[],
		[],
		[],
		[]
	];

	gt.Const.PerksCharmedUnit.UnholdTree <- [
		[
			gt.Const.Perks.PerkDefs.Stalwart,
			gt.Const.Perks.PerkDefs.SunderingStrikes,
			gt.Const.Perks.PerkDefs.UnholdUnarmedAttack,
		],
		[
			gt.Const.Perks.PerkDefs.LegendUnarmedTraining,
			gt.Const.Perks.PerkDefs.LegendGrapple,
			gt.Const.Perks.PerkDefs.HoldOut,
			gt.Const.Perks.PerkDefs.SteelBrow,
		],
		[
			gt.Const.Perks.PerkDefs.LegendSmackdown,
		],
		[
			gt.Const.Perks.PerkDefs.BloodyHarvest,
			gt.Const.Perks.PerkDefs.LegendSpecFists,
			gt.Const.Perks.PerkDefs.UnholdFling,
			gt.Const.Perks.PerkDefs.BearLineBreaker,
		],
		[
			gt.Const.Perks.PerkDefs.LegendFullForce,
		],
		[
			gt.Const.Perks.PerkDefs.LegendGruesomeFeast,
			gt.Const.Perks.PerkDefs.ReturnFavor,
		],
		[
			gt.Const.Perks.PerkDefs.KillingFrenzy,
		],
		[],
		[],
		[],
		[]
	];

	gt.Const.PerksCharmedUnit.BearTree <- [
		[
			gt.Const.Perks.PerkDefs.Pathfinder,
			gt.Const.Perks.PerkDefs.Stalwart,
			gt.Const.Perks.PerkDefs.SunderingStrikes,
		],
		[
			gt.Const.Perks.PerkDefs.HoldOut,
			gt.Const.Perks.PerkDefs.SteelBrow,
		],
		[
			gt.Const.Perks.PerkDefs.LegendSmackdown,
		],
		[
			gt.Const.Perks.PerkDefs.BloodyHarvest,
			gt.Const.Perks.PerkDefs.NachoFrenzy,
		],
		[
			gt.Const.Perks.PerkDefs.LegendFullForce,
			gt.Const.Perks.PerkDefs.BearLineBreaker,
		],
		[
			gt.Const.Perks.PerkDefs.LegendGruesomeFeast,
			gt.Const.Perks.PerkDefs.ReturnFavor,
			gt.Const.Perks.PerkDefs.Berserk,
		],
		[
			gt.Const.Perks.PerkDefs.KillingFrenzy,
		],
		[],
		[],
		[],
		[]
	];


	gt.Const.PerksCharmedUnit.DemonHound <- [
		[
			gt.Const.Perks.PerkDefs.FastAdaption,
			gt.Const.Perks.PerkDefs.Pathfinder,
			gt.Const.Perks.PerkDefs.CoupDeGrace,
		],
		[
			gt.Const.Perks.PerkDefs.Backstabber,
			gt.Const.Perks.PerkDefs.Nighttime,
		],
		[
			gt.Const.Perks.PerkDefs.Relentless,
			gt.Const.Perks.PerkDefs.Footwork,
			gt.Const.Perks.PerkDefs.Rotation,
		],
		[
			gt.Const.Perks.PerkDefs.SkeletonHarden,
			gt.Const.Perks.PerkDefs.Berserk,
			gt.Const.Perks.PerkDefs.BattleForged,
			gt.Const.Perks.PerkDefs.Overwhelm,
		],
		[
			gt.Const.Perks.PerkDefs.LegendGruesomeFeast,
			gt.Const.Perks.PerkDefs.LoneWolf,
			gt.Const.Perks.PerkDefs.BearLineBreaker,
			gt.Const.Perks.PerkDefs.DevastatingStrikes
		],
		[
			gt.Const.Perks.PerkDefs.LegendTerrifyingVisage,
			gt.Const.Perks.PerkDefs.LegendSecondWind,
			gt.Const.Perks.PerkDefs.LastStand,
			gt.Const.Perks.PerkDefs.InspiringPresence,
			gt.Const.Perks.PerkDefs.EnrageWolf,
			gt.Const.Perks.PerkDefs.Fearsome,
		],
		[
			gt.Const.Perks.PerkDefs.KillingFrenzy,
			gt.Const.Perks.PerkDefs.BattleFlow,
		],
		[],
		[],
		[],
		[]
	];


	gt.Const.PerksCharmedUnit.NecroTree <- [
		gt.Const.Perks.WarlockMagicTree.Tree,
		gt.Const.Perks.VampireMagicTree.Tree,
		gt.Const.Perks.ZombieMagicTree.Tree,
		gt.Const.Perks.SkeletonMagicTree.Tree,
	];

	delete this.HexenHooks.hookPerkDefs;
}