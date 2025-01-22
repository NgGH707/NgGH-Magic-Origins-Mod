::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/raise_undead", function(q)
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Raise a corpse back to life as an undead, faithfully follows your bidding.";
		m.IconDisabled = "skills/active_26_sw.png";
	}

	q.getTooltip <- function()
	{
		return getDefaultUtilityTooltip();
	}
});