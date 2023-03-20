::mods_hookExactClass("entity/tactical/legend_white_warwolf", function ( obj )
{
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