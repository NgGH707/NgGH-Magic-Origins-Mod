// new spawnlist
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
			Type = ::Const.World.Spawn.Troops.LegendPeasantWitchHunter,
			Cost = 0
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
					Cost = 20
				}
			]
		},
		{
			Weight = 15,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.MercenaryRanged,
					Cost = 20
				},
				{
					MaxCount = 2,
					Type = ::Const.World.Spawn.Troops.LegendPeasantMonk,
					Cost = 20
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
					Cost = 18
				}
			]
		},
		{
			Weight = 39,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.Footman,
					Cost = 15
				},
				{
					MaxCount = 1,
					Type = ::Const.World.Spawn.Troops.LegendPeasantMonk,
					Cost = 20
				},
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
			Weight = 4,
			MinR = 100,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.LegendNobleGuard,
					Cost = 60
				}
			]
		},
		{
			Weight = 1,
			MinR = 220,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.LegendManAtArms,
					Cost = 100
				}
			]
		}
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