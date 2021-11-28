this.getroottable().Nggh_MagicConcept.hookHexeOrigin <- function ()
{
	local gt = this.getroottable();
	gt.PerkTreeBuilder <- this.new("scripts/mods/perk_tree_builder");
	gt.TalentFiller <- this.new("scripts/mods/talent_filler");
	gt.HexeVersion <- 17;
	gt.IsAccessoryCompanionsExist <- ::mods_getRegisteredMod("mod_AC") != null;

	if (!("HexenOrigin" in gt.Const))
	{
	    gt.Const.HexenOrigin <- {};
	}

	gt.HexenHooks.hookPerkDefs();
	gt.HexenHooks.hookCharacterProperties();
	gt.HexenHooks.hookActorAndEntity();
	gt.HexenHooks.hookItem();
	gt.HexenHooks.hookContracts();
	gt.HexenHooks.hookCharacterScreenAndStates();
	gt.HexenHooks.hookEnemies();
	gt.HexenHooks.hookAI();

	gt.Const.World.Spawn.WitchHunter <- {
		Name = "WitchHunter",
		IsDynamic = true,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_noble_02",
		MaxR = 530,
		MinR = 75,
		Troops = [
			{
				Weight = 55,
				Types = [
					{
						MaxR = 200,
						Type = this.Const.World.Spawn.Troops.MercenaryLOW,
						Cost = 18
					},
					{
						MinR = 100,
						Type = this.Const.World.Spawn.Troops.Mercenary,
						Cost = 25
					}
				]
			},
			{
				Weight = 15,
				Types = [
					{
						MinR = 20,
						Type = this.Const.World.Spawn.Troops.LegendPeasantWitchHunter,
						Cost = 20
					}
				]
			},
			{
				Weight = 15,
				Types = [
					{
						Type = this.Const.World.Spawn.Troops.LegendPeasantMonk,
						Cost = 20
					}
				]
			},
			{
				Weight = 5,
				Types = [
					{
						Type = this.Const.World.Spawn.Troops.HedgeKnight,
						Cost = 40
					},
					{
						Type = this.Const.World.Spawn.Troops.Swordmaster,
						Cost = 40
					}
				]
			},
			{
				Weight = 5,
				Types = [
					{
						MaxR = 80,
						Type = this.Const.World.Spawn.Troops.MasterArcher,
						Cost = 40
					}
				]
			},
			{
				Weight = 5,
				Types = [
					{
						MaxR = 80,
						Type = this.Const.World.Spawn.Troops.Wardog,
						Cost = 8
					}
				]
			},
		]
	};

	//Change perk tree of goblins/orcs with a suitable one from PTR mod
	if (::mods_getRegisteredMod("mod_legends_PTR") != null)
	{
		gt.HexenHooks.hookPTR();
		gt.Const.PerksCharmedUnit.HyenaTree[3].push(gt.Const.Perks.PerkDefs.PTRDeepCuts);
		gt.Const.PerksCharmedUnit.SerpentTree[3].push(gt.Const.Perks.PerkDefs.PTRLeverage);
		gt.Const.PerksCharmedUnit.SerpentTree[5].push(gt.Const.Perks.PerkDefs.PTRUtilitarian);
		gt.Const.PerksCharmedUnit.LindwurmTree[3].push(gt.Const.Perks.PerkDefs.PTRLeverage);
		gt.Const.PerksCharmedUnit.LindwurmTree[5].push(gt.Const.Perks.PerkDefs.PTRUtilitarian);
		gt.Const.PerksCharmedUnit.LindwurmTree[5].push(gt.Const.Perks.PerkDefs.PTRExudeConfidence);
		gt.Const.PerksCharmedUnit.SchratTree[5].push(gt.Const.Perks.PerkDefs.PTRExudeConfidence);
		gt.Const.PerksCharmedUnit.GoblinAmbusher <- {
			WeightMultipliers = [
				{Multiplier = 2.0, Tree = this.Const.Perks.FitTree},
				{Multiplier = 0.5, Tree = this.Const.Perks.CrossbowTree},
				{Multiplier = 2.0, Tree = this.Const.Perks.DaggerTree}
			],
			Profession = [
				[{Weight = 100, Tree = this.Const.Perks.HunterProfessionTree}]
			],
			Traits = [
				[
					{Weight = 34, Tree = this.Const.Perks.AgileTree},
					{Weight = 33, Tree = this.Const.Perks.DeviousTree},
					{Weight = 33, Tree = this.Const.Perks.ViciousTree}
				]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.RangedTree}]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.LightArmorTree}]
			]
		};

		gt.Const.PerksCharmedUnit.GoblinFighter <- {
			WeightMultipliers = [
				{Multiplier = 5.0, Tree = this.Const.Perks.ShieldTree},
			],
			Profession = [
				[{Weight = 100, Tree = this.Const.Perks.SoldierProfessionTree}]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.LightArmorTree}]
			],
			Weapon = [
				[{Weight = 34, Tree = this.Const.Perks.SpearTree}],
				[{Weight = 33, Tree = this.Const.Perks.SwordTree}],
				[{Weight = 33, Tree = this.Const.Perks.ThrowingTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}]
			],
			Traits = [
				[
					{Weight = 34, Tree = this.Const.Perks.AgileTree},
					{Weight = 33, Tree = this.Const.Perks.FitTree},
					{Weight = 33, Tree = this.Const.Perks.ViciousTree}
				]
			],
		};

		gt.Const.PerksCharmedUnit.GoblinLeader <- {
			WeightMultipliers = [
				{ Multiplier = 0.25, Tree = this.Const.Perks.OrganisedTree },
				{ Multiplier = 0.25, Tree = this.Const.Perks.DeviousTree },
				{ Multiplier = 3, Tree = this.Const.Perks.SergeantClassTree },
				{ Multiplier = 0.33, Tree = this.Const.Perks.LightArmorTree },
				{ Multiplier = 0.33, Tree = this.Const.Perks.ShieldTree },
				{ Multiplier = 0, Tree = this.Const.Perks.HeavyArmorTree },
				{ Multiplier = 5.0, Tree = this.Const.Perks.BowTree },
				{ Multiplier = 10.0, Tree = this.Const.Perks.CrossbowTree },
				{ Multiplier = 0, Tree = this.Const.Perks.SlingsTree },
				{ Multiplier = 0.0, Tree = this.Const.Perks.SpearTree }
				{ Multiplier = 1.25, Tree = this.Const.Perks.TrainedTree }
			],
			Class = [
				[{Weight = 50, Tree = this.Const.Perks.SergeantClassTree}],
				[{Weight = 50, Tree = this.Const.Perks.HunterProfessionTree}],
			],
			Defense = [
				[
					{Weight = 50, Tree = this.Const.Perks.MediumArmorTree},
					{Weight = 50, Tree = this.Const.Perks.LightArmorTree}
				]
			],
			Weapon = [
				[{Weight = 100, Tree = this.Const.Perks.SwordTree}]
			]
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}],
				[{Weight = 100, Tree = this.Const.Perks.RangedTree}]
			]
		};

		gt.Const.PerksCharmedUnit.GoblinShaman <- {
			WeightMultipliers = [
			],
			Profession = [
				[{Weight = 100, Tree = this.Const.Perks.ApothecaryProfessionTree}]
			],
			Traits = [
				[
					{Weight = 34, Tree = this.Const.Perks.AgileTree},
					{Weight = 33, Tree = this.Const.Perks.DeviousTree},
					{Weight = 33, Tree = this.Const.Perks.ViciousTree}
				]
			],
			Weapon = [
				[{Weight = 100, Tree = this.Const.Perks.StavesTree}]
			]
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.LightArmorTree}]
			],
			Magic = [
				[{Weight = 100, Tree = this.Const.Perks.EvocationMagicTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}]
			],
		};

		gt.Const.PerksCharmedUnit.GoblinWolfrider <- {
			WeightMultipliers = [
				{Multiplier = 5.0, Tree = this.Const.Perks.ShieldTree},
			],
			Profession = [
				[{Weight = 100, Tree = this.Const.Perks.SoldierProfessionTree}]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.LightArmorTree}]
			],
			Weapon = [
				[{Weight = 34, Tree = this.Const.Perks.SpearTree}],
				[{Weight = 33, Tree = this.Const.Perks.SwordTree}],
				[{Weight = 33, Tree = this.Const.Perks.ThrowingTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}]
			],
			Traits = [
				[
					{Weight = 34, Tree = this.Const.Perks.AgileTree},
					{Weight = 33, Tree = this.Const.Perks.FitTree},
					{Weight = 33, Tree = this.Const.Perks.ViciousTree}
				]
			],
		};

		gt.Const.PerksCharmedUnit.OrcYoung <- {
			WeightMultipliers = [
				{Multiplier = 2, Tree = this.Const.Perks.ResilientTree},
				{Multiplier = 0.25, Tree = this.Const.Perks.ViciousTree},
				{Multiplier = 0, Tree = this.Const.Perks.DeviousTree},
				{Multiplier = 0, Tree = this.Const.Perks.OrganisedTree},
				{Multiplier = 0, Tree = this.Const.Perks.LightArmorTree},
				{Multiplier = 1.33, Tree = this.Const.Perks.ShieldTree},
				{Multiplier = 0, Tree = this.Const.Perks.DaggerTree},
				{Multiplier = 2, Tree = this.Const.Perks.SwordTree},
				{Multiplier = 2, Tree = this.Const.Perks.MaceTree},
				{Multiplier = 2, Tree = this.Const.Perks.FlailTree},
				{Multiplier = 3, Tree = this.Const.Perks.CleaverTree},
				{Multiplier = 2, Tree = this.Const.Perks.HammerTree},
				{Multiplier = 0.25, Tree = this.Const.Perks.PolearmTree},
				{Multiplier = 2, Tree = this.Const.Perks.ThrowingTree},
				{Multiplier = 0, Tree = this.Const.Perks.BowTree},
				{Multiplier = 0, Tree = this.Const.Perks.CrossbowTree},
				{Multiplier = 0, Tree = this.Const.Perks.SlingsTree},
				{Multiplier = 0, Tree = this.Const.Perks.SpearTree}
			],
			Profession = [
				[{Weight = 100, Tree = this.Const.Perks.SoldierProfessionTree},]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.HeavyArmorTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}],
				[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}]
			],
		};

		gt.Const.PerksCharmedUnit.OrcBerserker <- {
			WeightMultipliers = [
				{Multiplier = 2, Tree = this.Const.Perks.ResilientTree},
				{Multiplier = 0.25, Tree = this.Const.Perks.ViciousTree},
				{Multiplier = 0, Tree = this.Const.Perks.DeviousTree},
				{Multiplier = 0, Tree = this.Const.Perks.OrganisedTree},
				{Multiplier = 0, Tree = this.Const.Perks.LightArmorTree},
				{Multiplier = 1.33, Tree = this.Const.Perks.ShieldTree},
				{Multiplier = 0, Tree = this.Const.Perks.DaggerTree},
				{Multiplier = 2, Tree = this.Const.Perks.SwordTree},
				{Multiplier = 2, Tree = this.Const.Perks.MaceTree},
				{Multiplier = 3, Tree = this.Const.Perks.CleaverTree},
				{Multiplier = 2, Tree = this.Const.Perks.FlailTree},
				{Multiplier = 2, Tree = this.Const.Perks.HammerTree},
				{Multiplier = 0, Tree = this.Const.Perks.PolearmTree},
				{Multiplier = 2, Tree = this.Const.Perks.ThrowingTree},
				{Multiplier = 0, Tree = this.Const.Perks.BowTree},
				{Multiplier = 0, Tree = this.Const.Perks.CrossbowTree},
				{Multiplier = 0, Tree = this.Const.Perks.SlingsTree},
				{Multiplier = 0, Tree = this.Const.Perks.SpearTree}
			],
			Profession = [
				[
					{Weight = 100, Tree = this.Const.Perks.SoldierProfessionTree},
				]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.HeavyArmorTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}],
				[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}]
			],
			Traits = [
				[
					{Weight = 50, Tree = this.Const.Perks.IndestructibleTree},
					{Weight = 50, Tree = this.Const.Perks.SturdyTree},
				]
			],
		};

		gt.Const.PerksCharmedUnit.OrcWarrior <- {
			WeightMultipliers = [
				{Multiplier = 2, Tree = this.Const.Perks.ResilientTree},
				{Multiplier = 0.25, Tree = this.Const.Perks.ViciousTree},
				{Multiplier = 0, Tree = this.Const.Perks.DeviousTree},
				{Multiplier = 0, Tree = this.Const.Perks.OrganisedTree},
				{Multiplier = 0, Tree = this.Const.Perks.LightArmorTree},
				{Multiplier = 1.33, Tree = this.Const.Perks.ShieldTree},
				{Multiplier = 0, Tree = this.Const.Perks.DaggerTree},
				{Multiplier = 2, Tree = this.Const.Perks.SwordTree},
				{Multiplier = 2, Tree = this.Const.Perks.MaceTree},
				{Multiplier = 3, Tree = this.Const.Perks.CleaverTree},
				{Multiplier = 2, Tree = this.Const.Perks.FlailTree},
				{Multiplier = 2, Tree = this.Const.Perks.HammerTree},
				{Multiplier = 0, Tree = this.Const.Perks.PolearmTree},
				{Multiplier = 2, Tree = this.Const.Perks.ThrowingTree},
				{Multiplier = 0, Tree = this.Const.Perks.BowTree},
				{Multiplier = 0, Tree = this.Const.Perks.CrossbowTree},
				{Multiplier = 0, Tree = this.Const.Perks.SlingsTree},
				{Multiplier = 0, Tree = this.Const.Perks.SpearTree}
			],
			Profession = [
				[
					{Weight = 100, Tree = this.Const.Perks.SoldierProfessionTree},
				]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.HeavyArmorTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}],
				[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}]
			],
			Traits = [
				[
					{Weight = 50, Tree = this.Const.Perks.IndestructibleTree},
					{Weight = 50, Tree = this.Const.Perks.SturdyTree},
				]
			],
		};

		gt.Const.PerksCharmedUnit.OrcWarlord <- {
			WeightMultipliers = [
				{Multiplier = 2, Tree = this.Const.Perks.ResilientTree},
				{Multiplier = 0.25, Tree = this.Const.Perks.ViciousTree},
				{Multiplier = 0, Tree = this.Const.Perks.DeviousTree},
				{Multiplier = 0, Tree = this.Const.Perks.OrganisedTree},
				{Multiplier = 0, Tree = this.Const.Perks.LightArmorTree},
				{Multiplier = 1.33, Tree = this.Const.Perks.ShieldTree},
				{Multiplier = 0, Tree = this.Const.Perks.DaggerTree},
				{Multiplier = 2, Tree = this.Const.Perks.SwordTree},
				{Multiplier = 3, Tree = this.Const.Perks.CleaverTree},
				{Multiplier = 2, Tree = this.Const.Perks.MaceTree},
				{Multiplier = 2, Tree = this.Const.Perks.FlailTree},
				{Multiplier = 2, Tree = this.Const.Perks.HammerTree},
				{Multiplier = 2, Tree = this.Const.Perks.AxeTree},
				{Multiplier = 0, Tree = this.Const.Perks.PolearmTree},
				{Multiplier = 2, Tree = this.Const.Perks.ThrowingTree},
				{Multiplier = 0, Tree = this.Const.Perks.BowTree},
				{Multiplier = 0, Tree = this.Const.Perks.CrossbowTree},
				{Multiplier = 0, Tree = this.Const.Perks.SlingsTree},
				{Multiplier = 0, Tree = this.Const.Perks.SpearTree}
			],
			Profession = [
				[
					{Weight = 50, Tree = this.Const.Perks.SergeantClassTree},
				]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.HeavyArmorTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}],
				[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}]
			],
			Traits = [
				[
					{Weight = 50, Tree = this.Const.Perks.IndestructibleTree},
					{Weight = 50, Tree = this.Const.Perks.SturdyTree},
				]
			],
		};

		gt.Const.PerksCharmedUnit.LegendOrcBehemoth <- {
			WeightMultipliers = [
				{Multiplier = 2, Tree = this.Const.Perks.ResilientTree},
				{Multiplier = 0.25, Tree = this.Const.Perks.ViciousTree},
				{Multiplier = 0, Tree = this.Const.Perks.DeviousTree},
				{Multiplier = 0, Tree = this.Const.Perks.OrganisedTree},
				{Multiplier = 0, Tree = this.Const.Perks.LightArmorTree},
				{Multiplier = 1.33, Tree = this.Const.Perks.ShieldTree},
				{Multiplier = 0, Tree = this.Const.Perks.DaggerTree},
				{Multiplier = 3, Tree = this.Const.Perks.SwordTree},
				{Multiplier = 3, Tree = this.Const.Perks.CleaverTree},
				{Multiplier = 3, Tree = this.Const.Perks.MaceTree},
				{Multiplier = 2, Tree = this.Const.Perks.FlailTree},
				{Multiplier = 2, Tree = this.Const.Perks.HammerTree},
				{Multiplier = 0, Tree = this.Const.Perks.PolearmTree},
				{Multiplier = 2, Tree = this.Const.Perks.ThrowingTree},
				{Multiplier = 0, Tree = this.Const.Perks.BowTree},
				{Multiplier = 0, Tree = this.Const.Perks.CrossbowTree},
				{Multiplier = 0, Tree = this.Const.Perks.SlingsTree},
				{Multiplier = 0, Tree = this.Const.Perks.SpearTree}
			],
			Profession = [
				[
					{Weight = 100, Tree = this.Const.Perks.SoldierProfessionTree},
				]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.HeavyArmorTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}],
				[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}]
			],
			Traits = [
				[
					{Weight = 50, Tree = this.Const.Perks.FitTree},
					{Weight = 50, Tree = this.Const.Perks.SturdyTree},
				]
			],
		};

		gt.Const.PerksCharmedUnit.LegendOrcElite <- {
			WeightMultipliers = [
				{Multiplier = 2, Tree = this.Const.Perks.ResilientTree},
				{Multiplier = 0.25, Tree = this.Const.Perks.ViciousTree},
				{Multiplier = 0, Tree = this.Const.Perks.DeviousTree},
				{Multiplier = 0, Tree = this.Const.Perks.OrganisedTree},
				{Multiplier = 0, Tree = this.Const.Perks.LightArmorTree},
				{Multiplier = 1.33, Tree = this.Const.Perks.ShieldTree},
				{Multiplier = 0, Tree = this.Const.Perks.DaggerTree},
				{Multiplier = 2, Tree = this.Const.Perks.SwordTree},
				{Multiplier = 3, Tree = this.Const.Perks.CleaverTree},
				{Multiplier = 2, Tree = this.Const.Perks.MaceTree},
				{Multiplier = 2, Tree = this.Const.Perks.FlailTree},
				{Multiplier = 2, Tree = this.Const.Perks.HammerTree},
				{Multiplier = 2, Tree = this.Const.Perks.AxeTree},
				{Multiplier = 0, Tree = this.Const.Perks.PolearmTree},
				{Multiplier = 2, Tree = this.Const.Perks.ThrowingTree},
				{Multiplier = 0, Tree = this.Const.Perks.BowTree},
				{Multiplier = 0, Tree = this.Const.Perks.CrossbowTree},
				{Multiplier = 0, Tree = this.Const.Perks.SlingsTree},
				{Multiplier = 0, Tree = this.Const.Perks.SpearTree}
			],
			Profession = [
				[
					{Weight = 100, Tree = this.Const.Perks.SoldierProfessionTree},
				]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.HeavyArmorTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}],
				[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}]
			],
			Traits = [
				[
					{Weight = 50, Tree = this.Const.Perks.IndestructibleTree},
					{Weight = 50, Tree = this.Const.Perks.SturdyTree},
				]
			],
		};
	}

	//Adding new custom charmed unit entries 
	::mc_processingEntries();
	::mc_overwriteEntries();
	delete gt.Nggh_MagicConcept.hookHexeOrigin;
}