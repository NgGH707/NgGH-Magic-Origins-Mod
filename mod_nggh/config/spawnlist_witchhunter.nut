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
			MinCount = 1,
			MaxCount = 2,
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
			MinCount = 1,
			MaxCount = 1,
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


local files = ::IO.enumerateFiles("mod_legends/afterHooks");

if (files == null || files.len() == 0)
	return;

local notFound = true;
foreach (script in files)
{
	if (script.find("/afterHooks/update_spawnlist") != null) {
		notFound = false;
		break;
	}
}

if (!notFound)
	return;

function onCostCompare( _t1, _t2 )
{
	if (_t1.Cost < _t2.Cost)
		return -1;
	else if (_t1.Cost > _t2.Cost)
		return 1;
	return 0;
}

foreach(k in [
	"Nggh_WitchHunter",
	"Nggh_WitchHunterAndNoble"
])
{
	local v = ::Const.World.Spawn[k];

	//this.logInfo("Calculating costs for " + k)
	foreach (i, _t in v.Troops)
	{
		local costMap = {}
		foreach (tt in _t.Types) {
			if (!(tt.Cost in costMap)) {
				costMap[tt.Cost] <- []
			}
			costMap[tt.Cost].append(tt)
		}

		_t.SortedTypes <- [];

		foreach (k,v in costMap) {
			_t.SortedTypes.append({
				Cost = k,
				Types = v
			})
		}

		if (_t.SortedTypes.len() == 1)
		{
			continue;
		}

		_t.SortedTypes.sort(this.onCostCompare);

		//v.Troops[i].SortedTypes.sort(this.onCostCompare)

		local mean = 0;
		local variance = 0;
		local deviation = 0;

		foreach (o in v.Troops[i].SortedTypes)
		{
			mean += o.Cost;
		}
		mean = (mean * 1.0) / ( v.Troops[i].SortedTypes.len() * 1.0);

		foreach (o in v.Troops[i].SortedTypes)
		{
			local d = o.Cost - mean;
			variance += (d * d);
		}
		variance = (variance * 1.0) / ( v.Troops[i].SortedTypes.len() * 1.0);
		deviation = this.Math.pow(variance, 0.5);


		v.Troops[i].Mean <- mean;
		v.Troops[i].Variance <- variance;
		v.Troops[i].Deviation <- deviation;
		v.Troops[i].MinMean <- v.Troops[i].SortedTypes[0].Cost - deviation;
		v.Troops[i].MaxMean <-  v.Troops[i].Types[v.Troops[i].SortedTypes.len() - 1].Cost + deviation;
		//this.logInfo(" mean  " + mean + " variance " + variance + " deviation " + deviation + " min " + v.Troops[i].MinMean + " max " + v.Troops[i].MaxMean)
	}
}