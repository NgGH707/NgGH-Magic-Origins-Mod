// changes to beast perk tree if PTR exists
::Const.PerksCharmedUnit.HyenaTree[3].push(::Const.Perks.PerkDefs.PTRDeepCuts);
::Const.PerksCharmedUnit.SerpentTree[3].push(::Const.Perks.PerkDefs.PTRLeverage);
::Const.PerksCharmedUnit.SerpentTree[5].push(::Const.Perks.PerkDefs.PTRUtilitarian);
::Const.PerksCharmedUnit.LindwurmTree[3].push(::Const.Perks.PerkDefs.PTRLeverage);
::Const.PerksCharmedUnit.LindwurmTree[5].push(::Const.Perks.PerkDefs.PTRUtilitarian);
::Const.PerksCharmedUnit.LindwurmTree[5].push(::Const.Perks.PerkDefs.PTRExudeConfidence);
::Const.PerksCharmedUnit.SchratTree[5].push(::Const.Perks.PerkDefs.PTRExudeConfidence);

// overwrite with the new perk tree templates
::Const.PerksCharmedUnit.GoblinAmbusher = {
	WeightMultipliers = [
		[2.0, Const.Perks.UnstoppableTree],
		[10.0, ::Const.Perks.BowTree],
		[2.0, ::Const.Perks.DaggerTree]
	],
	Class = [
		::MSU.Class.WeightedContainer([
			[75, ::Const.Perks.ScoutClassTree],
			[33, ::Const.Perks.NggH_GoblinMountTree],
		])
	],
	Profession = [
		::Const.Perks.HunterProfessionTree
	],
	Styles = [
		::Const.Perks.RangedTree
	],
	Defense = [
		::Const.Perks.LightArmorTree
	],
	Traits = [
		::Const.Perks.FastTree,
		::Const.Perks.AgileTree
	],
};

::Const.PerksCharmedUnit.GoblinFighter = {
	WeightMultipliers = [
		[5.0, ::Const.Perks.ShieldTree],
		[5.0, ::Const.Perks.PolearmTree],
	],
	Class = [
		::MSU.Class.WeightedContainer([
			[40, ::Const.Perks.TrapperClassTree],
			[30, ::Const.Perks.NggH_GoblinMountTree],
			[30, ::Const.Perks.ScoutClassTree]
		]),
	],
	Profession = [
		::MSU.Class.WeightedContainer([
			[50, ::Const.Perks.SoldierProfessionTree],
			[50, ::Const.Perks.JugglerProfessionTree]
		]),
	],
	Defense = [
		::Const.Perks.LightArmorTree
	],
	Weapon = [
		::Const.Perks.SwordTree,
		::MSU.Class.WeightedContainer([
			[20, ::Const.Perks.ThrowingTree],
			[20, ::Const.Perks.SpearTree],
			[20, ::Const.Perks.AxeTree],
			[20, ::Const.Perks.FlailTree],
			[20, ::Const.Perks.DaggerTree],
		]),
	],
	Styles = [
		::MSU.Class.WeightedContainer([
			[80, ::Const.Perks.OneHandedTree],
			[20, ::Const.Perks.TwoHandedTree]
		])
	],
	Traits = [
		::Const.Perks.FastTree,
		::Const.Perks.AgileTree
	],
};

::Const.PerksCharmedUnit.GoblinLeader = {
	WeightMultipliers = [
		[0.25, ::Const.Perks.OrganisedTree ],
		[0.25, ::Const.Perks.DeviousTree ],
		[0.33, ::Const.Perks.ShieldTree ],
		[0.0, ::Const.Perks.HeavyArmorTree ],
		[0.0, ::Const.Perks.BowTree ],
		[0.0, ::Const.Perks.SlingTree ],
		[0.0, ::Const.Perks.SpearTree ],
		[1.25, ::Const.Perks.TrainedTree ]
	],
	Class = [
		::MSU.Class.WeightedContainer([
			[50, ::Const.Perks.SergeantClassTree],
			[50, ::Const.Perks.TacticianClassTree]
		]),
	],
	Defense = [
		::Const.Perks.LightArmorTree
	],
	Weapon = [
		::Const.Perks.SwordTree,
		::Const.Perks.CrossbowTree,
		::MSU.Class.WeightedContainer([
			[25, ::Const.Perks.AxeTree],
			[25, ::Const.Perks.FlailTree],
			[25, ::Const.Perks.CleaverTree],
			[25, ::Const.Perks.HammerTree],
		]),
	]
	Styles = [
		::MSU.Class.WeightedContainer([
			[60, ::Const.Perks.RangedTree],
			[40, ::Const.Perks.OneHandedTree]
		])
	],
	Traits = [
		::Const.Perks.AgileTree,
		::MSU.Class.WeightedContainer([
			[50, ::Const.Perks.NggH_GoblinMountTree],
			[50, ::Const.Perks.UnstoppableTree],
		])
	],
};

