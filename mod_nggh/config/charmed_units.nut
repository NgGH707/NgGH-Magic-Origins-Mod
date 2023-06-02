
if (!("CharmedUnits" in ::Const))
{
	::Const.CharmedUnits <- {};
}

//Database of default entries (Legends version)
::Const.CharmedUnits <- 
{
	// Default database
	Data = [
		//Necromancer = 0,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = [],
				Skills = [],
				Difficulty = 33,
				Custom = {
					ID = "background.legend_necromancer",
					AdditionalPerkGroup = [1 ,["BasicNecroMagicTree", "ZombieMagicTree", "SkeletonMagicTree"]],
				},
				Requirements = ["NggHCharmWords"],
				PerkTree = "legend_necromancer_background",
			},
			
		//Zombie = 1,
			{},
			
		//ZombieYeoman = 2,
			{},
			
		//ZombieKnight = 3,
			{},
			
		//ZombieBoss = 4,
			{},
			
		//SkeletonLight = 5,
			{},
			
		//SkeletonMedium = 6,
			{},
			
		//SkeletonHeavy = 7,
			{},
			
		//SkeletonPriest = 8,
			{},
			
		//SkeletonBoss = 9,
			{},
			
		//Vampire = 10,
			{},
			
		//Ghost = 11,
			{},
			
		//Ghoul = 12,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [-10, -5], Stamina = [0, 0], MeleeSkill = [-5, -5], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-25, -25] },
				Skills = ["actives/ghoul_claws", "actives/swallow_whole_skill"],
				Difficulty = 15,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 8, Stash = 9, Healing = 0.0, Injury = 0.0, Repair = 0.1, Salvage = 0.1, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.1, Gathering = 0.2, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [1, 5],
						PrimaryTalents = [],
						SecondaryTalents = [0, 4, 5],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "NachoNames",
				},
				PerkTree = "NachoTree",
				Script = "player_beast/nggh_mod_ghoul_player",
				Requirements = ["NggHCharmEnemyGhoul"],
			},
			
		//OrcYoung = 13,
			{
				StatMod = { Hitpoints = [-25, -15], Bravery = [-5, -5], Stamina = [-10, -10], MeleeSkill = [-2, -2], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-10, -10] },
				Skills = ["actives/charge"],
				Difficulty = 10,
				Custom =  {
					BgModifiers = {
						Ammo = 13, ArmorParts = 5, Meds = 8, Stash = 10, Healing = 0.0, Injury = 0.0, Repair = 0.05, Salvage = 0.1, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.05, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [3],
						PrimaryTalents = [0, 2, 4],
						SecondaryTalents = [],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "OrcNames",
				},
				PerkTree = "OrcYoung",
				Script = "nggh_mod_player_orc",
				Requirements = [],
				IsExperienced = true,
			},
			
		//OrcBerserker = 14,
			{
				StatMod = { Hitpoints = [-75, -55], Bravery = [-35, -25], Stamina = [-40, -40], MeleeSkill = [-10, -10], RangedSkill = [5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-25, -15] },
				Perks = ["LegendComposure"],
				Skills = ["effects/berserker_rage_effect", "actives/charge"],
				Difficulty = 35,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 10, Meds = 5, Stash = 15, Healing = 0.05, Injury = 0.05, Repair = 0.0, Salvage = 0.1, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.1, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [3],
						PrimaryTalents = [0, 2, 4],
						SecondaryTalents = [6],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "OrcNames",
				},
				PerkTree = "OrcBerserker",
				Script = "nggh_mod_player_orc",
				Requirements = ["NggHCharmEnemyOrk"],
			},
			
		//OrcWarrior = 15,
			{
				StatMod = { Hitpoints = [-50, -50], Bravery = [-15, -10], Stamina = [-80, -80], MeleeSkill = [-10, -10], RangedSkill = [0, 0], MeleeDefense = [-3, -3], RangedDefense = [-5, -5], Initiative = [-15, -10] },
				Perks = ["LegendComposure", "Stalwart", "ShieldBash"],
				Skills = ["actives/line_breaker"],
				Difficulty = 25,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 10, Meds = 8, Stash = 15, Healing = 0.0, Injury = 0.0, Repair = 0.05, Salvage = 0.1, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.1, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [3],
						PrimaryTalents = [0, 2, 4],
						SecondaryTalents = [],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "OrcNames",
				},
				PerkTree = "OrcWarrior",
				Script = "nggh_mod_player_orc",
				Requirements = ["NggHCharmEnemyOrk"],
			},
			
		//OrcWarlord = 16,
			{
				StatMod = { Hitpoints = [-90, -65], Bravery = [-35, -25], Stamina = [-110, -110], MeleeSkill = [-15, -9], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-5, -5] },
				Perks = ["LegendComposure", "Stalwart", "ShieldBash"],
				Skills = ["actives/warcry", "actives/line_breaker", "perks/perk_captain"],
				Difficulty = 25,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 15, Meds = 10, Stash = 20, Healing = 0.05, Injury = 0.0, Repair = 0.0, Salvage = 0.2, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.1, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [3],
						PrimaryTalents = [0, 2, 4],
						SecondaryTalents = [],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "OrcWarlordNames",
				},
				PerkTree = "OrcWarlord",
				Script = "nggh_mod_player_orc",
				Requirements = ["NggHCharmEnemyOrk", "NggHCharmEnemyOrk"],
			},
			
		//Militia = 17,
			{
				StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
				Perks = [],
				Difficulty = -5,
				Custom = {},
				PerkTree = "militia_background",
			},
			
		//MilitiaRanged = 18,
			{
				StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
				Perks = [],
				Difficulty = -5,
				Custom = {},
				PerkTree = "poacher_background",
			},
			
		//MilitiaVeteran = 19,
			{
				StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
				Perks = ["LegendSpecialistMilitiaSkill"],
				Difficulty = 0,
				Custom = {},
				PerkTree = "retired_soldier_background",
				IsExperienced = true,
			},
			
		//MilitiaCaptain = 20,
			{
				StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
				Perks = ["LegendSpecialistMilitiaSkill"],
				Skills = ["perks/perk_captain"],
				Difficulty = 10,
				Custom = {},
				PerkTree = "retired_soldier_background",
				IsExperienced = true,
			},
			
		//BountyHunter = 21,
			{
				StatMod = { Hitpoints = [-25, -10], Bravery = [-20, -15], Stamina = [-5, -5], MeleeSkill = [-12, -8], RangedSkill = [-5, 0], MeleeDefense = [-8, -5], RangedDefense = [-5, 0], Initiative = [0, 0] },
				Perks = ["Rotation", "Footwork"],
				Difficulty = 15,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "sellsword_background",
			},
			
		//Peasant = 22,
			{
				StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
				Perks = [],
				Difficulty = -25,
				Custom = {
					ID = "background.farmhand",
				},
				PerkTree = "farmhand_background",
			},
			
		//CaravanHand = 23,
			{
				StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
				Perks = [],
				Difficulty = 0,
				Custom = {
					ID = "background.caravan_hand",
				},
				PerkTree = "caravan_hand_background",
			},
			
		//CaravanGuard = 24,
			{
				StatMod = { Hitpoints = [-12, -10], Bravery = [-15, -12], Stamina = [-25, -20], MeleeSkill = [-10, -8], RangedSkill = [0, 0], MeleeDefense = [-2, 0], RangedDefense = [-2, 0], Initiative = [-10, 0] },
				Perks = ["Recover"],
				Difficulty = 10,
				Custom = {
					ID = "background.caravan_hand",
				},
				PerkTree = "sellsword_background",
				IsExperienced = true,
			},
			
		//CaravanDonkey = 25,
			{},

		//Footman = 26,
			{
				StatMod = { Hitpoints = [-7, -15], Bravery = [-10, -10], Stamina = [-10, -10], MeleeSkill = [-8, -8], RangedSkill = [-5, -5], MeleeDefense = [0, -5], RangedDefense = [0, -3], Initiative = [-10, -10] },
				Perks = ["Rotation"],
				Difficulty = 10,
				Custom = {},
				PerkTree = "deserter_background",
				IsExperienced = true,
			},
			
		//Greatsword = 27,
			{
				StatMod = { Hitpoints = [-25, -25], Bravery = [-15, -10], Stamina = [-15, -10], MeleeSkill = [-8, -8], RangedSkill = [0, 0], MeleeDefense = [-10, -5], RangedDefense = [0, 0], Initiative = [-5, 0] },
				Perks = ["Rotation", "LoneWolf"],
				Difficulty = 30,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "legend_noble_2h",
			},
			
		//Billman = 28,
			{
				StatMod = { Hitpoints = [-15, -15], Bravery = [-10, -10], Stamina = [-10, -10], MeleeSkill = [-8, -8], RangedSkill = [-5, -5], MeleeDefense = [0, -5], RangedDefense = [0, -3], Initiative = [-2, 0] },
				Perks = ["Rotation", "Backstabber"],
				Difficulty = 10,
				Custom = {},
				PerkTree = "beast_hunter_background",
				IsExperienced = true,
			},
			
		//Arbalester = 29,
			{
				StatMod = { Hitpoints = [-12, -7], Bravery = [-10, -10], Stamina = [-10, -10], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [-2, -1], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = ["Rotation"],
				Difficulty = 10,
				Custom = {},
				PerkTree = "legend_noble_ranged",
				IsExperienced = true,
			},
			
		//StandardBearer = 30,
			{
				StatMod = { Hitpoints = [-20, -15], Bravery = [-12, -10], Stamina = [-30, -15], MeleeSkill = [-5, -5], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-5, -5] },
				Perks = ["Rotation", "InspiringPresence"],
				Skills = ["perks/perk_captain"],
				Difficulty = 35,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "legend_noble_event_background",
			},

		//Sergeant = 31,
			{
				StatMod = { Hitpoints = [-30, -30], Bravery = [-20, -10], Stamina = [-15, -10], MeleeSkill = [-15, -10], RangedSkill = [0, 0], MeleeDefense = [-10, -7], RangedDefense = [0, 0], Initiative = [-15, -10] },
				Perks = ["Rotation", "Duelist"],
				Difficulty = 45,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "legend_noble_background",
			},
			
		//Knight = 32,
			{
				StatMod = { Hitpoints = [-35, -35], Bravery = [-25, -15], Stamina = [-20, -15], MeleeSkill = [-20, -20], RangedSkill = [0, 0], MeleeDefense = [-10, -7], RangedDefense = [0, 5], Initiative = [0, 5] },
				Perks = ["Rotation", "Brawny"],
				Skills = ["perks/perk_captain"],
				Difficulty = 45,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "hedge_knight_background",
			},
			
		//MilitaryDonkey = 33,
			{},
			
		//BanditThug = 34,
			{
				StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
				Perks = [],
				Difficulty = 0,
				Custom = {
					ID = "background.beggar",
				},
				PerkTree = "beggar_background",
			},

		//BanditPoacher = 35,
			{
				StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
				Perks = [],
				Difficulty = 0,
				Custom = {},
				PerkTree = "poacher_background",
			},
			
		//BanditMarksman = 36,
			{
				StatMod = { Hitpoints = [-5, -5], Bravery = [-5, -5], Stamina = [-5, 0], MeleeSkill = [-2, 2], RangedSkill = [-5, 2], MeleeDefense = [0, 0], RangedDefense = [-2, 2], Initiative = [0, 0] },
				Perks = [],
				Difficulty = 5,
				Custom = {},
				PerkTree = "hunter_background",
				IsExperienced = true,
			},
			
		//BanditRaider = 37,
			{
				StatMod = { Hitpoints = [-15, -15], Bravery = [-20, -15], Stamina = [-25, -15], MeleeSkill = [-8, -5], RangedSkill = [-5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-15, -5] },
				Perks = [],
				Difficulty = 5,
				Custom = {},
				PerkTree = "raider_background",
				IsExperienced = true,
			},
			
		//BanditLeader = 38,
			{
				StatMod = { Hitpoints = [-30, -30], Bravery = [-30, -30], Stamina = [-30, -25], MeleeSkill = [-13, -10], RangedSkill = [-10, -8], MeleeDefense = [-15, -8], RangedDefense = [-8, -5], Initiative = [-20, -15] },
				Perks = ["NineLives"],
				Skills = ["perks/perk_captain"]
				Difficulty = 15,
				Custom = {
					ID = "background.raider",
				},
				Requirements = ["NggHCharmWords"],
				PerkTree = "orc_slayer_background",
			},
			
		//GoblinAmbusher = 39,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [-11, -10], Stamina = [-10, 0], MeleeSkill = [-7, -5], RangedSkill = [-12, -9], MeleeDefense = [-5, -3], RangedDefense = [-10, -5], Initiative = [-32, -29] },
				Perks = ["Bullseye"],
				Skills = ["racial/goblin_ambusher_racial"],
				Difficulty = 10,
				Custom =  {
					BgModifiers = {
						Ammo = 20, ArmorParts = 3, Meds = 5, Stash = 0, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.1, Scout = 0.2, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [2],
						PrimaryTalents = [5, 7],
						SecondaryTalents = [4, 6, 3],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "GoblinNames",
				},
				PerkTree = "GoblinAmbusher",
				Script = "nggh_mod_player_goblin",
				Requirements = [],
			},
			
		//GoblinFighter = 40,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [-14, -15], Stamina = [-5, -5], MeleeSkill = [-12, -15], RangedSkill = [-12, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-32, -29] },
				Perks = [],
				Difficulty = 10,
				Custom =  {
					BgModifiers = {
						Ammo = 10, ArmorParts = 5, Meds = 5, Stash = 3, Healing = 0.0, Injury = 0.0, Repair = 0.1, Salvage = 0.0, Crafting = 0.075, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.2, Gathering = 0.05, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [2],
						PrimaryTalents = [4, 6, 7],
						SecondaryTalents = [3, 5],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "GoblinNames",
				},
				PerkTree = "GoblinFighter",
				Script = "nggh_mod_player_goblin",
				Requirements = [],
			},
			
		//GoblinLeader = 41,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [-5, 0], Stamina = [-20, -20], MeleeSkill = [-17, -15], RangedSkill = [-15, -14], MeleeDefense = [-5, -5], RangedDefense = [-10, -10], Initiative = [-25, -23] },
				Skills = ["perks/perk_captain", "actives/goblin_whip"],
				Difficulty = 30,
				Custom =  {
					BgModifiers = {
						Ammo = 25, ArmorParts = 8, Meds = 10, Stash = 3, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.1, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.2, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [0],
						PrimaryTalents = [4, 5, 1],
						SecondaryTalents = [2, 6, 7, 3],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "GoblinNames",
				},
				PerkTree = "GoblinLeader",
				Script = "nggh_mod_player_goblin",
				Requirements = ["NggHCharmEnemyGoblin"],
			},
			
		//GoblinShaman = 42,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [-2, 0], RangedSkill = [-2, 0], MeleeDefense = [-5, -5], RangedDefense = [-10, -10], Initiative = [-25, -20] },
				Skills = ["racial/goblin_shaman_racial", "actives/root_skill", "actives/insects_skill", "actives/grant_night_vision_skill"],
				Difficulty = 45,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 25, Stash = 0, Healing = 0.25, Injury = 0.25, Repair = 0.0, Salvage = 0.0, Crafting = 0.1, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.0, Gathering = 0.1, Training = 0.0, Enchanting = 0.4,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [],
						PrimaryTalents = [1, 5, 7],
						SecondaryTalents = [3],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "GoblinNames",
				},
				PerkTree = "GoblinShaman",
				Script = "nggh_mod_player_goblin",
				Requirements = ["NggHCharmEnemyGoblin"],
			},
			
		//GoblinWolfrider = 43,
			{
				StatMod = { Hitpoints = [-20, -20], Bravery = [-15, -15], Stamina = [-55, -55], MeleeSkill = [-13, -13], RangedSkill = [-1, 1], MeleeDefense = [0, 0], RangedDefense = [-5, -5], Initiative = [-23, -27] },
				Perks = [],
				Difficulty = 12,
				Custom =  {
					BgModifiers = {
						Ammo = 10, ArmorParts = 15, Meds = 0, Stash = 3, Healing = 0.0, Injury = 0.0, Repair = 0.15, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.3, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.05, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [0],
						PrimaryTalents = [4, 6, 2],
						SecondaryTalents = [7, 3, 5],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "GoblinNames",
				},
				PerkTree = "GoblinWolfrider",
				Script = "nggh_mod_player_goblin",
				Requirements = [],
				IsExperienced = true,
			},
			
		//Wolf = 44,
			{},
			
		//Wardog = 45,
			{},
			
		//ArmoredWardog = 46,
			{},
			
		//Mercenary = 47,
			{
				StatMod = { Hitpoints = [-35, -25], Bravery = [-20, -10], Stamina = [-25, -20], MeleeSkill = [-13, -8], RangedSkill = [-10, -5], MeleeDefense = [-8, -5], RangedDefense = [-10, 0], Initiative = [-20, -10] },
				Perks = ["Overwhelm"],
				Difficulty = 10,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "sellsword_background",
			},
			
		//MercenaryRanged = 48,
			{
				StatMod = { Hitpoints = [-10, -10], Bravery = [-20, -10], Stamina = [-20, -20], MeleeSkill = [-10, -10], RangedSkill = [0, 0], MeleeDefense = [-2, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = ["Overwhelm", "Footwork"],
				Difficulty = 12,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "sellsword_background",
			},
			
		//Swordmaster = 49,
			{
				StatMod = { Hitpoints = [-30, -20], Bravery = [-30, -20], Stamina = [-15, -15], MeleeSkill = [-25, -15], RangedSkill = [-10, -10], MeleeDefense = [-35, -30], RangedDefense = [-15, -10], Initiative = [-5, -5] },
				Perks = ["Duelist", "SpecSword", "LegendSpecGreatSword"],
				Difficulty = 75,
				Custom = {},
				Requirements = ["NggHCharmAppearance"],
				PerkTree = "swordmaster_background"
			},
			
		//HedgeKnight = 50,
			{
				StatMod = { Hitpoints = [-50, -30], Bravery = [-30, -20], Stamina = [-15, -15], MeleeSkill = [-25, -25], RangedSkill = [0, 0], MeleeDefense = [-15, -10], RangedDefense = [-12, -8], Initiative = [-15, -5] },
				Perks = ["DevastatingStrikes", "SteelBrow", "Brawny"],
				Difficulty = 60,
				Custom = {},
				Requirements = ["NggHCharmAppearance"],
				PerkTree = "hedge_knight_background"
			},
			
		//MasterArcher = 51,
			{
				StatMod = { Hitpoints = [-20, -15], Bravery = [-10, 0], Stamina = [-15, -15], MeleeSkill = [-5, -5], RangedSkill = [-15, -5], MeleeDefense = [-5, -5], RangedDefense = [0, 0], Initiative = [-25, -10] },
				Perks = ["Bullseye", "QuickHands", "SpecCrossbow", "SpecBow"],
				Difficulty = 70,
				Custom = {},
				Requirements = ["NggHCharmAppearance"],
				PerkTree = "legend_master_archer_background",
			},
			
		//GreenskinCatapult = 52,
			{},
			
		//Cultist = 53,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = ["Nimble", "Backstabber"],
				Difficulty = 33,
				Custom = {},
				PerkTree = "cultist_background",
				IsExperienced = true,
			},
			
		//Direwolf = 54,
			{
				StatMod = { Hitpoints = [-30, 0], Bravery = [-5, -5], Stamina = [-30, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [4, 6], RangedDefense = [1, 2], Initiative = [-15, 0] },
				Perks = [],
				Difficulty = 25,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 3, Meds = 0, Stash = 6, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.3, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [5],
						PrimaryTalents = [3, 4, 6],
						SecondaryTalents = [0],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "WolfNames",
				},
				PerkTree = "WolfTree",
				Script = "player_beast/nggh_mod_direwolf_player",
				Requirements = ["NggHCharmEnemyDirewolf"],
			},
			
		//Lindwurm = 55,
			{
				StatMod = { Hitpoints = [-300, -300], Bravery = [-50, -50], Stamina = [-225, -200], MeleeSkill = [-10, -5], RangedSkill = [5, -5], MeleeDefense = [-3, -3], RangedDefense = [-3, -3], Initiative = [-10, -5] },
				Perks = [],
				Difficulty = 10,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 15, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.2, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [3, 5, 7],
						PrimaryTalents = [4],
						SecondaryTalents = [0, 6],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "LindwurmNames",
				},
				PerkTree = "LindwurmTree",
				Script = "player_beast/nggh_mod_lindwurm_player",
				Requirements = ["NggHCharmEnemyLindwurm"],
			},
			
		//Unhold = 56,
			{
				StatMod = { Hitpoints = [-100, -100], Bravery = [-50, -50], Stamina = [-200, -200], MeleeSkill = [-8, -5], RangedSkill = [5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [0, 0] },
				Skills = ["racial/unhold_racial", "actives/sweep_skill", "actives/sweep_zoc_skill", "actives/fling_back_skill"],
				Difficulty = 10,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [5, 7],
						PrimaryTalents = [2, 4],
						SecondaryTalents = [0, 6],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "UnholdNames",
				},
				PerkTree = "UnholdTree",
				Script = "player_beast/nggh_mod_unhold_player",
				Requirements = ["NggHCharmEnemyUnhold"],
			},
			
		//UnholdFrost = 57,
			{
				StatMod = { Hitpoints = [-150, -150], Bravery = [-50, -50], Stamina = [-200, -200], MeleeSkill = [-8, -5], RangedSkill = [5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [0, 0] },
				Skills = ["racial/unhold_racial", "actives/sweep_skill", "actives/sweep_zoc_skill", "actives/fling_back_skill"],
				Difficulty = 0,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.05, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [5, 7],
						PrimaryTalents = [2, 4],
						SecondaryTalents = [0, 6],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "UnholdNames",
				},
				PerkTree = "UnholdTree",
				Script = "player_beast/nggh_mod_unhold_player",
				Requirements = ["NggHCharmEnemyUnhold"],
			},
			
		//UnholdBog = 58,
			{
				StatMod = { Hitpoints = [-100, -100], Bravery = [-50, -50], Stamina = [-200, -200], MeleeSkill = [-8, -5], RangedSkill = [5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [0, 0] },
				Skills = ["racial/legend_bog_unhold_racial", "actives/sweep_skill", "actives/sweep_zoc_skill", "actives/fling_back_skill"],
				Difficulty = 15,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.05, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [5, 7],
						PrimaryTalents = [2, 4],
						SecondaryTalents = [0, 6],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "UnholdNames",
				},
				PerkTree = "UnholdTree",
				Script = "player_beast/nggh_mod_unhold_player",
				Requirements = ["NggHCharmEnemyUnhold"],
			},
			
		//Spider = 59,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [-2, 2], RangedDefense = [-3, 0], Initiative = [-22, -12] },
				Skills = ["actives/spider_bite_skill", "racial/spider_racial"],
				Difficulty = -5,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.1, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.3, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.01, 0.01, 0.01, 0.05, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01],
					},
					Talents = {
						ExcludedTalents = [1, 5],
						PrimaryTalents = [3, 6, 7],
						SecondaryTalents = [0, 2, 4],
						StarsMax = 10,
						StarsMin = 2,
					},
					Names = "SpiderNames",
				},
				PerkTree = "SpiderTree",
				Script = "player_beast/nggh_mod_spider_player",
				Requirements = ["NggHCharmEnemySpider"],
			},
			
		//SpiderEggs = 60,
			{},
			
		//Alp = 61,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [-25, -15], Stamina = [0, 0], MeleeSkill = [-5, 5], RangedSkill = [-5, 5], MeleeDefense = [-2, 0], RangedDefense = [-2, 0], Initiative = [0, 0] },
				Perks = ["Underdog"],
				Skills = ["actives/sleep_skill", "actives/nightmare_skill", "actives/alp_teleport_skill"],
				Difficulty = 12,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 5, Stash = 3, Healing = 0.1, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.1, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.2, Gathering = 0.1, Training = 0.0, Enchanting = 0.1,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [2],
						PrimaryTalents = [1, 3],
						SecondaryTalents = [0, 4, 5, 6, 7],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "GoblinNames",
				},
				PerkTree = "AlpTree",
				Script = "player_beast/nggh_mod_alp_player",
				Requirements = ["NggHCharmEnemyAlp"],
			},
			
		//Hexe = 62,
			{},
			
		//Schrat = 63,
			{
				StatMod = { Hitpoints = [-200, -200], Bravery = [0, 0], Stamina = [-100, -100], MeleeSkill = [-10, -5], RangedSkill = [5, -5], MeleeDefense = [-3, -3], RangedDefense = [-3, -3], Initiative = [-5, 0] },
				Skills = ["racial/schrat_racial", "actives/grow_shield_skill"],
				Difficulty = -25,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 10, Stash = 12, Healing = 0.2, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.1, Gathering = 0.3, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05],
					},
					Talents = {
						ExcludedTalents = [3, 5],
						PrimaryTalents = [1, 2, 4],
						SecondaryTalents = [6, 7],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "SchratNames",
				},
				PerkTree = "SchratTree",
				Script = "player_beast/nggh_mod_schrat_player",
				Requirements = ["NggHCharmEnemySchrat"],
			},
		
		//SchratSmall = 64,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [-10, -8], RangedSkill = [0, 0], MeleeDefense = [-3, 0], RangedDefense = [-3, 0], Initiative = [0, 0] },
				Perks = [],
				Difficulty = -50,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 4, Stash = 5, Healing = 0.2, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.1, Gathering = 0.2, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.025],
					},
					Talents = {
						ExcludedTalents = [0, 5],
						PrimaryTalents = [6, 7],
						SecondaryTalents = [4, 5],
						StarsMax = 12,
						StarsMin = 1,
					},
					Names = "SchratNames",
				},
				PerkTree = "SmallSchratTree",
				Script = "player_beast/nggh_mod_schrat_small_player",
				Requirements = [],
			},
			
		//Wildman = 65,
			{
				StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
				Perks = [],
				Difficulty = 0,
				Custom = {},
				PerkTree = "wildman_background"
			},
			
		//Kraken = 66,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = [],
				Difficulty = -689,
				Custom =  {
					BgModifiers = {
						Ammo = 100, ArmorParts = 100, Meds = 100, Stash = 300, Healing = 0.1, Injury = 0.1, Repair = 0.1, Salvage = 0.1, Crafting = 0.1, Barter = 0.1, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 1.0, Fletching = 0.1, Scout = 0.1, Gathering = 1.0, Training = 0.1, Enchanting = 50.0,
						Terrain = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5],
					},
					Talents = {
						ExcludedTalents = [0, 1, 2, 3, 4, 5, 6, 7],
						PrimaryTalents = [],
						SecondaryTalents = [],
						StarsMax = 0,
						StarsMin = 0,
					},
					Names = "KrakenNamesOnly",
				},
				PerkTree = "KrakenTree",
				Script = "player_beast/nggh_mod_kraken_player",
				Requirements = ["NggHCharmSpec"],
			},
			
		//KrakenTentacle = 67,
			{},
			
		//ZombieBetrayer = 68,
			{},
			
		//AlpShadow = 69,
			{},
			
		//BarbarianThrall = 70,
			{
				StatMod = { Hitpoints = [-10, -5], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-2, 2] },
				Skills = ["actives/barbarian_fury_skill"],
				Difficulty = 0,
				Custom = {},
				PerkTree = "barbarian_background"
			},
			
		//BarbarianMarauder = 71,
			{
				StatMod = { Hitpoints = [-40, -40], Bravery = [-20, -15], Stamina = [-10, -10], MeleeSkill = [-5, -5], RangedSkill = [-7, -5], MeleeDefense = [-5, -5], RangedDefense = [-3, -3], Initiative = [-15, -5] },
				Skills = ["actives/barbarian_fury_skill"],
				Difficulty = 5,
				Custom = {},
				PerkTree = "barbarian_background"
				IsExperienced = true,
			},
			
		//BarbarianChampion = 72,
			{
				StatMod = { Hitpoints = [-50, -50], Bravery = [-20, -20], Stamina = [-25, -25], MeleeSkill = [-15, -10], RangedSkill = [-8, -8], MeleeDefense = [-10, -5], RangedDefense = [0, 0], Initiative = [-15, -5] },
				Perks = ["Brawny"],
				Skills = ["actives/barbarian_fury_skill"],
				Difficulty = 42,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "barbarian_background"
			},
			
		//BarbarianDrummer = 73,
			{
				StatMod = { Hitpoints = [-20, -20], Bravery = [-30, -20], Stamina = [-20, -10], MeleeSkill = [-5, -5], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [0, 0], Initiative = [-5, -5] },
				Skills = ["actives/barbarian_fury_skill"],
				Difficulty = 0,
				Custom = {},
				PerkTree = "minstrel_background",
				IsExperienced = true,
			},
			
		//BarbarianBeastmaster = 74,
			{
				StatMod = { Hitpoints = [-20, -20], Bravery = [-30, -20], Stamina = [-20, -10], MeleeSkill = [-5, -5], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [0, 0], Initiative = [-5, -5] },
				Skills = ["actives/barbarian_fury_skill", "actives/crack_the_whip_skill"],
				Difficulty = 10,
				Custom = {
					ID = "background.houndmaster",
				},
				Requirements = ["NggHCharmWords"],
				PerkTree = "cultist_background",
			},
			
		//BarbarianUnhold = 75,
			{
				StatMod = { Hitpoints = [-100, -100], Bravery = [-50, -50], Stamina = [-200, -200], MeleeSkill = [-8, -5], RangedSkill = [5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [0, 0] },
				Skills = ["racial/unhold_racial", "actives/sweep_skill", "actives/sweep_zoc_skill", "actives/fling_back_skill"],
				Difficulty = 10,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [5, 7],
						PrimaryTalents = [2, 4],
						SecondaryTalents = [0, 6],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "UnholdNames",
				},
				PerkTree = "UnholdTree",
				Script = "player_beast/nggh_mod_unhold_player",
				Requirements = ["NggHCharmEnemyUnhold"],
			},
			
		//BarbarianUnholdFrost = 76,
			{
				StatMod = { Hitpoints = [-150, -150], Bravery = [-50, -50], Stamina = [-200, -200], MeleeSkill = [-8, -5], RangedSkill = [5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [0, 0] },
				Skills = ["racial/unhold_racial", "actives/sweep_skill", "actives/sweep_zoc_skill", "actives/fling_back_skill"],
				Difficulty = 0,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.05, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [5, 7],
						PrimaryTalents = [2, 4],
						SecondaryTalents = [0, 6],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "UnholdNames",
				},
				PerkTree = "UnholdTree",
				Script = "player_beast/nggh_mod_unhold_player",
				Requirements = ["NggHCharmEnemyUnhold"],
			},
			
		//BarbarianChosen = 77,
			{
				StatMod = { Hitpoints = [-50, -50], Bravery = [-20, -15], Stamina = [-25, -25], MeleeSkill = [-10, -10], RangedSkill = [-8, -8], MeleeDefense = [-10, 0], RangedDefense = [0, 0], Initiative = [-15, -5] },
				Perks = ["DevastatingStrikes", "Brawny"],
				Skills = ["actives/barbarian_fury_skill"],
				Difficulty = 40,
				Custom = {
					ID = "background.barbarian",
				},
				Requirements = ["NggHCharmAppearance"],
				PerkTree = "orc_slayer_background",
			},
			
		//Warhound = 78,
			{},
			
		//TricksterGod = 79,
			{
				StatMod = { Hitpoints = [5, -5], Bravery = [5, -5], Stamina = [5, -5], MeleeSkill = [5, -5], RangedSkill = [5, -5], MeleeDefense = [3, -3], RangedDefense = [3, -3], Initiative = [10, -10] },
				Perks = [],
				Difficulty = -799,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 50, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.5, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.5, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05],
					},
					Talents = {
						ExcludedTalents = [5, 7],
						PrimaryTalents = [2, 4],
						SecondaryTalents = [0, 6],
						StarsMax = 9,
						StarsMin = 1,
					},
				},
				PerkTree = "UnholdTree",
				Script = "player_beast/nggh_mod_trickster_god_player",
				Requirements = ["NggHCharmSpec"],
			},
			
		//BarbarianMadman = 80,
			{},
			
		//Serpent = 81,
			{
				StatMod = { Hitpoints = [-10, -10], Bravery = [-15, -10], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [25, 25] },
				Perks = [],
				Difficulty = -15,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.2, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.025],
					},
					Talents = {
						ExcludedTalents = [5],
						PrimaryTalents = [0, 6, 7],
						SecondaryTalents = [1, 2, 3, 4],
						StarsMax = 10,
						StarsMin = 3,
					},
					Names = "SerpentNames",
				},
				PerkTree = "SerpentTree",
				Script = "player_beast/nggh_mod_serpent_player",
				Requirements = [],
			},
			
		//SandGolem = 82,
			{},
			
		//Hyena = 83,
			{
				StatMod = { Hitpoints = [-20, 0], Bravery = [-5, -5], Stamina = [-30, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [4, 6], RangedDefense = [0, 0], Initiative = [0, 5] },
				Perks = [],
				Difficulty = 5,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 3, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.3, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.025],
					},
					Talents = {
						ExcludedTalents = [5],
						PrimaryTalents = [3, 4, 6],
						SecondaryTalents = [0],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "WolfNames",
				},
				PerkTree = "HyenaTree",
				Script = "player_beast/nggh_mod_hyena_player",
				Requirements = ["NggHCharmEnemyDirewolf"],
			},

		//Conscript = 84,
			{
				StatMod = { Hitpoints = [-7, -10], Bravery = [-10, -10], Stamina = [-10, -10], MeleeSkill = [-8, -8], RangedSkill = [-5, -5], MeleeDefense = [0, -5], RangedDefense = [0, -3], Initiative = [-10, -10] },
				Perks = ["Rotation"],
				Difficulty = 5,
				Custom = {},
				PerkTree = "legend_noble_shield",
				IsExperienced = true,
			},
			
		//Gunner = 85,
			{
				StatMod = { Hitpoints = [-10, -10], Bravery = [-15, -10], Stamina = [-10, -10], MeleeSkill = [-5, -5], RangedSkill = [-8, -5], MeleeDefense = [-2, -1], RangedDefense = [-2, 0], Initiative = [0, 0] },
				Perks = ["Rotation", "SpecCrossbow"],
				Difficulty = 10,
				Custom = {},
				PerkTree = "legend_noble_ranged",
				IsExperienced = true,
			},
			
		//Officer = 86,
			{
				StatMod = { Hitpoints = [-35, -30], Bravery = [-20, -10], Stamina = [-17, -12], MeleeSkill = [-17, -12], RangedSkill = [0, 0], MeleeDefense = [-10, -7], RangedDefense = [0, 0], Initiative = [-15, -10] },
				Perks = ["QuickHands", "Rotation", "Duelist"],
				Skills = ["perks/perk_captain"]
				Difficulty = 45,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "legend_noble_background",
			},

		//Engineer = 87,
			{
				StatMod = { Hitpoints = [-30, -30], Bravery = [-30, -25], Stamina = [-20, -10], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = ["Rotation"],
				Difficulty = 30,
				Custom = {
					ID = "background.legend_inventor"
				},
				PerkTree = "legend_noble_ranged",
				IsExperienced = true,
			},
			
		//Assassin = 88,
			{
				StatMod = { Hitpoints = [-15, -10], Bravery = [-20, -10], Stamina = [-30, -10], MeleeSkill = [-10, -7], RangedSkill = [-5, -5], MeleeDefense = [0, 2], RangedDefense = [0, 0], Initiative = [-10, -5] },
				Perks = ["QuickHands", "Backstabber", "SpecDagger"],
				Difficulty = 45,
				Custom = {
					ID = "background.assassin_southern"
				},
				Requirements = ["NggHCharmWords"],
				PerkTree = "legend_assassin_background",
			},
			
		//Slave = 89,
			{
				StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
				Perks = [],
				Difficulty = -25,
				Custom = {},
				PerkTree = "slave_background",
			},
			
		//Gladiator = 90,
			{
				StatMod = { Hitpoints = [-40, -28], Bravery = [-30, -30], Stamina = [-15, -10], MeleeSkill = [-8, -8], RangedSkill = [-3, -3], MeleeDefense = [-10, -8], RangedDefense = [0, 0], Initiative = [-15, -15] },
				Perks = ["Footwork", "Underdog"],
				Difficulty = 15,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "gladiator_background",
			},
			
		//Mortar = 91,
			{},
			
		//NomadCutthroat = 92,
			{
				StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
				Skills = ["actives/throw_dirt_skill"],
				Difficulty = 0,
				Custom = {},
				PerkTree = "nomad_background"
			},
			
		//NomadOutlaw = 93,
			{
				StatMod = { Hitpoints = [-15, -15], Bravery = [-20, -15], Stamina = [-25, -15], MeleeSkill = [-8, -5], RangedSkill = [-5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-15, -5] },
				Skills = ["actives/throw_dirt_skill"],
				Difficulty = 10,
				Custom = {},
				PerkTree = "nomad_background",
			},
			
		//NomadSlinger = 94,
			{
				StatMod = { Hitpoints = [-5, -5], Bravery = [-5, -5], Stamina = [-5, 0], MeleeSkill = [-5, 2], RangedSkill = [-10, -8], MeleeDefense = [0, 0], RangedDefense = [-2, 2], Initiative = [0, 0] },
				Skills = ["actives/throw_dirt_skill"],
				Difficulty = 5,
				Custom = {},
				PerkTree = "nomad_ranged_background",
			},
			
		//NomadArcher = 95,
			{
				StatMod = { Hitpoints = [-5, -5], Bravery = [-5, -5], Stamina = [-5, 0], MeleeSkill = [-5, 2], RangedSkill = [-10, -8], MeleeDefense = [0, 0], RangedDefense = [-2, 2], Initiative = [0, 0] },
				Skills = ["actives/throw_dirt_skill"],
				Difficulty = 10,
				Custom = {},
				PerkTree = "nomad_ranged_background",
			},
			
		//NomadLeader = 96,
			{
				StatMod = { Hitpoints = [-30, -20], Bravery = [-20, -20], Stamina = [-25, -15], MeleeSkill = [-13, -8], RangedSkill = [-8, -8], MeleeDefense = [-13, -8], RangedDefense = [-8, -5], Initiative = [-20, -15] },
				Perks = ["NineLives"],
				Skills = ["actives/throw_dirt_skill", "perks/perk_captain"],
				Difficulty = 15,
				Custom = {
					ID = "background.nomad",
				},
				Requirements = ["NggHCharmWords"],
				PerkTree = "orc_slayer_background",
			},
			
		//DesertStalker = 97,
			{
				StatMod = { Hitpoints = [-20, -15], Bravery = [-10, 0], Stamina = [-15, -15], MeleeSkill = [-5, -5], RangedSkill = [-15, -10], MeleeDefense = [-5, -5], RangedDefense = [0, 0], Initiative = [-25, -10] },
				Perks = ["Bullseye", "QuickHands", "SpecCrossbow", "SpecBow"],
				Skills = ["actives/throw_dirt_skill"],
				Difficulty = 70,
				Custom = {},
				Requirements = ["NggHCharmAppearance"],
				PerkTree = "legend_master_archer_background",
			},
			
		//Executioner = 98,
			{
				StatMod = { Hitpoints = [-50, -25], Bravery = [-20, -15], Stamina = [-10, -10], MeleeSkill = [-15, -5], RangedSkill = [0, 0], MeleeDefense = [-5, 0], RangedDefense = [-12, -8], Initiative = [-15, -5] },
				Perks = ["DevastatingStrikes", "SteelBrow", "Brawny"],
				Skills = ["actives/throw_dirt_skill"],
				Difficulty = 50,
				Custom = {},
				Requirements = ["NggHCharmAppearance"],
				PerkTree = "hedge_knight_background"
			},
			
		//DesertDevil = 99,
			{
				StatMod = { Hitpoints = [-20, -20], Bravery = [-20, -15], Stamina = [-15, -15], MeleeSkill = [-25, -25], RangedSkill = [-10, -10], MeleeDefense = [-15, -10], RangedDefense = [-10, -10], Initiative = [-5, -5] },
				Perks = ["Duelist", "SpecSword", "LegendSpecGreatSword"],
				Skill = ["actives/throw_dirt_skill"],
				Difficulty = 50,
				Custom = {},
				Requirements = ["NggHCharmAppearance"],
				PerkTree = "swordmaster_background"
			},
			
		//PeasantSouthern = 100,
			{
				StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
				Perks = [],
				Difficulty = -25,
				Custom = {},
				PerkTree = "farmhand_background"
			},
			
		//SkeletonLich = 101,
			{},
			
		//SkeletonLichMirrorImage = 102,
			{},
			
		//SkeletonPhylactery = 103,
			{},
			
		//ZombieTreasureHunter = 104,
			{},
			
		//FlyingSkull = 105,
			{},
			
		//BanditRabble = 106,
			{
				StatMod = { Hitpoints = [-2, 2], Bravery = [-2, 2], Stamina = [-2, 2], MeleeSkill = [-2, 2], RangedSkill = [-2, 2], MeleeDefense = [-2, 2], RangedDefense = [-2, 2], Initiative = [-2, 2] },
				Perks = [],
				Difficulty = -10,
				Custom = {},
				PerkTree = "beggar_background"
			},
			
		//LegendCat = 107,
			{},
			
		//LegendOrcElite = 108,
			{
				StatMod = { Hitpoints = [-100, -70], Bravery = [-35, -35], Stamina = [-120, -120], MeleeSkill = [-17, -9], RangedSkill = [-5, -2], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-25, -20] },
				Perks = ["LegendComposure", "Stalwart", "ShieldBash"],
				Skills = ["actives/line_breaker"],
				Difficulty = 55,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 10, Meds = 10, Stash = 15, Healing = 0.0, Injury = 0.1, Repair = 0.0, Salvage = 0.30, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.15, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.1, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [3],
						PrimaryTalents = [0, 2, 4],
						SecondaryTalents = [],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "OrcNames",
				},
				PerkTree = "LegendOrcElite",
				Script = "nggh_mod_player_orc",
				Requirements = ["NggHCharmEnemyOrk"]
			},
			
		//LegendOrcBehemoth = 109,
			{
				StatMod = { Hitpoints = [-420, -400], Bravery = [-20, -15], Stamina = [-200, -200], MeleeSkill = [-12, -10], RangedSkill = [0, 0], MeleeDefense = [-7, -5], RangedDefense = [-5, -5], Initiative = [-7, 1] },
				Perks = ["Stalwart"]
				Skills = ["actives/line_breaker", "perks/perk_legend_taste_the_pain"],
				Difficulty = 105,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 20, Meds = 0, Stash = 30, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [3],
						PrimaryTalents = [0, 2, 4],
						SecondaryTalents = [],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "OrcNames",
				},
				PerkTree = "LegendOrcBehemoth",
				Script = "nggh_mod_player_orc",
				Requirements = ["NggHCharmEnemyOrk", "NggHCharmSpec"]
			},
			
		//LegendWhiteDirewolf = 110,
			{
				StatMod = { Hitpoints = [-200, -150], Bravery = [-40, -25], Stamina = [-80, -40], MeleeSkill = [-12, -10], RangedSkill = [0, 0], MeleeDefense = [-8, -8], RangedDefense = [-8, -8], Initiative = [-45, -35] },
				Perks = ["Footwork", "Rotation"],
				Skills = ["racial/werewolf_racial", "actives/legend_white_wolf_bite", "actives/legend_white_wolf_howl"],
				Difficulty = 25,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 3, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.3, Gathering = 0.1, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.03, 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.03, 0.03, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [5],
						PrimaryTalents = [3, 4, 6],
						SecondaryTalents = [0],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "WolfNames",
				},
				PerkTree = "WhiteWolfTree",
				Script = "player_beast/nggh_mod_direwolf_player",
				Requirements = ["NggHCharmEnemyDirewolf", "NggHCharmSpec"],
			},
			
		//LegendSkinGhoul = 111,
			{
				StatMod = { Hitpoints = [-80, -60], Bravery = [-30, -15], Stamina = [-10, -10], MeleeSkill = [-20, -15], RangedSkill = [0, 0], MeleeDefense = [-12, -10], RangedDefense = [-7, -7], Initiative = [-25, -25] },
				Skills = ["actives/legend_skin_ghoul_claws", "actives/legend_skin_ghoul_swallow_whole_skill", "traits/fearless_trait"],
				Difficulty = 20,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 8, Stash = 9, Healing = 0.0, Injury = 0.0, Repair = 0.1, Salvage = 0.1, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.1, Gathering = 0.2, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [1, 5],
						PrimaryTalents = [],
						SecondaryTalents = [0, 4, 5],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "NachoNames",
				},
				PerkTree = "NachoTree",
				Script = "player_beast/nggh_mod_ghoul_player",
				Requirements = ["NggHCharmEnemyGhoul", "NggHCharmSpec"],
			},
			
		//LegendStollwurm = 112,
			{
				StatMod = { Hitpoints = [-750, -550], Bravery = [-80, -50], Stamina = [-225, -200], MeleeSkill = [-10, -10], RangedSkill = [0, 0], MeleeDefense = [-10, -10], RangedDefense = [-5, -5], Initiative = [0, 0] },
				Perks = ["LegendMuscularity"],
				Skills = ["actives/legend_stollwurm_move_skill"],
				Difficulty = 75,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 15, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.2, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.1, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [3, 5, 7],
						PrimaryTalents = [4],
						SecondaryTalents = [0, 6],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "LindwurmNames",
				},
				PerkTree = "LindwurmTree",
				Script = "player_beast/nggh_mod_lindwurm_player",
				Requirements = ["NggHCharmEnemyLindwurm", "NggHCharmSpec"],
			},
			
		//LegendRockUnhold = 113,
			{
				StatMod = { Hitpoints = [-500, -500], Bravery = [-100, -100], Stamina = [-200, -200], MeleeSkill = [-10, -10], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-5, -5] },
				Skills = ["racial/unhold_racial", "racial/legend_rock_unhold_racial", "actives/sweep_skill", "actives/sweep_zoc_skill", "actives/fling_back_skill"],
				Difficulty = -60,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [5, 7],
						PrimaryTalents = [2, 4],
						SecondaryTalents = [0, 6],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "UnholdNames",
				},
				PerkTree = "UnholdTree",
				Script = "player_beast/nggh_mod_unhold_player",
				Requirements = ["NggHCharmEnemyUnhold", "NggHCharmSpec"],
			},
			
		//LegendRedbackSpider = 114,
			{
				StatMod = { Hitpoints = [-50, -50], Bravery = [-20, -20], Stamina = [-30, -20], MeleeSkill = [-20, -10], RangedSkill = [0, 0], MeleeDefense = [-10, -10], RangedDefense = [-10, -10], Initiative = [-45, -35] },
				Perks = ["BattleForged"],
				Skills = ["actives/legend_redback_spider_bite_skill", "racial/legend_redback_spider_racial"],
				Difficulty = 25,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.1, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.3, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.015, 0.015, 0.015, 0.05, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015, 0.015],
					},
					Talents = {
						ExcludedTalents = [1, 5],
						PrimaryTalents = [3, 6, 7],
						SecondaryTalents = [0, 2, 4],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "SpiderNames",
				},
				PerkTree = "SpiderTree",
				Script = "player_beast/nggh_mod_spider_player",
				Requirements = ["NggHCharmEnemySpider", "NggHCharmSpec"],
			},
			
		//LegendDemonAlp = 115,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [-50, -50], Stamina = [-50, -25], MeleeSkill = [-5, 5], RangedSkill = [-5, 5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [0, 0] },
				Perks = ["Footwork"],
				Skills = ["actives/legend_demon_shadows_skill", "actives/horrific_scream", "actives/gruesome_feast", "effects/gruesome_feast_effect"],
				Difficulty = 0,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 5, Stash = 3, Healing = 0.1, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.1, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.2, Gathering = 0.1, Training = 0.0, Enchanting = 0.5,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [2],
						PrimaryTalents = [1, 3],
						SecondaryTalents = [0, 4, 5, 6, 7],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "GoblinNames",
				},
				PerkTree = "DemonAlpTree",
				Script = "player_beast/nggh_mod_alp_player",
				Requirements = ["NggHCharmEnemyAlp", "NggHCharmSpec"],
			},
			
		//LegendHexeLeader = 116,
			{},
			
		//LegendGreenwoodSchrat = 117,
			{
				StatMod = { Hitpoints = [-300, -300], Bravery = [0, 0], Stamina = [-200, -150], MeleeSkill = [-15, -15], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-10, 0] },
				Perks = ["SteelBrow"],
				Skills = ["racial/legend_greenwood_schrat_racial", "actives/legend_grow_greenwood_shield_skill"],
				Difficulty = -10,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 10, Stash = 12, Healing = 0.2, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.1, Gathering = 0.3, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.075, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05],
					},
					Talents = {
						ExcludedTalents = [3, 5],
						PrimaryTalents = [1, 2, 4],
						SecondaryTalents = [6, 7],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "SchratNames",
				},
				PerkTree = "SchratTree",
				Script = "player_beast/nggh_mod_schrat_player",
				Requirements = ["NggHCharmEnemySchrat", "NggHCharmSpec"],
			},
			
		//LegendGreenwoodSchratSmall = 118,
			{
				StatMod = { Hitpoints = [-25, -25], Bravery = [-25, -25], Stamina = [-100, -100], MeleeSkill = [-10, -10], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-5, 5] },
				Skills = ["racial/schrat_racial"],
				Difficulty = -50,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 4, Stash = 5, Healing = 0.2, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.0, Fletching = 0.0, Scout = 0.1, Gathering = 0.2, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05],
					},
					Talents = {
						ExcludedTalents = [0, 5],
						PrimaryTalents = [6, 7],
						SecondaryTalents = [4, 5],
						StarsMax = 12,
						StarsMin = 1,
					},
					Names = "SchratNames",
				},
				PerkTree = "SmallSchratTree",
				Script = "player_beast/nggh_mod_schrat_small_player",
				Requirements = [],
				IsExperienced = true,
			},
			
		//LegendWhiteWarwolf = 119,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = [],
				Difficulty = 20,
				Custom = null,
				Requirements = null,
			},
			
		//LegendBanshee = 120,
			{},
			
		//LegendDemonHound = 121,
			{},
			
		//LegendVampireLord = 122,
			{},
			
		//BanditVeteran = 123,
			{
				StatMod = { Hitpoints = [-28, -20], Bravery = [-15, -10], Stamina = [-18, -10], MeleeSkill = [-8, -8], RangedSkill = [-5, -5], MeleeDefense = [-10, -5], RangedDefense = [-5, -5], Initiative = [-15, -15] },
				Perks = ["Brawny", "Relentless"],
				Difficulty = 55,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "raider_background",
				IsExperienced = true,
			},
			
		//BanditWarlord = 124,
			{
				StatMod = { Hitpoints = [-60, -60], Bravery = [-70, -60], Stamina = [-50, -50], MeleeSkill = [-30, -30], RangedSkill = [-25, -15], MeleeDefense = [-18, -15], RangedDefense = [-25, -20], Initiative = [-50, -30] },
				Perks = ["NineLives", "SunderingStrikes"],
				Difficulty = -10,
				Custom = {
					ID = "background.raider",
				},
				Requirements = ["NggHCharmAppearance"],
				PerkTree = "orc_slayer_background",
			},
			
		//LegendPeasantButcher = 125,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = ["LegendSpecialistButcherSkill"],
				Difficulty = 0,
				Custom = {},
				PerkTree = "butcher_background",
				IsExperienced = true,
			},
			
		//LegendPeasantBlacksmith = 126,
			{
				StatMod = { Hitpoints = [-20, -10], Bravery = [-5, 0], Stamina = [-40, -25], MeleeSkill = [-20, -10], RangedSkill = [10, 10], MeleeDefense = [-10, -10], RangedDefense = [-10, -5], Initiative = [-5, 0] },
				Perks = ["LegendSpecialistHammerSkill"],
				Difficulty = 0,
				Custom = {},
				PerkTree = "legend_blacksmith_background",
				IsExperienced = true,
			},
			
		//LegendPeasantMonk = 127,
			{
				StatMod = { Hitpoints = [-5, 0], Bravery = [-35, -10], Stamina = [-5, -5], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [-12, -10], RangedDefense = [-10, 0], Initiative = [0, 0] },
				Perks = ["LegendSpecBandage"],
				Difficulty = 25,
				Custom = {},
				PerkTree = "monk_background",
				IsExperienced = true,
			},
			
		//LegendPeasantFarmhand = 128,
			{
				StatMod = { Hitpoints = [-5, -5], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [-5, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = ["LegendSpecialistPitchforkSkill"],
				Difficulty = 10,
				Custom = {},
				PerkTree = "farmhand_background",
				IsExperienced = true,
			},
			
		//LegendPeasantMinstrel = 129,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = ["LegendCheerOn", "LegendSpecialistLuteSkill"],
				Difficulty = 25,
				Custom = {},
				PerkTree = "minstrel_background",
				IsExperienced = true,
			},
			
		//LegendPeasantPoacher = 130,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = ["LegendSpecialistShortbowSkill"],
				Difficulty = 0,
				Custom = {},
				PerkTree = "poacher_background",
			},
			
		//LegendPeasantWoodsman = 131,
			{
				StatMod = { Hitpoints = [-40, -30], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = ["LegendSpecialistWoodaxeSkill"],
				Difficulty = 25,
				Custom = {},
				PerkTree = "lumberjack_background",
				IsExperienced = true,
			},
			
		//LegendPeasantMiner = 132,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = ["LegendSpecialistPickaxeSkill"],
				Difficulty = 15,
				Custom = {},
				PerkTree = "miner_background",
				IsExperienced = true,
			},

		//LegendPeasantSquire = 133,
			{
				StatMod = { Hitpoints = [-30, -10], Bravery = [-25, -15], Stamina = [0, 0], MeleeSkill = [-20, -15], RangedSkill = [0, 0], MeleeDefense = [-15, -10], RangedDefense = [-10, -5], Initiative = [-20, -20] },
				Perks = ["LegendBackToBasics"],
				Difficulty = 25,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "squire_background",
			},
			
		//LegendPeasantWitchHunter = 134,
			{
				StatMod = { Hitpoints = [-25, -10], Bravery = [-15, -10], Stamina = [-5, -5], MeleeSkill = [-2, 0], RangedSkill = [-20, -12], MeleeDefense = [-10, -10], RangedDefense = [-10, -10], Initiative = [-10, -10] },
				Perks = ["Ballistics"],
				Difficulty = 25,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "witchhunter_background",
			},
			
		//LegendHalberdier = 135,
			{
				StatMod = { Hitpoints = [-23, -20], Bravery = [-25, -18], Stamina = [-10, -10], MeleeSkill = [-20, -15], RangedSkill = [0, 0], MeleeDefense = [-10, -10], RangedDefense = [-5, -5], Initiative = [-10, 0] },
				Perks = ["Rotation", "Backstabber"],
				Difficulty = 42,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "legend_noble_2h",
			},
			
		//LegendSlinger = 136,
			{
				StatMod = { Hitpoints = [-12, -12], Bravery = [-5, 0], Stamina = [-20, -15], MeleeSkill = [0, 0], RangedSkill = [-3, 1], MeleeDefense = [-2, -1], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = ["Rotation", "LegendMasterySlings"],
				Difficulty = 27,
				Custom = {
					ID = "background.legend_noble_ranged",
				},
				PerkTree = "nomad_background",
			},
			
		//LegendFencer = 137,
			{
				StatMod = { Hitpoints = [-35, -25], Bravery = [-25, -15], Stamina = [-15, -15], MeleeSkill = [-15, -10], RangedSkill = [0, 0], MeleeDefense = [-20, -15], RangedDefense = [-8, -5], Initiative = [-25, -20] },
				Perks = ["Rotation", "Feint", "Duelist"],
				Difficulty = 53,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "adventurous_noble_background",
			},
			
		//BanditOutrider = 138,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = [],
				Difficulty = 0,
				Custom = {},
				PerkTree = "raider_background",
				IsExperienced = true,
			},
			
		//LegendBear = 139,
			{
				StatMod = { Hitpoints = [-125, -125], Bravery = [0, 0], Stamina = [-150, -150], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = ["Stalwart", "LegendComposure", "LegendGrapple"],
				Skills = ["actives/legend_bear_bite", "actives/legend_bear_claws", "actives/unstoppable_charge_skill"],
				Difficulty = 50,
				Custom =  {
					BgModifiers = {
						Ammo = 0, ArmorParts = 0, Meds = 0, Stash = 20, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.3, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.2, Fletching = 0.0, Scout = 0.0, Gathering = 0.0, Training = 0.0, Enchanting = 0.0,
						Terrain = [0.0, 0.0, 0.0, 0.0, 0.025, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
					},
					Talents = {
						ExcludedTalents = [5, 7],
						PrimaryTalents = [2, 4],
						SecondaryTalents = [0, 6],
						StarsMax = 9,
						StarsMin = 1,
					},
					Names = "BearNames",
				},
				PerkTree = "BearTree",
				Script = "player_beast/nggh_mod_unhold_player",
				Requirements = ["NggHCharmEnemyDirewolf"],
			},
			
		//LegendCatapult = 140,
			{},
			
		//LegendHorse = 141,
			{},
			
		//SkeletonGladiator = 142,
			{},
			
		//BanditRabblePoacher = 143,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = [],
				Difficulty = -15,
				Custom = {
					ID = "background.beggar",
				},
				PerkTree = "poacher_background",
			},
			
		//BanditVermes = 144,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = [],
				Difficulty = 0,
				Custom = {
					ID = "background.beggar",
				},
				PerkTree = "poacher_background",
			},
			
		//SatoManhunter = 145,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = [],
				Difficulty = 0,
				Custom = {},
				PerkTree = "manhunter_background",
			},
			
		//SatoManhunterVeteran = 146,
			{
				StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
				Perks = [],
				Difficulty = 0,
				Custom = {},
				PerkTree = "manhunter_background",
				IsExperienced = true,
			},
			
		//LegendMummyLight = 147,
			{},
			
		//LegendMummyMedium = 148,
			{},
			
		//LegendMummyHeavy = 149,
			{},
			
		//LegendMummyQueen = 150,
			{},
			
		//KoboldFighter = 151,
			{},
			
		//KoboldWolfrider = 152,
			{},

		//LegendMummyPriest = 153,
			{},

		//FreeCompanySpearman = 154,
			{
				StatMod = { Hitpoints = [-20, -8], Bravery = [-5, -5], Stamina = [-15, -15], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [-5, 0], RangedDefense = [0, 0], Initiative = [15, 35] },
				Perks = ["LegendSpecialistMilitiaSkill", "LegendSpecialistMilitiaDamage"],
				Difficulty = 5,
				Custom = {},
				PerkTree = "militia_background",
				IsExperienced = true,
			}

		//FreeCompanySlayer = 155,
			{
				StatMod = { Hitpoints = [-15, -10], Bravery = [0, 0], Stamina = [-10, -10], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [15, 25] },
				Perks = ["LegendBigGameHunter"],
				Difficulty = 5,
				Custom = {},
				PerkTree = "beast_hunter_background",
				IsExperienced = true,
			}

		//FreeCompanyFootman = 156,
			{
				StatMod = { Hitpoints = [-12, -10], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [-5, 0], RangedSkill = [-5, -5], MeleeDefense = [0, 0], RangedDefense = [-5, -5], Initiative = [5, 25] },
				Perks = ["BattleForged"],
				Difficulty = 5,
				Custom = {},
				PerkTree = "legend_shieldmaiden_background",
				IsExperienced = true,
			}

		//FreeCompanyArcher = 157,
			{
				StatMod = { Hitpoints = [-10, -5], Bravery = [0, 0], Stamina = [-10, -0], MeleeSkill = [0, 0], RangedSkill = [-5, -0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-10, -5] },
				Perks = ["Bullseye", "Anticipation"],
				Difficulty = 5,
				Custom = {},
				PerkTree = "hunter_background",
				IsExperienced = true,
			}

		//FreeCompanyCrossbow = 158,
			{
				StatMod = { Hitpoints = [-10, -5], Bravery = [0, 0], Stamina = [-10, -0], MeleeSkill = [0, 0], RangedSkill = [-5, -0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-10, -5] },
				Perks = ["Ballistics", "Anticipation"],
				Difficulty = 5,
				Custom = {},
				PerkTree = "legend_nightwatch_background",
				IsExperienced = true,
			}

		//FreeCompanyLongbow = 159,
			{
				StatMod = { Hitpoints = [-10, -5], Bravery = [0, 0], Stamina = [-10, -0], MeleeSkill = [0, 0], RangedSkill = [-5, -0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-10, -5] },
				Perks = ["HeadHunter", "Anticipation"],
				Difficulty = 25,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "hunter_background"
			}

		//FreeCompanyBillman = 160,
			{
				StatMod = { Hitpoints = [-20, -15], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [-5, 0], RangedSkill = [-5, -5], MeleeDefense = [0, 0], RangedDefense = [-5, -5], Initiative = [5, 25] },
				Perks = ["Footwork", "Backstabber"],
				Difficulty = 25,
				Custom = {},
				PerkTree = "beast_hunter_background",
				Requirements = ["NggHCharmWords"],
				IsExperienced = true,
			}

		//FreeCompanyPikeman = 161,
			{
				StatMod = { Hitpoints = [-20, -15], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [-5, 0], RangedSkill = [-5, -5], MeleeDefense = [0, 0], RangedDefense = [-5, -5], Initiative = [5, 25] },
				Perks = ["Backstabber"],
				Difficulty = 13,
				Custom = {},
				PerkTree = "beast_hunter_background",
				IsExperienced = true,
			}

		//FreeCompanyInfantry = 162,
			{
				StatMod = { Hitpoints = [-25, -25], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [-10, -10], RangedSkill = [-5, -5], MeleeDefense = [0, 0], RangedDefense = [-5, -5], Initiative = [5, 25] },
				Perks = ["BattleForged", "SteelBrow"],
				Difficulty = 37,
				Custom = {},
				PerkTree = "legend_shieldmaiden_background",
				IsExperienced = true,
			}

		//FreeCompanyLeader = 163,
			{
				StatMod = { Hitpoints = [-15, -15], Bravery = [-40, -40], Stamina = [-15, -5], MeleeSkill = [-10, -5], RangedSkill = [-5, -5], MeleeDefense = [-5, 0], RangedDefense = [0, 0], Initiative = [5, 15] },
				Perks = ["RallyTheTroops", "SunderingStrikes", "Footwork"],
				Difficulty = 35,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "orc_slayer_background"
			}

		//FreeCompanyLeaderLow = 164,
			{
				StatMod = { Hitpoints = [-15, -15], Bravery = [-40, -40], Stamina = [-15, -5], MeleeSkill = [-10, -5], RangedSkill = [-5, -5], MeleeDefense = [-5, 0], RangedDefense = [0, 0], Initiative = [5, 15] },
				Perks = ["RallyTheTroops", "SunderingStrikes"],
				Difficulty = 25,
				Custom = {},
				Requirements = ["NggHCharmWords"],
				PerkTree = "orc_slayer_background"
			}
	],

	// Database for new entries registered by ::nggh_registerCharmedEntries(_array)
	CustomEntries = [],

	// Database of all background icon directories, used to confirm if a background icon exists or not
	BackgroundIcons = [],

	function getIndex( _index )
	{
		if (_index < 0 || _index > this.Data.len() - 1)
		{
			return null;
		}

		return _index;
	}

	function getData( _type )
	{
		local find = this.getIndex(_type);

		if (find != null)
		{
			return this.Data[find];
		}

		find = ::nggh_findThisInArray(_type, this.CustomEntries, "Type");

		if (find != null)
		{
			return this.CustomEntries[find];
		}

		return null;
	}

	function getBackgroundIcon( _type )
	{
		local find = ::nggh_findThisInArray(_type, this.CustomEntries, "Type");

		if (find != null && this.CustomEntries[find].rawin("Icon"))
		{
			return this.CustomEntries[find].Icon;
		}

		find = this.getIndex(_type);

		if (find != null && ::isThisBackgroundIconExist("background_charmed_" + _type + ".png"))
		{
			return "background_charmed_" + _type + ".png";
		}

		return "background_charmed_unknown.png";
	}

	function addBasicData( _data , _entity = null )
	{
		if (typeof _data != "table" || !("Type" in _data))
		{
			return _data;
		}

		local index = _data.Type;
		local isHuman = _entity != null ? _entity.getFlags().has("human") : this.isHuman(index);

		if (!("Script" in _data))
		{
			_data.Script <- this.getScript(index);
		}

		if (!("Requirements" in _data))
		{
			_data.Requirements <- this.getRequirements(index, isHuman);
		}

		if (!("IsHuman" in _data))
		{
			_data.IsHuman <- isHuman;
		}
	}

	function addAdditionalData( _data , _entity = null )
	{
		if (typeof _data != "table" || !("Type" in _data))
		{
			return _data;
		}

		if (("Entity" in _data) && _entity == null)
		{
			_entity = _data.Entity;
		}
		else if (_entity != null)
		{
			_data.Entity = _entity;
		}

		local index = _data.Type;

		if (!("Perks" in _data))
		{
			_data.Perks <- this.getSpecialPerks(index);
		}

		if (!("PerkTree" in _data))
		{
			_data.PerkTree <- this.getPerkTree(index);
		}

		if (!("Background" in _data))
		{
			_data.Background <- this.getBackground(index);
		}

		if (!("Custom" in _data))
		{
			_data.Custom <- this.getCustom(index);
		}

		if (_entity == null)
		{
			_data.IsMiniboss <- false;
			return _data;
		}

		if (!("Appearance" in _data))
		{
			_data.Appearance <- this.getAppeareace(_entity);
		}

		if (!("Items" in _data))
		{
			_data.Items <- _entity.getItems();
		}

		if (!("Stats" in _data))
		{
			_data.Stats <- _entity.getBaseProperties();
		}

		_data.IsMiniboss <- _entity.getSkills().hasSkill("racial.champion");
		return _data;
	}

	function isHuman( _type )
	{
		return this.getScript() != null;
	}

	function isKeyExist( _key, _data )
	{
		if (_data == null || !(_key in _data) || _data[_key] == null)
		{
			return false;
		}

		return true;
	}

	function getDataByKey( _type, _key, _defaultReturnValue = null )
	{
		local database = this.getData(_type);

		if (!this.isKeyExist(_key, database))
		{
			return _defaultReturnValue;
		}

		switch(typeof database[_key])
		{
		case "table":
		case "array":
			return ::nggh_deepCopy(database[_key]);

		default:
			return database[_key];
		}

		return null;
	}

	function getScript( _type )
	{
		return this.getDataByKey(_type, "Script", "player");
	}

	function getRequirements( _type , _isFindingHuman = false )
	{
		return this.getDataByKey(_type, "Requirements", _isFindingHuman ? [] : null);
	}
	
	function getStatMod( _type )
	{
		return this.getDataByKey(_type, "StatMod", { Hitpoints = [-5, -5], Bravery = [-5, -5], Stamina = [-5, -5], MeleeSkill = [-5, -5], RangedSkill = [-5, -5], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-5, -5] }, true);
	}

	function getBackground( _type )
	{
		return !this.isHuman(_type) ? this.getDataByKey(_type, "Background") : null;
	}
	
	function getPerks( _type )
	{
		return this.getDataByKey(_type, "Perks", []);
	}

	function getSkills( _type )
	{
		return this.getDataByKey(_type, "Skills", []);
	}

	function getCustom( _type )
	{
		return this.getDataByKey(_type, "Custom", {});
	}
	
	function getDifficulty( _type )
	{
		return this.getDataByKey(_type, "Difficulty", 0);
	}
	
	function getPerkTree( _type )
	{
		local perkTreeName = this.getDataByKey(_type, "PerkTree");
		return perkTreeName != null && (perkTreeName in ::Const.PerksCharmedUnit) ? ::nggh_deepCopy(::Const.PerksCharmedUnit[perkTreeName]) : null;
	}

	function getNames( _type )
	{
		local key = this.getDataByKey(_type, "Names");
		return key != null && (key in ::Const.Strings) ? ::nggh_deepCopy(::Const.Strings[key]) : null;
	}
	
	function getAppeareace( _entity )
	{
		local ret = [];
		::logInfo("Processing sprites need to be copied...");
		foreach (id in ::Const.CharmedUtilities.SpritesToClone)
		{
		    if (_entity.hasSprite(id))
		    {
		    	::logInfo("Sprite " + ret.len() + ": " + id);
		    	ret.push(id);
		    }
		}

		return ret;
	}
};

