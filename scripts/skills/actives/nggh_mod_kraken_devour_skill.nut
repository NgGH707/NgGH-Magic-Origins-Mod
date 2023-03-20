this.nggh_mod_kraken_devour_skill <- ::inherit("scripts/skills/skill", {
	m = {
		Cooldown = 0,
	},
	function create()
	{
		this.m.ID = "actives.kraken_devour";
		this.m.Name = "Devour";
		this.m.Description = "Hmm fresh meal to my mouth";
		this.m.KilledString = "Devoured";
		this.m.Icon = "skills/active_150.png";
		this.m.IconDisabled = "skills/active_150_sw.png";
		this.m.Overlay = "active_150";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/krake_devour_01.wav",
			"sounds/enemies/dlc2/krake_devour_02.wav",
			"sounds/enemies/dlc2/krake_devour_03.wav",
			"sounds/enemies/dlc2/krake_devour_04.wav",
			"sounds/enemies/dlc2/krake_devour_05.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 1800;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = false;
		this.m.IsUsingHitchance = false;
		this.m.IsAudibleWhenHidden = false;
		this.m.IsUsingActorPitch = true;
		this.m.InjuriesOnBody = ::Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = ::Const.Injury.CuttingHead;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 50;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/chance_to_hit_head.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]Instantly Kill[/color] any target"
		});

		if (this.m.Cooldown != 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "Need [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.Cooldown + "[/color] turn(s) to fully digest this meal"
			});
		}

		return ret;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		if (this.m.Cooldown != 0)
		{
			return false;
		}

		return true;
	}

	function spawnBloodbath( _targetTile )
	{
		for( local i = 0; i != ::Const.CorpsePart.len(); ++i )
		{
			_targetTile.spawnDetail(::Const.CorpsePart[i]);
		}

		for( local i = 0; i != 6; ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);

				for( local n = ::Math.rand(0, 2); n != 0; --n )
				{
					tile.spawnDetail(::MSU.Array.rand(::Const.BloodDecals[::Const.BloodType.Red]));
				}
			}
		}

		local myTile = this.getContainer().getActor().getTile();

		for( local n = 2; n != 0; --n )
		{
			myTile.spawnDetail(::MSU.Array.rand(::Const.BloodDecals[::Const.BloodType.Red]));
		}
	}

	function onRemoveTarget( _targetTile )
	{
		_targetTile.getEntity().kill(this.getContainer().getActor(), this, ::Const.FatalityType.Kraken);
		::Tactical.Entities.removeCorpse(_targetTile);
		_targetTile.clear(::Const.Tactical.DetailFlag.Corpse);
		_targetTile.Properties.remove("Corpse");
		_targetTile.Properties.remove("IsSpawningFlies");
		this.spawnBloodbath(_targetTile);

		if (::Tactical.State.m.StrategicProperties != null)
		{
			if (!("Loot" in ::Tactical.State.m.StrategicProperties))
			{
				::Tactical.State.m.StrategicProperties.Loot <- [];
			}
			
			::Tactical.State.m.StrategicProperties.Loot.push("scripts/items/supplies/strange_meat_item");
		}

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInGreatSwords)
		{
			local tentacles = this.getContainer().getActor().getTentacles();

			foreach (i, t in tentacles)
			{
				if (t == null || t.isNull() || !t.isAlive() || t.isDying())
				{
					continue;
				}

			    t.setHitpoints(::Math.min(t.getHitpointsMax(), t.getHitpoints() + ::Math.rand(20, 35)));

			    if (t.isPlacedOnMap())
			    {
			    	this.spawnIcon("status_effect_79", t.getTile());
			    }
			}
		}
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();

		if (!_targetTile.IsOccupiedByActor || _targetTile.getEntity().isAlliedWith(_user))
		{
			for( local i = 0; i != 6; i = ++i )
			{
				if (!myTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = myTile.getNextTile(i);
					
					if (tile.IsOccupiedByActor && !tile.getEntity().isAlliedWith(_user))
					{
						_targetTile = tile;
					}
				}
			}
		}

		if (!_targetTile.IsOccupiedByActor || _targetTile.getEntity().isAlliedWith(_user))
		{
			return false;
		}

		this.m.Cooldown = _user.getCurrentProperties().IsSpecializedInGreatSwords ? 1 : ::Math.rand(1, 2);
		::Time.scheduleEvent(::TimeUnit.Virtual, 1000, ::onDelayedEffect.bindenv(this), {
			User = _user,
			TargetTile = _targetTile
		});
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local myTile = this.getContainer().getActor().getTile();
		local isScreenShaking = false;
		::Tactical.getCamera().quake(_user, _targetTile.getEntity(), 5.0, 0.16, 0.3);

		for( local i = 0; i < ::Const.Tactical.KrakenDevourParticles.len(); ++i )
		{
			::Tactical.spawnParticleEffect(false, ::Const.Tactical.KrakenDevourParticles[i].Brushes, myTile, ::Const.Tactical.KrakenDevourParticles[i].Delay, ::Const.Tactical.KrakenDevourParticles[i].Quantity, ::Const.Tactical.KrakenDevourParticles[i].LifeTimeQuantity, ::Const.Tactical.KrakenDevourParticles[i].SpawnRate, ::Const.Tactical.KrakenDevourParticles[i].Stages);
		}
		
		if (_user.isDiscovered() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " devours " + ::Const.UI.getColorizedEntityName(_targetTile.getEntity()));
		}

		::Tactical.getShaker().shake(_targetTile.getEntity(), myTile, 3, ::Const.Combat.ShakeEffectHitpointsHitColor, ::Const.Combat.ShakeEffectHitpointsHitHighlight, ::Const.Combat.ShakeEffectHitpointsHitFactor, ::Const.Combat.ShakeEffectHitpointsSaturation, ::Const.ShakeCharacterLayers[::Const.BodyPart.All], 2.0);

		for( local i = 0; i < ::Const.Tactical.KrakenDevourVictimParticles.len(); ++i )
		{
			::Tactical.spawnParticleEffect(false, ::Const.Tactical.KrakenDevourVictimParticles[i].Brushes, _targetTile, ::Const.Tactical.KrakenDevourVictimParticles[i].Delay, ::Const.Tactical.KrakenDevourVictimParticles[i].Quantity, ::Const.Tactical.KrakenDevourVictimParticles[i].LifeTimeQuantity, ::Const.Tactical.KrakenDevourVictimParticles[i].SpawnRate, ::Const.Tactical.KrakenDevourVictimParticles[i].Stages);
		}

		_user.checkMorale(1, 20);
		::Time.scheduleEvent(::TimeUnit.Virtual, 500, this.onRemoveTarget.bindenv(this), _targetTile);
	}

	function onTurnStart()
	{
		this.m.Cooldown = ::Math.max(0, this.m.Cooldown - 1);
	}

	function onCombatFinished()
	{
		this.m.Cooldown = 0;
	}

});

