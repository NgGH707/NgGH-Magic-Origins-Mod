this.nggh_mod_shadow_copy_skill <- ::inherit("scripts/skills/skill", {
	m = {
		Copy = null,
		Tiles = [],
		LastRoundSummoned = -1,
	},
	function setShadowCopy( _c )
	{
		if (_c == null)
		{
			this.m.Copy = null;
		}
		else if (typeof _c == "instance")
		{
			this.m.Copy = _c;
		}
		else 
		{
		 	this.m.Copy = ::WeakTableRef(_c);
		}
	}

	function removeCopy( _terminate = false )
	{
		if (_terminate && this.m.Copy != null && !this.m.Copy.isNull())
		{
			this.m.Copy.setMaster(null);
			this.m.Copy.killSilently();
		}

		this.setShadowCopy(null);
	}

	function hasTile( _id )
	{
		foreach (i, t in this.m.Tiles) 
		{
		    if (t.ID == _id)
		    {
		    	return true;
		    }
		}

		return false;
	}

	function updateTiles()
	{
		local new = [];
		local id = this.getContainer().getActor().getID();

		foreach ( t in this.m.Tiles )
		{
			if (t.Properties.Effect == null || t.Properties.Effect.Type != "shadows")
			{
				continue;
			}

			if (("UserID" in t.Properties.Effect) && t.Properties.Effect.UserID == id)
			{
				new.push(t);
			}
		}

		this.m.Tiles = new;
	}

	function removeAllTiles()
	{
		foreach ( t in this.m.Tiles )
		{
			if (t.Properties.Effect != null && t.Properties.Effect.Type == "shadows")
			{
				::Tactical.Entities.removeTileEffect(t);
			}
		}

		this.m.Tiles = [];
	}

	function create()
	{
		this.m.ID = "actives.shadow_copy";
		this.m.Name = "Shadow Copy";
		this.m.Description = "Invoke a replicate copy makes out of shadow to aid you in battle while also expanding your realm of darkness. Your shadow copy can only exist within the reign of darkness and will respawned as long as darkness persists. Can\'t create more than one shadow copy.";
		this.m.Icon = "skills/active_160.png";
		this.m.IconDisabled = "skills/active_160.png";
		this.m.Overlay = "active_160";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/alp_sleep_01.wav",
			"sounds/enemies/dlc2/alp_sleep_02.wav",
			"sounds/enemies/dlc2/alp_sleep_03.wav",
			"sounds/enemies/dlc2/alp_sleep_04.wav",
			"sounds/enemies/dlc2/alp_sleep_05.wav",
			"sounds/enemies/dlc2/alp_sleep_06.wav",
			"sounds/enemies/dlc2/alp_sleep_07.wav",
			"sounds/enemies/dlc2/alp_sleep_08.wav",
			"sounds/enemies/dlc2/alp_sleep_09.wav",
			"sounds/enemies/dlc2/alp_sleep_10.wav",
			"sounds/enemies/dlc2/alp_sleep_11.wav",
			"sounds/enemies/dlc2/alp_sleep_12.wav"
		];
		this.m.IsUsingActorPitch = true;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 30;
		this.m.MinRange = 0;
		this.m.MaxRange = 10;
		this.m.MaxLevelDifference = 4;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();

		if (this.m.Tiles.len() == 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]You haven\'t created your realm of darkness[/color]"
			});

			return ret;
		}
		
		if (this.m.Copy != null && !this.m.Copy.isNull())
		{
		    ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "A shadow copy is under your control"
			});
		}
		else
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Instantly respawned your shadow copy at targeted area"
			});
		}

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = this.m.Copy != null && !this.m.Copy.isNull() && this.m.Copy.isAlive() ? 0.5 : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		local targets = [];
		local self = this;
		targets.push(_targetTile);

		for( local i = 0; i != 6; ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				targets.push(_targetTile.getNextTile(i));
			}
		}

		this.spawnReignOfShadow(targets)
		this.spawnShadow(::MSU.Array.rand(targets));
		return true;
	}

	function spawnReignOfShadow( _tiles )
	{
		local _user = this.getContainer().getActor();
		local p = {
			Type = "shadows",
			Tooltip = "Darkness reigns this place, be fear and be cautious. Created by " + ::Const.UI.getColorizedEntityName(_user),
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = false,
			IsAppliedOnMovement = true,
			IsAppliedOnEnter = true,
			IsPositive = false,
			Timeout = ::Time.getRound() + 3,
			IsByPlayer = _user.isPlayerControlled(),
			Callback = ::Const.Tactical.onApplyShadow,
			UserID = _user.getID(),
			function Applicable( _a )
			{
				return _a;
			}
		};

		foreach( tile in _tiles )
		{
			if (tile.Properties.Effect != null && tile.Properties.Effect.Type == "shadows")
			{
				local timeOut = tile.Properties.Effect.Timeout;
				tile.Properties.Effect = clone p;
				tile.Properties.Effect.Timeout = timeOut + 2;
			}
			else
			{
				if (tile.Properties.Effect != null)
				{
					::Tactical.Entities.removeTileEffect(tile);
				}

				tile.Properties.Effect = clone p;
				local particles = [];

				for( local i = 0; i < ::Const.Tactical.ShadowParticles.len(); ++i )
				{
					particles.push(::Tactical.spawnParticleEffect(true, ::Const.Tactical.ShadowParticles[i].Brushes, tile, ::Const.Tactical.ShadowParticles[i].Delay, ::Const.Tactical.ShadowParticles[i].Quantity, ::Const.Tactical.ShadowParticles[i].LifeTimeQuantity, ::Const.Tactical.ShadowParticles[i].SpawnRate, ::Const.Tactical.ShadowParticles[i].Stages));
				}
				
				::Tactical.Entities.addTileEffect(tile, tile.Properties.Effect, particles);
			}

			if (!this.hasTile(tile.ID))
			{
				this.m.Tiles.push(tile);
			}

			if (tile.IsOccupiedByActor)
			{
				::Const.Tactical.onApplyShadow(tile, tile.getEntity());
			}
		}
	}

	function spawnShadow( _tile = null )
	{
		if (this.m.Tiles.len() == 0)
		{
			return;
		}

		if (this.m.Copy != null && !this.m.Copy.isNull() && this.m.Copy.isAlive())
		{
			return;
		}

		if (this.m.LastRoundSummoned == ::Time.getRound())
		{
			return;
		}

		if (_tile == null || _tile.IsOccupiedByActor)
		{
			local viable = [];

			foreach ( t in this.m.Tiles ) 
			{
			    if (!t.IsOccupiedByActor)
			    {
			    	viable.push(t);
			    }
			}

			_tile = ::MSU.Array.rand(viable);
		}

		if (_tile == null)
		{
			return;
		}

		this.m.LastRoundSummoned = ::Time.getRound();
		::Tactical.EventLog.log("A nightmarish entity emerges from the darkness");
		local actor = this.getContainer().getActor();
		::Time.scheduleEvent(::TimeUnit.Virtual, 500, function( _skill )
		{
			local shadow_copy = ::Tactical.spawnEntity("scripts/entity/tactical/minions/nggh_mod_alp_nightmare_minion", _tile.Coords);
			shadow_copy.setFaction(2);
			shadow_copy.setMaster(actor);
			shadow_copy.setLink(_skill);
			shadow_copy.strengthen(actor);
			shadow_copy.spawnShadowEffect(_tile);
			_skill.setShadowCopy(shadow_copy);
		}.bindenv(this), this);
	}

	function onNewRound()
	{
		foreach ( t in this.m.Tiles )
		{
			if (t.Properties.Effect != null && t.Properties.Effect.Type == "shadows" && t.Properties.Effect.IsByPlayer)
			{
				t.addVisibilityForFaction(::Const.Faction.Player);
			}
		}
	}

	function onTurnStart()
	{
		this.updateTiles();
		this.spawnShadow();
	}

	function onResumeTurn()
	{
		this.updateTiles();
		this.spawnShadow();
	}

	function onDeath( _fatalityType )
	{
		this.removeCopy(true);
		this.removeAllTiles();
	}

	function onCombatStarted()
	{
		this.m.LastRoundSummoned = -1;
		this.m.Copy = null;
		this.m.Tiles = [];
	}

	function onCombatFinished()
	{
		this.m.Copy = null;
		this.m.Tiles = [];
	}

	function onTargetSelected( _targetTile )
	{
		::Tactical.getHighlighter().addOverlayIcon("mortar_target_02", _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);	

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = _targetTile.getNextTile(i);
				::Tactical.getHighlighter().addOverlayIcon("mortar_target_02", nextTile, nextTile.Pos.X, nextTile.Pos.Y);	
			}
		}
	}

});

