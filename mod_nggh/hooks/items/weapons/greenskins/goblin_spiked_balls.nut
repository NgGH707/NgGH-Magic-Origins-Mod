// alternative sprite so it doesn't look weird when your goblin player is mounted
::Nggh_MagicConcept.HooksMod.hook("scripts/items/weapons/greenskins/goblin_spiked_balls", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.ArmamentIcon = "icon_goblin_balls";
	}

	q.getTooltip <- function()
	{
		local result = weapon.getTooltip();

		result.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]Ignores[/color] the ranged penalties of mounting"
		});

		return result;
	}
	
});