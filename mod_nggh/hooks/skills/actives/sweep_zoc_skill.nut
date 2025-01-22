::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/sweep_zoc_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Order = ::Const.SkillOrder.OffensiveTargeted - 10;
		m.IsHidden = true;
	}

	q.isUsable <- function()
	{
		return m.IsUsable && ::MSU.isNull(getContainer().getActor().getMainhandItem()) && getContainer().getActor().getCurrentProperties().IsAbleToUseSkills;
	}

});