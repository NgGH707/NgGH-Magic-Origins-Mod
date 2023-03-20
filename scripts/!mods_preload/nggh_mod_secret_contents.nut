::Nggh_MagicConcept.secret_contents <- function ()
{
	/* not in use for now
	::mods_hookNewObjectOnce("states/main_menu_state", function( obj )
	{
		local onCreditsPressed = obj.main_menu_module_onCreditsPressed;
		obj.main_menu_module_onCreditsPressed = function()
		{
			this.getroottable().UnlockSecret = !this.getroottable().UnlockSecret;
			
			if (!this.getroottable().AddedSecret)
			{
				this.getroottable().AddedSecret = true;
				this.m.ScenarioManager.m.Scenarios.sort(this.m.ScenarioManager.onOrderCompare);
				this.m.MainMenuScreen.getNewCampaignMenuModule().setStartingScenarios(this.m.ScenarioManager.getScenariosForUI());
				this.logDebug("mod_nggh_magic_concept - Unlocking Secret: " + this.getroottable().UnlockSecret);
			}
			
			onCreditsPressed();
		}
	});
	::mods_hookNewObject("entity/world/locations/legendary/kraken_cult_location", function ( obj )
	{
		local ws_onSpawned = obj.onSpawned; 
		obj.onSpawned = function()
		{
			ws_onSpawned();

			if (this.World.Flags.get("IsKrakenOrigin"))
			{	
				local self = this;
				local tilePos = this.getTile().Pos;
         		this.World.State.getPlayer().setPos(tilePos);
         		this.World.setPlayerPos(tilePos);
         		this.World.getCamera().setPos(tilePos);
				this.onDiscovered();

				this.Time.scheduleEvent(this.TimeUnit.Real, 1100, function ( _tag )
				{
					this.World.State.enterLocation(self);
				}, null);
			}
		}
	});
	*/

	delete ::Nggh_MagicConcept.secret_contents;
}