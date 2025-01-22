::Nggh_MagicConcept.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_bow", function(q) 
{
	q.m.PossibleSkills.extend([
		"actives.legend_magic_missile",
		"actives.legend_chain_lightning",
	]);
});