::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_bear_claws_skill", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.ActionPointCost = 4;
	}
	
});