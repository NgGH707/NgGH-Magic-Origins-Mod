::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/horror_skill", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		//m.IsMagicSkill = true;
		//m.MagicPointsCost = 6;
		m.Description = "Fill selected target\'s mind with horrific images, weakening their will to fight and even making them freeze in place because of fear.";
		m.Icon = "skills/active_102.png";
		m.IconDisabled = "skills/active_102_sw.png";
		m.Overlay = "active_102";
	}

	q.onAdded <- function()
	{
		m.IsVisibleTileNeeded = ::MSU.isKindOf(getContainer().getActor(), "player");
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
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Scare the shit out of your target"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can affect up to 7 targets"
			},
		]);
		return ret;
	}
	
	q.onTargetSelected <- function( _targetTile )
	{
		local ownTile = _targetTile;

		for( local i = 0; i != 6; ++i )
		{
			if (!ownTile.hasNextTile(i))
				continue;

			local tile = ownTile.getNextTile(i);

			if (::Math.abs(tile.Level - ownTile.Level) <= 1)
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}
	
});