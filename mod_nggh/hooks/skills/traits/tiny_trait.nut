::mods_hookExactClass("skills/traits/tiny_trait", function(obj) 
{
  	obj.onAdded <- function()
    {
    	local actor = this.getContainer().getActor();

       	if (!actor.m.IsMiniboss && ::isKindOf(actor.get(), "nggh_mod_spider_player") && actor.getSize() < 0.65)
		{
			actor.setSize(0.65);
		}
    }
});