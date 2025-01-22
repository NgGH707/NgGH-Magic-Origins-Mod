::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_legend_horse_liberty", function(q) 
{
    q.onUpdate <- function( _properties )
    {
        if (getContainer().getActor().isMounted()) {
        	_properties.MovementFatigueCostMult *= 0.75;
        	_properties.BraveryMult *= 1.25;
        }
    }
});