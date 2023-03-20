::mods_hookExactClass("ai/tactical/behaviors/ai_attack_default", function ( obj )
{
	obj.m.PossibleSkills.extend([
		"actives.unhold_hand_to_hand",
		"actives.spit_acid",
		"actives.mind_break",
		"actives.death",
	]);
});