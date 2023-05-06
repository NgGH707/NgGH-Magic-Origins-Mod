
::Nggh_MagicConcept.isHexeOrigin <- function()
{
	return ("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getOrigin() != null && ::World.Assets.getOrigin().getID() == "scenario.hexe";
}

::Nggh_MagicConcept.spawnQuote <- function( _brush, _tile )
{
	::Tactical.spawnSpriteEffect(_brush, ::createColor("#ffffff"), _tile, ::Const.Tactical.Settings.SkillOverlayOffsetX, ::Const.Tactical.Settings.SkillOverlayOffsetY + 30, ::Const.Tactical.Settings.SkillOverlayScale, ::Const.Tactical.Settings.SkillOverlayScale, ::Const.Tactical.Settings.SkillOverlayStayDuration + 750, 0, ::Const.Tactical.Settings.SkillOverlayFadeDuration - 150);
}

::Nggh_MagicConcept.findPerkDefByID <- function( _id )
{
	foreach ( Def in ::Const.Perks.PerkDefObjects )
	{
		if (Def.ID == _id)
		{
			return Def;
		}
	}

	return null;
}

::Nggh_MagicConcept.findPerkScriptByID <- function( _id )
{
	local Def = ::Nggh_MagicConcept.findPerkDefByID(_id);

	if (Def != null)
	{
		return Def.Script;
	}

	return null;
}

if (!("Passive" in ::Const.UI.Color))
{
	::Const.UI.Color.Passive <- "#4f1800";
	::Const.UI.Color.Active <- "#000ec1";
}

::Const.KrakenTentacleMode <- {
	Ensnaring = 0,
	Attacking = 1
};

::Const.AlpWeaponDamageMod <- 0.85;

::Const.MaximumSpiderling <- 5;

::Const.SwallowWholeInvalidTargets <- [
	::Const.EntityType.Mortar,
	::Const.EntityType.Unhold,
	::Const.EntityType.UnholdFrost,
	::Const.EntityType.UnholdBog,
	::Const.EntityType.BarbarianUnhold,
	::Const.EntityType.BarbarianUnholdFrost,
	::Const.EntityType.GoblinWolfrider,
	::Const.EntityType.OrcWarlord,
	::Const.EntityType.ZombieBetrayer,
	::Const.EntityType.SkeletonPhylactery,
	::Const.EntityType.Schrat,
	::Const.EntityType.Lindwurm,
	::Const.EntityType.Kraken,
	::Const.EntityType.KrakenTentacle,
	::Const.EntityType.TricksterGod,
	::Const.EntityType.ZombieBoss,
	::Const.EntityType.SkeletonBoss,
	::Const.EntityType.SkeletonLich,
	::Const.EntityType.LegendOrcElite,
	::Const.EntityType.LegendOrcBehemoth,
	::Const.EntityType.LegendWhiteDirewolf,
	::Const.EntityType.LegendStollwurm,
	::Const.EntityType.LegendRockUnhold,
	::Const.EntityType.LegendGreenwoodSchrat,
];

::Const.StatsToRandomized <- [
	"Hitpoints",
	"Stamina",
	"Bravery",
	"Initiative",
	"MeleeSkill",
	"RangedSkill",
	"MeleeDefense",
	"RangedDefense"
];

::Const.Sprites_onFactionChanged <- [
	"head", 
	"head_frenzy",
	"body",
	"body_rage",
	"body_blood",
	"legs_back", 
	"legs_front",
	"injury",
	"injury_body",
	"quiver", 
	
	"wolf",
	"wolf_head",
	"wolf_armor",
	
	"tattoo_head", 
	"tattoo_body", 
];

if (!("Orc" in ::Const))
{
	::Const.Orc <- {};
}

::Const.Orc.Variants <- [
	::Const.EntityType.OrcYoung,
	::Const.EntityType.OrcBerserker,
	::Const.EntityType.OrcWarrior,
	::Const.EntityType.OrcWarlord,
	::Const.EntityType.LegendOrcElite,
	::Const.EntityType.LegendOrcBehemoth,
];

::Const.Orc.VariantRolls <- [
	[40, ::Const.EntityType.OrcYoung         ], // 72%
	[ 5, ::Const.EntityType.OrcBerserker     ], // 9%
	[ 7, ::Const.EntityType.OrcWarrior       ], // 13%
	[ 1, ::Const.EntityType.OrcWarlord       ], // 2%
	[ 1, ::Const.EntityType.LegendOrcElite   ], // 2%
	[ 1, ::Const.EntityType.LegendOrcBehemoth], // 2%
];

::Const.Orc.HelmetSpriteOffset <- [
	[ 4,  0],
	[ 8,  2],
	[10,  3],
	[13, 10],
	[10,  0],
	[13, 15]
];

::Const.Orc.ArmorScale <- [
	1.1,
	1.15,
	1.15,
	1.0,
	1.15,
	1.0,
];

::Const.Orc.BerserkerArmorMoraleThreshold <- ::Const.MoraleState.Breaking;

if (!("Goblin" in ::Const))
{
	::Const.Goblin <- {};
}

::Const.Goblin.ArmorFatigueThreshold <- 21;

::Const.Goblin.Variants <- [
	::Const.EntityType.GoblinFighter,
	::Const.EntityType.GoblinAmbusher,
	::Const.EntityType.GoblinWolfrider,
	::Const.EntityType.GoblinLeader,
	::Const.EntityType.GoblinShaman,
];

::Const.Goblin.VariantRolls <- [
	[30, ::Const.EntityType.GoblinFighter  ], // 45%
	[20, ::Const.EntityType.GoblinAmbusher ], // 30%
	[10, ::Const.EntityType.GoblinWolfrider], // 15%
	[ 5, ::Const.EntityType.GoblinLeader   ], // 8.5%
	[ 1, ::Const.EntityType.GoblinShaman   ], // 1.5%
];

::Const.Goblin.SkirmisherArmorSpawnHiding <- function( _tile )
{
	if (_tile.IsHidingEntity)
	{
		return false;
	}

	_tile.clear();
	_tile.spawnDetail(::Const.Tactical.HiddingPlace[_tile.Subtype][0]);
	_tile.spawnDetail(::Const.Tactical.HiddingPlace[_tile.Subtype][1]);
	_tile.IsHidingEntity = true;

	return true;
}

::Const.Tactical.HiddingPlace <- [
	[
		"hiding_shrubbery_01_front",
		"hiding_shrubbery_01_back"
	],
	[
		"hiding_shrubbery_01_front",
		"hiding_shrubbery_01_back"
	],
	[
		"hiding_shrubbery_01_front",
		"hiding_shrubbery_01_back"
	],
	[
		"hiding_shrubbery_01_front",
		"hiding_shrubbery_01_back"
	],
	[
		"hiding_shrubbery_01_front",
		"hiding_shrubbery_01_back"
	],
	[
		"hiding_shrubbery_01_front",
		"hiding_shrubbery_01_back"
	],
	[
		"hiding_ferns_01_front",
		"hiding_ferns_01_back"
	],
	[
		"hiding_swamp_01_front",
		"hiding_swamp_01_back"
	],
	[
		"hiding_desert_01_front",
		"hiding_desert_01_back"
	],
	[
		"hiding_swamp_01_front",
		"hiding_swamp_01_back_reflect"
	],
	[
		"hiding_shrubbery_01_front",
		"hiding_shrubbery_01_back"
	],
	[
		"hiding_shrubbery_01_front",
		"hiding_shrubbery_01_back"
	],
	[
		"hiding_shrubbery_01_front",
		"hiding_shrubbery_01_back"
	],
	[
		"hiding_shrubbery_01_front",
		"hiding_shrubbery_01_back"
	],
	[
		"hiding_shrubbery_01_front",
		"hiding_shrubbery_01_back"
	],
	[
		"hiding_shrubbery_01_front",
		"hiding_shrubbery_01_back"
	],
	[
		"hiding_shrubbery_01_front",
		"hiding_shrubbery_01_back"
	],
	[
		"hiding_desert_01_front",
		"hiding_desert_01_back"
	],
	[
		"hiding_desert_02_front",
		"hiding_desert_01_back"
	],
];


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
::Const.DefaultChangeAttributes <- {
	Hitpoints = [0, 0], 
	Bravery = [0, 0], 
	Stamina = [0, 0], 
	MeleeSkill = [0, 0], 
	RangedSkill = [0, 0], 
	MeleeDefense = [0, 0], 
	RangedDefense = [0, 0], 
	Initiative = [0, 0]
};

::Const.NoCopyPerks <- [
	"perk.inherit",
	"perk.breeding_machine",
	"perk.natural_selection",
	"perk.attach_egg",
	"perk.gifted",
	"perk.bags_and_belts",
	"perk.legend_back_to_basics",
	"perk_ptr_promised_potential",
	"perk.ptr_discovered_talent",
	"perk_ptr_rising_star",
	"perk.perk_ptr_follow_up",
	//"perk_ptr_king_of_all_weapons",
	//"perk_ptr_family_ties",
	//"perk_ptr_family_pride",
];


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
::Const.LuckyRuneChanceModifier <- 8;

::Const.Nggh_NamedStaff_MagicSkills <- [
	{
		Name = "Chain Lightning",
		Script = "actives/legend_chain_lightning",
		AdditionalFatigue = 0,
		AdditionalAP = 0,
		Count = 0
	},
	{
		Name = "Call Lightning",
		Script = "actives/legend_call_lightning",
		AdditionalFatigue = 0,
		AdditionalAP = 0,
		Count = 0
	},
	{
		Name = "Summon Wolf",
		Script = "actives/legend_unleash_wolf",
		AdditionalFatigue = 3,
		AdditionalAP = -2,
		Count = 0
	},
	{
		Name = "Magic Missile",
		Script = "actives/legend_magic_missile",
		AdditionalFatigue = 2,
		AdditionalAP = 0,
		Count = 0
	},
	{
		Name = "Holy Flame",
		Script = "actives/legend_holyflame_skill",
		AdditionalFatigue = 2,
		AdditionalAP = 0,
		Count = 0
	},
	{
		Name = "Web Bolt",
		Script = "actives/mage_legend_magic_web_bolt",
		AdditionalFatigue = 5,
		AdditionalAP = 0,
		Count = 0
	},
	{
		Name = "Darkflight",
		Script = "actives/legend_darkflight",
		AdditionalFatigue = 5,
		AdditionalAP = 0,
		Count = 0
	},
	{
		Name = "Miasma",
		Script = "actives/miasma_skill",
		AdditionalFatigue = 0,
		AdditionalAP = 1,
		Count = 0
	},
	{
		Name = "Conduct Seance",
		Script = "actives/legend_raise_undead",
		AdditionalFatigue = 5,
		AdditionalAP = 0,
		Count = 0
	},
	{
		Name = "Levitate Person",
		Script = "actives/legend_levitate_person",
		AdditionalFatigue = 0,
		AdditionalAP = 0,
		Count = 0
	},
	{
		Name = "Night Vision",
		Script = "actives/grant_night_vision_skill",
		AdditionalFatigue = 0,
		AdditionalAP = 4,
		Count = 0
	},
	{
		Name = "Life Siphon",
		Script = "actives/legend_siphon_skill",
		AdditionalFatigue = 3,
		AdditionalAP = 0,
		Count = 0
	},
	{
		Name = "Resistant to Ranged Attacks",
		Script = "racial/skeleton_racial",
		AdditionalFatigue = 0,
		AdditionalAP = 0,
		Count = 0
	},
];


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// add a new class for CombatInfo
::Const.Tactical.CombatInfo.LootWithoutScript <- [];

// add new named weapon to the list
::Const.Items.NamedMeleeWeapons.push("weapons/named/nggh_mod_named_staff");
::Const.Items.NamedWeapons = clone ::Const.Items.NamedMeleeWeapons;
::Const.Items.NamedWeapons.extend(::Const.Items.NamedRangedWeapons);

// ::Const.Items.addNewItemType("Ancient"); currently not use
// ::Const.Items.addNewItemType("Corpse"); currently not use


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// new tactical effects
::Const.Tactical.onApplyShadow <- function( _tile, _entity )
{
	if (_entity.getMoraleState() == ::Const.MoraleState.Ignore)
	{
		return;
	}

	if (_entity.getFlags().has("alp"))
	{
		return;
	}

	if ([
		::Const.EntityType.Alp,
		::Const.EntityType.AlpShadow,
		::Const.EntityType.LegendDemonAlp,
	].find(_entity.getType()) != null)
	{
		return;
	}

	if (!_entity.getSkills().hasSkill("effects.reign_of_darkness"))
	{
		_entity.getSkills().add(::new("scripts/skills/effects/nggh_mod_reign_of_darkness_effect"));
	}
};
::Const.AttackEffectPetting <- [
	{
		Brush = "effect_pet_left",
		Movement0 = ::createVec(-60, -130),
		Movement1 = ::createVec(-60, -130),
		Offset = ::createVec(-30, 70)
	},
	{
		Brush = "effect_pet_right",
		Movement0 = ::createVec(60, -130),
		Movement1 = ::createVec(60, -130),
		Offset = ::createVec(-45, 70)
	},
	{
		Brush = "effect_pet_right",
		Movement0 = ::createVec(60, -130),
		Movement1 = ::createVec(60, -130),
		Offset = ::createVec(-45, 70)
	},
	{
		Brush = "effect_pet_left",
		Movement0 = ::createVec(-60, -130),
		Movement1 = ::createVec(-60, -130),
		Offset = ::createVec(-30, 70)
	},
	{
		Brush = "effect_pet_left",
		Movement0 = ::createVec(-60, -130),
		Movement1 = ::createVec(-60, -130),
		Offset = ::createVec(-25, 70)
	},
	{
		Brush = "effect_pet_left",
		Movement0 = ::createVec(-60, -130),
		Movement1 = ::createVec(-60, -130),
		Offset = ::createVec(-25, 70)
	}
];
::Const.ShadowParticles <- [
	{
		Delay = 0,
		Quantity = 50,
		LifeTimeQuantity = 0,
		SpawnRate = 10,
		Brushes = [
			"effect_lightning_01",
			"effect_lightning_02",
			"effect_lightning_03"
		],
		Stages = [
			{
				LifeTimeMin = 0.75,
				LifeTimeMax = 1.25,
				ColorMin = ::createColor("00000000"),
				ColorMax = ::createColor("00000000"),
				ScaleMin = 0.25,
				ScaleMax = 0.5,
				RotationMin = 0,
				RotationMax = 359,
				TorqueMin = -10,
				TorqueMax = 10,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.5, -0.5),
				DirectionMax = ::createVec(0.5, -0.5),
				SpawnOffsetMin = ::createVec(-50, 0),
				SpawnOffsetMax = ::createVec(50, 40),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = ::createColor("0000002d"),
				ColorMax = ::createColor("0000002d"),
				ScaleMin = 0.5,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.4, -0.6),
				DirectionMax = ::createVec(0.4, -0.6),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = ::createColor("00000000"),
				ColorMax = ::createColor("00000000"),
				ScaleMin = 0.5,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			}
		]
	},
	{
		Delay = 0,
		Quantity = 50,
		LifeTimeQuantity = 0,
		SpawnRate = 8,
		Brushes = [
			"miasma_effect_02",
			"miasma_effect_03"
		],
		Stages = [
			{
				LifeTimeMin = 0.75,
				LifeTimeMax = 1.25,
				ColorMin = ::createColor("00000000"),
				ColorMax = ::createColor("00000000"),
				ScaleMin = 0.5,
				ScaleMax = 1.0,
				RotationMin = 0,
				RotationMax = 359,
				TorqueMin = -10,
				TorqueMax = 10,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.25, -0.25),
				DirectionMax = ::createVec(0.25, -0.25),
				SpawnOffsetMin = ::createVec(-50, 0),
				SpawnOffsetMax = ::createVec(50, 40),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = ::createColor("00000030"),
				ColorMax = ::createColor("00000030"),
				ScaleMin = 0.75,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.2, -0.3),
				DirectionMax = ::createVec(0.2, -0.3),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = ::createColor("00000000"),
				ColorMax = ::createColor("00000000"),
				ScaleMin = 0.75,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			}
		]
	}
];
::Const.SmokeParticles <- [
	{
		Delay = 0,
		Quantity = 50,
		LifeTimeQuantity = 0,
		SpawnRate = 9,
		Brushes = [
			"ash_light_01",
			"ash_light_02"
		],
		Stages = [
			{
				LifeTimeMin = 0.75,
				LifeTimeMax = 1.25,
				ColorMin = ::createColor("ffffff00"),
				ColorMax = ::createColor("ffffff00"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				TorqueMin = -10,
				TorqueMax = 10,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.5, 0.5),
				DirectionMax = ::createVec(0.5, 0.5),
				SpawnOffsetMin = ::createVec(-50, -40),
				SpawnOffsetMax = ::createVec(50, 20),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = ::createColor("ffffffed"),
				ColorMax = ::createColor("ffffffed"),
				ScaleMin = 0.75,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.4, 0.6),
				DirectionMax = ::createVec(0.4, 0.6),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = ::createColor("ffffff00"),
				ColorMax = ::createColor("ffffff00"),
				ScaleMin = 1.0,
				ScaleMax = 1.5,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
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
			"dust_light_01",
			"dust_light_02"
		],
		Stages = [
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = ::createColor("ffffff00"),
				ColorMax = ::createColor("ffffff00"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.5, 0.5),
				DirectionMax = ::createVec(0.5, 0.5),
				SpawnOffsetMin = ::createVec(-50, -40),
				SpawnOffsetMax = ::createVec(50, 10),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = ::createColor("ffffffef"),
				ColorMax = ::createColor("ffffffef"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.4, 0.6),
				DirectionMax = ::createVec(0.4, 0.6),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = ::createColor("ffffff00"),
				ColorMax = ::createColor("ffffff00"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			}
		]
	}
];
::Const.Tactical.MagicPurpleParticles <- [
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
				ColorMin = ::createColor("9d821700"),
				ColorMax = ::createColor("f5e6aa00"),
				ScaleMin = 0.25,
				ScaleMax = 0.5,
				RotationMin = 0,
				RotationMax = 359,
				TorqueMin = -10,
				TorqueMax = 10,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.5, 0.5),
				DirectionMax = ::createVec(0.5, 0.5),
				SpawnOffsetMin = ::createVec(-50, -40),
				SpawnOffsetMax = ::createVec(50, 20),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = ::createColor("9d82172d"),
				ColorMax = ::createColor("f5e6aa2d"),
				ScaleMin = 0.5,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.4, 0.6),
				DirectionMax = ::createVec(0.4, 0.6),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = ::createColor("9d821700"),
				ColorMax = ::createColor("f5e6aa00"),
				ScaleMin = 0.5,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
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
				ColorMin = ::createColor("9d821700"),
				ColorMax = ::createColor("f5e6aa00"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.5, 0.5),
				DirectionMax = ::createVec(0.5, 0.5),
				SpawnOffsetMin = ::createVec(-50, -40),
				SpawnOffsetMax = ::createVec(50, 10),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = ::createColor("9d82174f"),
				ColorMax = ::createColor("f5e6aa4f"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.4, 0.6),
				DirectionMax = ::createVec(0.4, 0.6),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = ::createColor("9d821700"),
				ColorMax = ::createColor("f5e6aa00"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			}
		]
	}
];

