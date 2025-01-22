::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_sundering_strikes", function(q) {
	q.create = @(__original) function()
	{
		__original();
		m.Order = ::Const.SkillOrder.Last;
	}
})