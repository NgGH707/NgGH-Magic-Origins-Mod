//All hexen magic abilities description and crucial function for legend version

local gt = this.getroottable();

if (!("HexenOrigin" in gt.Const))
{
	gt.Const.HexenOrigin <- {};
}

if (!("AffectedSprites" in gt.Const))
{
	gt.Const.HexenOrigin.AffectedSprites <- [];
}

if (!("PermanentInjury" in gt.Const))
{
	gt.Const.HexenOrigin.PermanentInjury <- [];
}

if (!("CharmedSlave" in gt.Const.HexenOrigin))
{
	gt.Const.HexenOrigin.CharmedSlave <- {};
}

if (!("Perks" in gt.Const))
{
	gt.Const.Perks <- {};
}

gt.Const.WitchHaters <- [
	"background.crusader",
	"background.flagellant",
	"background.legend_crusader",
	"background.legend_commander_crusader",
	"background.legend_diviner",
	"background.legend_nun",
	"background.monk",
	"background.monk_turned_flagellant",
	"background.pacified_flagellant",
	"background.witchhunter",
];

gt.Const.EggSpriteOffsets <- [
	[-27,  10],
	[ 15,   0],
	[-10, -20],
];

gt.Const.HexenEasterEggSeed <- [
	"LUFTISHERE",
];

gt.Const.HexenNameKeyWord <- [
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
		"BERSERKER",
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
];

gt.Const.HexenSeedKeyWord <- [
	"EGG",//0
	"SPI",//1
	"RED",//2
	"WOL",//3
	"WHI",//4
	"HYE",//5
	"SER",//6
	"UNH",//7
	"GHO",//8
	"ALP",//9
	"GOB",//10
	"ORC",//11
	"HUM",//12
	"IJIROK",//13
	"LIN",//14
	"SCH",//15
	"BEA",//16
	"CIRCUS",//17
	"GREEN"//18
	"ASMR",//19
];

gt.Const.HexenStartingRollName <- [
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
	"",
];

gt.Const.CharmedListRegularContract <- [
	"player_beast/spider_player",
	"player_beast/spider_player",
	"player_beast/spider_eggs_player",
	"player_beast/direwolf_player",
	"player_beast/direwolf_player",
	"player_beast/direwolf_player",
	"player_beast/hyena_player",
	"player_beast/hyena_player",
	"player_beast/hyena_player",
	"player_beast/serpent_player",
	"player_beast/serpent_player",
	"player_beast/unhold_player",
	"player_beast/ghoul_player",
	"player_beast/ghoul_player",
];

gt.Const.CharmedListSpecialContract <- [
	"player_beast/unhold_player",
	"player_beast/unhold_player",
	"player_beast/unhold_player",
	"player_beast/schrat_player",
	"player_beast/spider_eggs_player",
	"player_beast/lindwurm_player",
];

gt.Const.HexenCharmedUnitList <- [
	[
		2,
		"player_beast/spider_player",
	],
	[
		4,
		"player_beast/spider_eggs_player",
	],
	[
		3,
		"player_beast/direwolf_player",
	],
	[
		3,
		"player_beast/hyena_player",
	],
	[
		2,
		"player_beast/serpent_player",
	],
	[
		5,
		"player_beast/unhold_player",
	],
	[
		2,
		"player_beast/ghoul_player",
	],
	[
		3,
		"player_beast/alp_player",
	],
	[
		2,
		"player_goblin",
	],
	[
		3,
		"player_orc/player_orc_young",
	],
	[
		2,
		"player",
	],
];

gt.Const.HexenCharmablePet <-[
	gt.Const.EntityType.Wolf,	
	gt.Const.EntityType.Wardog,
	gt.Const.EntityType.ArmoredWardog,
	gt.Const.EntityType.Warhound,
	gt.Const.EntityType.LegendWhiteWarwolf,
];

