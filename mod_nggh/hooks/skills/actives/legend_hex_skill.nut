::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_hex_skill", function(q) 
{
	q.onAdded <- function()
	{
		m.IsHidden = getContainer().getActor().getFlags().has("Hexe");
	}
});