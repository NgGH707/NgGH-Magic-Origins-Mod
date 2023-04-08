::mods_hookExactClass("skills/actives/ghoul_claws", function ( obj )
{
	obj.getTooltip = function()
	{
		return this.getDefaultTooltip();
	};
	obj.onBeforeUse <- function( _user , _targetTile )
	{
		if (!_user.getFlags().has("luft"))
		{
			return;
		}
		
		::Nggh_MagicConcept.spawnQuote("luft_claw_quote_" + ::Math.rand(1, 5), _user.getTile());
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInShields ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
});