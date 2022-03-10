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


	// demon hound
	gt.Const.World.Spawn.Troops.LegendDemonHound.NameList <- this.Const.Strings.DemonHoundNames;
	gt.Const.World.Spawn.Troops.LegendDemonHound.TitleList <- null;
	gt.Const.World.Spawn.Troops.LegendDemonHound.Variant = 5;

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
	gt.Const.World.Spawn.Troops.Kraken.Variant = 44;

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
				{Multiplier = 2.0, Tree = this.Const.Perks.UnstoppableTree},
				{Multiplier = 10.0, Tree = this.Const.Perks.BowTree},
				{Multiplier = 2.0, Tree = this.Const.Perks.DaggerTree}
			],
			Class = [
				[
					{Weight = 75, Tree = this.Const.Perks.ScoutClassTree},
					{Weight = 25, Tree = this.Const.Perks.GoblinMountTree},
				]
			],
			Profession = [
				[{Weight = 100, Tree = this.Const.Perks.HunterProfessionTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.RangedTree}]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.LightArmorTree}]
			],
			Traits = [
				[{Weight = 100, Tree = this.Const.Perks.FastTree}],
				[{Weight = 100, Tree = this.Const.Perks.AgileTree}]
			],
		};

		gt.Const.PerksCharmedUnit.GoblinFighter <- {
			WeightMultipliers = [
				{Multiplier = 5.0, Tree = this.Const.Perks.ShieldTree},
				{Multiplier = 5.0, Tree = this.Const.Perks.PolearmTree},
			],
			Class = [
				[
					{Weight = 40, Tree = this.Const.Perks.TrapperClassTree},
					{Weight = 20, Tree = this.Const.Perks.GoblinMountTree},
					{Weight = 40, Tree = this.Const.Perks.ScoutClassTree}
				],
			],
			Profession = [
				[
					{Weight = 50, Tree = this.Const.Perks.SoldierProfessionTree},
					{Weight = 50, Tree = this.Const.Perks.JugglerProfessionTree}
				],
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.LightArmorTree}]
			],
			Weapon = [
				[{Weight = 100, Tree = this.Const.Perks.SwordTree}],
				[
					{Weight = 20, Tree = this.Const.Perks.ThrowingTree},
					{Weight = 20, Tree = this.Const.Perks.SpearTree},
					{Weight = 20, Tree = this.Const.Perks.AxeTree},
					{Weight = 20, Tree = this.Const.Perks.FlailTree},
					{Weight = 20, Tree = this.Const.Perks.DaggerTree},
				],
			],
			Styles = [
				[
					{Weight = 80, Tree = this.Const.Perks.OneHandedTree},
					{Weight = 20, Tree = this.Const.Perks.TwoHandedTree}
				]
			],
			Traits = [
				[{Weight = 100, Tree = this.Const.Perks.FastTree}],
				[{Weight = 100, Tree = this.Const.Perks.AgileTree}]
			],
		};

		gt.Const.PerksCharmedUnit.GoblinLeader <- {
			WeightMultipliers = [
				{ Multiplier = 0.25, Tree = this.Const.Perks.OrganisedTree },
				{ Multiplier = 0.25, Tree = this.Const.Perks.DeviousTree },
				{ Multiplier = 0.33, Tree = this.Const.Perks.ShieldTree },
				{ Multiplier = 0.0, Tree = this.Const.Perks.HeavyArmorTree },
				{ Multiplier = 0.0, Tree = this.Const.Perks.BowTree },
				{ Multiplier = 0.0, Tree = this.Const.Perks.SlingsTree },
				{ Multiplier = 0.0, Tree = this.Const.Perks.SpearTree },
				{ Multiplier = 1.25, Tree = this.Const.Perks.TrainedTree }
			],
			Class = [
				[
					{Weight = 50, Tree = this.Const.Perks.SergeantClassTree},
					{Weight = 50, Tree = this.Const.Perks.TacticianClassTree}
				],
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.LightArmorTree}]
			],
			Weapon = [
				[{Weight = 100, Tree = this.Const.Perks.SwordTree}],
				[{Weight = 100, Tree = this.Const.Perks.CrossbowTree}],
				[
					{Weight = 25, Tree = this.Const.Perks.AxeTree},
					{Weight = 25, Tree = this.Const.Perks.FlailTree},
					{Weight = 25, Tree = this.Const.Perks.CleaverTree},
					{Weight = 25, Tree = this.Const.Perks.HammerTree},
				],
			]
			Styles = [
				[
					{Weight = 60, Tree = this.Const.Perks.RangedTree},
					{Weight = 40, Tree = this.Const.Perks.OneHandedTree}
				]
			],
			Traits = [
				[{Weight = 100, Tree = this.Const.Perks.AgileTree}],
				[
					{Weight = 50, Tree = this.Const.Perks.GoblinMountTree},
					{Weight = 50, Tree = this.Const.Perks.UnstoppableTree},
				]
			],
		};

		gt.Const.PerksCharmedUnit.GoblinShaman <- {
			WeightMultipliers = [
				{Multiplier = 2.0, Tree = this.Const.Perks.CalmTree},
			],
			Profession = [
				[{Weight = 100, Tree = this.Const.Perks.ApothecaryProfessionTree}] 
			],
			Class = [
				[
					{Weight = 55, Tree = this.Const.Perks.HealerClassTree},
					{Weight = 35, Tree = this.Const.Perks.EntertainerClassTree},
					{Weight = 10, Tree = this.Const.Perks.GoblinMountTree},
				],
			],
			Weapon = [
				[{Weight = 100, Tree = this.Const.Perks.StavesTree}],
				[{Weight = 100, Tree = this.Const.Perks.DaggerTree}],
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
			Traits = [
				[{Weight = 100, Tree = this.Const.Perks.AgileTree}],
				[{Weight = 100, Tree = this.Const.Perks.TalentedTree}]
			],
		};

		gt.Const.PerksCharmedUnit.GoblinWolfrider <- {
			WeightMultipliers = [
				{Multiplier = 0.0, Tree = this.Const.Perks.ShieldTree},
				{Multiplier = 0.0, Tree = this.Const.Perks.PolearmTree},
			],
			Class = [
				[
					{Weight = 40, Tree = this.Const.Perks.ScoutClassTree},
					{Weight = 60, Tree = this.Const.Perks.HoundmasterClassTree},
				],
			],
			Profession = [
				[{Weight = 100, Tree = this.Const.Perks.RaiderProfessionTree}]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.LightArmorTree}]
			],
			Weapon = [
				[{Weight = 100, Tree = this.Const.Perks.SpearTree}],
				[{Weight = 100, Tree = this.Const.Perks.SwordTree}],
				[
					{Weight = 25, Tree = this.Const.Perks.ThrowingTree},
					{Weight = 25, Tree = this.Const.Perks.CleaverTree},
					{Weight = 25, Tree = this.Const.Perks.MaceTree},
					{Weight = 25, Tree = this.Const.Perks.HammerTree},
				],
			],
			Styles = [
				[
					{Weight = 67, Tree = this.Const.Perks.OneHandedTree},
					{Weight = 33, Tree = this.Const.Perks.TwoHandedTree}
				],
			],
			Traits = [
				[{Weight = 100, Tree = this.Const.Perks.GoblinMountTree}],
				[{Weight = 100, Tree = this.Const.Perks.FastTree}],
				[{Weight = 100, Tree = this.Const.Perks.AgileTree}]
			],
		};

		gt.Const.PerksCharmedUnit.OrcYoung <- {
			WeightMultipliers = [
				{Multiplier = 4, Tree = this.Const.Perks.LaborerProfessionTree},
				{Multiplier = 2, Tree = this.Const.Perks.ResilientTree},
				{Multiplier = 5, Tree = this.Const.Perks.ViciousTree},
				{Multiplier = 1.33, Tree = this.Const.Perks.ShieldTree},
				{Multiplier = 0.5, Tree = this.Const.Perks.DaggerTree},
				{Multiplier = 2, Tree = this.Const.Perks.SwordTree},
				{Multiplier = 2, Tree = this.Const.Perks.MaceTree},
				{Multiplier = 2, Tree = this.Const.Perks.FlailTree},
				{Multiplier = 3, Tree = this.Const.Perks.CleaverTree},
				{Multiplier = 2, Tree = this.Const.Perks.HammerTree},
				{Multiplier = 0.5, Tree = this.Const.Perks.PolearmTree},
				{Multiplier = 2, Tree = this.Const.Perks.ThrowingTree},
				{Multiplier = 0.5, Tree = this.Const.Perks.SlingsTree},
				{Multiplier = 0, Tree = this.Const.Perks.BowTree},
				{Multiplier = 0, Tree = this.Const.Perks.CrossbowTree},
				{Multiplier = 0, Tree = this.Const.Perks.DeviousTree},
				{Multiplier = 0, Tree = this.Const.Perks.OrganisedTree},
				{Multiplier = 0, Tree = this.Const.Perks.LightArmorTree},
			],
			Weapon = [
				[{Weight = 100, Tree = this.Const.Perks.AxeTree}],
			],
			Profession = [
				[{Weight = 100, Tree = this.Const.Perks.RaiderProfessionTree}],
				[{Weight = 100, Tree = this.Const.Perks.WildlingProfessionTree}],
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
					{Weight = 20, Tree = this.Const.Perks.ViciousTree},
					{Weight = 20, Tree = this.Const.Perks.SturdyTree},
					{Weight = 20, Tree = this.Const.Perks.LargeTree},
					{Weight = 20, Tree = this.Const.Perks.UnstoppableTree},
					{Weight = 10, Tree = this.Const.Perks.TrainedTree},
					{Weight = 10, Tree = this.Const.Perks.FastTree},
				]
			]
		};

		gt.Const.PerksCharmedUnit.OrcBerserker <- {
			WeightMultipliers = [
				{Multiplier = 4, Tree = this.Const.Perks.LaborerProfessionTree},
				{Multiplier = 2, Tree = this.Const.Perks.ResilientTree},
				{Multiplier = 5, Tree = this.Const.Perks.ViciousTree},
				{Multiplier = 0, Tree = this.Const.Perks.ShieldTree},
				{Multiplier = 0.5, Tree = this.Const.Perks.DaggerTree},
				{Multiplier = 2, Tree = this.Const.Perks.SwordTree},
				{Multiplier = 2, Tree = this.Const.Perks.MaceTree},
				{Multiplier = 3, Tree = this.Const.Perks.CleaverTree},
				{Multiplier = 2, Tree = this.Const.Perks.HammerTree},
				{Multiplier = 0, Tree = this.Const.Perks.PolearmTree},
				{Multiplier = 2, Tree = this.Const.Perks.ThrowingTree},
				{Multiplier = 0, Tree = this.Const.Perks.SlingsTree},
				{Multiplier = 0, Tree = this.Const.Perks.BowTree},
				{Multiplier = 0, Tree = this.Const.Perks.CrossbowTree},
				{Multiplier = 0, Tree = this.Const.Perks.DeviousTree},
				{Multiplier = 0, Tree = this.Const.Perks.OrganisedTree},
			],
			Profession = [
				[{Weight = 100, Tree = this.Const.Perks.WildlingProfessionTree}],
				[{Weight = 100, Tree = this.Const.Perks.RaiderProfessionTree}],
				[{Weight = 100, Tree = this.Const.Perks.LumberjackProfessionTree}],
			],
			Weapon = [
				[{Weight = 100, Tree = this.Const.Perks.AxeTree}],
				[{Weight = 100, Tree = this.Const.Perks.FlailTree}],
			],
			Defense = [
				[
					{Weight = 5, Tree = this.Const.Perks.MediumArmorTree},
					{Weight = 45, Tree = this.Const.Perks.HeavyArmorTree},
					{Weight = 50, Tree = this.Const.Perks.LightArmorTree}
				],
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}],
				[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}]
			],
			Traits = [
				[{Weight = 100, Tree = this.Const.Perks.UnstoppableTree}],
				[{Weight = 100, Tree = this.Const.Perks.IndestructibleTree}],
				[
					{Weight = 30, Tree = this.Const.Perks.ViciousTree},
					{Weight = 30, Tree = this.Const.Perks.SturdyTree},
					{Weight = 25, Tree = this.Const.Perks.LargeTree},
					{Weight = 25, Tree = this.Const.Perks.FastTree},
				]
			],
		};

		gt.Const.PerksCharmedUnit.OrcWarrior <- {
			WeightMultipliers = [
				{Multiplier = 4, Tree = this.Const.Perks.LaborerProfessionTree},
				{Multiplier = 2, Tree = this.Const.Perks.ResilientTree},
				{Multiplier = 5, Tree = this.Const.Perks.ViciousTree},
				{Multiplier = 0.5, Tree = this.Const.Perks.DaggerTree},
				{Multiplier = 2, Tree = this.Const.Perks.SwordTree},
				{Multiplier = 2, Tree = this.Const.Perks.MaceTree},
				{Multiplier = 3, Tree = this.Const.Perks.CleaverTree},
				{Multiplier = 2, Tree = this.Const.Perks.HammerTree},
				{Multiplier = 0, Tree = this.Const.Perks.PolearmTree},
				{Multiplier = 2, Tree = this.Const.Perks.ThrowingTree},
				{Multiplier = 0, Tree = this.Const.Perks.SlingsTree},
				{Multiplier = 0, Tree = this.Const.Perks.DeviousTree},
				{Multiplier = 0, Tree = this.Const.Perks.OrganisedTree},
				{Multiplier = 0, Tree = this.Const.Perks.LightArmorTree},
			],
			Profession = [
				[{Weight = 100, Tree = this.Const.Perks.SoldierProfessionTree}],
				[{Weight = 100, Tree = this.Const.Perks.RaiderProfessionTree}]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.HeavyArmorTree}],
				[{Weight = 100, Tree = this.Const.Perks.ShieldTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}],
				[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}]
			],
			Traits = [
				[{Weight = 100, Tree = this.Const.Perks.IndestructibleTree}],
				[
					{Weight = 20, Tree = this.Const.Perks.ViciousTree},
					{Weight = 20, Tree = this.Const.Perks.SturdyTree},
					{Weight = 20, Tree = this.Const.Perks.LargeTree},
					{Weight = 20, Tree = this.Const.Perks.UnstoppableTree},
					{Weight = 20, Tree = this.Const.Perks.TrainedTree},
				]
			],
		};

		gt.Const.PerksCharmedUnit.OrcWarlord <- {
			WeightMultipliers = [
				{Multiplier = 4, Tree = this.Const.Perks.LaborerProfessionTree},
				{Multiplier = 0, Tree = this/Const.Perks.ShieldTree},
				{Multiplier = 2, Tree = this.Const.Perks.ResilientTree},
				{Multiplier = 5, Tree = this.Const.Perks.ViciousTree},
				{Multiplier = 0.5, Tree = this.Const.Perks.DaggerTree},
				{Multiplier = 2, Tree = this.Const.Perks.SwordTree},
				{Multiplier = 2, Tree = this.Const.Perks.MaceTree},
				{Multiplier = 2, Tree = this.Const.Perks.CleaverTree},
				{Multiplier = 2, Tree = this.Const.Perks.HammerTree},
				{Multiplier = 0, Tree = this.Const.Perks.PolearmTree},
				{Multiplier = 2, Tree = this.Const.Perks.FlailTree},
				{Multiplier = 2, Tree = this.Const.Perks.ThrowingTree},
				{Multiplier = 0, Tree = this.Const.Perks.SlingsTree},
				{Multiplier = 0, Tree = this.Const.Perks.BowTree},
				{Multiplier = 0, Tree = this.Const.Perks.CrossbowTree},
				{Multiplier = 0, Tree = this.Const.Perks.DeviousTree},
				{Multiplier = 0, Tree = this.Const.Perks.OrganisedTree},
				{Multiplier = 0, Tree = this.Const.Perks.LightArmorTree},
			],
			Profession = [
				[{Weight = 100, Tree = this.Const.Perks.RaiderProfessionTree}],
				[{Weight = 100, Tree = this.Const.Perks.SergeantClassTree}],
				[{Weight = 100, Tree = this.Const.Perks.TacticianClassTree}],
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.HeavyArmorTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}],
				[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}]
			],
			Traits = [
				[{Weight = 100, Tree = this.Const.Perks.IndestructibleTree}],
				[
					{Weight = 20, Tree = this.Const.Perks.ViciousTree},
					{Weight = 20, Tree = this.Const.Perks.SturdyTree},
					{Weight = 30, Tree = this.Const.Perks.LargeTree},
					{Weight = 30, Tree = this.Const.Perks.UnstoppableTree},
				]
			],
		};

		gt.Const.PerksCharmedUnit.LegendOrcBehemoth <- {
			WeightMultipliers = [
				{Multiplier = 2, Tree = this.Const.Perks.ResilientTree},
				{Multiplier = 5, Tree = this.Const.Perks.ViciousTree},
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
				[{Weight = 100, Tree = this.Const.Perks.WildlingProfessionTree}],
				[{Weight = 100, Tree = this.Const.Perks.RaiderProfessionTree}]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.HeavyArmorTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}],
				[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}]
			],
			Traits = [
				[{Weight = 100, Tree = this.Const.Perks.IndestructibleTree}],
				[
					{Weight = 30, Tree = this.Const.Perks.SturdyTree},
					{Weight = 30, Tree = this.Const.Perks.LargeTree},
					{Weight = 40, Tree = this.Const.Perks.UnstoppableTree},
				]
			],
		};

		gt.Const.PerksCharmedUnit.LegendOrcElite <- {
			WeightMultipliers = [
				{Multiplier = 4, Tree = this.Const.Perks.LaborerProfessionTree},
				{Multiplier = 2, Tree = this.Const.Perks.ResilientTree},
				{Multiplier = 5, Tree = this.Const.Perks.ViciousTree},
				{Multiplier = 0.5, Tree = this.Const.Perks.DaggerTree},
				{Multiplier = 2, Tree = this.Const.Perks.SwordTree},
				{Multiplier = 2, Tree = this.Const.Perks.MaceTree},
				{Multiplier = 3, Tree = this.Const.Perks.CleaverTree},
				{Multiplier = 2, Tree = this.Const.Perks.HammerTree},
				{Multiplier = 0, Tree = this.Const.Perks.PolearmTree},
				{Multiplier = 2, Tree = this.Const.Perks.ThrowingTree},
				{Multiplier = 0, Tree = this.Const.Perks.SlingsTree},
				{Multiplier = 0, Tree = this.Const.Perks.DeviousTree},
				{Multiplier = 0, Tree = this.Const.Perks.OrganisedTree},
				{Multiplier = 0, Tree = this.Const.Perks.LightArmorTree},
			],
			Profession = [
				[{Weight = 100, Tree = this.Const.Perks.SoldierProfessionTree}],
				[{Weight = 100, Tree = this.Const.Perks.RaiderProfessionTree}],
				[{Weight = 100, Tree = this.Const.Perks.LumberjackProfessionTree}]
			],
			Defense = [
				[{Weight = 100, Tree = this.Const.Perks.HeavyArmorTree}],
				[{Weight = 100, Tree = this.Const.Perks.ShieldTree}]
			],
			Styles = [
				[{Weight = 100, Tree = this.Const.Perks.OneHandedTree}],
				[{Weight = 100, Tree = this.Const.Perks.TwoHandedTree}]
			],
			Traits = [
				[{Weight = 100, Tree = this.Const.Perks.IndestructibleTree}],
				[
					{Weight = 25, Tree = this.Const.Perks.ViciousTree},
					{Weight = 25, Tree = this.Const.Perks.SturdyTree},
					{Weight = 25, Tree = this.Const.Perks.LargeTree},
					{Weight = 25, Tree = this.Const.Perks.UnstoppableTree},
				]
			],
		};
	}

	//Adding new custom charmed unit entries 
	::mc_processingEntries();
	::mc_overwriteEntries();
	delete gt.Nggh_MagicConcept.hookHexeOrigin;
}