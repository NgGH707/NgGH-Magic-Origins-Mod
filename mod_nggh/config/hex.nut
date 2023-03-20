if (!("Hex" in ::Const))
{
	::Const.Hex <- {};
}

::Const.Hex.PerksToQuery <- [
	"perk.hex_share_the_pain",
	"perk.hex_mastery",
];

::Const.Hex.UniquePerksToQuery <- [
	"perk.hex_suffering",
	"perk.hex_weakening",
	"perk.hex_vulnerability",
	"perk.hex_misfortune"
];

::Const.Hex.Suffering_AffectedEffects <- [
	"effects.acid",
	"effects.bleeding",
	"effects.chilled",
	"effects.dazed",
	"effects.debilitated",
	"effects.disarmed",
	"effects.distracted",
	"effects.goblin_poison",
	"effects.insect_swarm",
	"effects.legend_baffled",
	"effects.legend_dazed",
	"effects.legend_grazed_effect",
	"effects.legend_redback_spider_poison",
	"effects.mummy_curse"
	"effects.shellshocked",
	"effects.spider_poison",
	"effects.staggered",
	"effects.stunned",
	"effects.withered",
];

::Const.Hex.Type <- {
	Default = 0,
	Suffering = 1,
	Weakening = 2,
	Vulnerability = 3,
	Misfortune = 4,
	COUNT = 5
}