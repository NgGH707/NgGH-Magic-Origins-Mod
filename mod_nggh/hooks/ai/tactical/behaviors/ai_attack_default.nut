::Nggh_MagicConcept.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_default", function ( q )
{
	q.m.PossibleSkills.extend([
		"actives.unhold_hand_to_hand",
		"actives.spit_acid",
		"actives.mind_break",
		//"actives.death",
	]);

});