//dynamic perk group for greenskins

local gt = this.getroottable();

if (!("PerksCharmedUnit" in gt.Const))
{
	gt.Const.PerksCharmedUnit <- {};
}

gt.Const.PerksCharmedUnit.GoblinAmbusher <- {
	Weapon = [
		this.Const.Perks.DaggerTree,
		this.Const.Perks.CrossbowTree,
		this.Const.Perks.BowTree,
	],
	Defense = [
		this.Const.Perks.LightArmorTree
	],
	Traits = [
		this.Const.Perks.AgileTree,
		this.Const.Perks.ViciousTree,
		this.Const.Perks.FitTree,
		this.Const.Perks.DeviousTree
	],
	Enemy = [],
	Class = [
		this.Const.Perks.ShortbowClassTree,
	],
	Magic = []
};

gt.Const.PerksCharmedUnit.GoblinFighter <- {
	Weapon = [
		this.Const.Perks.SwordTree,
		this.Const.Perks.PolearmTree,
		this.Const.Perks.DaggerTree,
		this.Const.Perks.ThrowingTree,
	],
	Defense = [
		this.Const.Perks.LightArmorTree,
		this.Const.Perks.ShieldTree,
	],
	Traits = [
		this.Const.Perks.AgileTree,
		this.Const.Perks.ViciousTree,
		this.Const.Perks.FitTree,
		this.Const.Perks.CalmTree
	],
	Enemy = [],
	Class = [
		this.Const.Perks.BeastClassTree,
	],
	Magic = []
};

gt.Const.PerksCharmedUnit.GoblinLeader <- {
	Weapon = [
		this.Const.Perks.CleaverTree,
		this.Const.Perks.SwordTree,
		this.Const.Perks.CrossbowTree,
	],
	Defense = [
		this.Const.Perks.LightArmorTree,
		this.Const.Perks.MediumArmorTree,
	],
	Traits = [
		this.Const.Perks.InspirationalTree,
		this.Const.Perks.AgileTree,
		this.Const.Perks.ViciousTree,
		this.Const.Perks.FitTree,
	],
	Enemy = [],
	Class = [],
	Magic = []
};

gt.Const.PerksCharmedUnit.GoblinShaman <- {
	Weapon = [
		this.Const.Perks.SwordTree,
		this.Const.Perks.DaggerTree,
		this.Const.Perks.StavesTree
	],
	Defense = [
		this.Const.Perks.LightArmorTree
	],
	Traits = [
		this.Const.Perks.IntelligentTree,
		this.Const.Perks.AgileTree,
		this.Const.Perks.FastTree,
		this.Const.Perks.CalmTree
	],
	Enemy = [],
	Class = [
		this.Const.Perks.HealerClassTree,
	],
	Magic = [
		this.Const.Perks.EvocationMagicTree
	]
};

gt.Const.PerksCharmedUnit.GoblinWolfrider<- {
	Weapon = [
		this.Const.Perks.SwordTree,
		this.Const.Perks.SpearTree,
		this.Const.Perks.ThrowingTree,
	],
	Defense = [
		this.Const.Perks.LightArmorTree,
		this.Const.Perks.ShieldTree,
	],
	Traits = [
		this.Const.Perks.AgileTree,
		this.Const.Perks.ViciousTree,
		this.Const.Perks.FitTree,
		this.Const.Perks.SturdyTree
	],
	Enemy = [],
	Class = [
		this.Const.Perks.BeastClassTree
	],
	Magic = []
};


gt.Const.PerksCharmedUnit.OrcYoung <- {
	Weapon = [
		this.Const.Perks.SwordTree,
		this.Const.Perks.AxeTree,
		this.Const.Perks.CleaverTree,
		this.Const.Perks.MaceTree,
	],
	Defense = [
		this.Const.Perks.MediumArmorTree,
		this.Const.Perks.HeavyArmorTree,
		this.Const.Perks.ShieldTree,
	],
	Traits = [
		this.Const.Perks.ViciousTree,
		this.Const.Perks.LargeTree,
		this.Const.Perks.SturdyTree,
		this.Const.Perks.TrainedTree
	],
	Enemy = [
		this.Const.Perks.SkeletonTree,
	],
	Class = [],
	Magic = []
};