::Const.Tactical.MagicGreenParticles <- [
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
				ColorMin = ::createColor("9d821700"),
				ColorMax = ::createColor("f5e6aa00"),
				ScaleMin = 0.25,
				ScaleMax = 0.5,
				RotationMin = 0,
				RotationMax = 359,
				TorqueMin = -10,
				TorqueMax = 10,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.5, 0.5),
				DirectionMax = ::createVec(0.5, 0.5),
				SpawnOffsetMin = ::createVec(-50, -40),
				SpawnOffsetMax = ::createVec(50, 20),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = ::createColor("9d82172d"),
				ColorMax = ::createColor("f5e6aa2d"),
				ScaleMin = 0.5,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.4, 0.6),
				DirectionMax = ::createVec(0.4, 0.6),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = ::createColor("9d821700"),
				ColorMax = ::createColor("f5e6aa00"),
				ScaleMin = 0.5,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
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
				ColorMin = ::createColor("9d821700"),
				ColorMax = ::createColor("f5e6aa00"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.5, 0.5),
				DirectionMax = ::createVec(0.5, 0.5),
				SpawnOffsetMin = ::createVec(-50, -40),
				SpawnOffsetMax = ::createVec(50, 10),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = ::createColor("9d82174f"),
				ColorMax = ::createColor("f5e6aa4f"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = ::createVec(-0.4, 0.6),
				DirectionMax = ::createVec(0.4, 0.6),
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = ::createColor("9d821700"),
				ColorMax = ::createColor("f5e6aa00"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = ::createVec(0, 0),
				ForceMax = ::createVec(0, 10),
				FlickerEffect = false
			}
		]
	}
];

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// implement more champions

