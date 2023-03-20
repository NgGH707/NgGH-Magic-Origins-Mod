::mods_hookExactClass("ai/tactical/behaviors/ai_warcry", function ( obj )
{
	obj.m.PossibleSkills.extend([
		"actives.frenzy",
		"actives.intimidate"
	]);
});