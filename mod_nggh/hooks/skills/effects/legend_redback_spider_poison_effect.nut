::Nggh_MagicConcept.HooksMod.hook("scripts/skills/effects/legend_redback_spider_poison_effect", function(q) 
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

   	q.applyDamage = @(__original) function()
	{
		local originalDamage = m.Damage;

		if (m.IsSuperPoison) m.Damage *= 2.0;

		__original();

		m.Damage = originalDamage;
	}
});