// orc berserker
::Const.World.Spawn.Troops.OrcBerserker.NameList <- ::Const.Strings.OrcNames;
::Const.World.Spawn.Troops.OrcBerserker.TitleList <- ::Const.Strings.BarbarianTitles;
::Const.World.Spawn.Troops.OrcBerserker.Variant = 2;

// demon hound
::Const.World.Spawn.Troops.LegendDemonHound.NameList <- ::Const.Strings.DemonHoundNames;
::Const.World.Spawn.Troops.LegendDemonHound.TitleList <- null;
::Const.World.Spawn.Troops.LegendDemonHound.Variant = 5;

// ghost
::Const.World.Spawn.Troops.Ghost.NameList <- ::Const.Strings.GhostNames;
::Const.World.Spawn.Troops.Ghost.TitleList <- ::Const.Strings.GhostTitles;
::Const.World.Spawn.Troops.Ghost.Variant = 5;

::Const.World.Spawn.Troops.LegendBanshee.NameList <- ::Const.Strings.BansheeNames;
::Const.World.Spawn.Troops.LegendBanshee.TitleList <- ::Const.Strings.BansheeTitles;
::Const.World.Spawn.Troops.LegendBanshee.Variant = 7;

// hexe
::Const.World.Spawn.Troops.Hexe.NameList <- ::Const.Strings.HexeNames;
::Const.World.Spawn.Troops.Hexe.TitleList <- null;
::Const.World.Spawn.Troops.Hexe.Variant = 3;

