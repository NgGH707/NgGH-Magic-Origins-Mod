::mods_hookExactClass("skills/perks/perk_legend_ubernimble", function(obj) 
{
	obj.m.IsForceEnabled <- false;

	local ws_getTooltip = obj.getTooltip;
	obj.getTooltip = function()
	{
		if (this.m.IsForceEnabled)
		{
			local tooltip = this.skill.getTooltip();
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Only receive [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.round(this.getChance() * 100) + "%[/color] of any damage to hitpoints from attacks"
			});
			return tooltip;
		}

		return ws_getTooltip();
	}

	local ws_onBeforeDamageReceived = obj.onBeforeDamageReceived;
	obj.onBeforeDamageReceived = function( _attacker, _skill, _hitInfo, _properties )
	{
		if (this.m.IsForceEnabled)
		{
			_properties.DamageReceivedRegularMult *= this.getChance();
			return;
		}

		ws_onBeforeDamageReceived(_attacker, _skill, _hitInfo, _properties);
	}
});