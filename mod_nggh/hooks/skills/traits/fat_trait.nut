::mods_hookExactClass("skills/traits/fat_trait", function ( obj )
{
	local ws_onAdded = obj.onAdded;
	obj.onAdded <- function()
	{
		if (!this.getContainer().getActor().getFlags().has("human"))
		{
			return;
		}
		
		ws_onAdded();
	}
});