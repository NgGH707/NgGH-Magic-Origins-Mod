::Nggh_MagicConcept.HooksMod.hook("scripts/skills/effects/spider_poison_effect", function(q) 
{
	q.m.IsSuperPoison <- false;
	
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (!m.IsSuperPoison)
			return;

		_properties.IsWeakenByPoison = true;
		_properties.FatigueEffectMult *= 1.05;
	}
	
});