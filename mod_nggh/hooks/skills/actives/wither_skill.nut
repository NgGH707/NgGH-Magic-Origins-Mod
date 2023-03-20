::mods_hookExactClass("skills/actives/wither_skill", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Wither a target for three turns, reducing their damage, fatigue and initiative by [color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color]. The effect is weaken by 10% each turn";
		this.m.IconDisabled = "skills/active_217_sw.png";
	};
	obj.getTooltip <- function()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" +  ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Only affect living beings"
			},
		]);
		return ret;
	};
	obj.onVerifyTarget <- function( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.getEntity().getFlags().has("undead"))
		{
			return false;
		}

		return true;
	}
});