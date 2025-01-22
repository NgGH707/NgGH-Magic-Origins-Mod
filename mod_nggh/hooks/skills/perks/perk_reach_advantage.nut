::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_reach_advantage", function(q) 
{
	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (getContainer().getActor().getFlags().has("lindwurm") && _skill != null && _skill.getID() != "actives.spit_acid") {
			m.Stacks = ::Math.min(m.Stacks + 1, 5);
			return;
		}

		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
	}

	q.onUpdate = @(__original) function( _properties )
	{
		m.IsHidden = m.Stacks == 0;

		if (getContainer().getActor().getFlags().has("lindwurm")) {
			_properties.MeleeDefense += m.Stacks * 5;
			return;
		}

		__original(_properties);
	}
});