::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/root_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Unleash roots from the ground to ensnare your foes. Fatigue and AP costs reduced while raining and with staff mastery. ";
		m.Icon = "skills/active_70.png";
		m.IconDisabled = "skills/active_70_sw.png";
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player"))
			setBaseValue("FatigueCost", 20);
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
				text = "Can hit up to 7 targets"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Trapped targets in Vines"
			}
		]);
		return ret;
	}

	q.onTargetSelected <- function( _targetTile )
	{
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		
		for( local i = 0; i < 6; ++i )
		{
			if (!_targetTile.hasNextTile(i))
				continue;

			local tile = _targetTile.getNextTile(i);
			::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}
	
});