gt.Const.Tactical.MagicPurpleParticles <- [
	{
		Delay = 0,
		Quantity = 50,
		LifeTimeQuantity = 0,
		SpawnRate = 9,
		Brushes = [
			"effect_circle_0",
			"effect_purple_magic_circle"
		],
		Stages = [
			{
				LifeTimeMin = 0.75,
				LifeTimeMax = 1.25,
				ColorMin = this.createColor("9d821700"),
				ColorMax = this.createColor("f5e6aa00"),
				ScaleMin = 0.25,
				ScaleMax = 0.5,
				RotationMin = 0,
				RotationMax = 359,
				TorqueMin = -10,
				TorqueMax = 10,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.5, 0.5),
				DirectionMax = this.createVec(0.5, 0.5),
				SpawnOffsetMin = this.createVec(-50, -40),
				SpawnOffsetMax = this.createVec(50, 20),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = this.createColor("9d82172d"),
				ColorMax = this.createColor("f5e6aa2d"),
				ScaleMin = 0.5,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("9d821700"),
				ColorMax = this.createColor("f5e6aa00"),
				ScaleMin = 0.5,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			}
		]
	},
	{
		Delay = 0,
		Quantity = 10,
		LifeTimeQuantity = 0,
		SpawnRate = 2,
		Brushes = [
			"effect_purple_dust",
			"effect_fire_01",
			"effect_fire_02",
			"effect_fire_03"
		],
		Stages = [
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("9d821700"),
				ColorMax = this.createColor("f5e6aa00"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.5, 0.5),
				DirectionMax = this.createVec(0.5, 0.5),
				SpawnOffsetMin = this.createVec(-50, -40),
				SpawnOffsetMax = this.createVec(50, 10),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = this.createColor("9d82174f"),
				ColorMax = this.createColor("f5e6aa4f"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("9d821700"),
				ColorMax = this.createColor("f5e6aa00"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			}
		]
	}
];

gt.Const.Tactical.MagicGreenParticles <- [
	{
		Delay = 0,
		Quantity = 50,
		LifeTimeQuantity = 0,
		SpawnRate = 9,
		Brushes = [
			"effect_circle_0",
			"effect_green_magic_circle"
		],
		Stages = [
			{
				LifeTimeMin = 0.75,
				LifeTimeMax = 1.25,
				ColorMin = this.createColor("9d821700"),
				ColorMax = this.createColor("f5e6aa00"),
				ScaleMin = 0.25,
				ScaleMax = 0.5,
				RotationMin = 0,
				RotationMax = 359,
				TorqueMin = -10,
				TorqueMax = 10,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.5, 0.5),
				DirectionMax = this.createVec(0.5, 0.5),
				SpawnOffsetMin = this.createVec(-50, -40),
				SpawnOffsetMax = this.createVec(50, 20),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = this.createColor("9d82172d"),
				ColorMax = this.createColor("f5e6aa2d"),
				ScaleMin = 0.5,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("9d821700"),
				ColorMax = this.createColor("f5e6aa00"),
				ScaleMin = 0.5,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			}
		]
	},
	{
		Delay = 0,
		Quantity = 10,
		LifeTimeQuantity = 0,
		SpawnRate = 2,
		Brushes = [
			"effect_green_dust",
			"effect_fire_01",
			"effect_fire_02",
			"effect_fire_03"
		],
		Stages = [
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("9d821700"),
				ColorMax = this.createColor("f5e6aa00"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.5, 0.5),
				DirectionMax = this.createVec(0.5, 0.5),
				SpawnOffsetMin = this.createVec(-50, -40),
				SpawnOffsetMax = this.createVec(50, 10),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = this.createColor("9d82174f"),
				ColorMax = this.createColor("f5e6aa4f"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("9d821700"),
				ColorMax = this.createColor("f5e6aa00"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			}
		]
	}
];

