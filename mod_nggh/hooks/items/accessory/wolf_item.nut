if (!::Is_AccessoryCompanions_Exist)
{
	// make wolf_item have an actual right icon for it wolf variant
	::mods_hookExactClass("items/accessory/wolf_item", function(obj) 
	{
	    obj.setEntity <- function( _e )
		{
			this.m.Entity = _e;

			if (this.m.Variant > 2)
			{
				this.m.Variant = ::Math.rand(1, 2);
			}

			local variant = this.m.Variant == 1 ? 2 : 1;

			if (this.m.Entity != null)
			{
				this.m.Icon = "tools/dog_01_leash_70x70.png";
			}
			else
			{
				this.m.Icon = "tools/wolf_0" + variant + "_70x70.png";
			}
		}
	});
}