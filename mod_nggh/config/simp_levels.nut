if (!("Simp" in ::Const))
{
	::Const.Simp <- {};
}

::Const.Simp.MaximumLevel <- 10;
::Const.Simp.DefaultBonusValue <- 0.05;
::Const.Simp.DefaultBonusTooltipValue <- 5;

::Const.Simp.Bonuses <- [
	[/* Property */"",   /* Property Name */"",  /* Icon */"" ],
	["BraveryMult",          "Resolve",         "bravery"     ],
	["XPGainMult",           "Experience Gain", "xp_received" ],
	["InitiativeMult",       "Initiative",      "initiative"  ],
	["StaminaMult",          "Max Fatigue",     "fatigue"     ],
	["BraveryMult",          "Resolve",         "bravery"     ],
	["HitpointsMult",        "Hitpoints",       "health"      ],
	["TotalAttackToHitMult", "Hit Chance",      "hitchance"   ],
	["DamageTotalMult",      "Attack Damage",   "damage_dealt"],
	["BraveryMult",          "Resolve",         "bravery"     ],
	["InitiativeMult",       "Initiative",      "initiative"  ],
];

::Const.Simp.SpecialBonuses <- [
	["DamageTotalMult",      "Attack Damage",   "damage_dealt",  5],
	[  "HitpointsMult",          "Hitpoints",         "health", 10]
]