gt.Const.AttackEffectPetting <- [
	{
		Brush = "effect_pet_left",
		Movement0 = this.createVec(-60, -130),
		Movement1 = this.createVec(-60, -130),
		Offset = this.createVec(-30, 70)
	},
	{
		Brush = "effect_pet_right",
		Movement0 = this.createVec(60, -130),
		Movement1 = this.createVec(60, -130),
		Offset = this.createVec(-45, 70)
	},
	{
		Brush = "effect_pet_right",
		Movement0 = this.createVec(60, -130),
		Movement1 = this.createVec(60, -130),
		Offset = this.createVec(-45, 70)
	},
	{
		Brush = "effect_pet_left",
		Movement0 = this.createVec(-60, -130),
		Movement1 = this.createVec(-60, -130),
		Offset = this.createVec(-30, 70)
	},
	{
		Brush = "effect_pet_left",
		Movement0 = this.createVec(-60, -130),
		Movement1 = this.createVec(-60, -130),
		Offset = this.createVec(-25, 70)
	},
	{
		Brush = "effect_pet_left",
		Movement0 = this.createVec(-60, -130),
		Movement1 = this.createVec(-60, -130),
		Offset = this.createVec(-25, 70)
	}
];

gt.Const.HexenOrigin.CharmedSlave <- {

	ExcludedSkills = [
		"effects.charmed_captive",
		"special.bag_fatigue",
		"special.double_grip",
		"special.mood_check",
		"special.morale.check",
		"special.no_ammo_warning",
		"special.stats_collector",
		"special.weapon_breaking_warning",
		"terrain.hidden",
		"terrain.swamp",
		"actives.load_mortar",
		"actives.fire_mortar",
		"actives.shieldwall",
		"actives.knock_back",
		"actives.drums_of_war",
		"actives.legend_piercing_shot",
		"actives.legend_cascade",
		"actives.legend_daze",
		"actives.legend_entice",
		"actives.legend_drums_of_life",
		"actives.legend_drums_of_war",
		"actives.load_mortar_player",
	],

	function processingCharmedBackground( _info, _background )
	{
		if (_info == null || typeof _info != "table")
		{
			return;
		}

		local names;
		local lastNames;

		if (("PerkTree" in _info) && _info.PerkTree != null)
		{
			switch (typeof _info.PerkTree)
			{
			case "array":
				_background.m.CustomPerkTree = _info.PerkTree;
				break;

			case "table":
				_background.m.PerkTreeDynamic = _info.PerkTree;
				break;

			case "string":
			    local bg = this.new("scripts/skills/backgrounds/" + _info.PerkTree);
			    _background.m.ID = bg.m.ID;
				_background.m.ExcludedTalents = bg.m.ExcludedTalents;
				_background.m.BackgroundType = bg.m.BackgroundType;
				_background.m.Modifiers = bg.m.Modifiers;
				names = bg.m.Names;
				
				if (bg.m.CustomPerkTree != null)
				{
					_background.m.CustomPerkTree = bg.m.CustomPerkTree;
				}
				else if (bg.m.PerkTreeDynamic != null)
				{
					_background.m.CustomPerkTree = null;
					_background.m.PerkTreeDynamic = bg.m.PerkTreeDynamic;
				}
			    break;
			}
		}

		if (_info.Type != null)
		{
			names = [this.Const.Strings.EntityName[_info.Type]];
		}
			
		if (_background.m.Entity != null && _background.m.Entity.getName() != this.Const.Strings.EntityName[_info.Type])
		{
			names = [_background.m.Entity.getName()];
		}
		else 
		{
			names = this.Const.Strings.CharacterNames;
		}

		if (("Custom" in _info) && _info.Custom.len() != 0)
		{
			if ("ID" in _info.Custom)
			{
				_background.m.ID = _info.Custom.ID;
			}

			if ("AdditionalPerkGroup" in _info.Custom)
			{
				local input = _info.Custom.AdditionalPerkGroup;
				_background.m.AdditionalPerks = [];

				if (typeof input[1] == "string" && (input[1] in this.Const.PerksCharmedUnit))
				{
					input[1] = this.Const.PerksCharmedUnit[input[1]];
				}

				if (input[0] == 0)
				{
					_background.m.AdditionalPerks.extend(input[1]);
				}
				else
				{
				    _background.m.AdditionalPerks.push(::mc_randArray(input[1]));
				}
			}
			
			if ("BgModifiers" in _info.Custom)
			{
				_background.m.Modifiers = _info.Custom.BgModifiers;
			}

			if (("Names" in _info.Custom) && typeof _info.Custom.Names == "string" && (_info.Custom.Names in this.Const.Strings))
			{
				names = this.Const.Strings[_info.Custom.Names];
				_background.m.Titles = [];
			}
		}

		if (names != null)
		{
			_background.m.Names = names;
		}
	}
	
	function TypeToInfoHuman( _human, _returnViable = false )
	{
		local _type = _human.getType();

		if (_returnViable)
		{
			return this.Const.CharmedSlave.getRequirements(_type, true);
		}
		
		local ret = {
			Type = _type,
			Script = "player",
			Background = _type == this.Const.EntityType.Engineer ? "charmed_human_engineer_background" : "charmed_human_background",
		};

		this.Const.CharmedSlave.addSimpleData(ret, _human);
		return ret;
	}
	
	function TypeToInfoNonHuman( _entity , _returnViable = false )
	{	
		local _type = _entity.getType();
		
		if (_returnViable)
		{
			return this.Const.CharmedSlave.getRequirements(_type);
		}
		
		local ret = {
			Type = _type,
		};
		this.Const.CharmedSlave.addSimpleData(ret, _entity);

		switch (_type)
		{
		case this.Const.EntityType.BarbarianUnhold:
			ret.Type = this.Const.EntityType.Unhold;
			break;
			
		case this.Const.EntityType.BarbarianUnholdFrost:
			ret.Type = this.Const.EntityType.UnholdFrost;
			break;
		}

		return ret;
	}

	function getTooltip( _properties )
	{
		local ret = [];

		if (_properties.FatigueRecoveryRate > 15)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (_properties.FatigueRecoveryRate - 15) + "[/color] Fatigue Recovery per turn"
			});
		}
		else if (_properties.FatigueRecoveryRate < 15)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + (15 - _properties.FatigueRecoveryRate) + "[/color] Fatigue Recovery per turn"
			});
		}

		local value = this.Math.floor(_properties.DamageTotalMult * 100);

		if (value > 100)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (value - 100) + "%[/color] Attack damage"
			});
		}
		else if (value < 100)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + (100 - value) + "%[/color] Attack damage"
			});
		}

		local value = this.Math.floor(_properties.DamageDirectMult * 100);

		if (value > 100)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (value - 100) + "%[/color]  Damage that ignores armor"
			});
		}
		else if (value < 100)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + (100 - value) + "%[/color]  Damage that ignores armor"
			});
		}

		if (_properties.IsImmuneToOverwhelm)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Overwhelm[/color]"
			});
		}
		
		if (_properties.IsImmuneToZoneOfControl)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Zone of Control[/color]"
			});
		}
		
		if (_properties.IsImmuneToStun)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Stun[/color]"
			});
		}
		
		if (_properties.IsImmuneToRoot)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Root[/color], [color=" + this.Const.UI.Color.NegativeValue + "]Net[/color], [color=" + this.Const.UI.Color.NegativeValue + "]Web[/color], [color=" + this.Const.UI.Color.NegativeValue + "]Ensnare[/color]"
			});
		}
		
		if (_properties.IsImmuneToKnockBackAndGrab)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Knock Back[/color] and [color=" + this.Const.UI.Color.NegativeValue + "]Grab[/color]"
			});
		}
		
		if (_properties.IsImmuneToRotation)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Rotation[/color]"
			});
		}
		
		if (_properties.IsImmuneToDisarm)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Disarm[/color]"
			});
		}
		
		if (_properties.IsImmuneToSurrounding)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to being [color=" + this.Const.UI.Color.NegativeValue + "]Surrounded[/color]"
			});
		}
		
		if (_properties.IsImmuneToBleeding)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Bleeding[/color]"
			});
		}
		
		if (_properties.IsImmuneToPoison)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Poison[/color]"
			});
		}
		
		if (_properties.IsImmuneToDamageReflection)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Damage Reflection[/color]"
			});
		}
			
		if (_properties.IsImmuneToFire)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Fire[/color]"
			});
		}	
		
		if (!_properties.IsAffectedByNight)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Not being affected by [color=" + this.Const.UI.Color.NegativeValue + "]Nighttime[/color] penalties"
			});
		}
		
		if (!_properties.IsAffectedByInjuries)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Not being affected by [color=" + this.Const.UI.Color.NegativeValue + "]Injuries[/color]"
			});
		}
		
		if (!_properties.IsAffectedByFreshInjuries)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Not being affected by [color=" + this.Const.UI.Color.NegativeValue + "]Fresh Injuries[/color]"
			});
		}

		return ret;
	}
	
};

