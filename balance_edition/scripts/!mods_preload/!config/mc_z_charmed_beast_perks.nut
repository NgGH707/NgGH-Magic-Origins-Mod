//dynamic perk group for beast

local gt = this.getroottable();

if (!("PerksCharmedBeast" in gt.Const))
{
	gt.Const.PerksCharmedBeast <- {};
}

if (!("Perks" in gt.Const))
{
	gt.Const.Perks <- {};
}

if (!("PerkDefs" in gt.Const.Perks))
{
	gt.Const.Perks.PerkDefs <- {};
}

//must have perks for each beasts type

gt.Const.AvailableFavourdPerks <- [
	//low-tier
	[
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyGhoul,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyDirewolf,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemySpider,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemySkeleton,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyZombie,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyCaravan,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyMercenary,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyNoble,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemySoutherner,
	],

	//mid-tier
	[
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyVampire,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyAlps,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyOrk,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyGoblin,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyBandit,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyNomad,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyBarbarian,
	],

	//high-tier
	[
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyHexen,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyUnhold,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemySchrat,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyLindwurm,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemyArcher,
		gt.Const.Perks.PerkDefs.LegendFavouredEnemySwordmaster,
	],
];

gt.Const.AvailablePerksForBeast <- [
	//low-tier
	[
		gt.Const.Perks.PerkDefs.LegendBackToBasics,
		gt.Const.Perks.PerkDefs.Colossus,
		gt.Const.Perks.PerkDefs.LegendAlert,
		gt.Const.Perks.PerkDefs.CripplingStrikes,
		gt.Const.Perks.PerkDefs.Pathfinder,
		gt.Const.Perks.PerkDefs.SunderingStrikes,
		gt.Const.Perks.PerkDefs.LegendBlendIn,
		gt.Const.Perks.PerkDefs.NineLives,
		gt.Const.Perks.PerkDefs.FastAdaption,
		gt.Const.Perks.PerkDefs.Adrenalin,
		gt.Const.Perks.PerkDefs.BagsAndBelts,
		gt.Const.Perks.PerkDefs.Recover,
		gt.Const.Perks.PerkDefs.Backstabber,
		gt.Const.Perks.PerkDefs.SteelBrow,
		gt.Const.Perks.PerkDefs.Dodge,
		gt.Const.Perks.PerkDefs.LegendComposure,
		gt.Const.Perks.PerkDefs.LegendTrueBeliever,
		gt.Const.Perks.PerkDefs.LegendEvasion,
		gt.Const.Perks.PerkDefs.FortifiedMind,
		gt.Const.Perks.PerkDefs.Anticipation,
		gt.Const.Perks.PerkDefs.Steadfast,
		gt.Const.Perks.PerkDefs.LegendOnslaught,
		gt.Const.Perks.PerkDefs.Feint,
		gt.Const.Perks.PerkDefs.CoupDeGrace,
		gt.Const.Perks.PerkDefs.HoldOut,
		gt.Const.Perks.PerkDefs.Sprint,
		gt.Const.Perks.PerkDefs.Footwork,
		gt.Const.Perks.PerkDefs.LegendLacerate,
		gt.Const.Perks.PerkDefs.Relentless,
		gt.Const.Perks.PerkDefs.Taunt,
		gt.Const.Perks.PerkDefs.Rotation,
		gt.Const.Perks.PerkDefs.LegendSmackdown,
		gt.Const.Perks.PerkDefs.Debilitate
		gt.Const.Perks.PerkDefs.LegendHidden,
		gt.Const.Perks.PerkDefs.Gifted,
	],
	
	//mid-tier
	[
		gt.Const.Perks.PerkDefs.LegendComposure,
		gt.Const.Perks.PerkDefs.LegendTrueBeliever,
		gt.Const.Perks.PerkDefs.LegendHairSplitter,
		gt.Const.Perks.PerkDefs.Underdog,
		gt.Const.Perks.PerkDefs.LegendLithe
		gt.Const.Perks.PerkDefs.LegendBloodbath,
		gt.Const.Perks.PerkDefs.LoneWolf,
		gt.Const.Perks.PerkDefs.Stalwart,
		gt.Const.Perks.PerkDefs.Overwhelm,
		gt.Const.Perks.PerkDefs.LegendClarity,
		gt.Const.Perks.PerkDefs.LegendEscapeArtist,
		gt.Const.Perks.PerkDefs.PushTheAdvantage,
		gt.Const.Perks.PerkDefs.LegendGatherer,
		gt.Const.Perks.PerkDefs.Nimble,
		gt.Const.Perks.PerkDefs.LegendTerrifyingVisage,
		gt.Const.Perks.PerkDefs.LegendAssuredConquest,
		gt.Const.Perks.PerkDefs.LegendSecondWind,
		gt.Const.Perks.PerkDefs.HeadHunter,
		gt.Const.Perks.PerkDefs.DoubleStrike,
		gt.Const.Perks.PerkDefs.DevastatingStrikes,
	],
	
	//high-tier
	[
		gt.Const.Perks.PerkDefs.LegendTerrifyingVisage,
		gt.Const.Perks.PerkDefs.InspiringPresence,
		gt.Const.Perks.PerkDefs.Berserk,
		gt.Const.Perks.PerkDefs.LegendTumble,
		gt.Const.Perks.PerkDefs.LegendFullForce,
		gt.Const.Perks.PerkDefs.Vengeance,
		gt.Const.Perks.PerkDefs.LegendMindOverBody,
		gt.Const.Perks.PerkDefs.ReturnFavor,
		gt.Const.Perks.PerkDefs.KillingFrenzy,
		gt.Const.Perks.PerkDefs.Fearsome,
		gt.Const.Perks.PerkDefs.LegendForcefulSwing,
		gt.Const.Perks.PerkDefs.PerfectFocus
		gt.Const.Perks.PerkDefs.Indomitable,
		gt.Const.Perks.PerkDefs.LegendSlaughter,
		gt.Const.Perks.PerkDefs.LegendFreedomOfMovement,
		gt.Const.Perks.PerkDefs.LegendMuscularity,
		gt.Const.Perks.PerkDefs.LastStand,
		gt.Const.Perks.PerkDefs.Rebound,
		gt.Const.Perks.PerkDefs.BattleFlow,
	],
];

