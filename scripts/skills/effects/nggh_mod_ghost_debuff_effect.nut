this.nggh_mod_ghost_debuff_effect <- ::inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 4,
	},
	function create()
	{
		m.ID = "effects.ghost_debuff";
		m.Name = "Ooooh! You Have Been Spooked";
		m.Overlay = "status_effect_70";
		m.Type = ::Const.SkillType.Special;
		m.IsRemovedAfterBattle = true;
		m.IsStacking = true;
		m.IsActive = false;
		m.IsHidden = true;
	}

	/* maybe not lol
	function onAdded()
	{
		if (getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && ::Math.rand(1, 100) <= 50)
			removeSelf();
		else
			m.TurnsLeft = ::Math.max(1, 2 + getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
	}
	*/

	function onUpdate( _properties )
	{
		_properties.Bravery -= 5;
		_properties.TotalAttackToHitMult *= 0.95;
		_properties.SurroundedDefense -= 2;
	}

	function onTurnEnd()
	{
		if (--m.TurnsLeft <= 0)
			removeSelf();
	}

});

