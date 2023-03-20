::mods_hookExactClass("skills/actives/uproot_small_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Send out roots to hold and damage an enemy.";
		this.m.KilledString = "Crushed";
		this.m.Icon = "skills/active_122.png";
		this.m.IconDisabled = "skills/active_122_sw.png";
		this.m.Overlay = "active_122";
		this.m.IsAOE = false;
	};
	obj.getTooltip <- function()
	{
		return this.getDefaultTooltip();
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInSpears ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;

		if (_properties.IsSpecializedInSpears)
		{
			_properties.DamageRegularMin += 5;
			_properties.DamageRegularMax += 15;
		}
	};
});