::Const.World.Spawn.Troops.LegendHexeLeader.NameList <- ::Const.Strings.HexeNames;
::Const.World.Spawn.Troops.LegendHexeLeader.TitleList <- null;
::Const.World.Spawn.Troops.LegendHexeLeader.Variant = 7;

// wolf
::Const.World.Spawn.Troops.Direwolf.NameList <- ::Const.Strings.WolfNames;
::Const.World.Spawn.Troops.Direwolf.TitleList <- null;
::Const.World.Spawn.Troops.Direwolf.Variant = 2;

::Const.World.Spawn.Troops.DirewolfHIGH.NameList <- ::Const.Strings.WolfNames;
::Const.World.Spawn.Troops.DirewolfHIGH.TitleList <- null;
::Const.World.Spawn.Troops.DirewolfHIGH.Variant = 4;

::Const.World.Spawn.Troops.LegendWhiteDirewolf.NameList <- ::Const.Strings.WolfNames;
::Const.World.Spawn.Troops.LegendWhiteDirewolf.TitleList <- null;
::Const.World.Spawn.Troops.LegendWhiteDirewolf.Variant = 5;

// nacho
::Const.World.Spawn.Troops.Ghoul.NameList <- ::Const.Strings.NachoNames;
::Const.World.Spawn.Troops.Ghoul.TitleList <- null;
::Const.World.Spawn.Troops.Ghoul.Variant = 1;

