this.perk_alp_living_nightmare <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.alp_living_nightmare";
		this.m.Name = this.Const.Strings.PerkName.AlpLivingNightmare;
		this.m.Description = this.Const.Strings.PerkDescription.AlpLivingNightmare;
		this.m.Icon = "ui/perks/perk_alp_living_nightmare.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	/*function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill != null && _skill.getID() == "actives.nightmare")
		{
			_targetEntity.getFlags().increment("nightmare_hits");
		}
	}*/

	function onTargetKilled( _targetEntity, _skill )
	{
		if (_skill == null || _skill.getID() != "actives.nightmare")
		{
			return;
		}

		/*if (this.Math.rand(1, 100) > _targetEntity.getFlags().getAsInt("nightmare_hits") * 50)
		{
			return;
		}*/

		local centerTile = _targetEntity.getTile();
		local tiles = [centerTile];

		for( local i = 0; i != 6; i = i )
		{
			if (!centerTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = centerTile.getNextTile(i);

				tiles.push(tile);
			}

			i = ++i;
		}

		this.spawnReignOfShadow(tiles);

		foreach ( tile in tiles )
		{
			if (tile.IsEmpty)
			{
				this.Tactical.EventLog.log("The nightmare manifests itself from " + this.Const.UI.getColorizedEntityName(_targetEntity) + "\'s dream");
				this.spawnShadow(tile);
				break;
			}
		}
	}

	function spawnShadow( _tile = null )
	{
		if (_tile == null)
		{
			return;
		}

		local actor = this.getContainer().getActor();
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, function( _skill )
		{
			_skill.spawnIcon("perk_alp_living_nightmare", _tile);
			local living_nightmare = this.Tactical.spawnEntity("scripts/entity/tactical/minions/special/alp_shadow_minion", _tile.Coords);
			living_nightmare.setFaction(2);
			living_nightmare.setMaster(actor);
			living_nightmare.strengthen(actor);
			living_nightmare.spawnShadowEffect(_tile);
		}.bindenv(this), this);
	}

	function spawnReignOfShadow( _tiles )
	{
		local _user = this.getContainer().getActor();
		local self = this;
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
			Callback = this.Const.MC_Combat.onApplyShadow,
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
				tile.Properties.Effect.Timeout = this.Time.getRound() + 3;
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

			if (tile.IsOccupiedByActor && tile.getEntity().isAlive() && !tile.getEntity().isDying())
			{
				this.Const.MC_Combat.onApplyShadow(tile, tile.getEntity());
			}
		}
	}

});