local defaultTemplate =
{
	StatMod = { Hitpoints = [0, 0], Bravery = [-10, -5], Stamina = [0, 0], MeleeSkill = [-5, -5], RangedSkill = [0, 0], MeleeDefense = [-5, -5], RangedDefense = [-5, -5], Initiative = [-25, -25] },
	Skills = ["actives/ghoul_claws", "actives/swallow_whole_skill"],
	Perks = ["HeadHunter", "Anticipation"],
	Requirements = ["NggHCharmEnemyGhoul"],
	Script = "player_beast/nggh_mod_ghoul_player",
	Background = "barbarian_background",
	PerkTree = "NachoTree", 
	Difficulty = 15,

	Custom =  {
		ID = "background.legend_necromancer",
		AdditionalPerkGroup = [1 ,["BasicNecroMagicTree", "ZombieMagicTree", "SkeletonMagicTree"]],
		BgModifiers = {
			Ammo = 0, ArmorParts = 0, Meds = 8, Stash = 9, Healing = 0.0, Injury = 0.0, Repair = 0.1, Salvage = 0.1, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.1, Fletching = 0.0, Scout = 0.1, Gathering = 0.2, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		Talents = {
			ExcludedTalents = [1, 5],
			PrimaryTalents = [],
			SecondaryTalents = [0, 4, 5],
			StarsMax = 9,
			StarsMin = 1,
		},
		Names = "NachoNames",
	},
	
	// all functions below will use '.call(background)' 

	function onAppearanceChanged( _playerEntity, _enemyEntity )
	{
		
	}

	function onBeforeBuildPerkTree()
	{
		
	}
};

local prefix = "gfx/ui/backgrounds/";
foreach (directory in ::IO.enumerateFiles(prefix))
{
	::Const.CharmedUnits.BackgroundIcons.push(directory.slice(prefix.len()) + ".png");
}

::isThisBackgroundIconExist <- function( _directory )
{
	local prefix = "backgrounds/";
	local find = _directory.find(prefix);

	if (find != null)
	{
		_directory = _directory.slice(find, prefix.len());
	}

	return ::Const.CharmedUnits.BackgroundIcons.find(_directory) != null;
}

