/*
::mods_hookExactClass("skills/actives/slash_lightning", function(obj) 
{
	obj.onAdded <- function()
	{
		if (this.getContainer().getActor().getFlags().has("isSwordSaint"))
		{
			this.m.IsUsingHitchance = false;
			this.m.ChanceDecapitate = 100;
			this.m.ChanceDisembowel = 0;
			this.m.ChanceSmash = 0;

			local bite = this.getContainer().getSkillByID("actives.zombie_bite");
		
			if (bite == null)
			{
				return;
			}

			bite.m.IsHidden = true;
		}
	};
	obj.onUse = function( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectSlash);
		local success = this.attackEntity(_user, _targetTile.getEntity());
		local myTile = _user.getTile();

		if (success && _user.isAlive())
		{
			local selectedTargets = [];
			local potentialTargets = [];
			local potentialTiles = [];
			local target;
			local targetTile = _targetTile;

			if (this.m.SoundOnLightning.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnLightning), ::Const.Sound.Volume.Skill * 2.0, _user.getPos());
			}

			if (!targetTile.IsEmpty && targetTile.getEntity().isAlive())
			{
				target = targetTile.getEntity();
				selectedTargets.push(target.getID());
			}

			local data = {
				Skill = this,
				User = _user,
				TargetTile = targetTile,
				Target = target
			};
			this.applyEffect(data, 100);
			potentialTargets = [];
			potentialTiles = [];

			for( local i = 0; i < 6; i = ++i )
			{
				if (!targetTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = targetTile.getNextTile(i);

					if (tile.ID != myTile.ID)
					{
						potentialTiles.push(tile);
					}

					if (!tile.IsOccupiedByActor || !tile.getEntity().isAttackable() || tile.getEntity().isAlliedWith(_user) || selectedTargets.find(tile.getEntity().getID()) != null)
					{
					}
					else
					{
						potentialTargets.push(tile);
					}
				}
			}

			if (potentialTargets.len() != 0)
			{
				target = ::MSU.Array.rand(potentialTargets).getEntity();
				selectedTargets.push(target.getID());
				targetTile = target.getTile();
			}
			else
			{
				target = null;
				targetTile = ::MSU.Array.rand(potentialTiles);
			}

			local data = {
				Skill = this,
				User = _user,
				TargetTile = targetTile,
				Target = target
			};
			this.applyEffect(data, 350);
			potentialTargets = [];
			potentialTiles = [];

			for( local i = 0; i < 6; i = ++i )
			{
				if (!targetTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = targetTile.getNextTile(i);

					if (tile.ID != myTile.ID)
					{
						potentialTiles.push(tile);
					}

					if (!tile.IsOccupiedByActor || !tile.getEntity().isAttackable() || tile.getEntity().isAlliedWith(_user) || selectedTargets.find(tile.getEntity().getID()) != null)
					{
					}
					else
					{
						potentialTargets.push(tile);
					}
				}
			}

			if (potentialTargets.len() != 0)
			{
				target = ::MSU.Array.rand(potentialTargets).getEntity();
				selectedTargets.push(target.getID());
				targetTile = target.getTile();
			}
			else
			{
				target = null;
				targetTile = ::MSU.Array.rand(potentialTiles);
			}

			local data = {
				Skill = this,
				User = _user,
				TargetTile = targetTile,
				Target = target
			};
			this.applyEffect(data, 550);
		}

		return success;
	};
});
*/