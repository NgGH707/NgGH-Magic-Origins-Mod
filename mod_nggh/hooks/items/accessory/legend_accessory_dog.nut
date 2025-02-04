::Nggh_MagicConcept.HooksMod.hook("scripts/items/accessory/legend_accessory_dog", function(q) 
{
	q.onActorDied = @(__original) function( _onTile )
	{
		local faction = getContainer().getActor().getFaction();

		__original(_onTile);

		if (!isUnleashed() && faction != ::Const.Faction.Player && ::MSU.isNull(m.Entity != null))
			m.Entity.setFaction(faction);
	}
});