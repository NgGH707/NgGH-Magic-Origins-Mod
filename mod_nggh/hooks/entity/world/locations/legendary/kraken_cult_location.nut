::mods_hookExactClass("entity/world/locations/legendary/kraken_cult_location", function ( obj )
{
	local ws_onSpawned = obj.onSpawned;
	obj.onSpawned = function()
	{
		ws_onSpawned();

		if (::World.Flags.get("IsKrakenOrigin"))
		{
			local tilePos = this.getTile().Pos;
			::World.uncoverFogOfWar(tilePos, 500.0);
			::World.getCamera().setPos(tilePos);
			::World.getCamera().Zoom = 1.0;
         	::World.State.getPlayer().setPos(tilePos);
          	::World.setPlayerPos(tilePos);

          	if (!::Nggh_MagicConcept.IsNoKrakenVsKraken)
          	{
          		::World.State.enterLocation(this);
          	}
		}
	}

});