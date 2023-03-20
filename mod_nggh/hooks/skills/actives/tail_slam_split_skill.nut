::mods_hookExactClass("skills/actives/tail_slam_split_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Tail Split";
		this.m.Description = "A wide-swinging overhead attack with your tail performed for maximum reach rather than force that can hit two tiles in a straight line.";
		this.m.KilledString = "Crushed";
		this.m.Icon = "skills/active_108.png";
		this.m.IconDisabled = "skills/active_108_sw.png";
	};
	obj.getTooltip <- function()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a chance to [color=" + ::Const.UI.Color.NegativeValue + "]Daze[/color], [color=" + ::Const.UI.Color.NegativeValue + "]Stun[/color] or [color=" + ::Const.UI.Color.NegativeValue + "]Knock Back[/color] on a hit"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Never hit [color=" + ::Const.UI.Color.NegativeValue + "]yourself[/color] or [color=" + ::Const.UI.Color.NegativeValue + "]your kind[/color]"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can hit up to 2 targets"
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
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectSplit);
		local ret = this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return ret;
		}

		if (ret && _targetTile.IsOccupiedByActor && _targetTile.getEntity().isAlive() && !_targetTile.getEntity().isDying())
		{
			this.applyEffectToTarget(_user, _targetTile.getEntity(), _targetTile);
		}

		local ownTile = _user.getTile();
		local dir = ownTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);
			local canbeHit = forwardTile.IsOccupiedByActor && this.canBeHit(_user, forwardTile.getEntity());

			if (forwardTile.IsOccupiedByActor && forwardTile.getEntity().isAttackable() && ::Math.abs(forwardTile.Level - ownTile.Level) <= 1 && canbeHit)
			{
				ret = this.attackEntity(_user, forwardTile.getEntity()) || ret;
			}

			if (ret && forwardTile.IsOccupiedByActor && forwardTile.getEntity().isAlive() && !forwardTile.getEntity().isDying() && canbeHit)
			{
				this.applyEffectToTarget(_user, forwardTile.getEntity(), forwardTile);
			}
		}

		return ret;
	};
	obj.onTargetSelected <- function( _targetTile )
	{
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		local ownTile = this.getContainer().getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);

			if (::Math.abs(forwardTile.Level - ownTile.Level) <= 1)
			{
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, forwardTile, forwardTile.Pos.X, forwardTile.Pos.Y);
			}
		}
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
});