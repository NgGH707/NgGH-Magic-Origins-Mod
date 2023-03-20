::mods_hookExactClass("skills/actives/legend_hex_skill", function(obj) 
{
	obj.onAdded <- function()
	{
		this.m.IsHidden = this.getContainer().getActor().getFlags().has("Hexe");
	}
});