::Const.PerksCharmedUnit.GoblinShaman = {
	WeightMultipliers = [
		[2.0, ::Const.Perks.CalmTree],
	],
	Profession = [
		::Const.Perks.ApothecaryProfessionTree
	],
	Class = [
		::MSU.Class.WeightedContainer([
			[55, ::Const.Perks.HealerClassTree],
			[35, ::Const.Perks.EntertainerClassTree],
			[10, ::Const.Perks.NggH_GoblinMountTree],
		]),
	],
	Weapon = [
		::Const.Perks.StaffTree,
		::Const.Perks.DaggerTree,
	]
	Defense = [
		::Const.Perks.LightArmorTree
	],
	Magic = [
		::Const.Perks.EvocationMagicTree
	],
	Styles = [
		::Const.Perks.TwoHandedTree
	],
	Traits = [
		::Const.Perks.AgileTree,
		::Const.Perks.TalentedTree
	],
};

::Const.PerksCharmedUnit.GoblinWolfrider = {
	WeightMultipliers = [
		[0.0, ::Const.Perks.ShieldTree],
		[0.0, ::Const.Perks.PolearmTree],
	],
	Class = [
		::MSU.Class.WeightedContainer([
			[40, ::Const.Perks.ScoutClassTree],
			[60, ::Const.Perks.HoundmasterClassTree],
		]),
	],
	Profession = [
		::Const.Perks.RaiderProfessionTree
	],
	Defense = [
		::Const.Perks.LightArmorTree
	],
	Weapon = [
		::Const.Perks.SpearTree,
		::Const.Perks.SwordTree,
		::MSU.Class.WeightedContainer([
			[25, ::Const.Perks.ThrowingTree],
			[25, ::Const.Perks.CleaverTree],
			[25, ::Const.Perks.MaceTree],
			[25, ::Const.Perks.HammerTree],
		]),
	],
	Styles = [
		::MSU.Class.WeightedContainer([
			[67, ::Const.Perks.OneHandedTree],
			[33, ::Const.Perks.TwoHandedTree]
		]),
	],
	Traits = [
		::Const.Perks.NggH_GoblinMountTree,
		::MSU.Class.WeightedContainer([
			[50, ::Const.Perks.FastTree],
			[50, ::Const.Perks.AgileTree]
		])
	],
};

::Const.PerksCharmedUnit.OrcYoung = {
	WeightMultipliers = [
		[4, ::Const.Perks.LaborerProfessionTree],
		[2, ::Const.Perks.ResilientTree],
		[5, ::Const.Perks.ViciousTree],
		[1.33, ::Const.Perks.ShieldTree],
		[0.5, ::Const.Perks.DaggerTree],
		[2, ::Const.Perks.SwordTree],
		[2, ::Const.Perks.MaceTree],
		[2, ::Const.Perks.FlailTree],
		[3, ::Const.Perks.CleaverTree],
		[2, ::Const.Perks.HammerTree],
		[0.5, ::Const.Perks.PolearmTree],
		[2, ::Const.Perks.ThrowingTree],
		[0.5, ::Const.Perks.SlingTree],
		[0, ::Const.Perks.BowTree],
		[0, ::Const.Perks.CrossbowTree],
		[0, ::Const.Perks.DeviousTree],
		[0, ::Const.Perks.OrganisedTree],
		[0, ::Const.Perks.LightArmorTree],
	],
	Weapon = [
		::Const.Perks.AxeTree,
	],
	Profession = [
		::Const.Perks.RaiderProfessionTree,
		::Const.Perks.WildlingProfessionTree,
	],
	Defense = [
		::Const.Perks.HeavyArmorTree
	],
	Styles = [
		::Const.Perks.OneHandedTree,
		::Const.Perks.TwoHandedTree
	],
	Traits = [
		::Const.Perks.TrainedTree,
		::MSU.Class.WeightedContainer([
			[20, ::Const.Perks.ViciousTree],
			[20, ::Const.Perks.SturdyTree],
			[20, ::Const.Perks.LargeTree],
			[20, ::Const.Perks.UnstoppableTree],
			[20, ::Const.Perks.FastTree],
		])
	]
};

