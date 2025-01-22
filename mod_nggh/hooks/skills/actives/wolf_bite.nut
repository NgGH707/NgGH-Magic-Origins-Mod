::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/wolf_bite", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Wolf Bite";
		m.Description = "Ripping off your enemy face with your powerful wolf jaw. Do poorly against armor.";
		m.KilledString = "Mangled";
		m.Icon = "skills/active_71.png";
		m.IconDisabled = "skills/active_71_sw.png";
	}

	q.isIgnoredAsAOO <- function()
	{
		return !m.IsRestrained ? m.IsIgnoredAsAOO : !getContainer().getActor().isArmedWithRangedWeapon();
	}
	
	q.getTooltip <- function()
	{
		return getDefaultTooltip();
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInSwords ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			removeMainhandBonuses(_properties);
			_properties.DamageRegularMin += 20;
			_properties.DamageRegularMax += 40;
			_properties.DamageArmorMult *= 0.4;
			
			if (getContainer().getActor().isDoubleGrippingWeapon())
				_properties.DamageTotalMult /= 1.25;
		}
	}

	q.onUpdate = @() function( _properties ) 
	{
	}

});