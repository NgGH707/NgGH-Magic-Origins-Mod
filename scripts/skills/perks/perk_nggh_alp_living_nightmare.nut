this.perk_nggh_alp_living_nightmare <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.alp_living_nightmare";
		this.m.Name = ::Const.Strings.PerkName.NggHAlpLivingNightmare;
		this.m.Description = ::Const.Strings.PerkDescription.NggHAlpLivingNightmare;
		this.m.Icon = "ui/perks/perk_alp_living_nightmare.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
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

		/*if (::Math.rand(1, 100) > _targetEntity.getFlags().getAsInt("nightmare_hits") * 50)
		{
			return;
		}*/

		local centerTile = _targetEntity.getTile();
		local tiles = [centerTile];

		for( local i = 0; i != 6; ++i )
		{
			if (!centerTile.hasNextTile(i))
			{
			}
			else
			{
				tiles.push(centerTile.getNextTile(i));
			}
		}

		this.spawnReignOfShadow(tiles);

		foreach ( tile in tiles )
		{
			if (tile.IsEmpty)
			{
				::Tactical.EventLog.log("The nightmare manifests itself from " + ::Const.UI.getColorizedEntityName(_targetEntity) + "\'s dream");
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
		::Time.scheduleEvent(::TimeUnit.Virtual, 500, function( _skill )
		{
			_skill.spawnIcon("perk_alp_living_nightmare", _tile);
			local living_nightmare = ::Tactical.spawnEntity("scripts/entity/tactical/minions/nggh_mod_alp_nightmare_minion", _tile.Coords);
			living_nightmare.setFaction(2);
			living_nightmare.setMaster(actor);
			living_nightmare.strengthen(actor);
			living_nightmare.spawnShadowEffect(_tile);
		}.bindenv(this), this);
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
				tile.Properties.Effect = clone p;
				tile.Properties.Effect.Timeout = ::Time.getRound() + 3;
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

			if (tile.IsOccupiedByActor && tile.getEntity().isAlive() && !tile.getEntity().isDying())
			{
				::Const.Tactical.onApplyShadow(tile, tile.getEntity());
			}
		}
	}

});

