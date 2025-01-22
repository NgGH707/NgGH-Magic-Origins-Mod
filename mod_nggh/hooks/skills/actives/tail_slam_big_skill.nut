::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/tail_slam_big_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Tail Thresh";
		m.Description = "Use your tail to hit all the targets around you, foe and friend alike, with a reckless threshing around. Has a chance to stun targets hit for one turn.";
		m.KilledString = "Crushed";
		m.Icon = "skills/active_108.png";
		m.IconDisabled = "skills/active_108_sw.png";
		m.Order = ::Const.SkillOrder.OffensiveTargeted + 2;
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + ::Const.UI.Color.NegativeValue + "]" + m.HitChanceBonus + "%[/color] chance to hit"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a chance to [color=" + ::Const.UI.Color.NegativeValue + "]Daze[/color], [color=" + ::Const.UI.Color.NegativeValue + "]Stun[/color] or [color=" + ::Const.UI.Color.NegativeValue + "]Knock Back[/color] on a hit"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Never hit [color=" + ::Const.UI.Color.NegativeValue + "]yourself[/color] or [color=" + ::Const.UI.Color.NegativeValue + "]your kind[/color]"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can hit up to 6 targets"
			}
		]);
		return ret;
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInAxes ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	q.onUse = @() function( _user, _targetTile )
	{
		local ret = false;
		local ownTile = this.getContainer().getActor().getTile();
		local soundBackup = [];
		m.TilesUsed = [];
		spawnAttackEffect(ownTile, ::Const.Tactical.AttackEffectThresh);

		for( local i = 5; i >= 0; --i )
		{
			if (!ownTile.hasNextTile(i))
				continue;

			local tile = ownTile.getNextTile(i);
			local canbeHit = tile.IsOccupiedByActor && canBeHit(_user, tile.getEntity());

			if (tile.IsOccupiedByActor && tile.getEntity().isAttackable() && ::Math.abs(tile.Level - ownTile.Level) <= 1 && canbeHit) {
				if (ret && soundBackup.len() == 0) {
					soundBackup = m.SoundOnHit;
					m.SoundOnHit = [];
				}

				local success = attackEntity(_user, tile.getEntity());

				if (success && !tile.IsEmpty && tile.getEntity().isAlive() && !tile.getEntity().isDying() && canbeHit)
					applyEffectToTarget(_user, tile.getEntity(), tile);

				ret = success || ret;

				if (!_user.isAlive() || _user.isDying())
					break;
			}
		}

		if (ret && m.SoundOnHit.len() == 0)
			m.SoundOnHit = soundBackup;

		m.TilesUsed = [];
		return ret;
	}

	q.canBeHit <- function( _user, _target )
	{
		if (!_target.getFlags().has("lindwurm")) return true;
		else if (!_target.isAlliedWith(_user)) return true;
		else return false;
	}

	q.onTargetSelected <- function( _targetTile )
	{
		local ownTile = getContainer().getActor().getTile();

		for( local i = 0; i != 6; ++i )
		{
			if (!ownTile.hasNextTile(i))
				continue;

			local tile = ownTile.getNextTile(i);

			if (!tile.IsEmpty && tile.getEntity().isAttackable() && ::Math.abs(tile.Level - ownTile.Level) <= 1)
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}

});