gt.Const.HumanoidBeast <- [
	gt.Const.EntityType.Alp,
	gt.Const.EntityType.SchratSmall,
	gt.Const.EntityType.LegendDemonAlp,
	gt.Const.EntityType.LegendGreenwoodSchratSmall,
];

gt.Const.BeastHasAoE <- [
	gt.Const.EntityType.Unhold,
	gt.Const.EntityType.UnholdFrost,
	gt.Const.EntityType.UnholdBog,
	gt.Const.EntityType.BarbarianUnhold,
	gt.Const.EntityType.BarbarianUnholdFrost,
	gt.Const.EntityType.LegendRockUnhold,
	gt.Const.EntityType.Lindwurm,
	gt.Const.EntityType.LegendStollwurm,
	gt.Const.EntityType.Schrat,
	gt.Const.EntityType.LegendGreenwoodSchrat,
	gt.Const.EntityType.LegendSkinGhoul,
	gt.Const.EntityType.LegendBear,
];

gt.Const.BeastNeverHasNimble <- [
	gt.Const.EntityType.Unhold,
	gt.Const.EntityType.UnholdFrost,
	gt.Const.EntityType.UnholdBog,
	gt.Const.EntityType.BarbarianUnhold,
	gt.Const.EntityType.BarbarianUnholdFrost,
	gt.Const.EntityType.LegendRockUnhold,
	gt.Const.EntityType.Lindwurm,
	gt.Const.EntityType.LegendStollwurm,
	gt.Const.EntityType.Schrat,
	gt.Const.EntityType.LegendGreenwoodSchrat,
	gt.Const.EntityType.LegendSkinGhoul,
	gt.Const.EntityType.TricksterGod,
];

gt.Const.PerkDefaultPerRow <- [
	6,
	6,
	6,
	9,
	5,
	4,
	4
];







