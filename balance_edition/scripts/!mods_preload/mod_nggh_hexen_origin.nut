this.getroottable().Nggh_MagicConcept.hookHexeOrigin <- function ()
{
	local gt = this.getroottable();
	gt.PerkTreeBuilder <- this.new("scripts/mods/perk_tree_builder");
	gt.TalentFiller <- this.new("scripts/mods/talent_filler");
	gt.HexeVersion <- 17;
	gt.IsAccessoryCompanionsExist <- ::mods_getRegisteredMod("mod_AC") != null;
	gt.Const.Items.NamedMeleeWeapons.push("weapons/named/mod_named_staff");
	gt.Const.Items.NamedWeapons = clone this.Const.Items.NamedMeleeWeapons;
	gt.Const.Items.NamedWeapons.extend(this.Const.Items.NamedRangedWeapons);
	gt.Const.Items.addNewItemType("Corpse");

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

	// ghost
	gt.Const.World.Spawn.Troops.Ghost.NameList <- this.Const.Strings.GhostNames;
	gt.Const.World.Spawn.Troops.Ghost.TitleList <- this.Const.Strings.GhostTitles;
	gt.Const.World.Spawn.Troops.Ghost.Variant = 3;

	gt.Const.World.Spawn.Troops.LegendBanshee.NameList <- this.Const.Strings.BansheeNames;
	gt.Const.World.Spawn.Troops.LegendBanshee.TitleList <- this.Const.Strings.BansheeTitles;
	gt.Const.World.Spawn.Troops.LegendBanshee.Variant = 5;

	// hexe
	gt.Const.World.Spawn.Troops.Hexe.NameList <- this.Const.Strings.HexeNames;
	gt.Const.World.Spawn.Troops.Hexe.TitleList <- null;
	gt.Const.World.Spawn.Troops.Hexe.Variant = 3;

	gt.Const.World.Spawn.Troops.LegendHexeLeader.NameList <- this.Const.Strings.HexeNames;
	gt.Const.World.Spawn.Troops.LegendHexeLeader.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendHexeLeader.Variant = 7;

	// wolf
	gt.Const.World.Spawn.Troops.Direwolf.NameList <- this.Const.Strings.WolfNames;
	gt.Const.World.Spawn.Troops.Direwolf.TitleList <- null;
	gt.Const.World.Spawn.Troops.Direwolf.Variant = 1;

	gt.Const.World.Spawn.Troops.DirewolfHIGH.NameList <- this.Const.Strings.WolfNames;
	gt.Const.World.Spawn.Troops.DirewolfHIGH.TitleList <- null;
	gt.Const.World.Spawn.Troops.DirewolfHIGH.Variant = 2;

	/*gt.Const.World.Spawn.Troops.DirewolfBodyguard.NameList <- gt.Const.Strings.WolfNames;
	gt.Const.World.Spawn.Troops.DirewolfBodyguard.TitleList <- null;
	gt.Const.World.Spawn.Troops.DirewolfBodyguard.Variant = 1;*/

	gt.Const.World.Spawn.Troops.LegendWhiteDirewolf.NameList <- this.Const.Strings.WolfNames;
	gt.Const.World.Spawn.Troops.LegendWhiteDirewolf.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendWhiteDirewolf.Variant = 5;

	/*gt.Const.World.Spawn.Troops.LegendWhiteDirewolfBodyguard.NameList <- gt.Const.Strings.WolfNames;
	gt.Const.World.Spawn.Troops.LegendWhiteDirewolfBodyguard.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendWhiteDirewolfBodyguard.Variant = 3;*/

	// nacho
	gt.Const.World.Spawn.Troops.Ghoul.NameList <- this.Const.Strings.NachoNames;
	gt.Const.World.Spawn.Troops.Ghoul.TitleList <- null;
	gt.Const.World.Spawn.Troops.Ghoul.Variant = 1;

	gt.Const.World.Spawn.Troops.GhoulHIGH.NameList <- this.Const.Strings.NachoNames;
	gt.Const.World.Spawn.Troops.GhoulHIGH.TitleList <- null;
	gt.Const.World.Spawn.Troops.GhoulHIGH.Variant = 5;

	gt.Const.World.Spawn.Troops.LegendSkinGhoulMED.NameList <- this.Const.Strings.NachoNames;
	gt.Const.World.Spawn.Troops.LegendSkinGhoulMED.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendSkinGhoulMED.Variant = 1;

	gt.Const.World.Spawn.Troops.LegendSkinGhoulHIGH.NameList <- this.Const.Strings.NachoNames;
	gt.Const.World.Spawn.Troops.LegendSkinGhoulHIGH.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendSkinGhoulHIGH.Variant = 1;

	// snake
	gt.Const.World.Spawn.Troops.Lindwurm.NameList <- this.Const.Strings.LindwurmNames;
	gt.Const.World.Spawn.Troops.Lindwurm.TitleList <- null;
	gt.Const.World.Spawn.Troops.Lindwurm.Variant = 3;

	gt.Const.World.Spawn.Troops.LegendStollwurm.NameList <- this.Const.Strings.LindwurmNames;
	gt.Const.World.Spawn.Troops.LegendStollwurm.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendStollwurm.Variant = 5;

	gt.Const.World.Spawn.Troops.Serpent.NameList <- this.Const.Strings.SerpentNames;
	gt.Const.World.Spawn.Troops.Serpent.TitleList <- null;
	gt.Const.World.Spawn.Troops.Serpent.Variant = 3;

	// bear
	gt.Const.World.Spawn.Troops.LegendBear.NameList <- this.Const.Strings.OrcNames;
	gt.Const.World.Spawn.Troops.LegendBear.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendBear.Variant = 5;

	// unhold
	gt.Const.World.Spawn.Troops.Unhold.NameList <- this.Const.Strings.UnholdNames;
	gt.Const.World.Spawn.Troops.Unhold.TitleList <- null;
	gt.Const.World.Spawn.Troops.Unhold.Variant = 2;

	gt.Const.World.Spawn.Troops.UnholdFrost.NameList <- this.Const.Strings.UnholdNames;
	gt.Const.World.Spawn.Troops.UnholdFrost.TitleList <- null;
	gt.Const.World.Spawn.Troops.UnholdFrost.Variant = 3;

	gt.Const.World.Spawn.Troops.UnholdBog.NameList <- this.Const.Strings.UnholdNames;
	gt.Const.World.Spawn.Troops.UnholdBog.TitleList <- null;
	gt.Const.World.Spawn.Troops.UnholdBog.Variant = 2;

	gt.Const.World.Spawn.Troops.BarbarianUnhold.NameList <- this.Const.Strings.UnholdNames;
	gt.Const.World.Spawn.Troops.BarbarianUnhold.TitleList <- null;
	gt.Const.World.Spawn.Troops.BarbarianUnhold.Variant = 2;

	gt.Const.World.Spawn.Troops.BarbarianUnholdFrost.NameList <- this.Const.Strings.UnholdNames;
	gt.Const.World.Spawn.Troops.BarbarianUnholdFrost.TitleList <- null;
	gt.Const.World.Spawn.Troops.BarbarianUnholdFrost.Variant = 2;

	gt.Const.World.Spawn.Troops.LegendRockUnhold.NameList <- this.Const.Strings.UnholdNames;
	gt.Const.World.Spawn.Troops.LegendRockUnhold.TitleList <- ["the Mountain"];
	gt.Const.World.Spawn.Troops.LegendRockUnhold.Variant = 5;

	// spider
	gt.Const.World.Spawn.Troops.Spider.NameList <- this.Const.Strings.SpiderNames;
	gt.Const.World.Spawn.Troops.Spider.TitleList <- null;
	gt.Const.World.Spawn.Troops.Spider.Variant = 1;

	/*gt.Const.World.Spawn.Troops.SpiderBodyguard.NameList <- gt.Const.Strings.SpiderNames;
	gt.Const.World.Spawn.Troops.SpiderBodyguard.TitleList <- null;
	gt.Const.World.Spawn.Troops.SpiderBodyguard.Variant = 1;*/

	gt.Const.World.Spawn.Troops.LegendRedbackSpider.NameList <- this.Const.Strings.SpiderNames;
	gt.Const.World.Spawn.Troops.LegendRedbackSpider.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendRedbackSpider.Variant = 5;

	/*gt.Const.World.Spawn.Troops.LegendRedbackSpiderBodyguard.NameList <- gt.Const.Strings.SpiderNames;
	gt.Const.World.Spawn.Troops.LegendRedbackSpiderBodyguard.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendRedbackSpiderBodyguard.Variant = 3;*/

	// alp
	gt.Const.World.Spawn.Troops.Alp.NameList <- this.Const.Strings.GoblinNames;
	gt.Const.World.Spawn.Troops.Alp.TitleList <- null;
	gt.Const.World.Spawn.Troops.Alp.Variant = 3;

	gt.Const.World.Spawn.Troops.LegendDemonAlp.NameList <- this.Const.Strings.GoblinNames;
	gt.Const.World.Spawn.Troops.LegendDemonAlp.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendDemonAlp.Variant = 1;

	// schrat
	gt.Const.World.Spawn.Troops.Schrat.NameList <- this.Const.Strings.SchratNames;
	gt.Const.World.Spawn.Troops.Schrat.TitleList <- null;

	// kraken
	gt.Const.World.Spawn.Troops.Kraken.Variant = 1;

	// trickster god
	gt.Const.World.Spawn.Troops.TricksterGod.Variant = 1;
	gt.Const.World.Spawn.Troops.LegendRockUnhold.TitleList <- ["the Trickster"];

	// hyena
	gt.Const.World.Spawn.Troops.Hyena.NameList <- this.Const.Strings.WolfNames;
	gt.Const.World.Spawn.Troops.Hyena.TitleList <- null;
	gt.Const.World.Spawn.Troops.Hyena.Variant = 1;

	gt.Const.World.Spawn.Troops.HyenaHIGH.NameList <- this.Const.Strings.WolfNames;
	gt.Const.World.Spawn.Troops.HyenaHIGH.TitleList <- null;
	gt.Const.World.Spawn.Troops.HyenaHIGH.Variant = 3;



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
				{Multiplier = 10.0, Tree = this.Const.Perks.BowTree},
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
				{ Multiplier = 3.0, Tree = this.Const.Perks.SergeantClassTree },
				{ Multiplier = 0.33, Tree = this.Const.Perks.LightArmorTree },
				{ Multiplier = 0.33, Tree = this.Const.Perks.ShieldTree },
				{ Multiplier = 0, Tree = this.Const.Perks.HeavyArmorTree },
				{ Multiplier = 2.0, Tree = this.Const.Perks.BowTree },
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