::Const.PerksCharmedUnit.OrcBerserker = {
	WeightMultipliers = [
		[4, ::Const.Perks.LaborerProfessionTree],
		[2, ::Const.Perks.ResilientTree],
		[5, ::Const.Perks.ViciousTree],
		[0, ::Const.Perks.ShieldTree],
		[0.5, ::Const.Perks.DaggerTree],
		[2, ::Const.Perks.SwordTree],
		[2, ::Const.Perks.MaceTree],
		[3, ::Const.Perks.CleaverTree],
		[2, ::Const.Perks.HammerTree],
		[0, ::Const.Perks.PolearmTree],
		[2, ::Const.Perks.ThrowingTree],
		[0, ::Const.Perks.SlingTree],
		[0, ::Const.Perks.BowTree],
		[0, ::Const.Perks.CrossbowTree],
		[0, ::Const.Perks.DeviousTree],
		[0, ::Const.Perks.OrganisedTree],
	],
	Profession = [
		::Const.Perks.WildlingProfessionTree,
		::Const.Perks.RaiderProfessionTree,
		::Const.Perks.LumberjackProfessionTree,
	],
	Weapon = [
		::Const.Perks.AxeTree,
		::Const.Perks.FlailTree,
	],
	Defense = [
		::MSU.Class.WeightedContainer([
			[10, ::Const.Perks.MediumArmorTree],
			[45, ::Const.Perks.HeavyArmorTree],
			[45, ::Const.Perks.LightArmorTree]
		]),
	],
	Styles = [
		::Const.Perks.OneHandedTree,
		::Const.Perks.TwoHandedTree
	],
	Traits = [
		::Const.Perks.UnstoppableTree,
		::Const.Perks.IndestructibleTree,
		::MSU.Class.WeightedContainer([
			[30, ::Const.Perks.ViciousTree],
			[20, ::Const.Perks.SturdyTree],
			[25, ::Const.Perks.LargeTree],
			[25, ::Const.Perks.FastTree],
		])
	],
};

::Const.PerksCharmedUnit.OrcWarrior = {
	WeightMultipliers = [
		[4, ::Const.Perks.LaborerProfessionTree],
		[2, ::Const.Perks.ResilientTree],
		[5, ::Const.Perks.ViciousTree],
		[0.5, ::Const.Perks.DaggerTree],
		[2, ::Const.Perks.SwordTree],
		[2, ::Const.Perks.MaceTree],
		[3, ::Const.Perks.CleaverTree],
		[2, ::Const.Perks.HammerTree],
		[0, ::Const.Perks.PolearmTree],
		[2, ::Const.Perks.ThrowingTree],
		[0, ::Const.Perks.SlingTree],
		[0, ::Const.Perks.DeviousTree],
		[0, ::Const.Perks.OrganisedTree],
		[0, ::Const.Perks.LightArmorTree],
	],
	Profession = [
		::Const.Perks.SoldierProfessionTree,
		::Const.Perks.RaiderProfessionTree
	],
	Defense = [
		::Const.Perks.HeavyArmorTree,
		::Const.Perks.ShieldTree
	],
	Styles = [
		::Const.Perks.OneHandedTree,
		::Const.Perks.TwoHandedTree
	],
	Traits = [
		::Const.Perks.IndestructibleTree,
		::MSU.Class.WeightedContainer([
			[20, ::Const.Perks.ViciousTree],
			[20, ::Const.Perks.SturdyTree],
			[20, ::Const.Perks.LargeTree],
			[20, ::Const.Perks.UnstoppableTree],
			[20, ::Const.Perks.TrainedTree],
		])
	],
};

