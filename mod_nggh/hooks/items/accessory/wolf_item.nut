if (!::Is_AccessoryCompanions_Exist)
{
	// make wolf_item have an actual right icon for it wolf variant
	::Nggh_MagicConcept.HooksMod.hook("scripts/items/accessory/wolf_item", function(q) 
	{
	    q.setEntity = @() function( _e )
		{
			m.Entity = _e;

			if (m.Variant > 2)
				m.Variant = ::Math.rand(1, 2);

			if (m.Entity != null)
				m.Icon = "tools/dog_01_leash_70x70.png";
			else
				m.Icon = "tools/wolf_0" + m.Variant == 1 ? 2 : 1 + "_70x70.png";
		}

	});
}