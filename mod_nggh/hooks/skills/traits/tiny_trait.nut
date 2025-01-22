::Nggh_MagicConcept.HooksMod.hook("scripts/skills/traits/tiny_trait", function(q) 
{
  	q.onAdded <- function()
    {
    	local actor = getContainer().getActor();

       	if (!actor.m.IsMiniboss && ::MSU.isKindOf(actor, "nggh_mod_spider_player") && actor.getSize() < 0.65)
			actor.setSize(0.65);
    }
});