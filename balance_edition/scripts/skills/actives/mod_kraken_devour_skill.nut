this.mod_kraken_devour_skill <- this.inherit("scripts/skills/skill", {
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
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 1800;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = false;
		this.m.IsUsingHitchance = false;
		this.m.IsAudibleWhenHidden = false;
		this.m.IsUsingActorPitch = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 100;
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
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]Instantly Kill[/color] any target"
		});

		if (this.m.Cooldown != 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "Need [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Cooldown + "[/color] turn(s) to fully digest this meal"
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
		for( local i = 0; i != this.Const.CorpsePart.len(); i = ++i )
		{
			_targetTile.spawnDetail(this.Const.CorpsePart[i]);
		}

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);

				for( local n = this.Math.rand(0, 2); n != 0; n = --n )
				{
					local decal = this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)];
					tile.spawnDetail(decal);
				}
			}
		}

		local myTile = this.getContainer().getActor().getTile();

		for( local n = 2; n != 0; n = --n )
		{
			local decal = this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)];
			myTile.spawnDetail(decal);
		}
	}

	function onRemoveTarget( _targetTile )
	{
		_targetTile.getEntity().kill(this.getContainer().getActor(), this, this.Const.FatalityType.Kraken);
		this.Tactical.Entities.removeCorpse(_targetTile);
		_targetTile.clear(this.Const.Tactical.DetailFlag.Corpse);
		_targetTile.Properties.remove("Corpse");
		_targetTile.Properties.remove("IsSpawningFlies");
		this.spawnBloodbath(_targetTile);

		if (this.Tactical.State.m.StrategicProperties != null)
		{
			if (!("Loot" in this.Tactical.State.m.StrategicProperties))
			{
				this.Tactical.State.m.StrategicProperties.Loot <- [];
			}
			
			this.Tactical.State.m.StrategicProperties.Loot.push("scripts/items/supplies/strange_meat_item");
		}

		if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInGreatSwords)
		{
			return;
		}

		local tentacles = this.getContainer().getActor().getTentacles();

		foreach (i, t in tentacles)
		{
		    t.setHitpoints(this.Math.min(t.getHitpointsMax(), t.getHitpoints() + 10));

		    if (t.isPlacedOnMap())
		    {
		    	this.spawnIcon("status_effect_79", t.getTile());
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

		local tag = {
			User = _user,
			TargetTile = _targetTile
		};

		if (_user.getCurrentProperties().IsSpecializedInGreatSwords)
		{
			this.m.Cooldown = 1;
		}
		else
		{
		    this.m.Cooldown = this.Math.rand(1, 2);
		}
		
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 1000, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local myTile = this.getContainer().getActor().getTile();
		local isScreenShaking = false;
		this.Tactical.getCamera().quake(_user, _targetTile.getEntity(), 5.0, 0.16, 0.3);

		for( local i = 0; i < this.Const.Tactical.KrakenDevourParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.KrakenDevourParticles[i].Brushes, myTile, this.Const.Tactical.KrakenDevourParticles[i].Delay, this.Const.Tactical.KrakenDevourParticles[i].Quantity, this.Const.Tactical.KrakenDevourParticles[i].LifeTimeQuantity, this.Const.Tactical.KrakenDevourParticles[i].SpawnRate, this.Const.Tactical.KrakenDevourParticles[i].Stages);
		}
		
		if (_user.isDiscovered() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " devours " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()));
		}

		this.Tactical.getShaker().shake(_targetTile.getEntity(), myTile, 3, this.Const.Combat.ShakeEffectHitpointsHitColor, this.Const.Combat.ShakeEffectHitpointsHitHighlight, this.Const.Combat.ShakeEffectHitpointsHitFactor, this.Const.Combat.ShakeEffectHitpointsSaturation, this.Const.ShakeCharacterLayers[this.Const.BodyPart.All], 2.0);

		for( local i = 0; i < this.Const.Tactical.KrakenDevourVictimParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.KrakenDevourVictimParticles[i].Brushes, _targetTile, this.Const.Tactical.KrakenDevourVictimParticles[i].Delay, this.Const.Tactical.KrakenDevourVictimParticles[i].Quantity, this.Const.Tactical.KrakenDevourVictimParticles[i].LifeTimeQuantity, this.Const.Tactical.KrakenDevourVictimParticles[i].SpawnRate, this.Const.Tactical.KrakenDevourVictimParticles[i].Stages);
		}

		_user.checkMorale(1, 20);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onRemoveTarget.bindenv(this), _targetTile);
	}

	function onTurnStart()
	{
		this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
	}

	function onCombatFinished()
	{
		this.m.Cooldown = 0;
	}

});

