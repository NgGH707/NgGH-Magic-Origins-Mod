::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_stollwurm_move_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Digging your way through the underground to reach you destination.";
		m.Icon = "skills/active_149.png";
		m.IconDisabled = "skills/active_149_sw.png";
		m.Overlay = "active_149";
	}

	q.onAdded <- function()
	{
		m.IsVisibleTileNeeded = ::MSU.isKindOf(getContainer().getActor(), "player");
	}
});