::mods_hookExactClass("skills/actives/tail_slam_big_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Tail Thresh";
		this.m.Description = "Skillfully using your tail to tresh all the targets around you, foe and friend alike, with a reckless round swing, of course you will not hit yourself. Has a chance to stun targets hit for one turn.";
		this.m.KilledString = "Crushed";
		this.m.Icon = "skills/active_108.png";
		this.m.IconDisabled = "skills/active_108_sw.png";
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted + 2;
	};
	obj.getTooltip <- function()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.HitChanceBonus + "%[/color] chance to hit"
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
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInAxes ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	};
	obj.onUse = function( _user, _targetTile )
	{
		local ret = false;
		local ownTile = this.getContainer().getActor().getTile();
		local soundBackup = [];
		this.m.TilesUsed = [];
		this.spawnAttackEffect(ownTile, ::Const.Tactical.AttackEffectThresh);

		for( local i = 5; i >= 0; --i )
		{
			if (!ownTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = ownTile.getNextTile(i);
				local canbeHit = tile.IsOccupiedByActor && this.canBeHit(_user, tile.getEntity());

				if (tile.IsOccupiedByActor && tile.getEntity().isAttackable() && ::Math.abs(tile.Level - ownTile.Level) <= 1 && canbeHit)
				{
					if (ret && soundBackup.len() == 0)
					{
						soundBackup = this.m.SoundOnHit;
						this.m.SoundOnHit = [];
					}

					local success = this.attackEntity(_user, tile.getEntity());

					if (success && !tile.IsEmpty && tile.getEntity().isAlive() && !tile.getEntity().isDying() && canbeHit)
					{
						this.applyEffectToTarget(_user, tile.getEntity(), tile);
					}

					ret = success || ret;

					if (!_user.isAlive() || _user.isDying())
					{
						break;
					}
				}
			}
		}

		if (ret && this.m.SoundOnHit.len() == 0)
		{
			this.m.SoundOnHit = soundBackup;
		}

		this.m.TilesUsed = [];
		return ret;
	};
	obj.canBeHit <- function( _user, _target )
	{
		local canBeHit = true;
		local isAllied = _target.isAlliedWith(_user);
		local isLindwurm = _target.getFlags().has("lindwurm");
		
		if (isLindwurm)
		{
			canBeHit = false;
			
			if (!isAllied)
			{
				canBeHit = true;
			}
		}
		
		return canBeHit;
	};
	obj.onTargetSelected <- function( _targetTile )
	{
		local ownTile = this.getContainer().getActor().getTile();

		for( local i = 0; i != 6; ++i )
		{
			if (!ownTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = ownTile.getNextTile(i);

				if (!tile.IsEmpty && tile.getEntity().isAttackable() && ::Math.abs(tile.Level - ownTile.Level) <= 1)
				{
					::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
				}
			}
		}
	};
});