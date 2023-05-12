
if (!("HexeOrigin" in ::Const))
{
	::Const.HexeOrigin <- {};
}

::Const.HexeOrigin.EasterEggSeed <- [
	"LUFTISHERE"
];

::Const.HexeOrigin.NameKeywords <- [
	[
		//0
		"EGGS EGGS EGGS",
		"EGG",
		"SCRAMBLED EGG",
		"EGGSCELLENT",
		"EGGMANIAC",
		"EGG EDGE ECT",
	],
	[
		//1
		"SPIDER",
		"WEBKNECHT",
		"WEB",
	],
	[
		//2
		"REDBACK",
		"RED"
	],
	[
		//3
		"WOLF",
		"PUPPY",
		"ALPHA",
	],
	[
		//4
		"MONONOKE",
		"WHITE",
	],
	[
		//5
		"HYENA",
		"DOGGO",
	],
	[
		//6
		"SERPENT",
		"SNAKE",
		"VIPER",
	],
	[
		//7
		"UNHOLD",
		"GIANT",
	],
	[
		//8
		"GHOUL",
		"NACHO"
	],
	[
		//9
		"ALP",
		"DREAM",
		"NIGHTMARE"
	],
	[
		//10
		"GOBLIN",
		"TRICKTER",
	],
	[
		//11
		"ORC",
		"BRUTE",
		"WARRIOR"
	],
	[
		//12
	],
	[
		//13
		"IJIROK",
		"TRICKTER GOD",
		"GOD",
		"DEITY"
	],
	[
		//14
		"DRAGON",
		"EARTHEN DRAGON",
		"LINDWURM",
	],
	[
		//15
		"ENT",
		"TREANT",
		"SCHRAT",
		"FOREST",
		"GUARDIAN"
	],
	[
		//16
		"BEAR",
	],
	[
		//17
		"CIRCUS",
	],
	[
		//18
		"HORDE",
		"GREENDUMBOS",
		"GREENSKIN"
	],
	[
		//19
		"SIMPS",
		"TWITCH",
		"ASMR",
		"STREAMER"
	],
	[
		//20
		"BERSERK"
	],
	[
		//21
		"WITCHES",
		"WITCH COVEN",
		"HEXEN COVEN",
	],
	[
		//22
		"SHADOW",
		"DEMON"
	]
];
::Const.HexeOrigin.SeedKeywords <- [
	"EGG",   //0
	"SPI",   //1
	"RED",   //2
	"WOL",   //3
	"WHI",   //4
	"HYE",   //5
	"SER",   //6
	"UNH",   //7
	"GHO",   //8
	"ALP",   //9
	"GOB",   //10
	"ORC",   //11
	"HUM",   //12
	"IJIROK",//13
	"LIN",   //14
	"SCH",   //15
	"BEA",   //16
	"CIRCUS",//17
	"GREEN", //18
	"ASMR",  //19
	"BER",   //20
	"HEX",   //21
	"DEM",   //22
];
::Const.HexeOrigin.StartingRollNames <- [
	"EGGS",
	"SPIDER",
	"REDBACK SPIDER",
	"WOLF",
	"WHITE DIREWOLF"
	"HYENA",
	"SERPENT",
	"UNHOLD",
	"GHOUL",
	"ALP",
	"GOBLIN",
	"ORC",
	"HUMAN",
	"IJIROK",
	"LINDWURM",
	"SCHRAT",
	"BEAR",
	"CIRCUS",
	"GREENSKINS",
	"AMOURANTH TWITCH",
	"BERSERK",
	"HEXEN COVEN",
	"DEMON ALP"
];
::Const.HexeOrigin.SeedsStartWithWhip <- [
	12,
	17,
	19,
];

