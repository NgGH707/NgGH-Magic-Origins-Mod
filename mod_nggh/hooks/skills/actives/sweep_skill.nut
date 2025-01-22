::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/sweep_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Swing your mighty hand to the side, dealing damage to mutiple targets who are unlucky enough to get hit. May cause knock back.";
		m.Icon = "skills/active_112.png";
		m.IconDisabled = "skills/active_112_sw.png";
		m.Overlay = "active_112";
	}

	q.getTooltip = function()
	{
		local ret = getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can hit up to 3 targets and never hit allies"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "May cause [color=" + ::Const.UI.Color.NegativeValue + "]Knock Back[/color] on hit"
			}
		]);
		return ret;
	}

	q.onTargetSelected <- function( _targetTile )
	{
		local ownTile = getContainer().getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		local nextDir = dir - 1 >= 0 ? dir - 1 : ::Const.Direction.COUNT - 1;

		if (ownTile.hasNextTile(nextDir)) {
			local nextTile = ownTile.getNextTile(nextDir);

			if (::Math.abs(nextTile.Level - ownTile.Level) <= 1)
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);
		}

		nextDir = nextDir - 1 >= 0 ? nextDir - 1 : ::Const.Direction.COUNT - 1;

		if (ownTile.hasNextTile(nextDir)) {
			local nextTile = ownTile.getNextTile(nextDir);

			if (::Math.abs(nextTile.Level - ownTile.Level) <= 1)
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);
		}
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInFists ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		local main = getContainer().getActor().getMainhandItem();
		m.IsHidden = !::MSU.isNull(main);

		if (!m.IsHidden) {
			__original(_properties);

			if (::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() && ::MSU.isKindOf(getContainer().getActor(), "player")) {
				_properties.DamageRegularMin -= 5;
				_properties.DamageRegularMax -= 15;
			}

			return;
		}

		_properties.DamageRegularMin += 10;
		_properties.DamageRegularMax += 20;

		if (main.isItemType(::Const.Items.ItemType.TwoHanded))
			_properties.DamageRegularMax += 5;
	}
	
});