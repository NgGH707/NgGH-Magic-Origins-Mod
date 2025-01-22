::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/fling_back_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Grab a target and throw them behind you in order to advance forward. Can be used on allies.";
		m.Icon = "skills/active_111.png";
		m.IconDisabled = "skills/active_111_sw.png";
		m.IsIgnoringRiposte = true;
		m.IsSpearwallRelevant = false;
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Throws[/color] an target away and [color=" + ::Const.UI.Color.PositiveValue + "]Steps Forward[/color]"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Deals [color=" + ::Const.UI.Color.NegativeValue + "]Fall Damage[/color] depending on the [color=" + ::Const.UI.Color.NegativeValue + "]Height[/color]"
			}
		]);

		if (isUpgraded())
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]100%[/color] chance to daze"
			});
		
		return ret;
	}

	q.isUpgraded <- function()
	{
		return getContainer().getActor().getCurrentProperties().IsSpecializedInThrowing;
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInThrowing ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;

		if (_properties.IsSpecializedInThrowing)
			m.ActionPointCost -= 1;
	}

	q.onKnockedDown = @(__original) function( _entity, _tag )
	{
		local isSpecialized = _tag.Skill.isUpgraded();

		if (_tag.HitInfo.DamageRegular > 0 && isSpecialized)
			_tag.HitInfo.DamageRegular *= 2.0;

		__original(_entity, _tag);

		if (_tag.HitInfo.DamageInflictedHitpoints <= 0)
			return;

		if (typeof _tag.Attacker == "instance" && _tag.Attacker.isNull() || !_tag.Attacker.isAlive() || _tag.Attacker.isDying())
			return;
		
		_tag.Skill.getContainer().onTargetHit(_tag.Skill, _entity, _tag.HitInfo.BodyPart, _tag.HitInfo.DamageInflictedHitpoints, _tag.HitInfo.DamageInflictedArmor);

		if (isSpecialized && _entity.isAlive() && !_entity.isDying() && !_entity.getCurrentProperties().IsImmuneToDaze) {
			_entity.getSkills().add(::new("scripts/skills/effects/dazed_effect"));

			if (!_entity.isHiddenToPlayer())
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_tag.Attacker) + " has dazed " + ::Const.UI.getColorizedEntityName(_entity) + " for one turn");
		}
	}

	q.onTargetSelected <- function( _targetTile )
	{
		local knockToTile = findTileToKnockBackTo(getContainer().getActor().getTile(), _targetTile);

		if (knockToTile != null)
			::Tactical.getHighlighter().addOverlayIcon("mortar_target_02", knockToTile, knockToTile.Pos.X, knockToTile.Pos.Y);
	}
});