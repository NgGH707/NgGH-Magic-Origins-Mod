::mods_hookExactClass("ai/tactical/behaviors/ai_attack_bow", function(obj) 
{
	obj.m.PossibleSkills.extend([
		"actives.legend_magic_missile",
		"actives.legend_chain_lightning",
	]);
});