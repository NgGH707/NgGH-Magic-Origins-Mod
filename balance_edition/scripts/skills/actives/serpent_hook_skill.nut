this.serpent_hook_skill <- this.inherit("scripts/skills/skill", {
	m = {
		DestinationTile = null,
	},

	function isImprovedDrag() 
	{
	    return this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields;
	}

	function isUpgradeDrag()
	{
		return this.getContainer().getActor().getCurrentProperties().IsSpecializedInThrowing;
	}

	function create()
	{
		this.m.ID = "actives.serpent_hook";
		this.m.Name = "Drag";
		this.m.Description = "Constrict a target and drag them closer to you. Will break any defensive stance if that target had before being dragged.";
		this.m.Icon = "skills/active_192.png";
		this.m.IconDisabled = "skills/active_192_sw.png";
		this.m.Overlay = "active_192";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/snake_snare_01.wav",
			"sounds/enemies/dlc6/snake_snare_02.wav",
			"sounds/enemies/dlc6/snake_snare_03.wav"
		];
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted - 1;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
	}
	
	function onAfterUpdate( _properties )
	{
		this.m.MaxRange = _properties.IsSpecializedInThrowing ? 4 : 3;
		this.m.FatigueCostMult = _properties.IsSpecializedInThrowing ? 0.75 : 1.0;
	}
	
	function onAdded()
	{
		this.setFatigueCost(this.m.Container.getActor().isPlayerControlled() ? 30 : 20);
	}
	
	function getHitchance( _targetEntity )
	{
		if (!_targetEntity.isAttackable() && !_targetEntity.isRock() && !_targetEntity.isTree() && !_targetEntity.isBush() && !_targetEntity.isSupplies())
		{
			return 0;
		}

		if (this.isImprovedDrag() && _targetEntity.getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			return 50;
		}

		return 100;
	}

	function getTooltip()
	{
		local p = this.getContainer().getActor().getCurrentProperties();
		local chance = this.Math.max(10, this.Math.floor(p.getMeleeSkill() * 0.5));
		local ret = (this.isImprovedDrag() || this.isUpgradeDrag()) ? this.getDefaultTooltip() : [
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
		];

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] chance to stagger on a hit"
			},
		]);

		if (p.IsSpecializedInShields)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + this.Const.UI.Color.PositiveValue + "]" + chance + "%[/color] chance to disarm on a hit"
			});
		}

		return ret;
	}

	function setDestinationTile( _t )
	{
		this.m.DestinationTile = _t;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().getActor().getCurrentProperties().IsRooted;
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		return this.getPulledToTile(_userTile, _targetTile);
	}

	function getPulledToTile( _userTile, _targetTile )
	{
		local tiles = this.getPulledToTiles(_userTile, _targetTile);

		if (tiles.len() != 0)
		{
			return tiles[0];
		}
		else
		{
			return null;
		}
	}

	function getPulledToTiles( _userTile, _targetTile )
	{
		local tiles = [];

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_userTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _userTile.getNextTile(i);

				if (tile.Level <= _userTile.Level && tile.IsEmpty && tile.getDistanceTo(_targetTile) <= this.m.MaxRange)
				{
					tiles.push(tile);
				}
			}
		}

		if (tiles.len() <= 1)
		{
			return tiles;
		}

		local ret = this.smartFilter(_userTile, _targetTile, tiles);
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.getEntity().getCurrentProperties().IsRooted)
		{
			return false;
		}
		
		if (_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab && (!_targetTile.getEntity().getFlags().has("egg") || _targetTile.getEntity().getType() != this.Const.EntityType.SpiderEggs))
		{
			if (this.isImprovedDrag() && this.isViableTarget(_originTile.getEntity(), _targetTile.getEntity()))
			{
			}
			else 
			{
			    return false;
			}
		}

		local pulledTo = this.getPulledToTile(_originTile, _targetTile);

		if (pulledTo == null)
		{
			return false;
		}

		return true;
	}

	function isViableTarget( _user, _target )
	{
		if (_target.isAlliedWith(_user))
		{
			return true;
		}

		if (_target.isNonCombatant())
		{
			return false;
		}

		local type = _target.getType();
		local invalid = [
			this.Const.EntityType.Mortar,
			this.Const.EntityType.Ghost,
			this.Const.EntityType.SkeletonPhylactery,
			this.Const.EntityType.SkeletonLichMirrorImage,
			this.Const.EntityType.Schrat,
			this.Const.EntityType.Lindwurm,
			this.Const.EntityType.Kraken,
			this.Const.EntityType.KrakenTentacle,
			this.Const.EntityType.TricksterGod,
			this.Const.EntityType.LegendOrcBehemoth,
			this.Const.EntityType.LegendWhiteDirewolf,
			this.Const.EntityType.LegendStollwurm,
			this.Const.EntityType.LegendRockUnhold,
			this.Const.EntityType.LegendGreenwoodSchrat,
		];

		return invalid.find(type) == null;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local distance = _user.getTile().getDistanceTo(_targetTile);
		local pullToTile;

		if (this.m.DestinationTile != null)
		{
			pullToTile = this.m.DestinationTile;
			this.m.DestinationTile = null;
		}
		else
		{
			pullToTile = this.getPulledToTile(_user.getTile(), _targetTile);
		}

		if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			local r = this.Math.rand(1, 100);

			if (target.getFlags().has("egg"))
			{
			}
			else if (!this.isImprovedDrag())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " fails to drag in " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()));
				return false;
			}
			else if (r > 50)
			{
			    this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " fails to drag in " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()) + " (Chance: 50, Rolled: " + r + ")");
				return false;
			}
		}

		if (pullToTile == null)
		{
			return false;
		}

		if (!_user.isHiddenToPlayer() && pullToTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " drags in " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()));
		}

		if (!_user.isHiddenToPlayer() || !target.isHiddenToPlayer())
		{
			local variant = _user.m.Variant;
			local scaleBackup = target.getSprite("status_rooted").Scale;
			_user.fadeOut(50);
			local rooted_front = target.getSprite("status_rooted");
			rooted_front.Scale = 1.0;
			rooted_front.setBrush("snake_ensnare_front_0" + variant);
			rooted_front.Visible = true;
			rooted_front.Alpha = 0;
			rooted_front.fadeIn(50);
			local rooted_back = target.getSprite("status_rooted_back");
			rooted_back.Scale = 1.0;
			rooted_back.setBrush("snake_ensnare_back_0" + variant);
			rooted_back.Visible = true;
			rooted_back.Alpha = 0;
			rooted_back.fadeIn(50);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 900, this.onDone, {
				User = _user,
				Target = target,
				ScaleBackup = scaleBackup,
				Skill = this
			});
		}

		local skills = _targetTile.getEntity().getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);

		local properties = this.getContainer().buildPropertiesForUse(this, target);
		local damage = properties.IsSpecializedInThrowing ? this.Math.rand(5, 15) : 0;
		damage = properties.IsSpecializedInShields ? damage + this.Math.rand(10, 15) : damage;
		local total_damage = damage * properties.DamageRegularMult;
		local damage_mult = properties.DamageTotalMult * properties.MeleeDamageMult;
		local damageArmor = damage * properties.DamageArmorMult;
		damageArmor = this.Math.max(0, damageArmor + distance * _info.Properties.DamageAdditionalWithEachTile) * damage_mult;
		total_damage = this.Math.max(0, total_damage + distance * _info.Properties.DamageAdditionalWithEachTile) * damage_mult;
		total_damage = this.Math.max(0, this.Math.abs(pullToTile.Level - _targetTile.Level) - 1) * this.Const.Combat.FallingDamage + total_damage;
		local damageDirect = this.Math.minf(1.0, properties.DamageDirectMult * (this.m.DirectDamageMult + properties.DamageDirectAdd));

		if (target.isAlliedWith(_user) || damage == 0)
		{
			this.Tactical.getNavigator().teleport(_targetTile.getEntity(), pullToTile, null, null, true);
		}
		else
		{
			local tag = {
				Attacker = _user,
				Skill = this,
				HitInfo = clone this.Const.Tactical.HitInfo
			};
			tag.HitInfo.DamageRegular = total_damage;
			tag.HitInfo.DamageArmor = damageArmor;
			tag.HitInfo.DamageFatigue = this.Const.Combat.FatigueReceivedPerHit;
			tag.HitInfo.DamageDirect = damageDirect;
			tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
			this.Tactical.getNavigator().teleport(_targetTile.getEntity(), pullToTile, this.onPulledDown, tag, true);
		}
		
		if (!target.isAlliedWith(_user) || this.Math.rand(1, 100) <= 50)
		{
			target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));
			
			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has staggered " + this.Const.UI.getColorizedEntityName(target) + " for one turn");
			}
		}

		return true;
	}

	function onPulledDown( _entity, _tag )
	{
		_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
		_tag.Skill.getContainer().onTargetHit(_tag.Skill, _entity, _tag.HitInfo.BodyPart, _tag.HitInfo.DamageInflictedHitpoints, _tag.HitInfo.DamageInflictedArmor);
	}

	function onDone( _data )
	{
		_data.User.fadeIn(50);

		if (_data.Target.isAlive() && !_data.Target.isDying())
		{
			local rooted_front = _data.Target.getSprite("status_rooted");
			rooted_front.fadeOutAndHide(50);
			rooted_front.Scale = _data.ScaleBackup;
			local rooted_back = _data.Target.getSprite("status_rooted_back");
			rooted_back.fadeOutAndHide(50);
			rooted_back.Scale = _data.ScaleBackup;
		}

		this.Time.scheduleEvent(this.TimeUnit.Virtual, 100, _data.Skill.onAfterDone, _data);
	}

	function onAfterDone( _data )
	{
		if (!_data.Target.isAlive() || _data.Target.isDying())
		{
			return;
		}

		if (_data.User.getCurrentProperties().IsSpecializedInShields && !_data.Target.isAlliedWith(_data.User))
		{
			local target = _data.Target;
			local chance = this.Math.max(10, this.Math.floor(_data.User.getCurrentProperties().getMeleeSkill() * 0.5));
			
			if (!target.getCurrentProperties().IsStunned && !target.getCurrentProperties().IsImmuneToDisarm && this.Math.rand(1, 100) <= chance)
			{
				target.getSkills().add(this.new("scripts/skills/effects/disarmed_effect"));
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_data.User) + " has disarmed " + this.Const.UI.getColorizedEntityName(target) + " for one turn");
			}
		}
		
		_data.Target.setDirty(true);
	}

	function onTargetSelected( _targetTile )
	{
		local pulledTo = this.getPulledToTile(this.getContainer().getActor().getTile(), _targetTile);

		if (pulledTo != null)
		{
			this.Tactical.getHighlighter().addOverlayIcon("mortar_target_02", pulledTo, pulledTo.Pos.X, pulledTo.Pos.Y);
		}
	}

	function smartFilter( _userTile, _targetTile , _tilesArray ) 
	{
		local ret = [];
	    local _user = this.getContainer().getActor();
		local _target = _targetTile.getEntity();
		local BestScore = 0;
		local BestTarget = null;

		foreach (i, t in _tilesArray) 
		{
		    local score = 0;

		    if (!_target.isAlliedWith(_user))
		    {
		    	if (t.Level < _userTile.Level)
		    	{
		    		score += _userTile.Level - t.Level;
		    	}

		    	if (t.Type == this.Const.Tactical.TerrainType.Swamp)
		    	{
		    		score += 5;
		    	}

		    	if (t.Properties.Effect != null && !t.Properties.Effect.IsPositive)
				{
					score += 3;
		    	}

		    	if (t.IsHidingEntity)
		    	{
		    		score -= 3;
		    	}

				for( local i = 0; i != 6; i = ++i )
				{
					if (!t.hasNextTile(i))
					{
					}
					else
					{
						local tile = t.getNextTile(i);

						if (tile.IsOccupiedByActor)
						{
							local entity = tile.getEntity();

							if (tile.isSameTileAs(_targetTile) || tile.isSameTileAs(_userTile))
							{
								continue;
							}

							if (entity.isAlliedWith(_user))
							{
								if (!entity.getCurrentProperties().IsStunned)
								{
									score += this.scoreTheEntity(entity);
								}
								
								score += 2
							}
							else
							{
								score -= 2;
							}
						}
					}
				}
		    }
		    else
		    {
		    	if (t.Type == this.Const.Tactical.TerrainType.Swamp)
		    	{
		    		score -= 5;
		    	}

		    	if (t.Properties.Effect != null && !t.Properties.Effect.IsPositive)
				{
					score -= 3;
		    	}

		    	if (t.IsHidingEntity)
		    	{
		    		score += 5;
		    	}

				for( local i = 0; i != 6; i = ++i )
				{
					if (!t.hasNextTile(i))
					{
					}
					else
					{
						local tile = t.getNextTile(i);

						if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != this.Const.MoraleState.Fleeing)
						{
							local entity = tile.getEntity();
							score += this.scoreDistanceToTheNearestEnemies(tile, _target);

							if (tile.isSameTileAs(_targetTile) || tile.isSameTileAs(_userTile))
							{
								continue;
							}

							if (entity.isAlliedWith(_user))
							{
								score += 2;
							}
							else
							{
								if (entity.getCurrentProperties().IsStunned)
								{
									score -= 4;
									continue;
								}

								score -= this.scoreTheEntity(entity);
								score -= 2;
							}
						}
					}
				}
		    }

		   if (score > BestScore)
			{
				BestScore = score;
				BestTarget = t;
			}
		}

		if (BestTarget != null)
		{
			return [BestTarget];
		}

		if (_tilesArray.len() != 0)
		{
			return _tilesArray;
		}

		return [];
	}

	function scoreTheEntity( _entity ) 
	{
	    local score = 0;
	    local mult = _entity.isAlliedWith(this.getContainer().getActor()) ? _entity.getHitpointsPct() : 1;
	    local meleeSkill =  _entity.getCurrentProperties().getMeleeSkill();
	    local meleeDefense = _entity.getCurrentProperties().getMeleeDefense();
	    
	    score = score + meleeSkill * 0.01;
		score = score + meleeDefense * 0.01;

		if (!_entity.isTurnDone() && _entity.getActionPoints() >= 5)
		{
			score += 2;
		}

		if (meleeSkill > 85)
		{
			score += 1;
		}

		if (meleeDefense > 40)
		{
			score += 1;
		}

		score = _entity.getMoraleState() == 0 ? 0 : score + _entity.getMoraleState() * 0.1;
		score = score * mult;

		if (_entity.isArmedWithRangedWeapon())
		{
			score = score + (_entity.isAlliedWith(this.getContainer().getActor()) ? -5 : 5);
		}

		if (_entity.isAlliedWith(this.getContainer().getActor()) && _entity.getCurrentProperties().TargetAttractionMult > 1.0)
		{
			score = score - _entity.getCurrentProperties().TargetAttractionMult * 1.15; 
		}

		local injuries = _entity.getSkills().query(this.Const.SkillType.Injury);
		score = score - (_entity.isAlliedWith(this.getContainer().getActor()) ? 0.75 * injuries.len() : 0);

		return score;
	}

	function scoreDistanceToTheNearestEnemies( _tile , _target ) 
	{
		local _user = this.getContainer().getActor();
		local score = 0;
		local distance = 9999;
		local danger = 0;
	    local allEntities = this.Tactical.Entities.getAllInstancesAsArray();

		foreach( e in allEntities )
		{
			if (e.getID() == _user.getID() || e.getID() == _target.getID() || e.isAlliedWith(_user))
			{
				continue;
			}

			local d = _tile.getDistanceTo(e.getTile());

			if (d < distance)
			{
				distance = d;
				danger = this.Math.max(1, this.scoreTheEntity(e));
			}
		}

		if (distance <= 0 || danger == 0)
		{
			return 0;
		}

		score += -(danger / distance);
	    return score;
	}

	function onSortScoreByDescend( _a, _b )
	{
		if (_a.Score > _b.Score)
		{
			return 1;
		}
		else if (_a.Score < _b.Score)
		{
			return -1;
		}

		return 0;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 0;
			_properties.DamageRegularMax = 0;
			_properties.DamageArmorMult *= 0.7;

			if (this.isUpgradeDrag())
			{
				_properties.DamageRegularMin +=  5;
				_properties.DamageRegularMax += 15;
			}

			if (this.isImprovedDrag())
			{
				_properties.DamageRegularMin += 10;
				_properties.DamageRegularMax += 15;
			}
		}
	}
});