gt.Const.PerksCharmedUnit.OrcBerserker <- {
	Weapon = [
		this.Const.Perks.FlailTree,
		this.Const.Perks.HammerTree,
		this.Const.Perks.AxeTree,
		this.Const.Perks.CleaverTree,
	],
	Defense = [
		this.Const.Perks.LightArmorTree,
		this.Const.Perks.MediumArmorTree
	],
	Traits = [
		this.Const.Perks.IndestructibleTree,
		this.Const.Perks.MartyrTree,
		this.Const.Perks.ViciousTree,
		this.Const.Perks.SturdyTree,
	],
	Enemy = [
		this.Const.Perks.SkeletonTree,
	],
	Class = [],
	Magic = []
};

gt.Const.PerksCharmedUnit.OrcWarrior <- {
	Weapon = [
		this.Const.Perks.HammerTree,
		this.Const.Perks.AxeTree,
		this.Const.Perks.CleaverTree,
		this.Const.Perks.GreatSwordTree,
		this.Const.Perks.SwordTree,
	],
	Defense = [
		this.Const.Perks.HeavyArmorTree,
		this.Const.Perks.ShieldTree,
	],
	Traits = [
		this.Const.Perks.IndestructibleTree,
		this.Const.Perks.ViciousTree,
		this.Const.Perks.LargeTree,
		this.Const.Perks.SturdyTree,
	],
	Enemy = [
		this.Const.Perks.SkeletonTree,
	],
	Class = [],
	Magic = []
};

gt.Const.PerksCharmedUnit.OrcWarlord <- {
	Weapon = [
		this.Const.Perks.FlailTree,
		this.Const.Perks.HammerTree,
		this.Const.Perks.AxeTree,
		this.Const.Perks.CleaverTree,
	],
	Defense = [
		this.Const.Perks.HeavyArmorTree,
		this.Const.Perks.ShieldTree,
	],
	Traits = [
		this.Const.Perks.IndestructibleTree,
		this.Const.Perks.ViciousTree,
		this.Const.Perks.InspirationalTree,
		this.Const.Perks.LargeTree,
		this.Const.Perks.SturdyTree,
	],
	Enemy = [
		this.Const.Perks.OrcTree,
		this.Const.Perks.SkeletonTree,
		this.Const.Perks.UnholdTree,
	],
	Class = [],
	Magic = []
};

gt.Const.PerksCharmedUnit.LegendOrcBehemoth <- {
	Weapon = [
		this.Const.Perks.MaceTree,
		this.Const.Perks.FlailTree,
		this.Const.Perks.HammerTree,
		this.Const.Perks.AxeTree,
		this.Const.Perks.CleaverTree,
	],
	Defense = [
		this.Const.Perks.HeavyArmorTree
	],
	Traits = [
		this.Const.Perks.IndestructibleTree,
		this.Const.Perks.MartyrTree,
		this.Const.Perks.ViciousTree,
		this.Const.Perks.SturdyTree,
	],
	Enemy = [
		this.Const.Perks.OrcTree,
		this.Const.Perks.SkeletonTree,
		this.Const.Perks.UnholdTree,
	],
	Class = [],
	Magic = []
};

gt.Const.PerksCharmedUnit.LegendOrcElite <- {
	Weapon = [
		this.Const.Perks.HammerTree,
		this.Const.Perks.AxeTree,
		this.Const.Perks.CleaverTree,
		this.Const.Perks.GreatSwordTree,
		this.Const.Perks.SwordTree,
	],
	Defense = [
		this.Const.Perks.HeavyArmorTree,
		this.Const.Perks.ShieldTree,
	],
	Traits = [
		this.Const.Perks.IndestructibleTree,
		this.Const.Perks.ViciousTree,
		this.Const.Perks.SturdyTree,
	],
	Enemy = [
		this.Const.Perks.OrcTree,
		this.Const.Perks.SkeletonTree,
	],
	Class = [],
	Magic = []
};
	

