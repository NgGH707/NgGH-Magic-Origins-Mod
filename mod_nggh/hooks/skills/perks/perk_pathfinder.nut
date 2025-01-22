::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_pathfinder", function(q) 
{
	q.onUpdate = @(__original) function( _properties )
	{
		local actor = getContainer().getActor();

		if (actor.isMounted()) {
			actor.m.LevelActionPointCost = 0;
			actor.m.LevelFatigueCost = 2;
			return;
		}
		
		__original(_properties);
	}
});