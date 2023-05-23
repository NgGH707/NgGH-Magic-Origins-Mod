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

// new tactical effects
::Const.World.Spawn.Nggh_WitchHunter <- {
	Name = "WitchHunter",
	IsDynamic = true,
	MovementSpeedMult = 1.15,
	VisibilityMult = 0.9,
	VisionMult = 99.0,
	Body = "figure_noble_02",
	MinR = 69, // funny number :3
	MaxR = 969, 
	Troops = [
		{
			Weight = 39,
			Types = [
				{
					MaxR = 400,
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
			Weight = 39,
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
			Weight = 4,
			MinR = 250,
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
		{
			Weight = 3,
			MinR = 250,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.Inquisitor,
					Cost = 40
				}
			]
		},
	]
};