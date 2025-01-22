::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/hyena_bite_skill", function ( q )
{
	q.m.IsRestrained <- false;
	q.m.IsSpent <- false;
	q.m.IsFrenzied <- false;

	q.create = @(__original) function()
	{
		__original();
		m.Description = "Ripping off your enemy face with your powerful hyena jaw. Can easily cause bleeding.";
		m.Icon = "skills/active_197.png";
		m.IconDisabled = "skills/active_197_sw.png";
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

	q.onAdded <- function()
	{
		m.IsFrenzied = getContainer().getActor().getFlags().has("frenzy");
	}

	q.getTooltip <- function()
	{
		local damage = 5, ret = getDefaultTooltip();
		if (m.IsFrenzied || (::MSU.isIn("isHigh", getContainer().getActor(), true) && getContainer().getActor().isHigh())) damage += 5;
		if (getContainer().getActor().getCurrentProperties().IsSpecializedInCleavers) damage += 5;
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Inflicts additional stacking [color=" + ::Const.UI.Color.DamageValue + "]" + damage + "[/color] bleeding damage per turn, for 2 turns"
		});
		return ret;
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInCleavers ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		if (m.IsRestrained)
			m.IsSpent = true;

		local target = _targetTile.getEntity();
		local hp = target.getHitpoints();
		local ret = __original(_user, _targetTile);

		if (_user.getCurrentProperties().IsSpecializedInCleavers && ret && target.isAlive() && !target.isDying() && !target.getCurrentProperties().IsImmuneToBleeding && hp - target.getHitpoints() >= ::Const.Combat.MinDamageToApplyBleeding) {
			local effect = ::new("scripts/skills/effects/bleeding_effect");
			if (_user.getFaction() == ::Const.Faction.Player) effect.setActor(_user);
			target.getSkills().add(effect);
		}

		return ret;
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			removeMainhandBonuses(_properties);
			_properties.DamageRegularMin += 20;
			_properties.DamageRegularMax += 35;
			_properties.DamageArmorMult *= 0.7;

			if (m.IsFrenzied && m.IsRestrained)
				_properties.DamageTotalMult *= 1.25;

			if (getContainer().getActor().isDoubleGrippingWeapon())
				_properties.DamageTotalMult /= 1.25;
		}
	}

	q.onUpdate = @(__original) function( _properties ) 
	{
		__original(_properties);

		_properties.DamageRegularMin -= 20;
		_properties.DamageRegularMax -= 35;
	}
});