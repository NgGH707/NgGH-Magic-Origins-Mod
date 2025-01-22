::Nggh_MagicConcept.HooksMod.hook("scripts/ai/tactical/behaviors/ai_darkflight", function ( q )
{
	q.m.PossibleSkills.extend([
		"actives.alp_teleport",
		"actives.legend_darkflight"
	]);
});