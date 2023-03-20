::mods_hookExactClass("ai/tactical/behaviors/ai_engage_ranged", function(obj) 
{
	obj.m.PossibleSkills.extend([
		"actives.legend_magic_missile",
		"actives.legend_chain_lightning",
	]);
});