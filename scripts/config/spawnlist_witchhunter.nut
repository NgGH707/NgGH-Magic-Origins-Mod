// new troop
local inquisitor_titles = [];
inquisitor_titles.extend(::Const.Strings.WitchhunterTitles);
inquisitor_titles.extend(::Const.Strings.PilgrimTitles);

::Const.World.Spawn.Troops.Inquisitor <- {
	ID = ::Const.EntityType.Knight,
	Variant = 2,
	Strength = 40,
	Cost = 40,
	Row = 0,
	Script = "scripts/entity/tactical/humans/nggh_mod_inquisitor",
	NameList = ::Const.Strings.KnightNames,
	TitleList = inquisitor_titles
};

// change witch hunter strength rating
::Const.World.Spawn.Troops.LegendPeasantWitchHunter.Strength = 30;

// new tactical effects
::Const.World.Spawn.Nggh_WitchHunter <- {
	Name = "WitchHunter",
	IsDynamic = true,
	MovementSpeedMult = 1.15,
	VisibilityMult = 0.9,
	VisionMult = 99.0,
	Body = "figure_player_inquisition",
	MinR = 69, // funny number :3
	MaxR = 969,
	Fixed = [
		{
			Weight = 100 
			Type = ::Const.World.Spawn.Troops.Inquisitor,
			Cost = 40
		}
	],
	Troops = [
		{
			Weight = 40,
			Types = [
				{
					MaxR = 300,
					Type = ::Const.World.Spawn.Troops.MercenaryLOW,
					Cost = 18
				},
				{
					Type = ::Const.World.Spawn.Troops.Mercenary,
					Cost = 22
				}
			]
		},
		{
			Weight = 40,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.LegendPeasantWitchHunter,
					Cost = 15
				}
			]
		},
		{
			Weight = 15,
			Types = [
				{
					MaxCount = 2,
					Type = ::Const.World.Spawn.Troops.LegendPeasantMonk,
					Cost = 20
				},
				{
					Type = ::Const.World.Spawn.Troops.MercenaryRanged,
					Cost = 22
				}
			]
		},
		{
			Weight = 5,
			MinR = 400,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.Inquisitor,
					Cost = 40
				},
				{
					Type = ::Const.World.Spawn.Troops.HedgeKnight,
					Cost = 40
				},
				{
					Type = ::Const.World.Spawn.Troops.Swordmaster,
					Cost = 40
				},
				{
					Type = ::Const.World.Spawn.Troops.MasterArcher,
					Cost = 40
				}
			]
		},
	]
};

::Const.World.Spawn.Nggh_WitchHunterAndNoble <- {
	Name = "WitchHunter",
	IsDynamic = true,
	MovementSpeedMult = 1.15,
	VisibilityMult = 0.9,
	VisionMult = 99.0,
	Body = "figure_player_inquisition",
	MinR = 69, // funny number :3
	MaxR = 969,
	Fixed = [
		{
			Weight = 100 
			Type = ::Const.World.Spawn.Troops.StandardBearer,
			Cost = 20
		}
	],
	Troops = [
		{
			Weight = 50,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.LegendPeasantWitchHunter,
					Cost = 15
				}
			]
		},
		{
			Weight = 39,
			Types = [
				{
					MaxCount = 1,
					Type = ::Const.World.Spawn.Troops.LegendPeasantMonk,
					Cost = 20
				},
				{
					Type = ::Const.World.Spawn.Troops.Footman,
					Cost = 15
				}
			]
		},
		{
			Weight = 5,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.Greatsword,
					Cost = 30
				}
			]
		},
		{
			Weight = 5,
			Types = [
				{
					MaxCount = 3,
					Type = ::Const.World.Spawn.Troops.ArmoredWardog,
					Cost = 5
				}
			]
		},
		{
			Weight = 5,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.Greatsword,
					Cost = 30
				}
			]
		},
		{
			Weight = 3,
			MinR = 150,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.Sergeant,
					Cost = 40,
					Roll = true
				}
			]
		},
		{
			Weight = 3,
			MinR = 300,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.Inquisitor,
					Cost = 40,
					Roll = true
				}
			]
		},
	]
};