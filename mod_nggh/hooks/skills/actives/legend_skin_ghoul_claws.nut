::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_skin_ghoul_claws", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Order = ::Const.SkillOrder.OffensiveTargeted + 3;
		m.IsIgnoredAsAOO = true;
	}

	q.isHidden <- function()
	{
		return getContainer().getActor().getMainhandItem() != null && !getContainer().hasSkill("effects.disarmed") || skill.isHidden();
	}

	q.onAdded <- function()
	{
		getContainer().add(::new("scripts/skills/actives/nggh_mod_ghoul_claws_zoc"));
	}

	q.getTooltip = @() function()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can hit up to 3 targets"
			}
		]);
		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		if (!isHidden())
			__original(_properties);
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInShields ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	q.use <- function( _targetTile, _forFree = false )
	{
		if (getContainer().getActor().getFlags().has("luft"))
			::Nggh_MagicConcept.spawnQuote("luft_claw_quote_" + ::Math.rand(1, 5), getContainer().getActor().getTile());

		return skill.use(_targetTile, _forFree);
	};
});