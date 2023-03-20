::mods_hookExactClass("skills/actives/kraken_ensnare_skill", function(obj) 
{
	local ws_onVerifyTarget = obj.onVerifyTarget;
	obj.onVerifyTarget = function( _originTile, _targetTile )
	{
		if (!ws_onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.getEntity().getFlags().has("kraken_tentacle"))
		{
			return false;
		}

		return true;
	}
});