::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/warhound_bite", function ( q )
{
	q.m.IsRestrained <- false;
	q.m.IsSpent <- false;

	q.create = @(__original) function()
	{
		__original();
		m.Name = "Warhound Bite";
		m.Description = "Ripping off your enemy face with your powerful hound jaw. Do poorly against armor.";
		m.Icon = "skills/active_164.png";
		m.IconDisabled = "skills/active_164_sw.png";
		m.Order = ::Const.SkillOrder.OffensiveTargeted + 5;
	}

	q.setRestrained <- function( _f )
	{
		m.IsRestrained = _f;
	}

	q.isIgnoredAsAOO <- function()
	{
		return !m.IsRestrained ? m.IsIgnoredAsAOO : !getContainer().getActor().isArmedWithRangedWeapon();
	}

	q.isUsable <- function()
	{
		return skill.isUsable() && !m.IsSpent;
	}

	q.onTurnStart <- function()
	{
		m.IsSpent = false;
	}

	q.getTooltip <- function()
	{
		return getDefaultTooltip();
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		if (m.IsRestrained)
			m.IsSpent = true;

		return __original(_user, _targetTile);
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
			_properties.DamageRegularMin += 25;
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