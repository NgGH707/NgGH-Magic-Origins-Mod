::mods_hookExactClass("entity/tactical/enemies/kraken_tentacle", function ( obj )
{
	local ws_setParent = obj.setParent;
	obj.setParent = function( _p )
	{
		ws_setParent(_p);

		if (_p != null && _p.m.IsMiniboss)
		{
			this.makeMiniboss();
			this.getSprite("miniboss").setBrush("bust_miniboss"); 
		}
	}
});