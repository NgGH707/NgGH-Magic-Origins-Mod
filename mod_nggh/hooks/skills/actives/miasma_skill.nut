::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/miasma_skill", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Release a cloud of noxious gasses that suffocates living beings. The cloud lasts for at least 3 rounds.";
		m.Icon = "skills/active_101.png";
		m.IconDisabled = "skills/active_101_sw.png";
		m.Order =  ::Const.SkillOrder.UtilityTargeted + 3;
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player")) // huge nerf for player
			setBaseValue("FatigueCost", 25);
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" +  ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = "Deals [color=" + ::Const.UI.Color.DamageValue + "]5[/color] - [color=" + ::Const.UI.Color.DamageValue + "]10[/color] poison damage per turn"
			}
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

			if ( ::Math.abs(tile.Level - ownTile.Level) <= 1)
				 ::Tactical.getHighlighter().addOverlayIcon( ::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}
	
});