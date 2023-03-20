::mods_hookExactClass("skills/actives/legend_banshee_scream", function(obj) 
{
	/*
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.IsMagicSkill = true;
		this.m.MagicPointsCost = 5;
	};
	*/
	obj.getTooltip <- function()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
		});
		return ret;
	};
	local ws_onUse = obj.onUse;
	obj.onUse = function( _user, _targetTile )
	{
		local ret = ws_onUse(_user, _targetTile);

		// more dangerous if the user is a champion
		if (_user.m.IsMiniboss)
		{
			_targetTile.getEntity().checkMorale(-1, -25, ::Const.MoraleCheckType.MentalAttack);
			_targetTile.getEntity().checkMorale(-1, -35, ::Const.MoraleCheckType.MentalAttack);
		}
		
		return ret;
	}
});