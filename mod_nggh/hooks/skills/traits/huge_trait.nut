::mods_hookExactClass("skills/traits/huge_trait", function(obj) 
{
    obj.onAdded <- function()
    {
    	local actor = this.getContainer().getActor();

       	if (!actor.m.IsMiniboss && ::isKindOf(actor.get(), "nggh_mod_spider_player") && actor.getSize() < 0.9)
		{
			actor.setSize(0.9);
		}
    }
});