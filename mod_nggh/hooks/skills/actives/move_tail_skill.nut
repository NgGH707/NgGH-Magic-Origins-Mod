::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/move_tail_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Move the tail closer to the body";
		m.Icon = "skills/active_109.png";
		m.IconDisabled = "skills/active_109_sw.png";
	}

	q.onAfterUpdate <- function( _properties )
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player"))
			m.ActionPointCost -= 1;
	}

	q.getTooltip <- function()
	{
		return getDefaultUtilityTooltip();
	}

});