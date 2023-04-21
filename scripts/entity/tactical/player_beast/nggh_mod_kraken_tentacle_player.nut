this.nggh_mod_kraken_tentacle_player <- ::inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {
		Parent = null,
		Mode = ::Const.KrakenTentacleMode.Ensnaring
	},
	function setParent( _p )
	{
		if (_p == null)
		{
			this.m.Parent = null;
		}
		else
		{
			this.m.Parent = typeof _p == "instance" ? _p : ::WeakTableRef(_p);
		}
	}

	function getImageOffsetY()
	{
		return 20;
	}

	function getParent()
	{
		return this.m.Parent;
	}

	function getBackground()
	{
		return this.m.Parent != null && !this.m.Parent.isNull() ? this.m.Parent.getBackground() : null;
	}

	function getTalents()
	{
		return this.m.Parent != null && !this.m.Parent.isNull() ? this.m.Parent.getTalents() : [0, 0, 0, 0, 0, 0, 0, 0];
	}

	function getMode()
	{
		return this.m.Mode;
	}

	function setMode( _m )
	{
		if (this.m.Mode == _m) return;

		this.m.Mode = _m;
		this.updateMode();
	}

	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.Type = ::Const.EntityType.KrakenTentacle;
		this.m.BloodType = ::Const.BloodType.Red;
		this.m.MoraleState = ::Const.MoraleState.Ignore;
		this.m.BloodSplatterOffset = ::createVec(0, 0);
		this.m.DecapitateSplatterOffset = ::createVec(15, -26);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.DeathBloodAmount = 0.0;
		this.m.IsUsingZoneOfControl = false;
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/dlc2/krake_choke_01.wav",
			"sounds/enemies/dlc2/krake_choke_02.wav",
			"sounds/enemies/dlc2/krake_choke_03.wav",
			"sounds/enemies/dlc2/krake_choke_04.wav",
			"sounds/enemies/dlc2/krake_choke_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/tentacle_death_01.wav",
			"sounds/enemies/dlc2/tentacle_death_02.wav",
			"sounds/enemies/dlc2/tentacle_death_03.wav",
			"sounds/enemies/dlc2/tentacle_death_04.wav",
			"sounds/enemies/dlc2/tentacle_death_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/dlc2/krake_idle_01.wav",
			"sounds/enemies/dlc2/krake_idle_02.wav",
			"sounds/enemies/dlc2/krake_idle_03.wav",
			"sounds/enemies/dlc2/krake_idle_04.wav",
			"sounds/enemies/dlc2/krake_idle_05.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/tentacle_hurt_01.wav",
			"sounds/enemies/dlc2/tentacle_hurt_02.wav",
			"sounds/enemies/dlc2/tentacle_hurt_03.wav",
			"sounds/enemies/dlc2/tentacle_hurt_04.wav",
			"sounds/enemies/dlc2/tentacle_hurt_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc2/krake_idle_10.wav",
			"sounds/enemies/dlc2/krake_idle_11.wav",
			"sounds/enemies/dlc2/krake_idle_12.wav",
			"sounds/enemies/dlc2/krake_idle_13.wav",
			"sounds/enemies/dlc2/krake_idle_14.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/dlc2/krake_choke_01.wav",
			"sounds/enemies/dlc2/krake_choke_02.wav",
			"sounds/enemies/dlc2/krake_choke_03.wav",
			"sounds/enemies/dlc2/krake_choke_04.wav",
			"sounds/enemies/dlc2/krake_choke_05.wav"
		];
		this.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] = 2.0;
		this.m.Flags.add("kraken_tentacle");
		this.setGuest(true);

		// can't equip most things
		local items = this.getItems(); 
		items.getData()[::Const.ItemSlot.Offhand][0] = -1;
		items.getData()[::Const.ItemSlot.Mainhand][0] = -1;
		items.getData()[::Const.ItemSlot.Accessory][0] = -1;
		items.getData()[::Const.ItemSlot.Head][0] = -1;
		items.getData()[::Const.ItemSlot.Body][0] = -1;
		items.getData()[::Const.ItemSlot.Ammo][0] = -1;
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		_tile = this.getTile();

		local decal_body = _tile.spawnDetail(this.getMode() == ::Const.KrakenTentacleMode.Ensnaring ? "bust_kraken_tentacle_01_injured" : "bust_kraken_tentacle_02_injured", ::Const.Tactical.DetailFlag.Corpse, false);
		local corpse_data = {
			Body = decal_body,
			Start = ::Time.getRealTimeF(),
			Vector = ::createVec(0.0, -150.0),
			Tile = _tile,
			function onCorpseEffect( _data )
			{
				if (::Time.getRealTimeF() - _data.Start >= 0.75)
				{
					_tile.clear(::Const.Tactical.DetailFlag.Corpse);
					return;
				}

				local f = (::Time.getRealTimeF() - _data.Start) / 0.75;
				_data.Body.setOffset(::createVec(0.0, 0.0 + _data.Vector.Y * f));
				::Time.scheduleEvent(::TimeUnit.Real, 10, _data.onCorpseEffect, _data);
			}

		};
		::Time.scheduleEvent(::TimeUnit.Real, 10, corpse_data.onCorpseEffect, corpse_data);

		if (::Const.Tactical.TerrainDropdownParticles[_tile.Subtype].len() != 0)
		{
			for( local i = 0; i < ::Const.Tactical.TerrainDropdownParticles[_tile.Subtype].len(); i = ++i )
			{
				if (::Tactical.getWeather().IsRaining && !::Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].ApplyOnRain)
				{
				}
				else
				{
					::Tactical.spawnParticleEffect(false, ::Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Brushes, _tile, ::Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Delay, ::Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Quantity, ::Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].LifeTimeQuantity, ::Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].SpawnRate, ::Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Stages);
				}
			}
		}
		else if (::Const.Tactical.RaiseFromGroundParticles.len() != 0)
		{
			for( local i = 0; i < ::Const.Tactical.RaiseFromGroundParticles.len(); i = ++i )
			{
				::Tactical.spawnParticleEffect(false, ::Const.Tactical.RaiseFromGroundParticles[i].Brushes, _tile, ::Const.Tactical.RaiseFromGroundParticles[i].Delay, ::Const.Tactical.RaiseFromGroundParticles[i].Quantity, ::Const.Tactical.RaiseFromGroundParticles[i].LifeTimeQuantity, ::Const.Tactical.RaiseFromGroundParticles[i].SpawnRate, ::Const.Tactical.RaiseFromGroundParticles[i].Stages);
			}
		}

		if (this.m.Parent != null && !this.m.Parent.isNull() && this.m.Parent.isAlive() && !this.m.Parent.isDying())
		{
			this.m.Parent.onTentacleDestroyed();
		}

		::Tactical.getTemporaryRoster().remove(this);
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.KrakenTentacle);
		b.IsMovable = false;
		b.IsAffectedByRain = false;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;

		this.addSprite("socket").setBrush("bust_base_player");
		local body = this.addSprite("body");
		body.setBrush("bust_kraken_tentacle_01");

		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.68;
		this.setSpriteOffset("status_rooted", ::createVec(5, 25));
		this.setSpriteOffset("arrow", ::createVec(0, 25));
		this.setSpriteOffset("status_stunned", ::createVec(0, 25));
		
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_kraken_bite_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_kraken_move_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_kraken_ensnare_skill"));

		::Tactical.getTemporaryRoster().add(this);
	}

	function onAfterFactionChanged()
	{
		this.getSprite("body").setHorizontalFlipping(this.isAlliedWithPlayer());
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = ::Const.BodyPart.Body;
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function onUpdateInjuryLayer()
	{
		local body = this.getSprite("body");

		if (this.getHitpointsPct() > 0.5)
		{
			if (this.getMode() == ::Const.KrakenTentacleMode.Ensnaring)
			{
				body.setBrush("bust_kraken_tentacle_01");
			}
			else
			{
				body.setBrush("bust_kraken_tentacle_02");
			}
		}
		else if (this.getMode() == ::Const.KrakenTentacleMode.Ensnaring)
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
		this.nggh_mod_player_beast.onActorKilled(_actor, _tile, _skill);
		
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
		//this.updateMode();
		this.nggh_mod_player_beast.onTurnStart();
	}

	function onTurnResumed()
	{
		//this.updateMode();
		this.nggh_mod_player_beast.onTurnResumed();
	}

	function updateMode()
	{
		if (this.isPlacedOnMap())
		{
			this.m.IsUsingZoneOfControl = this.m.Mode == ::Const.KrakenTentacleMode.Attacking;
			this.setZoneOfControl(this.getTile(), this.m.Mode == ::Const.KrakenTentacleMode.Attacking);
		}

		this.onUpdateInjuryLayer();
	}

	function spawnBloodPool( _a, _b ) 
	{
	}

});

