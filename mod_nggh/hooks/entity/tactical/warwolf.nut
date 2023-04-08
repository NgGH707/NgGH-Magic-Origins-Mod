::mods_hookExactClass("entity/tactical/warwolf", function ( obj )
{
	if (!::Is_AccessoryCompanions_Exist)
	{
		obj.setVariant <- function( _v )
		{
			this.m.Items.getAppearance().Body = "bust_wolf_0" + _v;
			this.getSprite("body").setBrush("bust_wolf_0" + _v + "_body");
			this.getSprite("head").setBrush("bust_wolf_0" + _v + "_head");
			this.setDirty(true);
		}
	}

	local ws_onDeath = obj.onDeath;
	obj.onDeath = function( _killer, _skill, _tile, _fatalityType )
	{
		if (this.m.Item != null && !this.m.Item.isNull())
		{
			if (this.m.Item.getContainer() == null || this.m.Item.getContainer().isNull())
			{
				this.m.Item = null;
			}
		}

		ws_onDeath(_killer, _skill, _tile, _fatalityType);
	}
});