::Const.World.Spawn.Troops.GhoulHIGH.NameList <- ::Const.Strings.NachoNames;
::Const.World.Spawn.Troops.GhoulHIGH.TitleList <- null;
::Const.World.Spawn.Troops.GhoulHIGH.Variant = 4;

::Const.World.Spawn.Troops.LegendSkinGhoulMED.NameList <- ::Const.Strings.NachoNames;
::Const.World.Spawn.Troops.LegendSkinGhoulMED.TitleList <- null;
::Const.World.Spawn.Troops.LegendSkinGhoulMED.Variant = 2;

::Const.World.Spawn.Troops.LegendSkinGhoulHIGH.NameList <- ::Const.Strings.NachoNames;
::Const.World.Spawn.Troops.LegendSkinGhoulHIGH.TitleList <- null;
::Const.World.Spawn.Troops.LegendSkinGhoulHIGH.Variant = 2;

// snake
::Const.World.Spawn.Troops.Lindwurm.NameList <- ::Const.Strings.LindwurmNames;
::Const.World.Spawn.Troops.Lindwurm.TitleList <- null;
::Const.World.Spawn.Troops.Lindwurm.Variant = 5;

::Const.World.Spawn.Troops.LegendStollwurm.NameList <- ::Const.Strings.LindwurmNames;
::Const.World.Spawn.Troops.LegendStollwurm.TitleList <- null;
::Const.World.Spawn.Troops.LegendStollwurm.Variant = 5;

::Const.World.Spawn.Troops.Serpent.NameList <- ::Const.Strings.SerpentNames;
::Const.World.Spawn.Troops.Serpent.TitleList <- null;
::Const.World.Spawn.Troops.Serpent.Variant = 5;

// bear
::Const.World.Spawn.Troops.LegendBear.NameList <- ::Const.Strings.OrcNames;
::Const.World.Spawn.Troops.LegendBear.TitleList <- null;
::Const.World.Spawn.Troops.LegendBear.Variant = 5;

// unhold
::Const.World.Spawn.Troops.Unhold.NameList <- ::Const.Strings.UnholdNames;
::Const.World.Spawn.Troops.Unhold.TitleList <- null;
//::Const.World.Spawn.Troops.Unhold.Variant = 5;

::Const.World.Spawn.Troops.UnholdFrost.NameList <- ::Const.Strings.UnholdNames;
::Const.World.Spawn.Troops.UnholdFrost.TitleList <- null;
::Const.World.Spawn.Troops.UnholdFrost.Variant = 2;

::Const.World.Spawn.Troops.UnholdBog.NameList <- ::Const.Strings.UnholdNames;
::Const.World.Spawn.Troops.UnholdBog.TitleList <- null;
//::Const.World.Spawn.Troops.UnholdBog.Variant = 5;

::Const.World.Spawn.Troops.BarbarianUnhold.NameList <- ::Const.Strings.UnholdNames;
::Const.World.Spawn.Troops.BarbarianUnhold.TitleList <- null;
//::Const.World.Spawn.Troops.BarbarianUnhold.Variant = 5;

::Const.World.Spawn.Troops.BarbarianUnholdFrost.NameList <- ::Const.Strings.UnholdNames;
::Const.World.Spawn.Troops.BarbarianUnholdFrost.TitleList <- null;
::Const.World.Spawn.Troops.BarbarianUnholdFrost.Variant = 5;

::Const.World.Spawn.Troops.LegendRockUnhold.NameList <- ::Const.Strings.UnholdNames;
::Const.World.Spawn.Troops.LegendRockUnhold.TitleList <- ["the Mountain"];
::Const.World.Spawn.Troops.LegendRockUnhold.Variant = 5;

// spider
::Const.World.Spawn.Troops.Spider.NameList <- ::Const.Strings.SpiderNames;
::Const.World.Spawn.Troops.Spider.TitleList <- null;
::Const.World.Spawn.Troops.Spider.Variant = 3;

::Const.World.Spawn.Troops.LegendRedbackSpider.NameList <- ::Const.Strings.SpiderNames;
::Const.World.Spawn.Troops.LegendRedbackSpider.TitleList <- null;
::Const.World.Spawn.Troops.LegendRedbackSpider.Variant = 5;

// alp
::Const.World.Spawn.Troops.Alp.NameList <- ::Const.Strings.GoblinNames;
::Const.World.Spawn.Troops.Alp.TitleList <- null;
::Const.World.Spawn.Troops.Alp.Variant = 5;

::Const.World.Spawn.Troops.LegendDemonAlp.NameList <- ::Const.Strings.GoblinNames;
::Const.World.Spawn.Troops.LegendDemonAlp.TitleList <- null;
//::Const.World.Spawn.Troops.LegendDemonAlp.Variant = 1;

// schrat
::Const.World.Spawn.Troops.Schrat.NameList <- ::Const.Strings.SchratNames;
::Const.World.Spawn.Troops.Schrat.TitleList <- null;
::Const.World.Spawn.Troops.Schrat.Variant = 5;

// kraken
::Const.World.Spawn.Troops.Kraken.Variant = 40;

// trickster god
::Const.World.Spawn.Troops.TricksterGod.Variant = 1;
::Const.World.Spawn.Troops.TricksterGod.TitleList <- ["the Trickster"];

// hyena
::Const.World.Spawn.Troops.Hyena.NameList <- ::Const.Strings.WolfNames;
::Const.World.Spawn.Troops.Hyena.TitleList <- null;
::Const.World.Spawn.Troops.Hyena.Variant = 2;

::Const.World.Spawn.Troops.HyenaHIGH.NameList <- ::Const.Strings.WolfNames;
::Const.World.Spawn.Troops.HyenaHIGH.TitleList <- null;
::Const.World.Spawn.Troops.HyenaHIGH.Variant = 5;

