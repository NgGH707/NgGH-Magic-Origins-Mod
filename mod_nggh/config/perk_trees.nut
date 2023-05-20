::Const.Perks.Hexe_BDSM_Tree <- {
	ID = "bdsm",
	Name = "Dommy Mommy",
	Descriptions = ["kinky stuffs"],
	Tree = [
		[
			::Const.Perks.PerkDefs.NggH_BDSM_WhipLash,
		],
		[
			::Const.Perks.PerkDefs.NggH_BDSM_MaskOn,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggH_BDSM_WhipMastery,
			::Const.Perks.PerkDefs.NggH_BDSM_Bondage,
		],
		[
			::Const.Perks.PerkDefs.NggH_BDSM_WhipPunish,
		],
		[
			::Const.Perks.PerkDefs.NggH_BDSM_DommyMommy,
			::Const.Perks.PerkDefs.NggH_BDSM_WhipLove,
		],
		[],
	]
};

::Const.Perks.HexeBeastCharmAdvancedTree <- {
	ID = "charm 3",
	Name = "Advanced Charm Beast",
	Descriptions = ["charm beast advance"],
	Tree = [
		[],
		[],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHCharmEnemyGhoul,
			::Const.Perks.PerkDefs.NggHCharmEnemyOrk
		],
		[
			::Const.Perks.PerkDefs.NggHCharmEnemyUnhold,
			::Const.Perks.PerkDefs.NggHCharmEnemySchrat
		],
		[
			::Const.Perks.PerkDefs.NggHCharmEnemyLindwurm
		],
	]
};

::Const.Perks.HexeBeastCharmTree <- {
	ID = "charm 2",
	Name = "Basic Charm Beast",
	Descriptions = ["charm beast basic"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHCharmEnemySpider
		],
		[
			::Const.Perks.PerkDefs.NggHCharmEnemyAlp
			::Const.Perks.PerkDefs.NggHCharmEnemyDirewolf
		],
		[
			::Const.Perks.PerkDefs.NggHCharmEnemyGoblin
		],
		[],
		[],
		[],
	]
};

::Const.Perks.HexeBasicTree <- {
	ID = "charm 1",
	Name = "Basic Charm",
	Descriptions = ["hexe basic"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHCharmBasic,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHCharmWords
		],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHCharmAppearance,
			::Const.Perks.PerkDefs.NggHCharmSpec,
			::Const.Perks.PerkDefs.NggHCharmNudist,
		],
	]
};

::Const.Perks.HexeHexTree <- {
	ID = "hex",
	Name = "Hex",
	Descriptions = ["hex"],
	Tree = [
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHHexHexer,
		],
		[
			::Const.Perks.PerkDefs.NggHHexMastery,
		],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHHexSharePain,
		],
	]
};

::Const.Perks.HexeSpecializedHexTree <- {
	ID = "specialized hex",
	Name = "Specialized Hex",
	Descriptions = ["specialized hex"],
	Tree = [
		[],
		[],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHHexSuffering,
			::Const.Perks.PerkDefs.NggHHexWeakening,
			::Const.Perks.PerkDefs.NggHHexVulnerability,
			::Const.Perks.PerkDefs.NggHHexMisfortune,
		],
		[],
		[],
	]
};

::Const.Perks.LuftTree <- {
	ID = "luft",
	Name = "Luft\'s Tricks",
	Descriptions = ["Luft"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHLuftUnholyFruits,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHLuftPattingSpec,
			::Const.Perks.PerkDefs.NggHLuftInnocentLook
		],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHLuftGhoulBeauty,
		],
	]
};


////////////////////////////////////////////////////
::Const.Perks.CharmArtTrees <- [
	::Const.Perks.HexeBasicTree,
	::Const.Perks.HexeBeastCharmTree,
	::Const.Perks.HexeBeastCharmAdvancedTree,
	::Const.Perks.Hexe_BDSM_Tree,
	//::Const.Perks.LuftTree,
];

::Const.Perks.HexArtTrees <- [
	::Const.Perks.HexeHexTree,
	::Const.Perks.HexeSpecializedHexTree,
];
////////////////////////////////////////////////////


