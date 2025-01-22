::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/goblin_whip", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Whip!";
		m.Description = "Whip your goblin troops to remind them know who is the boss here. Stand your ground!";
		m.Icon = "skills/active_72.png";
		m.IconDisabled = "skills/active_72_sw.png";
		m.Order = ::Const.SkillOrder.UtilityTargeted + 3;
		m.IsWeaponSkill = false;
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player"))
			setBaseValue("FatigueCost", 11);
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip(); 

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Resets the morale of the targeted [color=" + ::Const.UI.Color.DamageValue + "]goblin[/color] up to \'Confident\' if currently below"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Removes \'Sleeping\' status effect on targeted goblin"
			}
		]);

		return ret;
	}

	q.onDelayedEffect = @(__original) function( _target )
	{
		_target.getSkills().removeByID("effects.sleeping");
		__original(_target);
	}
});