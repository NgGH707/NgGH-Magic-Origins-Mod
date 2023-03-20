::mods_hookExactClass("items/accessory/accessory_dog", function(obj) 
{
	local ws_onActorDied = obj.onActorDied;
	obj.onActorDied = function( _onTile )
	{
		local hasUnleash = this.isUnleashed();
		local faction = this.getContainer().getActor().getFaction();
		local notPlayer = faction != ::Const.Faction.Player;

		ws_onActorDied(_onTile);

		if (!hasUnleash && notPlayer && this.m.Entity != null)
		{
			this.m.Entity.setFaction(faction);
		}
	}
});