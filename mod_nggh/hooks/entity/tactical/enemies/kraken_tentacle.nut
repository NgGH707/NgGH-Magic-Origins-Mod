::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/kraken_tentacle", function ( q )
{
	q.setParent = @(__original) function( _p )
	{
		__original(_p);

		if (!::MSU.isNull(_p) && _p.m.IsMiniboss) {
			makeMiniboss();
			getSprite("miniboss").setBrush("bust_miniboss"); 
		}
	}
	
});