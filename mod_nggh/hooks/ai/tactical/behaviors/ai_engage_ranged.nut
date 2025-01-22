::Nggh_MagicConcept.HooksMod.hook("scripts/ai/tactical/behaviors/ai_engage_ranged", function(q) 
{
	q.m.PossibleSkills.extend([
		"actives.legend_magic_missile",
		"actives.legend_chain_lightning",
	]);
});