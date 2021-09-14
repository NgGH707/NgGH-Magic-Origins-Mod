this.gruesome_feast <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.gruesome_feast";
		this.m.Name = "Gruesome Feast";
		this.m.Description = "Time to eat, you can\'t grow up if you can\'t get enough nutrition from corpses.";
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
		local ret = [
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
				icon = "ui/icons/days_wounded.png",
				text = "Restores [color=" + this.Const.UI.Color.PositiveValue + "]100[/color] health points"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Instantly heal a random [color=" + this.Const.UI.Color.PositiveValue + "]Injury[/color]"
			}
		];
		
		if (this.getContainer().hasSkill("effects.swallowed_whole"))
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]So full right now, can not eat any more corpse[/color]"
			});
		}
		
		return ret;
	}
	
	function isUsable()
	{
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			return this.skill.isUsable();
		}
		
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.swallowed_whole") && this.getContainer().getActor().getTile().IsCorpseSpawned && this.getContainer().getActor().getTile().Properties.get("Corpse").IsConsumable;
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
		local HealthAdded = actor.isPlayerControlled() ? 100 : 200;
		_effect.addFeastStack();
		_effect.getContainer().update();
		actor.setHitpoints(this.Math.min(actor.getHitpoints() + HealthAdded, actor.getHitpointsMax()));
		local skills = _effect.getContainer().getAllSkillsOfType(this.Const.SkillType.Injury);

		foreach( s in skills )
		{
			s.removeSelf();

			if (actor.isPlayerControlled())
			{
				break;
			}
		}

		if (_effect.getContainer().hasSkill("perk.nacho_eat"))
		{
			_effect.getContainer().add(this.new("scripts/skills/effects/nacho_eat_effect"));
		}

		actor.onUpdateInjuryLayer();
	}
	
	function onBeforeUse( _user , _targetTile )
	{
		if (!_user.getFlags().has("luft"))
		{
			return;
		}
		
		this.Tactical.spawnSpriteEffect("luft_eat_quote_" + this.Math.rand(1, 3), this.createColor("#ffffff"), _user.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 145, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
	}

	function onUse( _user, _targetTile )
	{
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
		
		local effect = _user.getSkills().getSkillByID("effects.gruesome_feast");
		
		if (effect == null)
		{
			effect = this.new("scripts/skills/effects/gruesome_feast_effect");
			this.getContainer().add(effect);
		}

		if (_user.getFlags().has("hunger"))
		{
			local count = this.Math.min(2, _user.getFlags().getAsInt("hunger") + 1);
			_user.getFlags().set("hunger", count);
		}
		else 
		{
		    _user.getFlags().set("hunger", 2);
		}

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

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInShields ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

});

