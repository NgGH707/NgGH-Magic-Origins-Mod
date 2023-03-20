::mods_hookExactClass("ai/tactical/behaviors/ai_darkflight", function ( obj )
{
	obj.m.PossibleSkills.extend([
		"actives.alp_teleport",
		"actives.legend_darkflight"
	]);
});