/* bodyguard version of beasts can never be champion
::Const.World.Spawn.Troops.DirewolfBodyguard.NameList <- ::Const.Strings.WolfNames;
::Const.World.Spawn.Troops.DirewolfBodyguard.TitleList <- null;
::Const.World.Spawn.Troops.DirewolfBodyguard.Variant = 1;

::Const.World.Spawn.Troops.LegendWhiteDirewolfBodyguard.NameList <- ::Const.Strings.WolfNames;
::Const.World.Spawn.Troops.LegendWhiteDirewolfBodyguard.TitleList <- null;
::Const.World.Spawn.Troops.LegendWhiteDirewolfBodyguard.Variant = 3;

::Const.World.Spawn.Troops.SpiderBodyguard.NameList <- ::Const.Strings.SpiderNames;
::Const.World.Spawn.Troops.SpiderBodyguard.TitleList <- null;
::Const.World.Spawn.Troops.SpiderBodyguard.Variant = 1;

::Const.World.Spawn.Troops.LegendRedbackSpiderBodyguard.NameList <- ::Const.Strings.SpiderNames;
::Const.World.Spawn.Troops.LegendRedbackSpiderBodyguard.TitleList <- null;
::Const.World.Spawn.Troops.LegendRedbackSpiderBodyguard.Variant = 3;
*/


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// for perk true builder
::Const.AvailableFavourdPerks <- [
//low-tier
[
	::Const.Perks.PerkDefs.LegendFavouredEnemyGhoul,
	::Const.Perks.PerkDefs.LegendFavouredEnemyDirewolf,
	::Const.Perks.PerkDefs.LegendFavouredEnemySpider,
	::Const.Perks.PerkDefs.LegendFavouredEnemySkeleton,
	::Const.Perks.PerkDefs.LegendFavouredEnemyZombie,
	::Const.Perks.PerkDefs.LegendFavouredEnemyCaravan,
	::Const.Perks.PerkDefs.LegendFavouredEnemyMercenary,
	::Const.Perks.PerkDefs.LegendFavouredEnemyNoble,
	::Const.Perks.PerkDefs.LegendFavouredEnemySoutherner,
],

//mid-tier
[
	::Const.Perks.PerkDefs.LegendFavouredEnemyVampire,
	::Const.Perks.PerkDefs.LegendFavouredEnemyAlps,
	::Const.Perks.PerkDefs.LegendFavouredEnemyOrk,
	::Const.Perks.PerkDefs.LegendFavouredEnemyGoblin,
	::Const.Perks.PerkDefs.LegendFavouredEnemyBandit,
	::Const.Perks.PerkDefs.LegendFavouredEnemyNomad,
	::Const.Perks.PerkDefs.LegendFavouredEnemyBarbarian,
],

//high-tier
[
	::Const.Perks.PerkDefs.LegendFavouredEnemyHexen,
	::Const.Perks.PerkDefs.LegendFavouredEnemyUnhold,
	::Const.Perks.PerkDefs.LegendFavouredEnemySchrat,
	::Const.Perks.PerkDefs.LegendFavouredEnemyLindwurm,
	::Const.Perks.PerkDefs.LegendFavouredEnemyArcher,
	::Const.Perks.PerkDefs.LegendFavouredEnemySwordmaster,
],
];

::Const.AvailablePerksForBeast <- [
//low-tier
[
	::Const.Perks.PerkDefs.LegendBackToBasics,
	::Const.Perks.PerkDefs.Colossus,
	::Const.Perks.PerkDefs.LegendAlert,
	::Const.Perks.PerkDefs.CripplingStrikes,
	::Const.Perks.PerkDefs.Pathfinder,
	::Const.Perks.PerkDefs.SunderingStrikes,
	::Const.Perks.PerkDefs.LegendBlendIn,
	::Const.Perks.PerkDefs.NineLives,
	::Const.Perks.PerkDefs.FastAdaption,
	::Const.Perks.PerkDefs.Adrenaline,
	::Const.Perks.PerkDefs.BagsAndBelts,
	::Const.Perks.PerkDefs.Recover,
	::Const.Perks.PerkDefs.Backstabber,
	::Const.Perks.PerkDefs.SteelBrow,
	::Const.Perks.PerkDefs.Dodge,
	::Const.Perks.PerkDefs.LegendComposure,
	::Const.Perks.PerkDefs.LegendTrueBeliever,
	::Const.Perks.PerkDefs.LegendEvasion,
	::Const.Perks.PerkDefs.FortifiedMind,
	::Const.Perks.PerkDefs.Anticipation,
	::Const.Perks.PerkDefs.Steadfast,
	::Const.Perks.PerkDefs.LegendOnslaught,
	::Const.Perks.PerkDefs.Feint,
	::Const.Perks.PerkDefs.CoupDeGrace,
	::Const.Perks.PerkDefs.HoldOut,
	::Const.Perks.PerkDefs.Sprint,
	::Const.Perks.PerkDefs.Footwork,
	::Const.Perks.PerkDefs.LegendLacerate,
	::Const.Perks.PerkDefs.Relentless,
	::Const.Perks.PerkDefs.Taunt,
	::Const.Perks.PerkDefs.Rotation,
	::Const.Perks.PerkDefs.LegendSmackdown,
	::Const.Perks.PerkDefs.Debilitate
	::Const.Perks.PerkDefs.LegendHidden,
	::Const.Perks.PerkDefs.Gifted,
],

//mid-tier
[
	::Const.Perks.PerkDefs.LegendComposure,
	::Const.Perks.PerkDefs.LegendTrueBeliever,
	::Const.Perks.PerkDefs.LegendHairSplitter,
	::Const.Perks.PerkDefs.Underdog,
	::Const.Perks.PerkDefs.LegendLithe
	::Const.Perks.PerkDefs.LegendBloodbath,
	::Const.Perks.PerkDefs.LoneWolf,
	::Const.Perks.PerkDefs.Stalwart,
	::Const.Perks.PerkDefs.Overwhelm,
	::Const.Perks.PerkDefs.LegendClarity,
	::Const.Perks.PerkDefs.LegendEscapeArtist,
	::Const.Perks.PerkDefs.PushTheAdvantage,
	::Const.Perks.PerkDefs.LegendGatherer,
	::Const.Perks.PerkDefs.Nimble,
	::Const.Perks.PerkDefs.LegendTerrifyingVisage,
	::Const.Perks.PerkDefs.LegendAssuredConquest,
	::Const.Perks.PerkDefs.LegendSecondWind,
	::Const.Perks.PerkDefs.HeadHunter,
	::Const.Perks.PerkDefs.DoubleStrike,
	::Const.Perks.PerkDefs.DevastatingStrikes,
],

//high-tier
[
	::Const.Perks.PerkDefs.LegendTerrifyingVisage,
	::Const.Perks.PerkDefs.InspiringPresence,
	::Const.Perks.PerkDefs.Berserk,
	::Const.Perks.PerkDefs.LegendTumble,
	::Const.Perks.PerkDefs.LegendFullForce,
	::Const.Perks.PerkDefs.Vengeance,
	::Const.Perks.PerkDefs.LegendMindOverBody,
	::Const.Perks.PerkDefs.ReturnFavor,
	::Const.Perks.PerkDefs.KillingFrenzy,
	::Const.Perks.PerkDefs.Fearsome,
	::Const.Perks.PerkDefs.LegendForcefulSwing,
	::Const.Perks.PerkDefs.PerfectFocus
	::Const.Perks.PerkDefs.Indomitable,
	::Const.Perks.PerkDefs.LegendSlaughter,
	::Const.Perks.PerkDefs.LegendFreedomOfMovement,
	::Const.Perks.PerkDefs.LegendMuscularity,
	::Const.Perks.PerkDefs.LastStand,
	::Const.Perks.PerkDefs.Rebound,
	::Const.Perks.PerkDefs.BattleFlow,
],
];

