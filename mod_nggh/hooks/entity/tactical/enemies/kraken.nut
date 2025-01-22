::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/kraken", function ( q )
{
	q.makeMiniboss <- function()
	{
		if (!actor.makeMiniboss())
			return false;

		foreach( i, t in m.Tentacles )
		{
			if (!::MSU.isNull(t) && !t.isDying() && t.isAlive()) {
				t.makeMiniboss();
				t.getSprite("miniboss").setBrush("bust_miniboss"); 
			}
		}
	}

	q.onInit = @(__original) function()
	{
		__original();
		m.IsEnraged = ::World.Flags.get("IsKrakenOrigin");

		if (m.IsEnraged) {
			foreach( t in m.Tentacles )
			{
				if (!t.isNull())
					t.setMode(1);
			}
		}
	}
	
});