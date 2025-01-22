::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/werewolf_bite", function ( q )
{
	q.m.IsRestrained <- false;
	q.m.IsSpent <- false;
	q.m.IsFrenzied <- false;

	q.create = @(__original) function()
	{
		__original();
		m.Description = "Tear an enemy assunder with your teeth";
		m.Icon = "skills/active_71.png";
		m.IconDisabled = "skills/active_71_bw.png";
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

	q.onAdded <- function()
	{
		m.IsFrenzied = getContainer().getActor().getFlags().has("frenzy");
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		if (m.IsRestrained)
			m.IsSpent = true;

		return __original(_user, _targetTile);
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			removeMainhandBonuses(_properties);
			_properties.DamageRegularMin += 30;
			_properties.DamageRegularMax += 50;
			_properties.DamageArmorMult *= 0.75;

			if (m.IsFrenzied && m.IsRestrained)
				_properties.DamageTotalMult *= 1.25;

			if (getContainer().getActor().isDoubleGrippingWeapon())
				_properties.DamageTotalMult /= 1.25;
		}
	}

	q.onUpdate = @() function( _properties ) 
	{
	}
	
});