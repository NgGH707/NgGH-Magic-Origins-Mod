::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/throw_balls", function ( q )
{
	q.m.StaggerChance <- 33;

	q.getTooltip = @(__original) function()
	{
		local find, ret = __original();

		foreach (i, tooltip in ret)
		{
			if (tooltip.type == "text" && tooltip.id = 8) {
				find = i;
				break;
			}
		}

		if (find != null)
			ret.insert(find, {
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]" + m.StaggerChance + "%[/color] chance to stagger on a hit"
			});

		return ret;
	}

	q.onTargetHit <- function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this && _targetEntity.isAlive() && ::Math.rand(1, 100) <= m.StaggerChance) {
			_targetEntity.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(getContainer().getActor()) + " has staggered " + ::Const.UI.getColorizedEntityName(_targetEntity) + " for 2 turns");
		}
	}

});