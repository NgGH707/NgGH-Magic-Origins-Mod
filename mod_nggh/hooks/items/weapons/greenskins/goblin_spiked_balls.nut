// alternative sprite so it doesn't look weird when your goblin player is mounted
::mods_hookExactClass("items/weapons/greenskins/goblin_spiked_balls", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.ArmamentIcon = "icon_goblin_balls";
	}

	obj.getTooltip <- function()
	{
		local result = this.weapon.getTooltip();

		result.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]Ignores[/color] the ranged penalties of mounting"
		});

		return result;
	}
});