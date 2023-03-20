::mods_hookExactClass("skills/perks/perk_horse_liberty", function(obj) 
{
    obj.onUpdate <- function( _properties )
    {
        if (this.getContainer().getActor().isMounted())
        {
        	_properties.MovementFatigueCostMult *= 0.75;
        	_properties.BraveryMult *= 1.25;
        }
    }
});