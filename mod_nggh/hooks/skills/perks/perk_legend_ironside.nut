::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_legend_ironside", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
	}

	q.getBonus = function()
	{
		return getContainer().getActor().isPlacedOnMap() ? getContainer().getActor().getSurroundedCount() * 0.05 : 0;
	}

	q.onBeforeDamageReceived = function( _attacker, _skill, _hitInfo, _properties )
	{
		_properties.DamageReceivedTotalMult *= 1.0 - getBonus();
	}
});