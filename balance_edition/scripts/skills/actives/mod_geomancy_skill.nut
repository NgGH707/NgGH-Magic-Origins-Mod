this.mod_geomancy_skill <- this.inherit("scripts/skills/skill", {
	m = {
		AffectedTiles = [], 
		Cooldown = 0
	},
	function create()
	{
		this.m.ID = "actives.geomancy";
		this.m.Name = "Geomancy";
		this.m.Description = "Change the terrain height of a tile of your choice for 2 turns, all thanks to the power of \'The Black Book\'.";
		this.m.Icon = "skills/active_220.png";
		this.m.IconDisabled = "skills/active_220_sw.png";
		this.m.Overlay = "active_220";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/sand_golem_death_01.wav",
			"sounds/enemies/dlc6/sand_golem_death_02.wav",
			"sounds/enemies/dlc6/sand_golem_death_03.wav",
			"sounds/enemies/dlc6/sand_golem_death_04.wav"
		];
		this.m.SoundOnHit = this.m.SoundOnUse;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted + 2;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 99;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();

		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Raise a low level tile to the highest level and vice versa"
		});

		if (this.m.Cooldown > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can only be used after " + this.m.Cooldown + " turn(s)[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.m.Cooldown == 0;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		foreach ( a in this.m.AffectedTiles )
		{
			if (_targetTile.ID == a.Tile.ID)
			{
				return false;
			}
		}

		return true;
	}

	function onDeath( _fatalityType )
	{
		this.onReturnAllTilesToNormal();
	}

	function onCombatStarted()
	{
		this.m.Cooldown = 0;
		this.m.AffectedTiles = [];
	}

	function onCombatFinished()
	{
		this.m.Cooldown = 0;
		this.m.AffectedTiles = [];
	}

	function addAffectedTile( _tile )
	{
		this.m.AffectedTiles.push({
			Tile = _tile,
			TurnsLeft = 2,
			Level = _tile.Level
		});
	}

	function onTurnStart()
	{
		local stillGood = [];
		local garbage = [];

		foreach ( a in this.m.AffectedTiles )
		{
			if (--a.TurnsLeft <= 0)
			{
				garbage.push(a);
			}
			else
			{
				stillGood.push(a);
			}
		}

		foreach (i, a in garbage )
		{
			this.onReturnTileToNormal(a.Tile, a.Level, i == 0);
		}

		this.m.AffectedTiles = stillGood;
		this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
	}

	function onUse( _user, _targetTile )
	{
		//this.m.Cooldown = 2;
		this.onSwapTiles(_user, _targetTile);
		return true;
	}

	function onSwapTiles( _user , _targetTile )
	{
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, _user.getPos());
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " commands the earth!");
		this.addAffectedTile(_targetTile);

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local next = _targetTile.getNextTile(i);

				if (next.IsOccupiedByActor)
				{
					if (next.getEntity().hasZoneOfControl())
					{
						next.getEntity().setZoneOfControl(next, false);
					}

					next.removeZoneOfOccupation(next.getEntity().getFaction());
				}
			}
		}

		if (_targetTile.Level < 3)
		{
			_targetTile.Level = 3;
		}
		else if (_targetTile.Level > 0)
		{
			_targetTile.Level = 0;
		}

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local next = _targetTile.getNextTile(i);

				if (next.IsOccupiedByActor)
				{
					if (next.getEntity().hasZoneOfControl())
					{
						next.getEntity().setZoneOfControl(next, next.getEntity().hasZoneOfControl());
					}

					next.addZoneOfOccupation(next.getEntity().getFaction());
				}
			}
		}

		for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _targetTile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity, this.Const.Tactical.DustParticles[i].LifeTimeQuantity, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
		}

		if (this.Tactical.getCamera().Level < 3)
		{
			this.Tactical.getCamera().Level = 3;
		}
	}

	function onReturnAllTilesToNormal()
	{
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, this.getContainer().getActor().Pos);
		this.Tactical.EventLog.log("The earth moves again");

		foreach ( a in this.m.AffectedTiles )
		{
			this.onReturnTileToNormal(a.Tile, a.Level, false);
		}

		if (this.Tactical.getCamera().Level == 3)
		{
			this.Tactical.getCamera().Level = 2;
		}
	}

	function onReturnTileToNormal( _tile, _level, _isMakingSound = true )
	{
		if (_isMakingSound)
		{
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, _tile.Pos);
			this.Tactical.EventLog.log("The earth moves again");
		}
		
		for( local i = 0; i < 6; i = ++i )
		{
			if (!_tile.hasNextTile(i))
			{
			}
			else
			{
				local next = _tile.getNextTile(i);

				if (next.IsOccupiedByActor)
				{
					if (next.getEntity().hasZoneOfControl())
					{
						next.getEntity().setZoneOfControl(next, false);
					}

					next.removeZoneOfOccupation(next.getEntity().getFaction());
				}
			}
		}

		_tile.Level = _level;

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_tile.hasNextTile(i))
			{
			}
			else
			{
				local next = _tile.getNextTile(i);

				if (next.IsOccupiedByActor)
				{
					if (next.getEntity().hasZoneOfControl())
					{
						next.getEntity().setZoneOfControl(next, next.getEntity().hasZoneOfControl());
					}

					next.addZoneOfOccupation(next.getEntity().getFaction());
				}
			}
		}

		if (_tile.IsVisibleForPlayer)
		{
			for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _tile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity, this.Const.Tactical.DustParticles[i].LifeTimeQuantity, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
			}

			if (_isMakingSound && this.Tactical.getCamera().Level == 3)
			{
				this.Tactical.getCamera().Level = 2;
			}
		}
	}

});

