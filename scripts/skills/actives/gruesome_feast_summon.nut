this.gruesome_feast_summon <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 0
	},
	function create()
	{
		this.m.ID = "actives.gruesome_feast";
		this.m.Name = "Gruesome Feast";
		this.m.Description = "Time to eat, you can\'t grow up if you can\'t get enough nutrition.";
		this.m.Icon = "skills/active_40.png";
		this.m.IconDisabled = "skills/active_40_sw.png";
		this.m.Overlay = "active_40";
		this.m.SoundOnUse = [
			"sounds/enemies/gruesome_feast_01.wav",
			"sounds/enemies/gruesome_feast_02.wav",
			"sounds/enemies/gruesome_feast_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAudibleWhenHidden = false;
		this.m.IsUsingActorPitch = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local p = this.getContainer().getActor().getCurrentProperties();
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Feasts on corpse to [color=" + this.Const.UI.Color.PositiveValue + "]self-heal[/color] or to [color=" + this.Const.UI.Color.PositiveValue + "]evolve[/color]"
			}
		];
	}
	
	function isUsable()
	{
		return this.skill.isUsable() && this.getContainer().getActor().getTile().IsCorpseSpawned && this.getContainer().getActor().getTile().Properties.get("Corpse").IsConsumable && this.m.Cooldown <= 0;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (!_targetTile.IsCorpseSpawned)
		{
			return false;
		}

		if (!_targetTile.Properties.get("Corpse").IsConsumable)
		{
			return false;
		}

		if (!_targetTile.IsEmpty)
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

	function onRemoveCorpse( _tag )
	{
		this.Tactical.Entities.removeCorpse(_tag);
		_tag.clear(this.Const.Tactical.DetailFlag.Corpse);
		_tag.Properties.remove("Corpse");
		_tag.Properties.remove("IsSpawningFlies");
	}

	function onFeasted( _effect )
	{
		local actor = _effect.getContainer().getActor();
		_effect.addFeastStack();
		_effect.getContainer().update();
		actor.setHitpoints(this.Math.min(actor.getHitpoints() + 200, actor.getHitpointsMax()));
		local skills = _effect.getContainer().getAllSkillsOfType(this.Const.SkillType.Injury);

		foreach( s in skills )
		{
			s.removeSelf();
		}
	}

	function onUse( _user, _targetTile )
	{
		++this.m.Cooldown;
		_targetTile = _user.getTile();

		if (_targetTile.IsVisibleForPlayer)
		{
			if (this.Const.Tactical.GruesomeFeastParticles.len() != 0)
			{
				for( local i = 0; i < this.Const.Tactical.GruesomeFeastParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.GruesomeFeastParticles[i].Brushes, _targetTile, this.Const.Tactical.GruesomeFeastParticles[i].Delay, this.Const.Tactical.GruesomeFeastParticles[i].Quantity, this.Const.Tactical.GruesomeFeastParticles[i].LifeTimeQuantity, this.Const.Tactical.GruesomeFeastParticles[i].SpawnRate, this.Const.Tactical.GruesomeFeastParticles[i].Stages);
				}
			}

			if (_user.isDiscovered() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " feasts on a corpse");
			}
		}

		if (!_user.isHiddenToPlayer())
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onRemoveCorpse, _targetTile);
		}
		else
		{
			this.onRemoveCorpse(_targetTile);
		}

		this.spawnBloodbath(_targetTile);
		_user.setHitpoints(_user.getHitpointsMax());
		_user.onUpdateInjuryLayer();
		local effect = _user.getSkills().getSkillByID("effects.gruesome_feast");

		if (!_user.isHiddenToPlayer())
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onFeasted, effect);
		}
		else
		{
			this.onFeasted(effect);
		}

		return true;
	}
	
	function onTurnEnd()
	{
		this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
	}

});

