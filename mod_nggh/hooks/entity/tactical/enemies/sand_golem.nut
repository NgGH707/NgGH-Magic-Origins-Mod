::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/sand_golem", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Flags.add("sand_golem");
	}

});