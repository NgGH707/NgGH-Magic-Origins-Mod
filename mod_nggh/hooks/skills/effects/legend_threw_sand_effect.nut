::Nggh_MagicConcept.HooksMod.hook("scripts/skills/effects/legend_threw_sand_effect", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.IsHidden = true;
	}
});