::mods_hookExactClass("skills/perks/perk_ptr_weapon_master", function ( obj )
{
	local ws_onUpdate = obj.onUpdate;
	obj.onUpdate = function( _properties )
	{
		if (!::MSU.isKindOf(this.getContainer().getActor(), "player"))
		{
			_properties.IsSpecializedInAxes = true;
			_properties.IsSpecializedInMaces = true;
			_properties.IsSpecializedInFlails = true;
			_properties.IsSpecializedInSpears = true;
			_properties.IsSpecializedInSwords = true;
			_properties.IsSpecializedInDaggers = true;
			_properties.IsSpecializedInHammers = true;
			_properties.IsSpecializedInCleavers = true;
			_properties.IsSpecializedInThrowing = true;
			return;
		}

		ws_onUpdate(_properties);
	};
});
