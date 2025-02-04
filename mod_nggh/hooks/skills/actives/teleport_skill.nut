::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/teleport_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Teleport away by using unknown power at the same time causes the surrounding temperature to drop down absolute zero. ";
		m.Icon = "skills/active_167.png";
		m.IconDisabled = "skills/active_167_sw.png";
		m.Overlay = "active_167";
	}

	q.onAdded <- function()
	{
		m.IsVisibleTileNeeded = ::MSU.isKindOf(getContainer().getActor(), "player");
	}

	q.onUpdate <- function( _properties )
	{
		_properties.Vision += 7;
	}

	q.onAfterUpdate <- function( _properties )
	{
		local actor = getContainer().getActor();

		if (::MSU.isKindOf(getContainer().getActor(), "player")) {
			m.ActionPointCost += 1;
			m.MaxRange -= 15;
		}
	}

	q.getTooltip = @() function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of  [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Creates snow tiles and inflicts \'Chilled\' status effect to anyone nearby"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Teleport instantly"
			},
		]);
		return ret;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		local free = getContainer().getSkillByID("actives.break_free");

		if (free != null) {
			free.setChanceBonus(2000);

			if (!free.onUse(_user, _user.getTile()))
				return false;
		}

		return __original(_user, _targetTile);
	}
	
});