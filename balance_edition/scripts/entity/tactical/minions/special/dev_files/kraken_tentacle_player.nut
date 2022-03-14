this.kraken_tentacle_player <- this.inherit("scripts/entity/tactical/player_beast", {
	m = {
		Parent = null,
		Mode = 0
	},
	function spawnBloodPool( _a, _b ) {}
	function setParent( _p )
	{
		if (_p == null)
		{
			this.m.Parent = null;
		}
		else
		{
			this.m.Parent = this.WeakTableRef(_p);
		}
	}

	function getParent()
	{
		return this.m.Parent;
	}

	function getBackground()
	{
		return this.m.Parent != null ? this.m.Parent.getBackground() : null;
	}

	function getTalents()
	{
		return this.m.Parent != null ? this.m.Parent.getTalents() : [0, 0, 0, 0, 0, 0, 0, 0];
	}

	function setMode( _m )
	{
		this.m.Mode = _m;

		if (this.isPlacedOnMap())
		{
			if (this.m.Mode == 0 && _m == 1)
			{
				this.m.IsUsingZoneOfControl = true;
				this.setZoneOfControl(this.getTile(), true);
			}

			this.onUpdateInjuryLayer();
		}
	}

	function getMode()
	{
		return this.m.Mode;
	}

	function getImageOffsetY()
	{
		return 20;
	}

	function create()
	{
		this.player_beast.create();
		this.m.IsControlledByPlayer = true;
		this.m.Type = this.Const.EntityType.KrakenTentacle;
		this.m.XP = this.Const.Tactical.Actor.KrakenTentacle.XP;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.IsUsingZoneOfControl = false;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(15, -26);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.DeathBloodAmount = 0.0;
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/dlc2/krake_choke_01.wav",
			"sounds/enemies/dlc2/krake_choke_02.wav",
			"sounds/enemies/dlc2/krake_choke_03.wav",
			"sounds/enemies/dlc2/krake_choke_04.wav",
			"sounds/enemies/dlc2/krake_choke_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/tentacle_death_01.wav",
			"sounds/enemies/dlc2/tentacle_death_02.wav",
			"sounds/enemies/dlc2/tentacle_death_03.wav",
			"sounds/enemies/dlc2/tentacle_death_04.wav",
			"sounds/enemies/dlc2/tentacle_death_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/dlc2/krake_idle_01.wav",
			"sounds/enemies/dlc2/krake_idle_02.wav",
			"sounds/enemies/dlc2/krake_idle_03.wav",
			"sounds/enemies/dlc2/krake_idle_04.wav",
			"sounds/enemies/dlc2/krake_idle_05.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/tentacle_hurt_01.wav",
			"sounds/enemies/dlc2/tentacle_hurt_02.wav",
			"sounds/enemies/dlc2/tentacle_hurt_03.wav",
			"sounds/enemies/dlc2/tentacle_hurt_04.wav",
			"sounds/enemies/dlc2/tentacle_hurt_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc2/krake_idle_10.wav",
			"sounds/enemies/dlc2/krake_idle_11.wav",
			"sounds/enemies/dlc2/krake_idle_12.wav",
			"sounds/enemies/dlc2/krake_idle_13.wav",
			"sounds/enemies/dlc2/krake_idle_14.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/dlc2/krake_choke_01.wav",
			"sounds/enemies/dlc2/krake_choke_02.wav",
			"sounds/enemies/dlc2/krake_choke_03.wav",
			"sounds/enemies/dlc2/krake_choke_04.wav",
			"sounds/enemies/dlc2/krake_choke_05.wav"
		];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 2.0;
		this.m.Flags.add("kraken_tentacle");
		this.m.Items.blockAllSlots();
		this.setGuest(true);
		this.setName("Irrlicht");
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		_tile = this.getTile();
		local decal_body = _tile.spawnDetail(this.getMode() == 0 ? "bust_kraken_tentacle_01_injured" : "bust_kraken_tentacle_02_injured", this.Const.Tactical.DetailFlag.Corpse, false);
		local corpse_data = {
			Body = decal_body,
			Start = this.Time.getRealTimeF(),
			Vector = this.createVec(0.0, -150.0),
			Tile = _tile,
			function onCorpseEffect( _data )
			{
				if (this.Time.getRealTimeF() - _data.Start >= 0.75)
				{
					_tile.clear(this.Const.Tactical.DetailFlag.Corpse);
					return;
				}

				local f = (this.Time.getRealTimeF() - _data.Start) / 0.75;
				_data.Body.setOffset(this.createVec(0.0, 0.0 + _data.Vector.Y * f));
				this.Time.scheduleEvent(this.TimeUnit.Real, 10, _data.onCorpseEffect, _data);
			}

		};
		this.Time.scheduleEvent(this.TimeUnit.Real, 10, corpse_data.onCorpseEffect, corpse_data);

		if (this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype].len() != 0)
		{
			for( local i = 0; i < this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype].len(); i = ++i )
			{
				if (this.Tactical.getWeather().IsRaining && !this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].ApplyOnRain)
				{
				}
				else
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Brushes, _tile, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Delay, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Quantity, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].LifeTimeQuantity, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].SpawnRate, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Stages);
				}
			}
		}
		else if (this.Const.Tactical.RaiseFromGroundParticles.len() != 0)
		{
			for( local i = 0; i < this.Const.Tactical.RaiseFromGroundParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseFromGroundParticles[i].Brushes, _tile, this.Const.Tactical.RaiseFromGroundParticles[i].Delay, this.Const.Tactical.RaiseFromGroundParticles[i].Quantity, this.Const.Tactical.RaiseFromGroundParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseFromGroundParticles[i].SpawnRate, this.Const.Tactical.RaiseFromGroundParticles[i].Stages);
			}
		}

		if (this.m.Parent != null && !this.m.Parent.isNull() && this.m.Parent.isAlive() && !this.m.Parent.isDying())
		{
			this.m.Parent.onTentacleDestroyed();
		}

		this.Tactical.getTemporaryRoster().remove(this);
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.KrakenTentacle);
		b.IsAffectedByNight = false;
		b.IsMovable = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;
		b.IsAffectedByRain = false;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_player");
		local body = this.addSprite("body");
		body.setBrush("bust_kraken_tentacle_01");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.68;
		this.setSpriteOffset("status_rooted", this.createVec(5, 25));
		this.setSpriteOffset("arrow", this.createVec(0, 25));
		this.setSpriteOffset("status_stunned", this.createVec(0, 25));
		
		this.m.Skills.add(this.new("scripts/skills/actives/mod_kraken_bite_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_kraken_move_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_kraken_ensnare_skill"));

		this.Tactical.getTemporaryRoster().add(this);
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = this.Const.BodyPart.Body;
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function onUpdateInjuryLayer()
	{
		local body = this.getSprite("body");
		local p = this.getHitpointsPct();

		if (p > 0.5)
		{
			if (this.m.Mode == 0)
			{
				body.setBrush("bust_kraken_tentacle_01");
			}
			else
			{
				body.setBrush("bust_kraken_tentacle_02");
			}
		}
		else if (this.m.Mode == 0)
		{
			body.setBrush("bust_kraken_tentacle_01_injured");
		}
		else
		{
			body.setBrush("bust_kraken_tentacle_02_injured");
		}

		this.setDirty(true);
	}

	function onPlacedOnMap()
	{
		this.actor.onPlacedOnMap();
		this.onUpdateInjuryLayer();
	}

	function onActorKilled( _actor, _tile, _skill )
	{
		this.player_beast.onActorKilled(_actor, _tile, _skill);
		
		if (this.m.Parent != null && !this.m.Parent.isNull() && this.m.Parent.isAlive() && !this.m.Parent.isDying())
		{
			local stats = this.m.Parent.getSkills().getSkillByID("special.stats_collector");

			if (stats != null)
			{
				stats.onTargetKilled(_actor, _skill);
			}
		}
	}

	function addXP( _xp, _scale = true )
	{
		if (this.m.Parent != null && !this.m.Parent.isNull() && this.m.Parent.isAlive() && !this.m.Parent.isDying())
		{
			this.m.Parent.addXP(_xp, _scale);
		}
	}

	function onTurnStart()
	{
		this.updateMode();
		this.player_beast.onTurnStart();
	}

	function onTurnResumed()
	{
		this.updateMode();
		this.player_beast.onTurnResumed();
	}

	function updateMode()
	{
		if (this.m.Mode == 1)
		{
			this.m.IsUsingZoneOfControl = true;
			this.setZoneOfControl(this.getTile(), true);
		}

		this.onUpdateInjuryLayer();
	}

});

