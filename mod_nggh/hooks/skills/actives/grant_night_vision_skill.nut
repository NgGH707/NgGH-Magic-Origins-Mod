::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/grant_night_vision_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		//m.IsMagicSkill = true;
		//m.MagicPointsCost = 1;
		//m.IsRequireStaff = true;
		m.Description = "A simple chant to give a group of your men the ability to see through the darkness of the night.";
		m.Icon = "skills/active_156.png";
		m.IconDisabled = "skills/active_156_sw.png";
		m.Order = ::Const.SkillOrder.UtilityTargeted + 3;
		m.IsTargetingActor = false;
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();

		ret.push({
			id = 9,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Removes [color=" + ::Const.UI.Color.NegativeValue + "]Nighttime[/color] penalties to a group of allies"
		});
		
		if (m.IsSpent)
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can only be used once per turn[/color]"
			});

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