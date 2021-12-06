local gt = this.getroottable();

if (!("World" in gt.Const))
{
	gt.Const.World <- {};
}

if (!("Spawn" in gt.Const.World))
{
	gt.Const.World.Spawn <- {};
}

gt.Const.World.Spawn.MC_WitchHunter <- {
	Name = "MC_WitchHunter",
	IsDynamic = true,
	MovementSpeedMult = 1.0,
	VisibilityMult = 1.0,
	VisionMult = 1.0,
	Body = "figure_noble_02",
	MinR = 75,
	MaxR = 555,
	Troops = [
		{
			Weight = 52,
			Types = [
				{
					Type = this.Const.World.Spawn.Troops.Mercenary,
					Cost = 25
				}
			]
		},
		{
			Weight = 23,
			Types = [
				{
					Type = this.Const.World.Spawn.Troops.LegendPeasantWitchHunter,
					Cost = 20
				}
			]
		},
		{
			Weight = 12,
			Types = [
				{
					Type = this.Const.World.Spawn.Troops.LegendPeasantMonk,
					Cost = 20
				},
				{
					Type = this.Const.World.Spawn.Troops.MercenaryRanged,
					Cost = 25
				}
			]
		},
		{
			Weight = 5,
			Types = [
				{
					Type = this.Const.World.Spawn.Troops.ArmoredWardog,
					Cost = 5
				}
			]
		},
		{
			Weight = 3,
			MinR = 0.5 * 555,
			Types = [
				{
					Type = this.Const.World.Spawn.Troops.HedgeKnight,
					Cost = 40
				},
				{
					Type = this.Const.World.Spawn.Troops.Swordmaster,
					Cost = 40
				},
				{
					Type = this.Const.World.Spawn.Troops.MasterArcher,
					Cost = 40
				}
			]
		},
	]
};