::Const.HumanoidBeast <- [
	::Const.EntityType.Alp,
	::Const.EntityType.SchratSmall,
	::Const.EntityType.LegendDemonAlp,
	::Const.EntityType.LegendGreenwoodSchratSmall,
];

::Const.BeastHasAoE <- [
	::Const.EntityType.Unhold,
	::Const.EntityType.UnholdFrost,
	::Const.EntityType.UnholdBog,
	::Const.EntityType.BarbarianUnhold,
	::Const.EntityType.BarbarianUnholdFrost,
	::Const.EntityType.LegendRockUnhold,
	::Const.EntityType.Lindwurm,
	::Const.EntityType.LegendStollwurm,
	::Const.EntityType.Schrat,
	::Const.EntityType.LegendGreenwoodSchrat,
	::Const.EntityType.LegendSkinGhoul,
	::Const.EntityType.LegendBear,
];

::Const.BeastNeverHasNimble <- [
	::Const.EntityType.Unhold,
	::Const.EntityType.UnholdFrost,
	::Const.EntityType.UnholdBog,
	::Const.EntityType.BarbarianUnhold,
	::Const.EntityType.BarbarianUnholdFrost,
	::Const.EntityType.LegendRockUnhold,
	::Const.EntityType.Lindwurm,
	::Const.EntityType.LegendStollwurm,
	::Const.EntityType.Schrat,
	::Const.EntityType.LegendGreenwoodSchrat,
	::Const.EntityType.LegendSkinGhoul,
	::Const.EntityType.TricksterGod,
];

