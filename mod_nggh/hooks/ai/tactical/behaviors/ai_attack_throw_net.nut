::Nggh_MagicConcept.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_throw_net", function(q) 
{
	q.m.PossibleSkills.extend([
		"actives.legend_magic_web_bolt",
	]);
});