::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_white_wolf_bite_skill", function ( q )
{
	q.m.IsRestrained <- false;
	q.m.IsSpent <- false;

	q.create = @(__original) function()
	{
		__original();
		m.Description = "Ripping off your enemy face with your powerful white wolf jaw.";
		m.Icon = "skills/active_71.png";
		m.IconDisabled = "skills/active_71_sw.png";
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

	q.isHidden <- function()
	{
		return getContainer().hasSkill("actives.werewolf_bite");
	}

	q.getTooltip <- function()
	{
		return getDefaultTooltip();
	}

	q.onUpdate = @(__original) function( _properties )
	{
		if (!m.IsRestrained)
			__original(_properties);
	}

	q.onAfterUpdate <- function( _properties )
	{
		if (!::MSU.isKindOf(getContainer().getActor(), "player"))
			return;

		m.ActionPointCost += 2;
		m.FatigueCostMult *= 2.0;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		if (m.IsRestrained) m.IsSpent = true;
		return __original(_user, _targetTile);
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == this && m.IsRestrained)
		{
			removeMainhandBonuses(_properties);
			_properties.DamageRegularMin += 45;
			_properties.DamageRegularMax += 75;
			_properties.DamageArmorMult *= 1.0;
			
			if (getContainer().getActor().isDoubleGrippingWeapon())
				_properties.DamageTotalMult /= 1.25;
		}
	}
});