::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_ptr_weapon_master", function ( q ) {
	q.onUpdate = @(__original) function( _properties )
	{
		if (!::MSU.isKindOf(this.getContainer().getActor(), "player")) {
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

		__original(_properties);
	};
});
