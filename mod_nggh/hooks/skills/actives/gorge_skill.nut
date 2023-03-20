::mods_hookExactClass("skills/actives/gorge_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "A powerful attack that can be used at a distance.";
		this.m.Icon = "skills/active_107.png";
		this.m.IconDisabled = "skills/active_107_sw.png";
	};
	obj.getTooltip <- function()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
		});
		return ret;
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInAxes ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	};
});