this.shadow_copy_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Copy = null,
		Tiles = []
	},
	function removeCopy( _terminate = false )
	{
		if (_terminate && this.m.Copy != null)
		{
			this.m.Copy.setMaster(null);
			this.m.Copy.killSilently();
		}

		this.m.Copy = null;
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

		foreach ( t in this.m.Tiles )
		{
			if (t.Properties.Effect != null && t.Properties.Effect.Type == "shadows" && t.Properties.Effect.UserID == this.getContainer().getActor().getID())
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
				this.Tactical.Entities.removeTileEffect(t);
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
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]You haven\'t created your realm of darkness[/color]"
			});
		}
		else 
		{
			if (this.m.Copy != null)
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
		}

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = this.m.Copy != null ? 0.5 : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		local targets = [];
		local self = this;
		targets.push(_targetTile);

		for( local i = 0; i != 6; i = i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				targets.push(tile);
			}

			i = ++i;
		}

		this.spawnReignOfShadow(targets)
		this.spawnShadow(::mc_randArray(targets));
		return true;
	}

	function spawnReignOfShadow( _tiles )
	{
		local _user = this.getContainer().getActor();
		local p = {
			Type = "shadows",
			Tooltip = "Darkness reigns this place, be fear and be cautious.",
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = false,
			IsAppliedOnMovement = true,
			IsAppliedOnEnter = true,
			IsPositive = false,
			Timeout = this.Time.getRound() + 3,
			IsByPlayer = _user.isPlayerControlled(),
			Callback = self.onApplyShadow,
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
				tile.Properties.Effect = clone p;
				tile.Properties.Effect.Timeout = this.Time.getRound() + 2;
			}
			else
			{
				if (tile.Properties.Effect != null)
				{
					this.Tactical.Entities.removeTileEffect(tile);
				}

				tile.Properties.Effect = clone p;
				local particles = [];

				for( local i = 0; i < this.Const.Tactical.ShadowParticles.len(); i = i )
				{
					particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.ShadowParticles[i].Brushes, tile, this.Const.Tactical.ShadowParticles[i].Delay, this.Const.Tactical.ShadowParticles[i].Quantity, this.Const.Tactical.ShadowParticles[i].LifeTimeQuantity, this.Const.Tactical.ShadowParticles[i].SpawnRate, this.Const.Tactical.ShadowParticles[i].Stages));
					i = ++i;
				}
				
				this.Tactical.Entities.addTileEffect(tile, tile.Properties.Effect, particles);
			}

			if (!this.hasTile(tile.ID))
			{
				this.m.Tiles.push(tile);
			}

			if (tile.IsOccupiedByActor)
			{
				this.onApplyShadow(tile, tile.getEntity());
			}
		}
	}

	function spawnShadow( _tile = null )
	{
		if (this.m.Tiles.len() == 0 || this.m.Copy != null)
		{
			return;
		}

		if (_tile == null || _tile.IsOccupiedByActor)
		{
			local viable = [];

			foreach ( i, t in this.m.Tiles ) 
			{
			    if (!t.IsOccupiedByActor)
			    {
			    	viable.push(t);
			    }
			}

			_tile = ::mc_randArray(viable);
		}

		if (_tile == null)
		{
			return;
		}

		this.Tactical.EventLog.log("A ghastly entity emerges from the darkness");
		local actor = this.getContainer().getActor();
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, function( _skill )
		{
			_skill.m.Copy = this.Tactical.spawnEntity("scripts/entity/tactical/minions/special/alp_shadow_minion", _tile.Coords);
			_skill.m.Copy.setFaction(2);
			_skill.m.Copy.setMaster(actor);
			_skill.m.Copy.setLink(_skill);
			_skill.m.Copy.strengthen(actor);
			_skill.m.Copy.spawnShadowEffect(_tile);
		}.bindenv(this), this);
	}

	function onApplyShadow( _tile, _entity )
	{
		if (_entity.getMoraleState() == this.Const.MoraleState.Ignore)
		{
			return;
		}

		if (_entity.getFlags().has("alp"))
		{
			return;
		}

		local exclude = [
			this.Const.EntityType.Alp,
			this.Const.EntityType.AlpShadow,
			this.Const.EntityType.LegendDemonAlp,
		];

		if (exclude.find(_entity.getType()) != null)
		{
			return;
		}

		local shadow = _entity.getSkills().getSkillByID("effects.reign_of_darkness");

		if (shadow == null)
		{
			_entity.getSkills().add(this.new("scripts/skills/effects/reign_of_darkness_effect"));
		}
	}

	function onNewRound()
	{
		foreach ( t in this.m.Tiles )
		{
			if (t.Properties.Effect != null && t.Properties.Effect.Type == "shadows" && t.Properties.Effect.IsByPlayer)
			{
				t.addVisibilityForFaction(this.Const.Faction.Player);
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
	}

	function onDeath()
	{
		this.removeCopy(true);
		this.removeAllTiles();
	}

	function onCombatStarted()
	{
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
		this.Tactical.getHighlighter().addOverlayIcon("mortar_target_02", _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);	

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = _targetTile.getNextTile(i);
				this.Tactical.getHighlighter().addOverlayIcon("mortar_target_02", nextTile, nextTile.Pos.X, nextTile.Pos.Y);	
			}
		}
	}

});

