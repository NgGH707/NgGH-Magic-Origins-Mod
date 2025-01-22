::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/tail_slam_zoc_skill", function ( q )
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