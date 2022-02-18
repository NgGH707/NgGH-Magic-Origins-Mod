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
	ConditionLossPerSixHour = 0.125,
	NoMaintainedMult = 1.0,
	HasMaintainedMult = 0.1,
	UndeadType = {
		Zombie = 0,
		Skeleton = 1,
		Vampire = 2,
		Mummy = 3,
		Ghost = 4,
		Banshee = 5,
		DemonHound = 6,
		COUNT =	6
	},
	CommonUndeadBackgrounds = [
		"nggh_zombie_background",
		"nggh_skeleton_background",
		"nggh_vampire_background",
		"nggh_mummy_background",
		"nggh_ghost_background",
		"nggh_banshee_background",
		"nggh_demon_hound_background",
	],
	InjuryPermanent = [
		[
			{
				ID = "injury.missing_nose",
				Script = "injury_permanent/missing_nose_injury"
			},
			{
				ID = "injury.missing_eye",
				Script = "injury_permanent/missing_eye_injury"
			},
			{
				ID = "injury.missing_ear",
				Script = "injury_permanent/missing_ear_injury"
			},
			{
				ID = "injury.missing_finger",
				Script = "injury_permanent/missing_finger_injury"
			},
			{
				ID = "injury.maimed_foot",
				Script = "injury_permanent/maimed_foot_injury"
			},
			{
				ID = "injury.broken_elbow_joint",
				Script = "injury_permanent/broken_elbow_joint_injury"
			},
			{
				ID = "injury.missing_hand",
				Script = "injury_permanent/missing_hand_injury"
			},
		],
		[
			{
				ID = "injury.missing_finger",
				Script = "injury_permanent/missing_finger_injury"
			},
			{
				ID = "injury.maimed_foot",
				Script = "injury_permanent/maimed_foot_injury"
			},
			{
				ID = "injury.broken_elbow_joint",
				Script = "injury_permanent/broken_elbow_joint_injury"
			},
			{
				ID = "injury.missing_hand",
				Script = "injury_permanent/missing_hand_injury"
			},
		],
		[], // vampire
		[
			{
				ID = "injury.missing_ear",
				Script = "injury_permanent/missing_ear_injury"
			},
			{
				ID = "injury.missing_finger",
				Script = "injury_permanent/missing_finger_injury"
			},
			{
				ID = "injury.maimed_foot",
				Script = "injury_permanent/maimed_foot_injury"
			},
			{
				ID = "injury.broken_elbow_joint",
				Script = "injury_permanent/broken_elbow_joint_injury"
			},
			{
				ID = "injury.missing_hand",
				Script = "injury_permanent/missing_hand_injury"
			},
		],
		[], // ghost
		[], // banshee
		[
			{
				ID = "injury.maimed_foot",
				Script = "injury_permanent/maimed_foot_injury"
			},
			{
				ID = "injury.broken_elbow_joint",
				Script = "injury_permanent/broken_elbow_joint_injury"
			},
		],
	],
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

	



