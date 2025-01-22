::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/uproot_small_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Send out roots to hold and damage an enemy.";
		m.KilledString = "Crushed";
		m.Icon = "skills/active_122.png";
		m.IconDisabled = "skills/active_122_sw.png";
		m.Overlay = "active_122";
		m.IsAOE = false;
	}

	q.getTooltip <- function()
	{
		return getDefaultTooltip();
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInSpears ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;

		if (_properties.IsSpecializedInSpears) return;

		_properties.DamageRegularMin += 5;
		_properties.DamageRegularMax += 15;
	}
	
});