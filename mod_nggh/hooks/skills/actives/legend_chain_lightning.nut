::mods_hookExactClass("skills/actives/legend_chain_lightning", function(obj) 
{
	/*
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.IsMagicSkill = true;
		this.m.MagicPointsCost = 3;
		this.m.IsRequireStaff = true
	}
	*/

	// this skill is so mess up so i fix this with a cleaner code
	obj.onUse = function( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local selectedTargets = [];
		local targetTile = _targetTile;
		local target = targetTile.getEntity();
		selectedTargets.push(target.getID());

		if (this.m.SoundOnLightning.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnLightning), ::Const.Sound.Volume.Skill * 2.0, _user.getPos());
		}

		local data = {
			Skill = this,
			User = _user,
			TargetTile = targetTile,
			Target = target
		};
		this.applyEffect(data, 100);
		local potentialTiles = this.searchTiles(targetTile, myTile);
		local potentialTargets = this.searchTargets(_user , potentialTiles, selectedTargets);

		if (potentialTargets.len() != 0)
		{
			target = ::MSU.Array.rand(potentialTargets).getEntity();
			selectedTargets.push(target.getID());
			targetTile = target.getTile();
		}
		else
		{
			target = null;
			targetTile = ::MSU.Array.rand(potentialTiles)
		}

		local data = {
			Skill = this,
			User = _user,
			TargetTile = targetTile,
			Target = target
		};
		this.applyEffect(data, 350);
		potentialTiles = this.searchTiles(targetTile, myTile);
		potentialTargets= this.searchTargets(_user , potentialTiles, selectedTargets);

		if (potentialTargets.len() != 0)
		{
			target = ::MSU.Array.rand(potentialTargets).getEntity();
			selectedTargets.push(target.getID());
			targetTile = target.getTile();
		}
		else
		{
			target = null;
			targetTile = ::MSU.Array.rand(potentialTiles)
		}

		local data = {
			Skill = this,
			User = _user,
			TargetTile = targetTile,
			Target = target
		};
		this.applyEffect(data, 550);
		return true;
	}
	obj.searchTiles <- function( _tile, _originTile )
	{
		local ret = [];
		for( local i = 0; i < 6; i = ++i )
		{
			if (!_tile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _tile.getNextTile(i);

				if (tile.ID != _originTile.ID)
				{
					ret.push(tile);
				}
			}
		}
		return ret;
	}
	obj.searchTargets <- function( _user , _tiles , _excluded )
	{
		local ret = [];
		foreach( tile in _tiles )
		{
			if (!tile.IsOccupiedByActor || !tile.getEntity().isAttackable() || tile.getEntity().isAlliedWith(_user) || _excluded.find(tile.getEntity().getID()) != null)
			{
			}
			else
			{
				ret.push(tile);
			}
		}
		return ret;
	}
});