this.getroottable().Nggh_MagicConcept.hookAddCorpseDatabase <- function ()
{
	local gt = this.getroottable();
	gt.Const.NecroCorpseType <- array(gt.Const.EntityType.len() - 2, {});
	// database of all corpses
	// human ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	gt.Const.NecroCorpseType[this.Const.EntityType.Necromancer] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Militia] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.MilitiaRanged] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.MilitiaVeteran] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.MilitiaCaptain] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BountyHunter] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Peasant] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.CaravanHand] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Footman] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Greatsword] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Billman] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Arbalester] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.StandardBearer] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Sergeant] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Knight] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BanditThug] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BanditPoacher] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BanditMarksman] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BanditRaider] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BanditLeader] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Mercenary] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.MercenaryRanged] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Swordmaster] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.HedgeKnight] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.MasterArcher] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Cultist] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Wildman] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BarbarianThrall] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BarbarianMarauder] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BarbarianChampion] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BarbarianDrummer] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BarbarianBeastmaster] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BarbarianChosen] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BarbarianMadman] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Conscript] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Gunner] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Officer] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Engineer] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Assassin] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Slave] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Gladiator] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.NomadCutthroat] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.NomadOutlaw] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.NomadSlinger] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.NomadArcher] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.NomadLeader] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.DesertStalker] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Executioner] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.DesertDevil] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.PeasantSouthern] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BanditRabble] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BanditVeteran] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BanditWarlord] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendPeasantButcher] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendPeasantBlacksmith] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendPeasantMonk] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendPeasantFarmhand] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendPeasantMinstrel] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendPeasantPoacher] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendPeasantWoodsman] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendPeasantMiner] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendPeasantSquire] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendPeasantWitchHunter] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendHalberdier] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendSlinger] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendFencer] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BanditOutrider] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BanditRabblePoacher] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BanditVermes] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SatoManhunter] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SatoManhunterVeteran] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.FreeCompanySlayer] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.FreeCompanySpearman] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.FreeCompanyFootman] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.FreeCompanyArcher] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.FreeCompanyCrossbow] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.FreeCompanyLongbow] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.FreeCompanyBillman] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.FreeCompanyPikeman] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.FreeCompanyInfantry] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.FreeCompanyLeader] = {
		Description = "",
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.FreeCompanyLeaderLow] = {
		Description = "",
	};


	// undead /////////////////////////////////////////////////////////////////////////////////////////////////////////////
	gt.Const.NecroCorpseType[this.Const.EntityType.Zombie] = {
		Description = "",
		IsHuman = true,
		IsRotten = true,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.ZombieYeoman] = {
		Description = "",
		IsHuman = true,
		IsRotten = true,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.ZombieKnight] = {
		Description = "",
		IsHuman = true,
		IsRotten = true,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.ZombieBetrayer] = { 
		Description = "",
		IsHuman = true,
		IsRotten = true,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.ZombieTreasureHunter] = {
		Description = "",
		IsHuman = true,
		IsRotten = true,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SkeletonLight] = {
		Description = "",
		Icon = "icon_corpse_skeleton_70x70",
		IsBone = true,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SkeletonMedium] = {
		Description = "",
		Icon = "icon_corpse_skeleton_70x70",
		IsBone = true,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SkeletonHeavy] = {
		Description = "",
		Icon = "icon_corpse_skeleton_70x70",
		IsBone = true,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SkeletonPriest] = {
		Description = "",
		Icon = "icon_corpse_skeleton_70x70",
		IsBone = true,
		Loots = [
			{
				Scripts = ["misc/happy_powder_item"],
				Max = 1,
				Min = 0
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SkeletonGladiator] = {
		Description = "",
		Icon = "icon_corpse_skeleton_70x70",
		IsBone = true,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendMummyLight] = {
		Description = "",
		Icon = "icon_corpse_mummy_70x70",
		IsEdible = false,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendMummyMedium] = {
		Description = "",
		Icon = "icon_corpse_mummy_70x70",
		IsEdible = false,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendMummyHeavy] = {
		Description = "",
		Icon = "icon_corpse_mummy_70x70",
		IsEdible = false,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendMummyPriest] = {
		Description = "",
		Icon = "icon_corpse_mummy_70x70",
		IsEdible = false,
		Loots = [
			{
				Scripts = ["misc/happy_powder_item"],
				Max = 1,
				Min = 0
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Vampire] = {
		Description = "",
		Icon = "icon_corpse_vampire_70x70",
		Value = 250,
		IsHeadLess = false,
		IsEdible = false,
		Loots = [
			{
				Scripts = ["misc/vampire_dust_item"],
				Max = 1,
				Min = 0
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendVampireLord] = {
		Description = "",
		Icon = "icon_corpse_vampire_70x70",
		Value = 350,
		IsHeadLess = false,
		IsEdible = false,
		Loots = [
			{
				Scripts = ["misc/vampire_dust_item"],
				Max = 1,
				Min = 0
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendDemonHound] = {
		Description = "",
		Icon = "icon_corpse_demon_hound_70x70",
		Value = 500,
		IsHeadLess = false,
		IsEdible = false,
		Loots = [
			{
				Scripts = ["misc/legend_demon_hound_bones_item"],
				Max = 1,
				Min = 0
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Ghost] = {
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendBanshee] = {
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SkeletonLichMirrorImage] = {
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SkeletonPhylactery] = {
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.FlyingSkull] = {
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.ZombieBoss] = {
		Description = "",
		Icon = "icon_corpse_zombie_boss_70x70",
		Value = 9999,
		IsBoss = true,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SkeletonBoss] = {
		Description = "",
		Icon = "icon_corpse_skeleton_boss_70x70",
		Value = 9999,
		IsHeadLess = false,
		IsBoss = true,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SkeletonLich] = {
		Description = "",
		Icon = "icon_corpse_skeleton_lich_70x70",
		Value = 9999,
		IsHeadLess = false,
		IsBoss = true,
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendMummyQueen] = {
		Description = "",
		Icon = "icon_corpse_mummy_queen_70x70",
		Value = 9999,
		IsHeadLess = false,
		IsBoss = true,
	};


	// non-human ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	gt.Const.NecroCorpseType[this.Const.EntityType.Ghoul] = {
		Description = "",
		Icon = "icon_corpse_ghoul_70x70",
		Value = 500,
		MedicinePerDay = 2,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/ghoul_teeth_item", "misc/ghoul_horn_item", "misc/ghoul_brain_item", "loot/growth_pearls_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.OrcYoung] = {
		Description = "",
		Icon = "icon_corpse_orc_young_70x70",
		Value = 0,
		MedicinePerDay = 2,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_yummy_sausages"],
			}
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.OrcBerserker] = {
		Description = "",
		Icon = "icon_corpse_orc_berserker_70x70",
		Value = 0,
		MedicinePerDay = 2,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_yummy_sausages"],
			}
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.OrcWarrior] = {
		Description = "",
		Icon = "icon_corpse_orc_warrior_70x70",
		Value = 0,
		MedicinePerDay = 2,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_yummy_sausages"],
			}
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.OrcWarlord] = {
		Description = "",
		Icon = "icon_corpse_orc_warlord_70x70",
		Value = 0,
		MedicinePerDay = 3,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_yummy_sausages"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.CaravanDonkey] = {
		Description = "",
		Icon = "icon_corpse_donkey_70x70",
		Value = 250,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.MilitaryDonkey] = {
		Description = "",
		Icon = "icon_corpse_donkey_70x70",
		Value = 250,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.GoblinAmbusher] = {
		Description = "",
		Icon = "icon_corpse_goblin_70x70",
		Value = 0,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_fresh_meat_item"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.GoblinFighter] = {
		Description = "",
		Icon = "icon_corpse_goblin_70x70",
		Value = 0,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_fresh_meat_item"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.GoblinLeader] = {
		Description = "",
		Icon = "icon_corpse_goblin_70x70",
		Value = 0,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_yummy_sausages"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.GoblinShaman] = {
		Description = "",
		Icon = "icon_corpse_goblin_70x70",
		Value = 0,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_yummy_sausages"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.GoblinWolfrider] = {
		Description = "",
		Icon = "icon_corpse_goblin_70x70",
		Value = 0,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_fresh_meat_item"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Wolf] = {
		Description = "",
		Icon = "icon_corpse_wolf_70x70",
		Value = 300,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Wardog] = {
		Description = "",
		Icon = "icon_corpse_wardog_70x70",
		Value = 100,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.ArmoredWardog] = {
		Description = "",
		Icon = "icon_corpse_wardog_70x70",
		Value = 100,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Direwolf] = {
		Description = "",
		Icon = "icon_corpse_direwolf_70x70",
		Value = 500,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/werewolf_pelt_item", "misc/adrenaline_gland_item", "loot/sabertooth_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Lindwurm] = {
		Description = "",
		Icon = "icon_corpse_lindwurm_70x70",
		Value = 1200,
		MedicinePerDay = 7,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_fresh_meat_item"],
			},
			{
				Scripts = ["misc/lindwurm_blood_item", "misc/lindwurm_scales_item", "misc/lindwurm_bones_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Unhold] = {
		Description = "",
		Icon = "icon_corpse_unhold_70x70",
		Value = 750,
		MedicinePerDay = 5,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/unhold_bones_item", "misc/unhold_heart_item", "misc/unhold_hide_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.UnholdFrost] = {
		Description = "",
		Icon = "icon_corpse_unhold_frost_70x70",
		Value = 900,
		MedicinePerDay = 5,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/unhold_bones_item", "misc/unhold_heart_item", "misc/frost_unhold_fur_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.UnholdBog] = {
		Description = "",
		Icon = "icon_corpse_unhold_bog_70x70",
		Value = 800,
		MedicinePerDay = 5,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/unhold_bones_item", "misc/unhold_heart_item", "misc/unhold_hide_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Spider] = {
		Description = "",
		Icon = "icon_corpse_spider_70x70",
		Value = 300,
		MedicinePerDay = 1,
		Loots = [
			{
				Scripts = ["misc/spider_silk_item", "misc/poison_gland_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SpiderEggs] = {
		/*Description = "",
		Icon = "",
		Value = 0,
		MedicinePerDay = 0,
		Loots = [],*/
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Alp] = {
		Description = "",
		Icon = "icon_corpse_alp_70x70",
		Value = 700,
		MedicinePerDay = 0,
		Loots = [
			{
				Scripts = ["misc/parched_skin_item", "misc/third_eye_item", "misc/petrified_scream_item", "loot/soul_splinter_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Hexe] = {
		Description = "",
		Icon = "icon_corpse_hexe_70x70",
		Value = 100,
		MedicinePerDay = 2,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/witch_hair_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Schrat] = {
		Description = "",
		Icon = "icon_corpse_schrat_70x70",
		Value = 1000,
		MedicinePerDay = 0,
		IsEdible = false,
		Loots = [
			{
				Scripts = ["trade/legend_raw_wood_item"],
				Max = 5,
				Min = 3,
			},
			{
				Scripts = ["misc/ancient_wood_item", "misc/glowing_resin_item", "misc/heart_of_the_forest_item", "loot/ancient_amber_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SchratSmall] = {
		Description = "",
		Icon = "icon_corpse_schrat_small_70x70",
		Value = 50,
		MedicinePerDay = 0,
		IsEdible = false,
		Loots = [
			{
				Scripts = ["trade/legend_raw_wood_item"],
				Max = 1,
				Min = 1,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Kraken] = {
		Description = "",
		Icon = "icon_corpse_kraken_70x70",
		Value = 5000,
		MedicinePerDay = 15,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_yummy_sausages"],
			},
			{
				Scripts = ["misc/kraken_horn_plate_item", "misc/kraken_tentacle_item"],
				Max = 3,
				Min = 1,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.KrakenTentacle] = {
		/*Description = "",
		Icon = "",
		Value = 0,
		MedicinePerDay = 0,
		Loots = [],*/
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BarbarianUnhold] = {
		Description = "",
		Icon = "icon_corpse_unhold_70x70",
		Value = 750,
		MedicinePerDay = 5,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/unhold_bones_item", "misc/unhold_heart_item", "misc/unhold_hide_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.BarbarianUnholdFrost] = {
		Description = "",
		Icon = "icon_corpse_unhold_frost_70x70",
		Value = 900,
		MedicinePerDay = 5,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/unhold_bones_item", "misc/unhold_heart_item", "misc/frost_unhold_fur_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Warhound] = {
		Description = "",
		Icon = "icon_corpse_warhound_70x70",
		Value = 125,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.TricksterGod] = {
		Description = "",
		Icon = "icon_corpse_trickster_god_70x70",
		Value = 9999,
		MedicinePerDay = 0,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/unhold_bones_item"],
				Max = 3,
				Min = 3,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Serpent] = {
		Description = "",
		Icon = "icon_corpse_serpent_70x70",
		Value = 400,
		MedicinePerDay = 2,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/serpent_skin_item", "misc/glistening_scales_item", "loot/rainbow_scale_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.SandGolem] = {
		Description = "",
		Icon = "icon_corpse_sand_golem_70x70",
		Value = 50,
		MedicinePerDay = 0,
		IsEdible = false,
		Loots = [
			{
				Scripts = ["trade/peat_bricks_item"],
				Max = 1,
				Min = 0
			},
			{
				Scripts = ["misc/sulfurous_rocks_item", "loot/glittering_rock_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.Hyena] = {
		Description = "",
		Icon = "icon_corpse_hyena_70x70",
		Value = 400,
		MedicinePerDay = 2,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/hyena_fur_item", "misc/acidic_saliva_item", "loot/sabertooth_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendCat] = {
		Description = "",
		Icon = "icon_corpse_cat_70x70",
		Value = 5,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendOrcElite] = {
		Description = "",
		Icon = "icon_corpse_orc_warrior_70x70",
		Value = 0,
		MedicinePerDay = 2,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_yummy_sausages"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendOrcBehemoth] = {
		Description = "",
		Icon = "icon_corpse_orc_behemoth_70x70",
		Value = 0,
		MedicinePerDay = 4,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_yummy_sausages"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendWhiteDirewolf] = {
		Description = "",
		Icon = "icon_corpse_white_direwolf_70x70",
		Value = 1200,
		MedicinePerDay = 4,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/legend_white_wolf_pelt_item", "misc/adrenaline_gland_item", "loot/sabertooth_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendSkinGhoul] = {
		Description = "",
		Icon = "icon_corpse_skin_ghoul_70x70",
		Value = 900,
		MedicinePerDay = 3,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/legend_skin_ghoul_skin_item", "misc/ghoul_teeth_item", "misc/ghoul_brain_item", "loot/growth_pearls_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendStollwurm] = {
		Description = "",
		Icon = "icon_corpse_stollwurm_70x70",
		Value = 3500,
		MedicinePerDay = 10,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_fresh_meat_item"],
			},
			{
				Scripts = ["misc/legend_stollwurm_blood_item", "misc/legend_stollwurm_scales_item", "misc/lindwurm_bones_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendRockUnhold] = {
		Description = "",
		Icon = "icon_corpse_unhold_rock_70x70",
		Value = 1800,
		MedicinePerDay = 9,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/legend_rock_unhold_bones_item", "misc/unhold_heart_item", "misc/legend_rock_unhold_hide_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendRedbackSpider] = {
		Description = "",
		Icon = "icon_corpse_redback_70x70",
		Value = 900,
		MedicinePerDay = 5,
		Loots = [
			{
				Scripts = ["misc/spider_silk_item", "misc/legend_redback_poison_gland_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendDemonAlp] = {
		Description = "",
		Icon = "icon_corpse_demon_alp_70x70",
		Value = 1500,
		MedicinePerDay = 0,
		Loots = [
			{
				Scripts = ["misc/legend_demon_alp_skin_item", "misc/legend_demon_third_eye_item", "misc/petrified_scream_item", "loot/soul_splinter_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendHexeLeader] = {
		Description = "",
		Icon = "icon_corpse_hexe_leader_70x70",
		Value = 350,
		MedicinePerDay = 2,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/legend_witch_leader_hair_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendGreenwoodSchrat] = {
		Description = "",
		Icon = "icon_corpse_schrat_green_70x70",
		Value = 2000,
		MedicinePerDay = 0,
		IsEdible = false,
		Loots = [
			{
				Scripts = ["trade/legend_raw_wood_item"],
				Max = 7,
				Min = 2,
			},
			{
				Scripts = ["misc/legend_ancient_green_wood_item", "misc/glowing_resin_item", "misc/heart_of_the_forest_item", "loot/ancient_amber_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendGreenwoodSchratSmall] = {
		Description = "",
		Icon = "icon_corpse_schrat_green_small_70x70",
		Value = 50,
		MedicinePerDay = 0,
		IsEdible = false,
		Loots = [
			{
				Scripts = ["trade/legend_raw_wood_item"],
				Max = 2,
				Min = 1,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendWhiteWarwolf] = {
		Description = "",
		Icon = "icon_corpse_white_direwolf_70x70",
		Value = 600,
		MedicinePerDay = 2,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["misc/adrenaline_gland_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.LegendBear] = {
		Description = "",
		Icon = "icon_corpse_bear_70x70",
		Value = 600,
		MedicinePerDay = 4,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/strange_meat_item"],
			},
			{
				Scripts = ["trade/furs_item", "loot/legend_bear_fur_item"],
				Max = 1,
				Min = 0,
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.KoboldFighter] = {
		Description = "",
		Icon = "icon_corpse_kobold_70x70",
		Value = 0,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_yummy_sausages"],
			},
		],
	};
	gt.Const.NecroCorpseType[this.Const.EntityType.KoboldWolfrider] = {
		Description = "",
		Icon = "icon_corpse_kobold_70x70",
		Value = 0,
		MedicinePerDay = 1,
		Loots = [
			{
				IsSupplies = true,
				Scripts = ["supplies/legend_yummy_sausages"],
			},
		],
	};

	delete this.Nggh_MagicConcept.hookAddCorpseDatabase;
}