::Const.HexenCharmablePet <-[
	::Const.EntityType.Wolf,	
	::Const.EntityType.Wardog,
	::Const.EntityType.ArmoredWardog,
	::Const.EntityType.Warhound,
	::Const.EntityType.LegendWhiteWarwolf,
];
::Const.CharmedListRegularContract <- [
	"nggh_mod_spider_player",
	"nggh_mod_spider_player",
	"nggh_mod_spider_eggs_player",
	"nggh_mod_direwolf_player",
	"nggh_mod_direwolf_player",
	"nggh_mod_direwolf_player",
	"nggh_mod_hyena_player",
	"nggh_mod_hyena_player",
	"nggh_mod_hyena_player",
	"nggh_mod_serpent_player",
	"nggh_mod_serpent_player",
	"nggh_mod_unhold_player",
	"nggh_mod_ghoul_player",
	"nggh_mod_ghoul_player",
];
::Const.CharmedListSpecialContract <- [
	"nggh_mod_unhold_player",
	"nggh_mod_unhold_player",
	"nggh_mod_unhold_player",
	"nggh_mod_schrat_player",
	"nggh_mod_spider_eggs_player",
	"nggh_mod_lindwurm_player",
];
::Const.HexeOrigin.PossibleStartingPotions <- [
	[10, "accessory/poison_item"],
	[10, "accessory/cat_potion_item"],
	[10, "accessory/iron_will_potion_item"],
	[10, "accessory/recovery_potion_item"],
	[10, "accessory/lionheart_potion_item"],
	[10, "accessory/night_vision_elixir_item"],
	[ 5, "accessory/legend_heartwood_sap_flask_item"],
	[ 5, "accessory/legend_hexen_ichor_potion_item"],
	[ 5, "accessory/legend_skin_ghoul_blood_flask_item"],
	[ 5, "accessory/legend_stollwurm_blood_flask_item"],
	[ 1, "special/bodily_reward_item"],
	[ 1, "special/spiritual_reward_item"],
];
::Const.HexeOrigin.PossibleStartingPlayers <- [
	{
		Cost = 2,
		Name = "SPIDER",
		Script = "player_beast/nggh_mod_spider_player"
	},
	{
		Cost = 5,
		Name = "EGGS",
		Script = "player_beast/nggh_mod_spider_eggs_player"
	},
	{
		Cost = 3,
		Name = "WOLF",
		Script = "player_beast/nggh_mod_direwolf_player"
	},
	{
		Cost = 3,
		Name = "HYENA",
		Script = "player_beast/nggh_mod_hyena_player"
	},
	{
		Cost = 2,
		Name = "SERPENT",
		Script = "player_beast/nggh_mod_serpent_player"
	},
	{
		Cost = 5,
		Name = "UNHOLD",
		Script = "player_beast/nggh_mod_unhold_player"
	},
	{
		Cost = 2,
		Name = "GHOUL",
		Script = "player_beast/nggh_mod_ghoul_player"
	},
	{
		Cost = 3,
		Name = "ALP",
		Script = "player_beast/nggh_mod_alp_player"
	},
	{
		Cost = 2,
		Name = "GOBLIN",
		Script = "nggh_mod_player_goblin"
	},
	{
		Cost = 3,
		Name = "ORC",
		Script = "nggh_mod_player_orc"
	},
	{
		Cost = 2,
		Name = "HUMAN",
		Script = "player"
	},
];

