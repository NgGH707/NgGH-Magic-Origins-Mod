::mods_hookExactClass("skills/perks/perk_pathfinder", function(obj) 
{
	local ws_onUpdate = obj.onUpdate;
	obj.onUpdate = function( _properties )
	{
		local actor = this.getContainer().getActor();

		if (actor.isMounted())
		{
			actor.m.LevelActionPointCost = 0;
			actor.m.LevelFatigueCost = 2;
			return;
		}
		
		ws_onUpdate(_properties);
	}
});