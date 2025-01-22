::Nggh_MagicConcept.HooksMod.hook("scripts/ai/tactical/behaviors/ai_warcry", function ( q )
{
	q.m.PossibleSkills.extend([
		"actives.frenzy",
		"actives.intimidate"
	]);
});