::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/ghoul_claws", function ( q )
{
	q.getTooltip = @() function()
	{
		return getDefaultTooltip();
	}

	q.use <- function( _targetTile, _forFree = false )
	{
		if (!getContainer().getActor().getFlags().has("luft"))
			::Nggh_MagicConcept.spawnQuote("luft_claw_quote_" + ::Math.rand(1, 5), getContainer().getActor().getTile());
		
		return skill.use(_targetTile, _forFree);
	}

	q.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInShields ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
	
});