::Const.Perks.NggH_MiscTree <- {
	ID = "Misc",
	Name = "Misc",
	Descriptions = ["Misc"],
	Tree = [
		[
			::Const.Perks.PerkDefs.BoondockBlade,
			::Const.Perks.PerkDefs.NggHMiscDaytime
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHMiscNighttime,
			::Const.Perks.PerkDefs.NggHMiscFairGame
		],
		[],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHMiscChampion
		],
	]
};

::Const.Perks.NggH_GoblinMountTree <- {     
	ID = "Goblin Mount",
	Name = "Mounting",
	Descriptions = ["goblin mount"],
	WeightMultipliers = [
		{Multiplier = 0.0, Tree = ::Const.Perks.DaggerTree},
		{Multiplier = 0.0, Tree = ::Const.Perks.CrossbowTree},
		{Multiplier = 0.0, Tree = ::Const.Perks.PolearmTree},
	],
	Tree = [
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHGoblinMountTraining
		],
		[
			::Const.Perks.PerkDefs.LegendHorseLiberty
		],
		[
			::Const.Perks.PerkDefs.NggHGoblinMountedCharge
		],
		[
			::Const.Perks.PerkDefs.NggHGoblinMountedArchery
		],
		[],
	]
};

::Const.Perks.NggH_AlpTree <- {
	ID = "Alp",
	Name = "Alp",
	Descriptions = ["alp"],
	Tree = [
		[
			::Const.Perks.PerkDefs.NggHMiscDaytime,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpMindBreak,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHAlpAfterimage,
			::Const.Perks.PerkDefs.NggHAlpSleepSpec,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpAfterWake,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpLivingNightmare,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpNightmareSpec,
		],
	]
};

::Const.Perks.NggH_DemonAlpTree <- {
	ID = "Demon Alp",
	Name = "Demonology",
	Descriptions = ["demon alp"],
	Tree = [
		[
			::Const.Perks.PerkDefs.NggHAlpFieceFlame,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpMindBreak,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHAlpControlFlame,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpHellishFlame,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpShadowCopy,
		],
		[],
	]
};

::Const.Perks.NggH_WolfTree <- {
	ID = "Wolf",
	Name = "Canine",
	Descriptions = ["wolf"],
	Tree = [
		[],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHWolfBite,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHWolfThickHide,
			::Const.Perks.PerkDefs.NggHWolfEnrage,
		],
		[
			::Const.Perks.PerkDefs.NggHWolfRabies
		],
	]
};

::Const.Perks.NggH_HyenaTree <- {
	ID = "Hyena",
	Name = "Canine",
	Descriptions = ["hyena"],
	Tree = [
		[],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHHyenaBite,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHWolfThickHide,
			::Const.Perks.PerkDefs.NggHWolfEnrage,
		],
		[
			::Const.Perks.PerkDefs.NggHWolfRabies
		],
	]
};

::Const.Perks.NggH_NachoTree <- {
	ID = "Nacho",
	Name = "Ghoul",
	Descriptions = ["nacho"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHNachoFrenzy,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHNacho,
		],
		[
			::Const.Perks.PerkDefs.NggHNachoEat,
			::Const.Perks.PerkDefs.NggHMiscLineBreaker,
		],
		[
			::Const.Perks.PerkDefs.NggHNachoBigTummy,
		],
		[
			//::Const.Perks.PerkDefs.NggHNachoVomit,
			::Const.Perks.PerkDefs.NggHNachoScavenger,
		],
	]
};

::Const.Perks.NggH_LindwurmTree <- {
	ID = "Lindwurm",
	Name = "Lindwurm",
	Descriptions = ["lindwurm"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHLindwurmIntimidate
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHLindwurmBody,
		],
		[
			::Const.Perks.PerkDefs.NggHMiscLineBreaker,
		],
		[
			::Const.Perks.PerkDefs.NggHLindwurmAcid,
		],
		[],
	]
};

::Const.Perks.NggH_SchratTree <- {
	ID = "Schrat",
	Name = "Schrat",
	Descriptions = ["schrat"],
	Tree = [
		[
			::Const.Perks.PerkDefs.NggHSchratUprootAoE,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHSchratShield,
			::Const.Perks.PerkDefs.NggHMiscLineBreaker,
		],
		[
			::Const.Perks.PerkDefs.NggHSchratUproot,
		],
		[
			::Const.Perks.PerkDefs.NggHSchratSapling,
		],
		[],
		[
			::Const.Perks.PerkDefs.LegendRoots,
		],
	]
};

