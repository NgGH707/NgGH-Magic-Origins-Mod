::Nggh_MagicConcept.HooksMod.hook("scripts/entity/world/locations/legendary/kraken_cult_location", function ( q )
{
	q.onSpawned = @(__original) function()
	{
		__original();

		if (!::World.Flags.get("IsKrakenOrigin")) return;
		
		local tilePos = getTile().Pos;
		::World.uncoverFogOfWar(tilePos, 500.0);
		::World.getCamera().setPos(tilePos);
		::World.getCamera().Zoom = 1.0;
     	::World.State.getPlayer().setPos(tilePos);
      	::World.setPlayerPos(tilePos);

      	if (!::Nggh_MagicConcept.Mod.ModSettings.getSetting("kraken_vs_kraken").getValue())
      		::World.State.enterLocation(this);
	}

});