gt.Const.HexenOrigin.Magic <- {
	
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
		
		ret += skills.getAllSkillsOfType(this.Const.SkillType.Injury).len();
		
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
					ColorMin = this.createColor("fff3e50f"),
					ColorMax = this.createColor("ffffff5f"),
					ScaleMin = 0.5,
					ScaleMax = 0.5,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-0.5, 0.0),
					DirectionMax = this.createVec(0.5, 1.0),
					SpawnOffsetMin = this.createVec(-30, -70),
					SpawnOffsetMax = this.createVec(30, 30),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = this.createColor("fff3e500"),
					ColorMax = this.createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-0.5, 0.0),
					DirectionMax = this.createVec(0.5, 1.0),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				}
			]
		};
		
		this.Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
	}
};

gt.Const.HexenOrigin.PermanentInjury <- [
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

gt.Const.HexenOrigin.Body <- [
	"bust_hexen_fake_body_00",
	"bust_hexen_fake_body_01",
	"bust_hexen_true_body"
];

gt.Const.HexenOrigin.TrueHead <- [
	"bust_hexen_true_head_01",
	"bust_hexen_true_head_02",
	"bust_hexen_true_head_03"
];

gt.Const.HexenOrigin.TrueHair <- [
	"bust_hexen_true_hair_01",
	"bust_hexen_true_hair_02",
	"bust_hexen_true_hair_03",
	"bust_hexen_true_hair_04"
];

gt.Const.HexenOrigin.FakeHead <- [
	"bust_hexen_fake_head_01",
	"bust_hexen_fake_head_02"
];

gt.Const.HexenOrigin.FakeHair <- [
	"bust_hexen_fake_hair_01",
	"bust_hexen_fake_hair_02",
	"bust_hexen_fake_hair_03",
	"bust_hexen_fake_hair_04",
	"bust_hexen_fake_hair_05"
];

gt.Const.HexenOrigin.FakeArmor <- [
	"bust_hexen_fake_dress_01",
	"bust_hexen_fake_dress_02",
	"bust_hexen_fake_dress_03"
];

gt.Const.HexenOrigin.AffectedSprites <- [
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

gt.Const.Strings.GoblinNames.extend([
	"Nagat"
	"Gob"
	"Idrut"
	"Vos"
	"Dachus"
	"Moldear"
	"Bearbite"
	"Leechhead"
	"Toadwart"
	"Mite"
	"Stegg"
	"Rab"
	"Hagerk"
	"Allu"
	"Magg"
	"Mule"
	"Murkteeth"
	"Strangegut"
	"Stinkknuckles"
	"Stublegs"
	"Kradgis"
	"Creg"
	"Crab"
	"Tot"
	"Krelluk"
	"Snoteye"
	"Sickcheek"
	"Gnat"
	"Grubeyes"
	"Deviant"
	"Vrograb"
	"Stib"
	"Cedgit"
	"Puggog"
	"Cigdegg"
	"Shrillchin"
	"Moldbrain"
	"Peon"
	"Grimchin"
	"Chickenbrain"
]);

gt.Const.Strings.OrcNames <- [
	"Ragzog",
	"Krauzzur",
	"Kruzzerg",
	"Shogzo",
	"Begraug",
	"Olcmeth",
	"Azgig",
	"Aurzadh",
	"Uzad",
	"Ordodh",
	"Sushni",
	"Bigzugh",
	"Crethrodh",
	"Belgag",
	"Kulcmir",
	"Ahad",
	"Addakh",
	"Auzagh",
	"Ogit",
	"Authra",
	"Girduc",
	"Draddath",
	"Bifdif",
	"Srozrirg",
	"Baucrat",
	"Uzboc",
	"Ogli",
	"Ugzorg",
	"Aurdet",
	"Auddugh",
	"Crozugh",
	"Cezbau",
	"Ghagze",
	"Ghulgi",
	"Dulgef",
	"Urcir",
	"Ufthagh",
	"Aglal",
	"Orcag",
	"Ugbokh",
	"Cocdaud",
	"Graulcmakh",
	"Laddish",
	"Kredbac",
	"Drurgir",
	"Ogbid",
	"Ashnaugh",
	"Ogderg",
	"Aggauc",
	"Urgaut",
	"Ghozzut",
	"Ghelcmo",
	"Shilgal",
	"Shoddish",
	"Locbakh",
	"Ofdo",
	"Odbid",
	"Acdekh",
	"Aldedh",
	"Audbu",
];

gt.Const.Strings.UnholdNames <- [
	"Graarorn",
	"Erkun",
	"Emnorn",
	"Rhunzern",
	"Trunmart",
	"Threnmur",
	"Valkar",
	"Struztort",
	"Uzron",
	"Vokteror",
	"Velzurt",
	"Galzarn",
	"Stragrundurn",
	"Rezrarn",
	"Strazdas",
	"Zoktos",
	"Zaaltur",
	"Momnur",
	"Vurdas",
	"Makssur",
	"Sulles",
	"Zrostem",
	"Veksum",
	"Trozuthart",
	"Voktes",
	"Ozdaun",
	"Hennern",
	"Emnert",
	"Zordurt",
	"Olar",
	"Soztauj",
	"Vuzdem",
	"Skolus",
	"Skortert",
	"Egnum",
	"Ontam",
	"Omner",
	"Thamnort",
	"Gurton",
	"Velmarn",
	"Zagron",
	"Rhelzen",
	"Karom",
	"Strenzunturn",
	"Kanzort",
	"Monnum",
	"Gagnorn",
	"Truzun",
	"Ugrarn",
	"Traltar",
	"Hulkaeuj",
	"Vemnortun",
	"Ertort",
	"Skoluj",
	"Stralkes",
	"Keles",
	"Astern",
	"Trolzam",
	"Thauzdoj",
	"Raullus",
];

gt.Const.Strings.WolfNames <- [
	"Asbas",
	"Ilduk",
	"Nourzim",
	"Daoldrim",
	"Toldil",
	"Adram",
	"Lendim",
	"Dinzek",
	"Umkil",
	"Tounzox",
	"Aoznik",
	"Zuzli",
	"Ukris",
	"Guznus",
	"Ognan",
	"Ualdim",
	"Malguk",
	"Huarbol",
	"Lebrul",
	"Laugrik",
	"Lunzak",
	"Uknim",
	"Delkok",
	"Luarbak",
	"Erdak",
	"Vaundil",
	"Tervux",
	"Agnik",
	"Dimdrox",
	"Haulgra",
	"Lorzul",
	"Negrek",
	"Galdex",
	"Aogran",
	"Zalka",
	"Nuamkim",
	"Zomkan",
	"Lalgre",
	"Migdik",
	"Zuaklin",
	"Liskal",
	"Zuznum",
	"Nouslas",
	"Zignok",
	"Tikra",
	"Lervux",
	"Zuaklum",
	"Gumkas",
	"Laorzas",
	"Duslim",
	"Norda",
	"Mazli",
	"Laograx",
	"Zigrak",
	"Voumri",
	"Umkax",
	"Zoclo",
	"Arvin",
	"Luagra",
	"Oumrul",
	"Diklol",
	"Turdak",
	"Tenzis",
	"Arzel",
	"Takdok",
	"Eldil",
	"Dalgul",
	"Vulgrol",
	"Omkek",
	"Anguk",
	"Ekdux",
	"Naugduk",
	"Labrak",
	"Abram",
	"Maczu",
	"Vaolgrix",
	"Tesbum",
	"Maskox",
	"Oudres",
	"Tekrun",
];

gt.Const.Strings.NachoNames <- [
	"Bic",
	"Khad",
	"Rog",
	"Khotzoz",
	"Amgac",
	"Khozlaug",
	"Cliffdribbler",
	"Banemark",
	"Bonemuncher",
	"Slimebrow",
	"Khauc",
	"Rok",
	"Ruc",
	"Baldog",
	"Gikiz",
	"Vaskrot",
	"Cursebane",
	"Iceguzzler",
	"Grimlimb",
	"Goomaw",
	"Vog",
	"Zod",
	"Kox",
	"Oknug",
	"Untit",
	"Ummag",
	"Snowclaw",
	"Emberrunner",
	"Earthrunner",
	"Ironchewer",
	"Khag",
	"Khox",
	"Chot",
	"Vaqux",
	"Rablod",
	"Bikvag",
	"Darkwatcher",
	"Puscrown",
	"Stormchewer",
	"Chainbrewer",
	"Roq",
	"Zog",
	"Gat",
	"Chikvac",
	"Oskrux",
	"Osgout",
	"Filthbasher",
	"Dirtsnarl",
	"Gorestuffer",
	"Gooface",
	"Bux",
	"Rig",
	"Chok",
	"Kholgrot",
	"Vanok",
	"Uktrat",
	"Forgesorrow",
	"Darksworn",
	"Flameslobber",
	"Sludgeripper",
];

gt.Const.Strings.SpiderNames <- [
	"Kreciq",
	"Qix'ab",
	"Rouqzis",
	"Kriqed",
	"Assirriq",
	"Rartaq",
	"Qaviqo",
	"Kraqad",
	"Keqrit",
	"Qhalra",
	"Sriazikib",
	"Qartus",
	"Zhaqak'ror",
	"Qhiantu",
	"Yirrad",
	"Rocur",
	"Srark'as",
	"Zhek'sid",
	"Qraarricheeb",
	"Khaquntai",
	"Irernaib",
	"Sriq'teke",
	"Sassox",
	"Szisiq",
	"Zhosniq",
	"Qrok'zud",
	"Choqtu",
	"Rocos",
	"Zhaakuced",
	"Civus",
	"Xousri",
	"Qen'qus",
	"Szakzor",
	"Cek'ra",
	"Lerox",
	"Krakzoq",
	"Qantet",
	"Szoq'zivoq",
	"Zhek'zax",
	"Aqizra",
	"Caiva",
	"Charilli",
	"Khavur",
	"Renteseh",
	"Rer'oh",
	"Qhevah",
	"Szeecur",
	"Sikuh",
	"Qher'aq",
	"Lat'o",
	"Loroqaid",
	"Qir'eq",
	"Qhasniq",
	"Khirti",
	"Qisod",
	"Yallur",
	"Qhaizes",
	"Yezsa",
	"Chiriq",
	"Zhivi",
	"Zasur",
	"At'i",
	"Zhirzasa",
	"Zhisorzal",
	"Chen'qis",
	"Lan'qiel",
	"Sezier",
	"Zivoh",
	"Relli",
	"Qhereezed",
];

gt.Const.Strings.SchratNames <- [
	"Cypresstrunk",
	"Poplarblossom",
	"Sprucebark",
	"Locustherb",
	"Wiselarch",
	"Larchcovert",
	"Pineshadow",
	"Yewbrow",
	"Oakfury",
	"Treeburn",
	"Pygmyash",
	"Silentbeard",
	"Weepingoak",
	"Mildfir",
	"Weepinglocust",
	"Ashgrowl",
	"Acorneye",
	"Alderpaw",
	"Barecherry",
	"Elmroar",
	"Mellowleg",
	"Spruceburn",
	"Willowwood",
	"Algalwillow",
	"Denseelm",
	"Aldertrunk",
	"Tainttrunk",
	"Burnedspruce",
	"Willowgrowl",
	"Pinetooth",
	"Elmburn",
	"Cunningtendril",
	"Treebrow",
	"Pineshade",
	"Thistlehowl",
	"Beechburn",
	"Sprucetwig",
	"Summerelm",
	"Poplarscar",
	"Tenderlocust",
	"Mildyew",
	"Walnutlimb",
	"Beechhusk",
	"Poplarleaf",
	"Scrubash",
];

gt.Const.Strings.LindwurmNames <- [
	"Gaho",
	"Ghekhun",
	"Verga",
	"Messo",
	"Ergaris",
	"Koveka",
	"Geriammoj",
	"Memmona",
	"Jhauguhshouz",
	"Eruszin",
	"Zozzu",
	"Zrezi",
	"Zrihshu",
	"Zhukash",
	"Jorineh",
	"Nremzaves",
	"Zugussi",
	"Zhikachu",
	"Iamuhjoush",
	"Ngunara",
	"Akhush",
	"Chuve",
	"Jhardih",
	"Mraissuh",
	"Ennizi",
	"Khasshekai",
	"Uravi",
	"Zrezzouron",
	"Mranengua",
	"Viraiga",
	"Jhuvou",
	"Mgukkeh",
	"Zekas",
	"Nraeka",
	"Mozukkaij",
	"Ugzozou",
	"Zuagunan",
	"Zhiaziveh",
	"Maergumehs",
	"Nirounkan",
	"Zimo",
	"Ghainnaz",
	"Khizaz",
	"Chozzihs",
	"Aurgino",
	"Kuzkenu",
	"Jhogini",
	"Kaennumzij",
	"Mikenohz",
	"Nrezorosh",
	"Ngunua",
	"Mrisshis",
	"Ogehs",
	"Ikhohs",
	"Jhauzogo",
	"Zaishgouri",
	"Chonuachohz",
	"Ghemmuzshai",
	"Mrehazshai",
	"Zhogiki",
];

gt.Const.Strings.SerpentNames <- [
	"Thyxishae",
	"Castiphelia",
	"Chalithea",
	"Isesis",
	"Thronea",
	"Thosolphi",
	"Sylphiphaeia",
	"Messethis",
	"Pixishia",
	"Thespophai",
	"Phalaemios",
	"Xenosyne",
	"Parthobus",
	"Typhothius",
	"Kosalus",
	"Anchastos",
	"Alcelaus",
	"Agathoneus",
	"Dionysaestus",
	"Casoneus",
	"Eusix",
	"Xenas",
	"Heristhus",
	"Iphicrastus",
	"Caesixus",
	"Sotus",
	"Isocritus",
	"Phrixous",
	"Demophyx",
	"Achererus",
	"Meniphymes",
	"Galixiche",
	"Theleleia",
	"Acoseila",
	"Amathissis",
	"Sagaxise",
	"Olithanthe",
	"Olitheshi",
	"Aphisia",
	"Saphiphoia",
	"Savareris",
	"Mathessei",
	"Hyseithe",
	"Galixeasi",
	"Amathiphise",
	"Bathithea",
	"Prosenis",
	"Mystice",
	"Pasose",
	"Lithusi",
	"Sinesi",
	"Lephaxise",
	"Selanise",
	"Axiphisei",
	"Thalalise",
	"Sagethia",
	"Phalalphia",
	"Thanohsa",
	"Chalertes",
	"Nethithea",
];

gt.Const.Strings.BearNames <- [
	"Marley",
	"Osborn",
	"Osborn",
	"Uther",
	"Ursinus",
	"Scoot",
	"Bern",
	"Frankie",
	"Tatty",
	"Uther",
	"Doris",
	"Bernadette",
	"Bubbles",
	"Banjo",
	"Averi",
	"Hagar",
	"Twinky",
	"Jane",
	"Grumpy",
	"Myr",
	"Osborne",
	"Basil",
	"Beirne",
	"Mahon",
	"Sugar",
	"Uzumati",
	"Billie",
	"Orsino",
	"Torben",
	"Vemados",
	"Teddy",
];

gt.Const.Strings.KrakenNamesOnly <- [
	"Ogg-Sattoth",
	"Kha-Athlu",
	"Shaggaruth",
	"Gla-Oth",
	"Gu-Shogg",
	"Chtan-Nahitil",
	"Xa-Shutar",
	"Thohochoth",
	"Naccorath",
	"Xapocathlu"
];

gt.Const.Strings.KrakenTitlesOnly <- [
	"the Grand Devourer",
	"the All-Ender",
	"the Unending",
	"the Endless Maw",
	"the Thousand-Armed Thresher",
	"the Gorger of All",
	"the Eater of Worlds",
	"the All-Ender",
	"the Eternal",
	"the All-Reaching"
];