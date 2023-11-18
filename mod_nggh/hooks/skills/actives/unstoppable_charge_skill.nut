::mods_hookExactClass("skills/actives/unstoppable_charge_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Charge forward with unbeleivable speed and ram at enemy formation. Can cause knock back or stun. Can not be used in melee.";
		this.m.Icon = "skills/active_110.png";
		this.m.IconDisabled = "skills/active_110_sw.png";
	};
	obj.getTooltip = function()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "May [color=" + ::Const.UI.Color.PositiveValue + "]Stun[/color] or [color=" + ::Const.UI.Color.PositiveValue + "]Knock Back[/color] to nearby foes"
			}
		];
		
		if (::Tactical.isActive() && this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not be used because this unhold is engaged in melee[/color]"
			});
		}
		
		return ret;
	};
	obj.isUsable = function()
	{
		return !::Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().isEngagedInMelee();
	};
	obj.onTurnStart = function() {};
});