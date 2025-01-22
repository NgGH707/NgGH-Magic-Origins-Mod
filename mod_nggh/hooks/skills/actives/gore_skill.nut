::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/gore_skill", function ( q )
{
	q.m.ModMinDamage <- 10;
	q.m.IsPlayer <- false;

	q.create = @(__original) function()
	{
		__original();
		m.Description = "Dealing devastating damage by ramming with an incredible speed, easily punch through enemy formation.";
		m.KilledString = "Crushed";
		m.Icon = "skills/active_166.png";
		m.IconDisabled = "skills/active_166_sw.png";
		m.IsAOE = true;
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player")) {
			m.IsVisibleTileNeeded = true;
			m.IsIgnoringRiposte = true;
			m.IsPlayer = true;
			m.ActionPointCost = 4;
			m.MinRange = 1;
			m.MaxRange = 6;
			m.ChanceDisembowel = 30;
			m.ChanceSmash = 30;
		}

		getContainer().add(::new("scripts/skills/actives/nggh_mod_gore_skill_zoc"));
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultTooltip();

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/stat_screen_dmg_dealt.png",
				text = "Always inflicts at least [color=" + ::Const.UI.Color.DamageValue + "]" + m.ModMinDamage + "[/color] damage to hitpoints, regardless of armor"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range within [color=" + ::Const.UI.Color.PositiveValue + "]" + getMinRange() + "[/color] - [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can [color=" + ::Const.UI.Color.PositiveValue + "]Stagger[/color] and [color=" + ::Const.UI.Color.PositiveValue + "]Knock Back[/color] on a hit"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can hit up to 5 targets"
			},
		]);

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		_properties.DamageMinimum += m.ModMinDamage;

		if (::Tactical.isActive())
			__original(_properties);
		else {
			_properties.DamageRegularMin += 100;
			_properties.DamageRegularMax += 130;
			_properties.DamageArmorMult *= 0.75;
			m.MaxRange = 6;
		}
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