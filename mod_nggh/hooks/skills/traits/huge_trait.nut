::Nggh_MagicConcept.HooksMod.hook("scripts/skills/traits/huge_trait", function(q) 
{
    q.onAdded <- function()
    {
    	local actor = getContainer().getActor();

       	if (!actor.m.IsMiniboss && ::MSU.isKindOf(actor, "nggh_mod_spider_player") && actor.getSize() < 0.9)
			actor.setSize(0.9);
    }
});