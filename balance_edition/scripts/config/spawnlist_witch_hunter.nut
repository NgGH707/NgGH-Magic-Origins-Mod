local gt = this.getroottable();

if (!("World" in gt.Const))
{
	gt.Const.World <- {};
}

if (!("Spawn" in gt.Const.World))
{
	gt.Const.World.Spawn <- {};
}

gt.Const.World.Spawn.WitchHunter <- {
	Name = "WitchHunter",
	IsDynamic = true,
	MovementSpeedMult = 1.0,
	VisibilityMult = 1.0,
	VisionMult = 1.0,
	Body = "figure_noble_02",
	MaxR = 530,
	MinR = 55,
	Fixed = [
		{
			Weight = 100,
			Type = this.Const.World.Spawn.Troops.LegendPeasantWitchHunter,
			Cost = 20
		}
	],
	Troops = [
		{
			Weight = 60,
			Types = [
				{
					MaxR = 400,
					Type = this.Const.World.Spawn.Troops.MercenaryLOW,
					Cost = 18
				},
				{
					Type = this.Const.World.Spawn.Troops.Mercenary,
					Cost = 25
				}
			]
		},
		{
			Weight = 5,
			Types = [
				{
					Type = this.Const.World.Spawn.Troops.Wardog,
					Cost = 8
				}
			]
		},
		{
			Weight = 15,
			Types = [
				{
					Type = this.Const.World.Spawn.Troops.LegendPeasantWitchHunter,
					Cost = 20
				},
				{
					Type = this.Const.World.Spawn.Troops.MasterArcher,
					Cost = 40
				}
			]
		},
		{
			Weight = 15,
			MinR = 0.5 * 385,
			Types = [
				{
					Type = this.Const.World.Spawn.Troops.LegendPeasantMonk,
					Cost = 20
				},
			]
		},
		{
			Weight = 5,
			Types = [
				{
					Type = this.Const.World.Spawn.Troops.HedgeKnight,
					Cost = 40
				},
				{
					Type = this.Const.World.Spawn.Troops.Swordmaster,
					Cost = 40
				}
			]
		}
	]
};

