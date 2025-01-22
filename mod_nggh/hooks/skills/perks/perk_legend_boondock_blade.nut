::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_legend_boondock_blade", function(q) 
{
	q.onUpdate = @(__original) function( _properties )
	{
		if (!getContainer().getActor().isPlacedOnMap())
			return;

		__original(_properties);
	}
});