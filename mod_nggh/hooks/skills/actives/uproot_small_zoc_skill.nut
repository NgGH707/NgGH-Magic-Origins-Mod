::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/uproot_small_zoc_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.IsHidden = true;
	}

	q.isUsable <- function()
	{
		return m.IsUsable && getContainer().getActor().getCurrentProperties().IsAbleToUseSkills;
	}
	
});