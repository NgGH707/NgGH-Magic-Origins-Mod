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
	MovementSpeedMult = 5.0,
	VisibilityMult = 1.0,
	VisionMult = 99.0,
	Body = "figure_noble_02",
	MinR = 75,
	MaxR = 690,
	Troops = [
		{
			Weight = 50,
			Types = [
				{
					MaxR = 400,
					Type = ::Const.World.Spawn.Troops.MercenaryLOW,
					Cost = 18
				},
				{
					Type = ::Const.World.Spawn.Troops.Mercenary,
					Cost = 25
				}
			]
		},
		{
			Weight = 22,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.LegendPeasantWitchHunter,
					Cost = 20
				}
			]
		},
		{
			Weight = 12,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.LegendPeasantMonk,
					Cost = 20
				},
				{
					Type = ::Const.World.Spawn.Troops.MercenaryRanged,
					Cost = 25
				}
			]
		},
		{
			Weight = 5,
			Types = [
				{
					Type = ::Const.World.Spawn.Troops.ArmoredWardog,
					Cost = 5
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