::mods_hookExactClass("ai/tactical/behaviors/ai_attack_throw_net", function(obj) 
{
	obj.m.PossibleSkills.extend([
		"actives.mage_legend_magic_web_bolt",
	]);
});