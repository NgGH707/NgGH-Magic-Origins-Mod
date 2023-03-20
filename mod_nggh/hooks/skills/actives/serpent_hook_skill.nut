::mods_hookExactClass("skills/actives/serpent_hook_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Serpent Drag";
		this.m.Description = "Constrict a target and drag them closer to you. Will break any defensive stance that target had before being dragged. Can be used on allies.";
		this.m.Icon = "skills/active_192.png";
		this.m.IconDisabled = "skills/active_192_sw.png";
		this.m.Delay = 500;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted - 1;
		this.m.IsWeaponSkill = false;
		this.m.IsAttack = false;
		this.m.DirectDamageMult = 0.2;
	};
	obj.isImprovedDrag <- function() 
	{
	    return this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields;
	};
	obj.isUpgradeDrag <- function()
	{
		return this.getContainer().getActor().getCurrentProperties().IsSpecializedInThrowing;
	};
	obj.onAdded <- function()
	{
		this.setFatigueCost(this.getContainer().getActor().isPlayerControlled() ? 30 : 20);
	};
	function getTooltip()
	{
		local p = this.getContainer().getActor().getCurrentProperties();
		local chance = ::Math.max(10, ::Math.floor(p.getMeleeSkill() * 0.5));
		local ret = this.isImprovedDrag() || this.isUpgradeDrag() ? this.getDefaultTooltip() : this.getDefaultUtilityTooltip();

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]100%[/color] chance to stagger on a hit"
			},
		]);

		if (p.IsSpecializedInShields)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]" + chance + "%[/color] chance to disarm on a hit"
			});
		}

		return ret;
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.MaxRange = _properties.IsSpecializedInThrowing ? 4 : 3;
		this.m.FatigueCostMult = _properties.IsSpecializedInThrowing ? 0.75 : 1.0;
	};
	obj.getHitchance <- function( _targetEntity )
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
	};
	obj.getPulledToTiles = function( _userTile, _targetTile )
	{
		local tiles = [];

		for( local i = 0; i < 6; ++i )
		{
			if (!_userTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _userTile.getNextTile(i);

				if (tile.Level <= _userTile.Level && tile.IsEmpty && tile.getDistanceTo(_targetTile) <= this.getMaxRange())
				{
					tiles.push(tile);
				}
			}
		}

		if (tiles.len() <= 1)
		{
			return tiles;
		}

		return this.smartFilter(_userTile, _targetTile, tiles);
	};
	obj.onVerifyTarget = function( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (target.getCurrentProperties().IsRooted)
		{
			return false;
		}

		if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			if (!target.isAlliedWith(this.getContainer().getActor()))
			{
				return false;
			}

			if (!this.isImprovedDrag())
			{
				return false;
			}
		}

		return this.getPulledToTile(_originTile, _targetTile) != null;
	};
	obj.isViableTarget <- function( _user, _target )
	{
		if (_target.isAlliedWith(_user))
		{
			return true;
		}

		if (_target.isNonCombatant())
		{
			return false;
		}

		return [
			::Const.EntityType.Mortar,
			::Const.EntityType.Ghost,
			::Const.EntityType.SkeletonPhylactery,
			::Const.EntityType.SkeletonLichMirrorImage,
			::Const.EntityType.Schrat,
			::Const.EntityType.Lindwurm,
			::Const.EntityType.Kraken,
			::Const.EntityType.KrakenTentacle,
			::Const.EntityType.TricksterGod,
			::Const.EntityType.LegendOrcBehemoth,
			::Const.EntityType.LegendWhiteDirewolf,
			::Const.EntityType.LegendStollwurm,
			::Const.EntityType.LegendRockUnhold,
			::Const.EntityType.LegendGreenwoodSchrat,
		].find(_target.getType()) == null;
	};
	obj.onUse = function( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local distance = _user.getTile().getDistanceTo(_targetTile);
		local pullToTile;

		if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab && (!target.isAlliedWith(_user) || !this.isImprovedDrag()))
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " fails to drag in " + ::Const.UI.getColorizedEntityName(_targetTile.getEntity()));
			return false;
		}

		if (this.m.DestinationTile != null)
		{
			pullToTile = this.m.DestinationTile;
			this.m.DestinationTile = null;
		}
		else
		{
			pullToTile = this.getPulledToTile(_user.getTile(), _targetTile);
		}

		if (pullToTile == null)
		{
			return false;
		}

		if (!_user.isHiddenToPlayer() && pullToTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " drags in " + ::Const.UI.getColorizedEntityName(_targetTile.getEntity()));
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
			::Time.scheduleEvent(::TimeUnit.Virtual, 900, this.onDone, {
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
		skills.removeByID("effects.legend_vala_chant_disharmony_effect");
		skills.removeByID("effects.legend_vala_chant_fury_effect");
		skills.removeByID("effects.legend_vala_chant_senses_effect");
		skills.removeByID("effects.legend_vala_currently_chanting");
		skills.removeByID("effects.legend_vala_in_trance");
		target.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);

		local properties = this.getContainer().buildPropertiesForUse(this, target);
		local damage = properties.IsSpecializedInThrowing ? ::Math.rand(5, 15) : 0;
		damage = properties.IsSpecializedInShields ? damage + ::Math.rand(10, 15) : damage;
		local total_damage = damage * properties.DamageRegularMult;
		local damage_mult = properties.DamageTotalMult * properties.MeleeDamageMult;
		local damageArmor = damage * properties.DamageArmorMult;
		damageArmor = ::Math.max(0, damageArmor + distance * properties.DamageAdditionalWithEachTile) * damage_mult;
		total_damage = ::Math.max(0, total_damage + distance * properties.DamageAdditionalWithEachTile) * damage_mult;
		total_damage = ::Math.max(0, ::Math.abs(pullToTile.Level - _targetTile.Level) - 1) * ::Const.Combat.FallingDamage + total_damage;
		local damageDirect = ::Math.minf(1.0, properties.DamageDirectMult * (this.m.DirectDamageMult + properties.DamageDirectAdd));

		if (target.isAlliedWith(_user) || damage == 0)
		{
			::Tactical.getNavigator().teleport(_targetTile.getEntity(), pullToTile, null, null, true);
		}
		else
		{
			local tag = {
				Attacker = _user,
				Skill = this,
				HitInfo = clone ::Const.Tactical.HitInfo
			};
			tag.HitInfo.DamageRegular = total_damage;
			tag.HitInfo.DamageArmor = damageArmor;
			tag.HitInfo.DamageFatigue = ::Const.Combat.FatigueReceivedPerHit;
			tag.HitInfo.DamageDirect = damageDirect;
			tag.HitInfo.BodyPart = ::Const.BodyPart.Body;
			::Tactical.getNavigator().teleport(_targetTile.getEntity(), pullToTile, this.onPulledDown, tag, true);
		}
		
		if (!target.isAlliedWith(_user) || ::Math.rand(1, 100) <= 50)
		{
			target.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
			
			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " has staggered " + ::Const.UI.getColorizedEntityName(target) + " for one turn");
			}
		}

		return true;
	};

	local ws_onPulledDown = obj.onPulledDown;
	obj.onPulledDown = function( _entity, _tag )
	{
		ws_onPulledDown(_entity, _tag);
		_tag.Skill.getContainer().onTargetHit(_tag.Skill, _entity, _tag.HitInfo.BodyPart, _tag.HitInfo.DamageInflictedHitpoints, _tag.HitInfo.DamageInflictedArmor);
	};
	obj.onDone = function( _data )
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

		::Time.scheduleEvent(::TimeUnit.Virtual, 100, _data.Skill.onAfterDone, _data);
	};

	local ws_onAfterDone = obj.onAfterDone;
	obj.onAfterDone = function( _data )
	{
		if (!_data.Target.isAlive() || _data.Target.isDying())
		{
			return;
		}

		if (_data.User.getCurrentProperties().IsSpecializedInShields && !_data.Target.isAlliedWith(_data.User))
		{
			local target = _data.Target;
			local chance = ::Math.max(10, ::Math.floor(_data.User.getCurrentProperties().getMeleeSkill() * 0.45));
			
			if (!target.getCurrentProperties().IsStunned && !target.getCurrentProperties().IsImmuneToDisarm && ::Math.rand(1, 100) <= chance)
			{
				target.getSkills().add(::new("scripts/skills/effects/disarmed_effect"));
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_data.User) + " has disarmed " + ::Const.UI.getColorizedEntityName(target) + " for one turn");
			}
		}
		
		ws_onAfterDone(_data);
	};
	obj.onTargetSelected <- function( _targetTile )
	{
		local pulledTo = this.getPulledToTile(this.getContainer().getActor().getTile(), _targetTile);

		if (pulledTo != null)
		{
			::Tactical.getHighlighter().addOverlayIcon("mortar_target_02", pulledTo, pulledTo.Pos.X, pulledTo.Pos.Y);
		}
	};
	obj.smartFilter <- function( _userTile, _targetTile , _tilesArray ) 
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

		    	if (t.Type == ::Const.Tactical.TerrainType.Swamp)
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
								else 
								{
									score -= 4;
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
		    	if (t.Type == ::Const.Tactical.TerrainType.Swamp)
		    	{
		    		score -= 5;
		    	}

		    	if (t.Properties.Effect != null && !t.Properties.Effect.IsPositive)
				{
					score -= 3;
		    	}

		    	if (t.IsHidingEntity)
		    	{
		    		score += 3;
		    	}

				for( local i = 0; i != 6; i = ++i )
				{
					if (!t.hasNextTile(i))
					{
					}
					else
					{
						local tile = t.getNextTile(i);

						if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != ::Const.MoraleState.Fleeing)
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
									score += 1;
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
	};
	obj.scoreTheEntity <- function( _entity ) 
	{
	    local score = 0;
	    local isAllied = _entity.isAlliedWith(this.getContainer().getActor());
	    local mult = 1.0;

	    if (isAllied)
	    {
	    	mult = _entity.getHitpointsPct();

	    	if (_entity.getHitpointsMax() < 250)
	    	{
	    		if (mult <= 0.5)
	    		{
	    			mult *= 0.67;
	    		}
	    	}
	    	else
	    	{
	    		if (mult > 0.5)
	    		{
	    			mult *= 1.25;
	    		}
	    	}
	    }

	    local meleeSkill =  _entity.getCurrentProperties().getMeleeSkill();
	    local meleeDefense = _entity.getCurrentProperties().getMeleeDefense();

		if (!_entity.isTurnDone() && _entity.getActionPoints() >= 5)
		{
			score += 2;
		}

		if (meleeSkill >= 85)
		{
			score += 1;
		}
		else if (meleeSkill >= 50)
	    {
			score = score + meleeDefense * 0.02;
		}
		else
		{
			score = score - meleeDefense * 0.02;
		}

		if (meleeDefense >= 50)
		{
			score += 1;
		}
		else if (meleeDefense >= 30)
	    {
			score = score + meleeDefense * 0.02;
		}
		else
		{
			score = score - meleeDefense * 0.02;
		}

		score = _entity.getMoraleState() == 0 ? 0 : score + _entity.getMoraleState() * 0.1;
		score = score * mult;

		if (_entity.isArmedWithRangedWeapon())
		{
			score = score + (isAllied ? -10 : 5);
		}

		if (isAllied && _entity.getCurrentProperties().TargetAttractionMult > 1.0)
		{
			score = score - _entity.getCurrentProperties().TargetAttractionMult * 1.25; 
		}

		local injuries = _entity.getSkills().query(::Const.SkillType.Injury);
		score = score - (isAllied ? 1.35 * injuries.len() : 0);

		return score;
	};
	obj.scoreDistanceToTheNearestEnemies <- function( _tile , _target ) 
	{
		local _user = this.getContainer().getActor();
		local score = 0;
		local distance = 9999;
		local danger = 0;

		foreach( e in ::Tactical.Entities.getAllInstancesAsArray() )
		{
			if (e.getID() == _user.getID() || e.getID() == _target.getID() || e.isAlliedWith(_user))
			{
				continue;
			}

			local d = _tile.getDistanceTo(e.getTile());

			if (d < distance)
			{
				distance = d;
				danger = ::Math.max(1, this.scoreTheEntity(e));
			}
		}

		if (distance <= 0 || danger == 0)
		{
			return 0;
		}

		score += -(danger / distance);
	    return score;
	};
	obj.onSortScoreByDescend <- function( _a, _b )
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
	};
	obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 0;
			_properties.DamageRegularMax = 0;

			if (this.isUpgradeDrag())
			{
				_properties.DamageRegularMin += 5;
				_properties.DamageRegularMax += 15;
			}

			if (this.isImprovedDrag())
			{
				_properties.DamageRegularMin += 10;
				_properties.DamageRegularMax += 15;
			}
		}
	};
});