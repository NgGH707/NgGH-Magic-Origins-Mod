local gt = this.getroottable();
gt.Const.Tactical.CombatInfo.LootWithoutScript <- [];
gt.Const.Corpse.CorpseAsItem <- null;
gt.Const.World.CampBuildings.Butcher <- "camp.butcher";
gt.Const.Difficulty.ButcherMult <- [
	1.0,
	0.9,
	0.8,
	0.7
];
gt.Const.Necro <- {
	ConditionLossPerSixHour = 0.06,
	NoMaintainedMult = 1.0,
	HasMaintainedMult = 0.1,
	BossTypeEnemies = [
		this.Const.EntityType.ZombieBoss,
		this.Const.EntityType.SkeletonBoss,
		this.Const.EntityType.SkeletonLich,
		this.Const.EntityType.LegendMummyQueen,
		this.Const.EntityType.Kraken,
		this.Const.EntityType.TricksterGod,
	],
	LeaderTypeEnemies = [
		// human
		this.Const.EntityType.BanditLeader,
		this.Const.EntityType.MilitiaCaptain,
		this.Const.EntityType.Sergeant,
		this.Const.EntityType.Knight,
		this.Const.EntityType.Swordmaster,
		this.Const.EntityType.HedgeKnight,
		this.Const.EntityType.MasterArcher,
		this.Const.EntityType.Wildman,
		this.Const.EntityType.BarbarianChampion,
		this.Const.EntityType.BarbarianChosen,
		this.Const.EntityType.BarbarianMadman,
		this.Const.EntityType.Officer,
		this.Const.EntityType.NomadLeader,
		this.Const.EntityType.DesertStalker,
		this.Const.EntityType.Executioner,
		this.Const.EntityType.DesertDevil,
		this.Const.EntityType.BanditWarlord,
		this.Const.EntityType.FreeCompanyLeader,
		this.Const.EntityType.FreeCompanyLeaderLow,

		// non-human
		this.Const.EntityType.OrcWarlord,
		this.Const.EntityType.GoblinLeader,
		this.Const.EntityType.Lindwurm,
		this.Const.EntityType.Hexe,
		this.Const.EntityType.ZombieBetrayer,
		this.Const.EntityType.LegendOrcBehemoth,
		this.Const.EntityType.LegendWhiteDirewolf,
		this.Const.EntityType.LegendSkinGhoul,
		this.Const.EntityType.LegendStollwurm,
		this.Const.EntityType.LegendRockUnhold,
		this.Const.EntityType.LegendRedbackSpider,
		this.Const.EntityType.LegendDemonAlp,
		this.Const.EntityType.LegendHexeLeader,
		this.Const.EntityType.LegendGreenwoodSchrat,
		this.Const.EntityType.LegendBanshee,
		this.Const.EntityType.LegendDemonHound,
		this.Const.EntityType.LegendVampireLord,
	],
};

	



