::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/kraken_ensnare_skill", function(q) 
{
	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		if (!__original(_originTile, _targetTile))
			return false;

		return !_targetTile.getEntity().getFlags().has("kraken_tentacle");
	}
});