::Const.HexeOrigin.Magic <- 
{
	function CountDebuff( _entity , _all = true )
	{
		local ret = 0;
		local skills = _entity.getSkills();
		local NormalDebuffs = [
			"acid",
			"debilitated",
			"disarmed",
			"goblin_poison",
			"hex_slave",
			"insect_swarm",
			"lindwurm_acid",
			"spider_poison",
		];
		
		local InitiativeDebuffs = [
			"chilled",
			"dazed",
			"distracted",
			"withered",
			"staggered",
			"shellshocked",
		];
		
		local StackableDebuffs = [
			"bleeding",
			"overwhelmed",
		];
		
		local ImmoblieDebuffs = [
			"horrified",
			"nightmare",
			"sleeping",
			"stunned",
			"web",
			"net",
			"rooted",
			"serpent_ensnare",
		];
		
		foreach ( a in NormalDebuffs )
		{
			if (skills.hasSkill("effects." + a))
			{
				++ret;
			}
		}
		
		foreach ( b in InitiativeDebuffs )
		{
			if (skills.hasSkill("effects." + b))
			{
				++ret;
			}
		}
		
		foreach ( c in ImmoblieDebuffs )
		{
			if (skills.hasSkill("effects." + c))
			{
				++ret;
			}
		}
		
		foreach ( d in StackableDebuffs )
		{
			ret += skills.getAllSkillsByID("effects." + d).len();
		}
		
		ret += skills.getAllSkillsOfType(::Const.SkillType.Injury).len();
		
		return ret;
	}
	
	function SpawnCharmParticleEffect( _tile )
	{
		local effect = {
			Delay = 0,
			Quantity = 50,
			LifeTimeQuantity = 50,
			SpawnRate = 1000,
			Brushes = [
				"effect_heart_01"
			],
			Stages = [
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = ::createColor("fff3e50f"),
					ColorMax = ::createColor("ffffff5f"),
					ScaleMin = 0.5,
					ScaleMax = 0.5,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-0.5, 0.0),
					DirectionMax = ::createVec(0.5, 1.0),
					SpawnOffsetMin = ::createVec(-30, -70),
					SpawnOffsetMax = ::createVec(30, 30),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = ::createColor("fff3e500"),
					ColorMax = ::createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-0.5, 0.0),
					DirectionMax = ::createVec(0.5, 1.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				}
			]
		};
		
		::Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
	}
};

::Const.HexeOrigin.PermanentInjury <- [
	{
		ID = "injury.brain_damage",
		Script = "injury_permanent/brain_damage_injury"
	},
	{
		ID = "injury.traumatized",
		Script = "injury_permanent/traumatized_injury"
	},
	{
		ID = "injury.broken_knee",
		Script = "injury_permanent/broken_knee_injury"
	},
	{
		ID = "injury.weakened_heart",
		Script = "injury_permanent/weakened_heart_injury"
	},
	{
		ID = "injury.collapsed_lung_part",
		Script = "injury_permanent/collapsed_lung_part_injury"
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
	}
];

::Const.HexeOrigin.Body <- [
	"bust_hexen_fake_body_00",
	"bust_hexen_fake_body_01",
	"bust_hexen_true_body"
];

::Const.HexeOrigin.TrueHead <- [
	"bust_hexen_true_head_01",
	"bust_hexen_true_head_02",
	"bust_hexen_true_head_03"
];

::Const.HexeOrigin.TrueHair <- [
	"bust_hexen_true_hair_01",
	"bust_hexen_true_hair_02",
	"bust_hexen_true_hair_03",
	"bust_hexen_true_hair_04"
];

::Const.HexeOrigin.FakeHead <- [
	"bust_hexen_fake_head_01",
	"bust_hexen_fake_head_02"
];

::Const.HexeOrigin.FakeHair <- [
	"bust_hexen_fake_hair_01",
	"bust_hexen_fake_hair_02",
	"bust_hexen_fake_hair_03",
	"bust_hexen_fake_hair_04",
	"bust_hexen_fake_hair_05"
];

::Const.HexeOrigin.FakeArmor <- [
	"bust_hexen_fake_dress_01",
	"bust_hexen_fake_dress_02",
	"bust_hexen_fake_dress_03"
];

::Const.HexeOrigin.AffectedSprites <- [
	"armor",
	"armor_layer_chain",
	"armor_layer_plate",
	"armor_layer_tabbard",
	"armor_layer_cloak",
	"armor_upgrade_back",
	"armor_upgrade_front",
	"helmet",
	"helmet_damage",
	"helmet_helm",
	"helmet_top",
	"helmet_vanity",
	"helmet_vanity_2",
	"helmet_vanity_lower",
	"helmet_vanity_lower_2",
	"body",
	"tattoo_body",
	"scar_body",
	"surcoat",
	"bandage_2",
	"bandage_3",
	"head",
	"tattoo_head",
	"scar_head",
	"beard",
	"hair",
	"accessory",
	"accessory_special",
	"beard_top",
	"bandage_1",
];

	