::Const.PerkDefaultPerRow <- [
	6,
	6,
	7,
	9,
	5,
	4,
	4
];

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// identifier for good nature stuffs
::Const.WitchHaters <- [
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
::Const.GoodMoralReputaions <- [
	"Chivalrous",
	"Saintly"
];
::Const.GoodOrigins <- [
	"scenario.legends_crusader",
	"scenario.legends_inquisition",
	"scenario.sato_escaped_slaves",
	"scenario.paladins",
];	


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// equimemnt restriction
::Const.Items.NotForGoblinArmorList <- [
	"armor.body.legend_orc_behemoth_armor",
	"armor.body.orc_berserker_light_armor",
	"armor.body.orc_berserker_medium_armor",
	"armor.body.orc_elite_heavy_armor",
	"armor.body.orc_warlord_armor",
	"armor.body.orc_warrior_heavy_armor",
	"armor.body.orc_warrior_light_armor",
	"armor.body.orc_warrior_medium_armor",
	"armor.body.orc_young_heavy_armor",
	"armor.body.orc_young_light_armor",
	"armor.body.orc_young_medium_armor",
	"armor.body.orc_young_very_light_armor",
	"armor.body.unhold_armor_heavy",
	"armor.body.unhold_armor_light",
];
::Const.Items.NotForGoblinHelmetList <- [
	"armor.head.orc_berserker_helmet",
	"armor.head.orc_warrior_heavy_helmet",
	"armor.head.orc_warrior_light_helmet",
	"armor.head.orc_warrior_medium_helmet",
	"armor.head.orc_young_heavy_helmet",
	"armor.head.orc_young_light_helmet",
	"armor.head.orc_young_medium_helmet",
	"armor.head.orc_elite_heavy_helmet",
	"armor.head.legend_orc_behemoth_helmet",
	"armor.head.orc_warlord_helmet",
	"armor.head.unhold_helmet_heavy",
	"armor.head.unhold_helmet_light",
];

::Const.Items.NotForOrcArmorList <- [
	"armor.body.legend_orc_behemoth_armor",
	"armor.body.orc_warlord_armor",
	"armor.body.goblin_heavy_armor",
	"armor.body.goblin_leader_armor",
	"armor.body.goblin_light_armor",
	"armor.body.goblin_medium_armor",
	"armor.body.goblin_shaman_armor",
	"armor.body.goblin_skirmisher_armor",
	"armor.body.unhold_armor_heavy",
	"armor.body.unhold_armor_light",
];
::Const.Items.NotForOrcHelmetList <- [
	"armor.head.goblin_heavy_helmet",
	"armor.head.goblin_leader_helmet",
	"armor.head.goblin_light_helmet",
	"armor.head.goblin_shaman_helmet",
	"armor.head.goblin_skirmisher_helmet",
	"armor.head.unhold_helmet_heavy",
	"armor.head.unhold_helmet_light",
];

::Const.Items.NotForHumanArmorList <- [
	"armor.body.legend_orc_behemoth_armor",
	"armor.body.orc_berserker_light_armor",
	"armor.body.orc_berserker_medium_armor",
	"armor.body.orc_elite_heavy_armor",
	"armor.body.orc_warlord_armor",
	"armor.body.orc_warrior_heavy_armor",
	"armor.body.orc_warrior_light_armor",
	"armor.body.orc_warrior_medium_armor",
	"armor.body.orc_young_heavy_armor",
	"armor.body.orc_young_light_armor",
	"armor.body.orc_young_medium_armor",
	"armor.body.orc_young_very_light_armor",
	"armor.body.goblin_heavy_armor",
	"armor.body.goblin_leader_armor",
	"armor.body.goblin_light_armor",
	"armor.body.goblin_medium_armor",
	"armor.body.goblin_shaman_armor",
	"armor.body.goblin_skirmisher_armor",
	"armor.body.unhold_armor_heavy",
	"armor.body.unhold_armor_light",
];
::Const.Items.NotForHumanHelmetList <- [
	"armor.head.orc_berserker_helmet",
	"armor.head.orc_warrior_heavy_helmet",
	"armor.head.orc_warrior_light_helmet",
	"armor.head.orc_warrior_medium_helmet",
	"armor.head.orc_young_heavy_helmet",
	"armor.head.orc_young_light_helmet",
	"armor.head.orc_young_medium_helmet",
	"armor.head.orc_elite_heavy_helmet",
	"armor.head.legend_orc_behemoth_helmet",
	"armor.head.orc_warlord_helmet",
	"armor.head.goblin_heavy_helmet",
	"armor.head.goblin_leader_helmet",
	"armor.head.goblin_light_helmet",
	"armor.head.goblin_shaman_helmet",
	"armor.head.goblin_skirmisher_helmet",
	"armor.head.unhold_helmet_heavy",
	"armor.head.unhold_helmet_light",
];
::Const.Items.NotForUnholdHelmetList <- [
	"armor.head.orc_berserker_helmet",
	"armor.head.orc_warrior_heavy_helmet",
	"armor.head.orc_warrior_light_helmet",
	"armor.head.orc_warrior_medium_helmet",
	"armor.head.orc_young_heavy_helmet",
	"armor.head.orc_young_light_helmet",
	"armor.head.orc_young_medium_helmet",
	"armor.head.orc_elite_heavy_helmet",
	"armor.head.legend_orc_behemoth_helmet",
	"armor.head.orc_warlord_helmet",
	"armor.head.goblin_heavy_helmet",
	"armor.head.goblin_leader_helmet",
	"armor.head.goblin_light_helmet",
	"armor.head.goblin_shaman_helmet",
	"armor.head.goblin_skirmisher_helmet",
];

/*
local gt = this.getroottable();
local lich_armor = { 
    ID = "ancient/nggh_ancient_lich_attire", // 60
    Script = "",
    Sets = [{
        Cloth = [
        	[1, "cloth/legend_gladiator_harness"]
        ],
        Chain = [
        ],
        Plate = [
        ],
        Cloak = [
			[1, "cloak/nggh_ancient_lich_attire"]        
        ],
        Tabard = [
        ],
        Attachments =[
        ]
    }]
};
local lich_helmet = {
    ID = "ancient/nggh_ancient_lich_headpiece", 
    Script = "",
    Sets = [{
        Hoods = [
            [1, "hood/legend_helmet_southern_headband_coin"]
        ],
        Helms = [
            [1, "helm/legend_helmet_sallet"] //50, -2
        ],
        Tops = [
        ],
        Vanity = [
        	[1, "vanity/nggh_ancient_lich_headpiece"] //25, 0
        ]
    }]
}

gt.Const.LegendMod.ArmorObjs.push(lich_armor);
gt.Const.LegendMod.Armors[lich_armor.ID] <- lich_armor;
gt.Const.LegendMod.HelmObjs.push(lich_helmet);
gt.Const.LegendMod.Helmets[lich_helmet.ID] <- lich_helmet;


//
local pretext = "scripts/";
local ancient_weapons = this.IO.enumerateFiles(pretext + "items/weapons/ancient/");
ancient_weapons.extend([
	"items/weapons/named/legend_named_gladius",
	"items/weapons/named/named_bladed_pike",
	"items/weapons/named/named_crypt_cleaver",
	"items/weapons/named/named_khopesh",
	"items/weapons/named/named_legend_great_khopesh",
	"items/weapons/named/named_warscythe",
]);

foreach (directory in ancient_weapons)
{
	local idx = directory.find(pretext);

	if (idx != null)
	{
		directory = directory.slice(idx + pretext.len());
	}

	::mods_hookNewObject(directory, function(obj) 
	{
		obj.addItemType(this.Const.Items.ItemType.Ancient);
	});
}
*/

::Const.LuftTips <- [
	"They say [color=#bcad8c]Ijirok[/color] can be charmed or just put IJIROK to the seed.",
	"I heard there is an ultimate [color=#bcad8c]Simp[/color] level earned by love and rejection.",
	"Necro told me, Spiders may guide you to their [color=#bcad8c]Nest[/color] while traveling through forest.",
	"Gosh! I wish i would be jumped scared by a burrowed Stollwurm in a middle of combat. It would be fun to see, i\'m telling you.",
	"I had a dream about a necromancer origin where you can collect body parts to make your own undead. It likes something coming out of frankenstein movie. I\'m not hating it, switching body parts seems fun to me.",
	"It\' best to keep a spare named item in your stash. You never know you will meet someone willing to make a deal for it."
	//A wise man once told me, [color=#bcad8c]Credits[/color] can lead you to a secret.
]