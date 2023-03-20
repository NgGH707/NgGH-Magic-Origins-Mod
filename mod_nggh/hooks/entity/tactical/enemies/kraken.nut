::mods_hookExactClass("entity/tactical/enemies/kraken", function ( obj )
{
	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		foreach( i, t in this.m.Tentacles )
		{
			if (!t.isNull() && !t.isDying() && t.isAlive())
			{
				t.makeMiniboss();
				t.getSprite("miniboss").setBrush("bust_miniboss"); 
			}
		}
	}

	local ws_onInit = obj.onInit;
	obj.onInit = function()
	{
		ws_onInit();
		this.m.IsEnraged = ::World.Flags.get("IsKrakenOrigin");

		if (this.m.IsEnraged)
		{
			foreach( t in this.m.Tentacles )
			{
				if (!t.isNull())
				{
					t.setMode(1);
				}
			}
		}
	}
});