::Const.PerksCharmedUnit.OrcWarlord = {
	WeightMultipliers = [
		[4, ::Const.Perks.LaborerProfessionTree],
		[0, ::Const.Perks.ShieldTree],
		[2, ::Const.Perks.ResilientTree],
		[5, ::Const.Perks.ViciousTree],
		[0.5, ::Const.Perks.DaggerTree],
		[2, ::Const.Perks.SwordTree],
		[2, ::Const.Perks.MaceTree],
		[2, ::Const.Perks.CleaverTree],
		[2, ::Const.Perks.HammerTree],
		[0, ::Const.Perks.PolearmTree],
		[2, ::Const.Perks.FlailTree],
		[2, ::Const.Perks.ThrowingTree],
		[0, ::Const.Perks.SlingTree],
		[0, ::Const.Perks.BowTree],
		[0, ::Const.Perks.CrossbowTree],
		[0, ::Const.Perks.DeviousTree],
		[0, ::Const.Perks.OrganisedTree],
		[0, ::Const.Perks.LightArmorTree],
	],
	Profession = [
		::Const.Perks.RaiderProfessionTree,
		::Const.Perks.SergeantClassTree,
		::Const.Perks.TacticianClassTree,
	],
	Defense = [
		::Const.Perks.HeavyArmorTree
	],
	Styles = [
		::Const.Perks.OneHandedTree,
		::Const.Perks.TwoHandedTree
	],
	Traits = [
		::Const.Perks.IndestructibleTree,
		::MSU.Class.WeightedContainer([
			[20, ::Const.Perks.ViciousTree],
			[20, ::Const.Perks.SturdyTree],
			[30, ::Const.Perks.LargeTree],
			[30, ::Const.Perks.UnstoppableTree],
		])
	],
};

::Const.PerksCharmedUnit.LegendOrcBehemoth = {
	WeightMultipliers = [
		[2, ::Const.Perks.ResilientTree],
		[5, ::Const.Perks.ViciousTree],
		[0, ::Const.Perks.DeviousTree],
		[0, ::Const.Perks.OrganisedTree],
		[0, ::Const.Perks.LightArmorTree],
		[1.33, ::Const.Perks.ShieldTree],
		[0, ::Const.Perks.DaggerTree],
		[3, ::Const.Perks.SwordTree],
		[3, ::Const.Perks.CleaverTree],
		[3, ::Const.Perks.MaceTree],
		[2, ::Const.Perks.FlailTree],
		[2, ::Const.Perks.HammerTree],
		[0, ::Const.Perks.PolearmTree],
		[2, ::Const.Perks.ThrowingTree],
		[0, ::Const.Perks.BowTree],
		[0, ::Const.Perks.CrossbowTree],
		[0, ::Const.Perks.SlingTree],
		[0, ::Const.Perks.SpearTree]
	],
	Profession = [
		::Const.Perks.WildlingProfessionTree,
		::Const.Perks.RaiderProfessionTree
	],
	Defense = [
		::Const.Perks.HeavyArmorTree
	],
	Styles = [
		::Const.Perks.OneHandedTree,
		::Const.Perks.TwoHandedTree
	],
	Traits = [
		::Const.Perks.IndestructibleTree,
		::MSU.Class.WeightedContainer([
			[30, ::Const.Perks.SturdyTree],
			[30, ::Const.Perks.LargeTree],
			[40, ::Const.Perks.UnstoppableTree],
		])
	],
};

::Const.PerksCharmedUnit.LegendOrcElite = {
	WeightMultipliers = [
		[4, ::Const.Perks.LaborerProfessionTree],
		[2, ::Const.Perks.ResilientTree],
		[5, ::Const.Perks.ViciousTree],
		[0.5, ::Const.Perks.DaggerTree],
		[2, ::Const.Perks.SwordTree],
		[2, ::Const.Perks.MaceTree],
		[3, ::Const.Perks.CleaverTree],
		[2, ::Const.Perks.HammerTree],
		[0, ::Const.Perks.PolearmTree],
		[2, ::Const.Perks.ThrowingTree],
		[0, ::Const.Perks.SlingTree],
		[0, ::Const.Perks.DeviousTree],
		[0, ::Const.Perks.OrganisedTree],
		[0, ::Const.Perks.LightArmorTree],
	],
	Profession = [
		::Const.Perks.SoldierProfessionTree,
		::Const.Perks.RaiderProfessionTree,
		::Const.Perks.LumberjackProfessionTree
	],
	Defense = [
		::Const.Perks.HeavyArmorTree,
		::Const.Perks.ShieldTree
	],
	Styles = [
		::Const.Perks.OneHandedTree,
		::Const.Perks.TwoHandedTree
	],
	Traits = [
		::Const.Perks.IndestructibleTree,
		::MSU.Class.WeightedContainer([
			[25, ::Const.Perks.ViciousTree],
			[25, ::Const.Perks.SturdyTree],
			[25, ::Const.Perks.LargeTree],
			[25, ::Const.Perks.UnstoppableTree],
		])
	],
};

