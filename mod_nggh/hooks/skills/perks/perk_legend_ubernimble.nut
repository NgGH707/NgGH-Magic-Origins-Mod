::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_legend_ubernimble", function(q) 
{
	q.m.IsForceEnabled <- false;

	q.getTooltip = @(__original) function()
	{
		if (m.IsForceEnabled)
		{
			local tooltip = skill.getTooltip();
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Only receive [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.round(getChance() * 100) + "%[/color] of any damage to hitpoints from attacks"
			});
			return tooltip;
		}

		return __original();
	}

	q.onBeforeDamageReceived = @(__original) function( _attacker, _skill, _hitInfo, _properties )
	{
		if (m.IsForceEnabled) {
			_properties.DamageReceivedRegularMult *= getChance();
			return;
		}

		__original(_attacker, _skill, _hitInfo, _properties);
	}
});