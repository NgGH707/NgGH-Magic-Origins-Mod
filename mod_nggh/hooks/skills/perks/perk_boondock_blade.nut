::mods_hookExactClass("skills/perks/perk_boondock_blade", function(obj) 
{
	obj.onUpdate = function( _properties )
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return;
		}
		
		if (!this.getContainer().getActor().getTile().IsHidingEntity && !this.getContainer().getActor().isHidden())
		{
			return;
		}

		_properties.MeleeDefense += 10;
		_properties.RangedDefense += 10;
		_properties.MeleeSkill += 10;
		_properties.RangedSkill += 10;
	}
});