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

	gt.Const.World.Spawn.MC_WitchHunter <- {
		Name = "MC_WitchHunter",
		IsDynamic = true,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_noble_02",
		MaxR = 650,
		Troops = [
			{
				Weight = 59,
				Types = [
					{				
						Type = gt.Const.World.Spawn.Troops.MercenaryLOW,
						MaxR = 180,
						Cost = 20
					},
					{
						Type = gt.Const.World.Spawn.Troops.Mercenary,
						Cost = 30
					}
				]
			},
			{
				Weight = 22,
				Types = [
					{
						Type = gt.Const.World.Spawn.Troops.LegendPeasantWitchHunter,
						Cost = 20
					},
					{
						MinR = 400,
						Type = this.Const.World.Spawn.Troops.MasterArcher,
						Cost = 60,
						Roll = true
					}
				]
			},
			{
				Weight = 5,
				Types = [
					{
						Type = gt.Const.World.Spawn.Troops.Wardog,
						Cost = 5
					}
				]
			},
			{
				Weight = 12,
				Types = [
					{
						Type = gt.Const.World.Spawn.Troops.LegendPeasantMinstrel,
						Cost = 20
					},
					{
						Type = gt.Const.World.Spawn.Troops.LegendPeasantMonk,
						Cost = 20
					},
				]
			},
			{
				Weight = 1,
				MinR = 400,
				Types = [
					{
						Type = gt.Const.World.Spawn.Troops.HedgeKnight,
						Cost = 60,
						Roll = true
					}
				]
			},
			{
				Weight = 1,
				MinR = 400,
				Types = [
					{
						Type = gt.Const.World.Spawn.Troops.Swordmaster,
						Cost = 60,
						Roll = true
					}
				]
			}
		]
	};


	//Create Champion Beast
	/*foreach(i, troop in gt.Const.World.Spawn.Troops)
	{
		switch (troop.ID) 
		{
	    case this.Const.EntityType.Direwolf:
	       	NameList = gt.Const.Strings.WolfNames,
			TitleList = null
	        break;
		}
	}*/

	// wolf
	gt.Const.World.Spawn.Troops.Direwolf.NameList <- gt.Const.Strings.WolfName;
	gt.Const.World.Spawn.Troops.Direwolf.TitleList <- null;
	gt.Const.World.Spawn.Troops.Direwolf.Variant = 1;

	gt.Const.World.Spawn.Troops.DirewolfHIGH.NameList <- gt.Const.Strings.WolfName;
	gt.Const.World.Spawn.Troops.DirewolfHIGH.TitleList <- null;
	gt.Const.World.Spawn.Troops.DirewolfHIGH.Variant = 2;

	gt.Const.World.Spawn.Troops.DirewolfBodyguard.NameList <- gt.Const.Strings.WolfName;
	gt.Const.World.Spawn.Troops.DirewolfBodyguard.TitleList <- null;
	gt.Const.World.Spawn.Troops.DirewolfBodyguard.Variant = 1;

	gt.Const.World.Spawn.Troops.LegendWhiteDirewolf.NameList <- gt.Const.Strings.WolfName;
	gt.Const.World.Spawn.Troops.LegendWhiteDirewolf.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendWhiteDirewolf.Variant = 5;

	gt.Const.World.Spawn.Troops.LegendWhiteDirewolfBodyguard.NameList <- gt.Const.Strings.WolfName;
	gt.Const.World.Spawn.Troops.LegendWhiteDirewolfBodyguard.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendWhiteDirewolfBodyguard.Variant = 3;

	// nacho
	gt.Const.World.Spawn.Troops.Ghoul.NameList <- gt.Const.Strings.NachoNames;
	gt.Const.World.Spawn.Troops.Ghoul.TitleList <- null;
	gt.Const.World.Spawn.Troops.Ghoul.Variant = 1;

	gt.Const.World.Spawn.Troops.GhoulHIGH.NameList <- gt.Const.Strings.NachoNames;
	gt.Const.World.Spawn.Troops.GhoulHIGH.TitleList <- null;
	gt.Const.World.Spawn.Troops.GhoulHIGH.Variant = 3;

	gt.Const.World.Spawn.Troops.LegendSkinGhoulMED.NameList <- gt.Const.Strings.NachoNames;
	gt.Const.World.Spawn.Troops.LegendSkinGhoulMED.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendSkinGhoulMED.Variant = 3;

	gt.Const.World.Spawn.Troops.LegendSkinGhoulHIGH.NameList <- gt.Const.Strings.NachoNames;
	gt.Const.World.Spawn.Troops.LegendSkinGhoulHIGH.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendSkinGhoulHIGH.Variant = 5;

	// snake
	gt.Const.World.Spawn.Troops.Lindwurm.NameList <- gt.Const.Strings.LindwurmNames;
	gt.Const.World.Spawn.Troops.Lindwurm.TitleList <- null;
	gt.Const.World.Spawn.Troops.Lindwurm.Variant = 3;

	gt.Const.World.Spawn.Troops.LegendStollwurm.NameList <- gt.Const.Strings.LindwurmNames;
	gt.Const.World.Spawn.Troops.LegendStollwurm.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendStollwurm.Variant = 5;

	gt.Const.World.Spawn.Troops.Serpent.NameList <- gt.Const.Strings.SerpentNames;
	gt.Const.World.Spawn.Troops.Serpent.TitleList <- null;
	gt.Const.World.Spawn.Troops.Serpent.Variant = 3;

	// bear
	gt.Const.World.Spawn.Troops.LegendBear.NameList <- gt.Const.Strings.OrcNames;
	gt.Const.World.Spawn.Troops.LegendBear.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendBear.Variant = 5;

	// unhold
	gt.Const.World.Spawn.Troops.Unhold.NameList <- gt.Const.Strings.UnholdNames;
	gt.Const.World.Spawn.Troops.Unhold.TitleList <- null;
	gt.Const.World.Spawn.Troops.Unhold.Variant = 2;

	gt.Const.World.Spawn.Troops.UnholdFrost.NameList <- gt.Const.Strings.UnholdNames;
	gt.Const.World.Spawn.Troops.UnholdFrost.TitleList <- null;
	gt.Const.World.Spawn.Troops.UnholdFrost.Variant = 3;

	gt.Const.World.Spawn.Troops.UnholdBog.NameList <- gt.Const.Strings.UnholdNames;
	gt.Const.World.Spawn.Troops.UnholdBog.TitleList <- null;
	gt.Const.World.Spawn.Troops.UnholdBog.Variant = 2;

	gt.Const.World.Spawn.Troops.BarbarianUnhold.NameList <- gt.Const.Strings.UnholdNames;
	gt.Const.World.Spawn.Troops.BarbarianUnhold.TitleList <- null;
	gt.Const.World.Spawn.Troops.BarbarianUnhold.Variant = 2;

	gt.Const.World.Spawn.Troops.BarbarianUnholdFrost.NameList <- gt.Const.Strings.UnholdNames;
	gt.Const.World.Spawn.Troops.BarbarianUnholdFrost.TitleList <- null;
	gt.Const.World.Spawn.Troops.BarbarianUnholdFrost.Variant = 2;

	gt.Const.World.Spawn.Troops.LegendRockUnhold.NameList <- gt.Const.Strings.UnholdNames;
	gt.Const.World.Spawn.Troops.LegendRockUnhold.TitleList <- ["the Mountain"];
	gt.Const.World.Spawn.Troops.LegendRockUnhold.Variant = 5;

	// spider
	gt.Const.World.Spawn.Troops.Spider.NameList <- gt.Const.Strings.SpiderNames;
	gt.Const.World.Spawn.Troops.Spider.TitleList <- null;
	gt.Const.World.Spawn.Troops.Spider.Variant = 1;

	gt.Const.World.Spawn.Troops.SpiderBodyguard.NameList <- gt.Const.Strings.SpiderNames;
	gt.Const.World.Spawn.Troops.SpiderBodyguard.TitleList <- null;
	gt.Const.World.Spawn.Troops.SpiderBodyguard.Variant = 1;

	gt.Const.World.Spawn.Troops.LegendRedbackSpider.NameList <- gt.Const.Strings.SpiderNames;
	gt.Const.World.Spawn.Troops.LegendRedbackSpider.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendRedbackSpider.Variant = 5;

	gt.Const.World.Spawn.Troops.LegendRedbackSpiderBodyguard.NameList <- gt.Const.Strings.SpiderNames;
	gt.Const.World.Spawn.Troops.LegendRedbackSpiderBodyguard.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendRedbackSpiderBodyguard.Variant = 5;

	// alp
	gt.Const.World.Spawn.Troops.Alp.NameList <- gt.Const.Strings.GoblinNames;
	gt.Const.World.Spawn.Troops.Alp.TitleList <- null;
	gt.Const.World.Spawn.Troops.Alp.Variant = 1;

	gt.Const.World.Spawn.Troops.LegendDemonAlp.NameList <- gt.Const.Strings.GoblinNames;
	gt.Const.World.Spawn.Troops.LegendDemonAlp.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendDemonAlp.Variant = 5;

	// schrat
	gt.Const.World.Spawn.Troops.Schrat.NameList <- gt.Const.Strings.SchratNames;
	gt.Const.World.Spawn.Troops.Schrat.TitleList <- null;

	// kraken
	gt.Const.World.Spawn.Troops.Kraken.Variant = 1;

	// trickster god
	gt.Const.World.Spawn.Troops.TricksterGod.Variant = 1;
	gt.Const.World.Spawn.Troops.LegendRockUnhold.TitleList <- ["the Trickster"];

	// hyena
	gt.Const.World.Spawn.Troops.Hyena.NameList <- gt.Const.Strings.WolfNames;
	gt.Const.World.Spawn.Troops.Hyena.TitleList <- null;
	gt.Const.World.Spawn.Troops.Hyena.Variant = 1;

	gt.Const.World.Spawn.Troops.HyenaHIGH.NameList <- gt.Const.Strings.WolfNames;
	gt.Const.World.Spawn.Troops.HyenaHIGH.TitleList <- null;
	gt.Const.World.Spawn.Troops.HyenaHIGH.Variant = 2;



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