::Const.Perks.NggH_SmallSchratTree <- {
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
			::Const.Perks.PerkDefs.LegendRoots,
		],
	]
};

::Const.Perks.NggH_SerpentTree <- {
	ID = "Serpent",
	Name = "Serpent",
	Descriptions = ["serpent"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.LegendEntice,
		],
		[
			::Const.Perks.PerkDefs.NggHSerpentVenom,
		],
		[
			::Const.Perks.PerkDefs.NggHSerpentDrag,
			::Const.Perks.PerkDefs.NggHSerpentGiant,
		],
		[],
		[],
		[	
			::Const.Perks.PerkDefs.NggHSerpentBite,
		],
	]
};

::Const.Perks.NggH_SpiderTree <- {
	ID = "Webknecht",
	Name = "Arachnid",
	Descriptions = ["spider"],
	Tree = [
		[
			::Const.Perks.PerkDefs.BoondockBlade,
		],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHSpiderVenom,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHSpiderWeb,
		],
		[
			::Const.Perks.PerkDefs.NggHSpiderBite,
		],
	]
};

::Const.Perks.NggH_UnholdTree <- {
	ID = "Unhold",
	Name = "Unhold",
	Descriptions = ["unhold"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHUnholdUnarmedAttack,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHUnholdFling,
			::Const.Perks.PerkDefs.NggHMiscLineBreaker,
		],
		[],
		[],
		[],
	]
};

::Const.Perks.NggH_SpiderHiveTree <- {
	ID = "Webknecht Eggs",
	Name = "???",
	Descriptions = ["spider hive"],
	Tree = [
		[],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHEggBreedingMachine, 
			::Const.Perks.PerkDefs.NggHEggAttachSpider
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHEggNaturalSelection
		],
		[
			::Const.Perks.PerkDefs.NggHEggInherit
		]
	]			
};

::Const.Perks.NggH_KrakenTree <- {
	ID = "Kraken",
	Name = "Beast of Beasts",
	Descriptions = ["beast of beasts"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHKrakenDevour, 
		],
		[
			::Const.Perks.PerkDefs.NggHKrakenMove, 
		],
		[
			::Const.Perks.PerkDefs.NggHKrakenBite,
		],
		[
			::Const.Perks.PerkDefs.NggHKrakenSwing,
		],
		[ 
			::Const.Perks.PerkDefs.NggHKrakenEnsnare,
		],
		[
			::Const.Perks.PerkDefs.NggHKrakenTentacle,
		]
	]
};

//------------------------------
// undead perk group
::Const.Perks.GhostClassTree <- {
	ID = "Ghost",
	Name = "Vengeful Spirit",
	Descriptions = ["ghastly abilities"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHGhostSpectralBody,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHGhostPhase,
			::Const.Perks.PerkDefs.NggHGhostGhastlyTouch,
		],
		[
			::Const.Perks.PerkDefs.NggHGhostVanish
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHGhostSoulEater,
		]
	]
};

////////////////////////////////////////////////////
::Const.Perks.HexenBeastTrees <- [
	::Const.Perks.NggH_NachoTree,
	::Const.Perks.NggH_UnholdTree,
	::Const.Perks.NggH_SchratTree,
	::Const.Perks.NggH_SerpentTree,
	::Const.Perks.NggH_LindwurmTree,
	::Const.Perks.NggH_WolfTree,
	::Const.Perks.NggH_HyenaTree,
	::Const.Perks.NggH_AlpTree,
	::Const.Perks.NggH_DemonAlpTree,
	::Const.Perks.NggH_SpiderTree,
	::Const.Perks.NggH_SpiderHiveTree,
	::Const.Perks.NggH_GoblinMountTree,
	::Const.Perks.NggH_KrakenTree,
	::Const.Perks.NggH_MiscTree,
];
////////////////////////////////////////////////////
::Const.Perks.NggH_UndeadTrees <- [
	::Const.Perks.GhostClassTree,
];
////////////////////////////////////////////////////



