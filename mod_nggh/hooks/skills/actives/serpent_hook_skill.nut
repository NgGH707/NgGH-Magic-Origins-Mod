::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/serpent_hook_skill", function ( q )
{
	q.m.DragMinDamage <- 0;
	q.m.DragMaxDamage <- 0;
	q.m.CanNotBeDragEntityTypes <- [];

	q.create = @(__original) function()
	{
		__original();
		m.Name = "Serpent Drag";
		m.Description = "Constrict a target and drag them closer to you. Will break any defensive stance that target had before being dragged. Can be used on allies.";
		m.Icon = "skills/active_192.png";
		m.IconDisabled = "skills/active_192_sw.png";
		m.Delay = 500;
		m.Order = ::Const.SkillOrder.UtilityTargeted - 1;
		m.IsIgnoringRiposte = true;
		m.IsWeaponSkill = false;
		m.IsAttack = false;
		m.DirectDamageMult = 0.2;

		m.CanNotBeDragEntityTypes = [
			::Const.EntityType.Mortar,
			::Const.EntityType.GreenskinCatapult,
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
		];
	}

	q.isImprovedDrag <- function() 
	{
	    return getContainer().getActor().getCurrentProperties().IsSpecializedInShields;
	}

	q.isUpgradeDrag <- function()
	{
		return getContainer().getActor().getCurrentProperties().IsSpecializedInThrowing;
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player"))
			setBaseValue("FatigueCost", 30);
	}

	q.getTooltip <- function()
	{
		local improve = getContainer().getSkillByID("perk.serpent_giant");
		local ret = improve != null || isUpgradeDrag() ? getDefaultTooltip() : getDefaultUtilityTooltip();

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]100%[/color] chance to stagger on a hit"
			},
		]);

		if (improve != null)
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.max(10, ::Math.floor(p.getMeleeSkill() * improve.getMult())) + "%[/color] chance to disarm on a hit"
			});

		return ret;
	}

	q.softReset <- function()
	{
		resetField("DragMinDamage");
		resetField("DragMaxDamage");
		return skill.softReset();
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.MaxRange = _properties.IsSpecializedInThrowing ? 4 : 3;
		m.FatigueCostMult = _properties.IsSpecializedInThrowing ? 0.75 : 1.0;
	}

	q.getHitchance <- function( _targetEntity )
	{
		if (!_targetEntity.isAttackable() && !_targetEntity.isRock() && !_targetEntity.isTree() && !_targetEntity.isBush() && !_targetEntity.isSupplies())
			return 0;

		if (!_targetEntity.getCurrentProperties().IsImmuneToKnockBackAndGrab) 
			return 100;

		if (isImprovedDrag() && _targetEntity.isAlliedWith(getContainer().getActor()))
			return 100;

		return 0;
	}

	q.getPulledToTiles = @() function( _userTile, _targetTile )
	{
		local tiles = [];

		for( local i = 0; i < 6; ++i )
		{
			if (!_userTile.hasNextTile(i))
				continue;

			local tile = _userTile.getNextTile(i);

			if (tile.Level <= _userTile.Level && tile.IsEmpty && tile.getDistanceTo(_targetTile) <= this.getMaxRange())
				tiles.push(tile);
		}

		if (tiles.len() <= 1)
			return tiles;

		return smartFilter(_userTile, _targetTile, tiles);
	}

	q.onVerifyTarget = @() function( _originTile, _targetTile )
	{
		if (!skill.onVerifyTarget(_originTile, _targetTile))
			return false;

		local target = _targetTile.getEntity();

		if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			if (!target.isAlliedWith(getContainer().getActor()))
				return false;

			if (!isImprovedDrag())
				return false;
		}

		return !target.getCurrentProperties().IsRooted && getPulledToTile(_originTile, _targetTile) != null;
	}

	q.isViableTarget <- function( _user, _target )
	{
		if (_target.isAlliedWith(_user))
			return true;

		if (_target.isNonCombatant())
			return false;

		return m.CanNotBeDragEntityTypes.find(_target.getType()) == null;
	}

	q.onUse = @() function( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local distance = _user.getTile().getDistanceTo(_targetTile);
		local pullToTile;

		if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab && (!target.isAlliedWith(_user) || !isImprovedDrag())) {
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " fails to drag in " + ::Const.UI.getColorizedEntityName(_targetTile.getEntity()));
			return false;
		}

		if (m.DestinationTile != null) {
			pullToTile = m.DestinationTile;
			m.DestinationTile = null;
		}
		else {
			pullToTile = getPulledToTile(_user.getTile(), _targetTile);
		}

		if (pullToTile == null)
			return false;

		if (!_user.isHiddenToPlayer() && pullToTile.IsVisibleForPlayer)
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " drags in " + ::Const.UI.getColorizedEntityName(_targetTile.getEntity()));

		local scaleBackup = target.getSprite("status_rooted").Scale;

		if (!_user.isHiddenToPlayer() || !target.isHiddenToPlayer()) {
			local variant = _user.m.Variant;
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
			::Time.scheduleEvent(::TimeUnit.Virtual, 900, onDone, {
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

		local properties = getContainer().buildPropertiesForUse(this, target);
		local damage = m.DragMaxDamage > 0 ? ::Math.rand(m.DragMinDamage, m.DragMaxDamage) : 0;
		local total_damage = damage * properties.DamageRegularMult;
		local damage_mult = properties.DamageTotalMult * properties.MeleeDamageMult;
		local damageArmor = damage * properties.DamageArmorMult;
		damageArmor = ::Math.max(0, damageArmor + distance * properties.DamageAdditionalWithEachTile) * damage_mult;
		total_damage = ::Math.max(0, total_damage + distance * properties.DamageAdditionalWithEachTile) * damage_mult;
		total_damage = ::Math.max(0, ::Math.abs(pullToTile.Level - _targetTile.Level) - 1) * ::Const.Combat.FallingDamage + total_damage;
		local damageDirect = ::Math.minf(1.0, properties.DamageDirectMult * (m.DirectDamageMult + properties.DamageDirectAdd));

		if (target.isAlliedWith(_user) || total_damage <= 0)
			::Tactical.getNavigator().teleport(_targetTile.getEntity(), pullToTile, null, null, true);
		else {
			local tag = {
				Attacker = _user,
				Skill = this,
				Target = target,
				ScaleBackup = scaleBackup,
				HitInfo = clone ::Const.Tactical.HitInfo
			};
			tag.HitInfo.DamageRegular = total_damage;
			tag.HitInfo.DamageArmor = damageArmor;
			tag.HitInfo.DamageFatigue = ::Const.Combat.FatigueReceivedPerHit;
			tag.HitInfo.DamageDirect = damageDirect;
			tag.HitInfo.BodyPart = ::Const.BodyPart.Body;
			::Tactical.getNavigator().teleport(_targetTile.getEntity(), pullToTile, onPulledDown, tag, true);
		}
		
		if (!target.isAlliedWith(_user) || ::Math.rand(1, 100) <= 50) {
			target.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
			
			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " has staggered " + ::Const.UI.getColorizedEntityName(target) + " for one turn");
		}

		return true;
	}

	q.onPulledDown = @(__original) function( _entity, _tag )
	{
		__original(_entity, _tag);
		_tag.Skill.getContainer().onTargetHit(_tag.Skill, _entity, _tag.HitInfo.BodyPart, _tag.HitInfo.DamageInflictedHitpoints, _tag.HitInfo.DamageInflictedArmor);
	}

	q.onDone = @(__original) function( _data )
	{
		if (_data.Target.isAlive() && !_data.Target.isDying())
			return __original(_data);

		_data.User.fadeIn(50);
	}

	q.onAfterDone = @(__original) function( _data )
	{
		if (_data.Target.isAlive() && !_data.Target.isDying())
			return;

		if (_data.User.getCurrentProperties().IsSpecializedInShields && !_data.Target.getCurrentProperties().IsImmuneToDisarm && !_data.Target.isAlliedWith(_data.User)) {
			local perk = getContainer().getSkillByID("perk.serpent_giant");
			local chance = ::Math.max(10, ::Math.floor(_data.User.getCurrentProperties().getMeleeSkill() * (perk != null : perk.getMult() : 1.0)));
			
			if (::Math.rand(1, 100) <= chance){
				_data.Target.getSkills().add(::new("scripts/skills/effects/disarmed_effect"));
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_data.User) + " has disarmed " + ::Const.UI.getColorizedEntityName(_data.Target) + " for one turn");
			}
		}
		
		__original(_data);
	}

	q.onTargetSelected <- function( _targetTile )
	{
		local pulledTo = getPulledToTile(getContainer().getActor().getTile(), _targetTile);

		if (pulledTo != null)
			::Tactical.getHighlighter().addOverlayIcon("mortar_target_02", pulledTo, pulledTo.Pos.X, pulledTo.Pos.Y);
	}

	q.smartFilter <- function( _userTile, _targetTile , _tilesArray ) 
	{
		local _user = getContainer().getActor(), _target = _targetTile.getEntity();
		local isAllied = _target.isAlliedWith(_user);
		local BestScore = 0, BestTarget = null;

		foreach (i, t in _tilesArray) 
		{
		    local score = 0;

		    if (!isAllied) {
		    	if (t.Level < _userTile.Level)
		    		score += _userTile.Level - t.Level;

		    	if (t.Type == ::Const.Tactical.TerrainType.Swamp)
		    		score += 5;

		    	if (t.Properties.Effect != null && !t.Properties.Effect.IsPositive)
					score += 3;

		    	if (t.IsHidingEntity)
		    		score -= 1;

				for( local i = 0; i != 6; ++i )
				{
					if (!t.hasNextTile(i))
						continue;
					
					local tile = t.getNextTile(i);

					if (!tile.IsOccupiedByActor)
						continue;

					if (tile.isSameTileAs(_targetTile) || tile.isSameTileAs(_userTile))
						continue;

					local entity = tile.getEntity();

					if (!entity.isAlliedWith(_user))
						score -= 2;
					else if (!entity.getCurrentProperties().IsStunned && entity.getMoraleState() != ::Const.MoraleState.Fleeing)
						score += scoreTheEntity(entity);
					else 
						score -= 5;	
				}
		    }
		    else {
		    	if (t.Type == ::Const.Tactical.TerrainType.Swamp)
		    		score -= 5;

		    	if (t.Properties.Effect != null && !t.Properties.Effect.IsPositive)
					score -= 3;

		    	if (t.IsHidingEntity)
		    		score += 3;

				for( local i = 0; i != 6; ++i )
				{
					if (!t.hasNextTile(i))
						continue;
					
					local tile = t.getNextTile(i);

					if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != ::Const.MoraleState.Fleeing) {
						score += scoreDistanceToTheNearestEnemies(tile, _target);

						if (tile.isSameTileAs(_targetTile) || tile.isSameTileAs(_userTile))
							continue;

						local entity = tile.getEntity();

						if (entity.isAlliedWith(_user))
							score += 2;
						else {
							if (entity.getCurrentProperties().IsStunned) {
								score += 2;
								continue;
							}

							score -= scoreTheEntity(entity) + 2;
						}
					}
				}
		    }

			if (score > BestScore) {
				BestScore = score;
				BestTarget = t;
			}
		}

		if (BestTarget != null)
			return [BestTarget];

		if (_tilesArray.len() != 0)
			return _tilesArray;

		return [];
	}

	q.scoreTheEntity <- function( _entity ) 
	{
	    local score = 0, mult = 1.0, isAllied = _entity.isAlliedWith(getContainer().getActor());

	    if (isAllied) {
	    	mult = _entity.getHitpointsPct();

	    	if (_entity.getHitpointsMax() < 250) {
	    		if (mult <= 0.5)
	    			mult *= 0.67;
	    	}
	    	else {
	    		if (mult > 0.5)
	    			mult *= 1.25;
	    	}
	    }

	    if (_entity.getMoraleState() > ::Const.MoraleState.Fleeing)
	    {
	    	local meleeSkill =  _entity.getCurrentProperties().getMeleeSkill();
		    local meleeDefense = _entity.getCurrentProperties().getMeleeDefense();

			if (!_entity.isTurnDone() && _entity.getActionPoints() >= 5)
				score += 2;

			if (meleeSkill >= 85)
				score += 1;
			else if (meleeSkill >= 50)
				score += meleeDefense * 0.02;
			else
				score -= meleeDefense * 0.02;

			if (meleeDefense >= 50)
				score += 1;
			else if (meleeDefense >= 30)
				score += meleeDefense * 0.02;
			else
				score -= meleeDefense * 0.02;
	    }
	    
		score += _entity.getMoraleState() * 0.1;
		score *= mult;

		if (_entity.isArmedWithRangedWeapon())
			score += (isAllied ? -10 : 5);

		if (isAllied && _entity.getCurrentProperties().TargetAttractionMult > 1.0)
			score -= _entity.getCurrentProperties().TargetAttractionMult * 1.25; 

		score -= (isAllied ? 1.25 * _entity.getSkills().query(::Const.SkillType.Injury).len() : 0);
		return score;
	}

	q.scoreDistanceToTheNearestEnemies <- function( _tile , _target ) 
	{
		local _user = this.getContainer().getActor();
		local score = 0, danger = 0, distance = 9999;

		foreach( e in ::Tactical.Entities.getAllInstancesAsArray() )
		{
			if (e.getID() == _user.getID() || e.getID() == _target.getID() || e.isAlliedWith(_user))
				continue;

			local d = _tile.getDistanceTo(e.getTile());

			if (d < distance) {
				distance = d;
				danger = ::Math.max(1, scoreTheEntity(e));
			}
		}

		if (distance <= 0 || danger == 0)
			return 0;

		score -= danger / distance;
	    return score;
	}

	q.onSortScoreByDescend <- function( _a, _b )
	{
		if (_a.Score > _b.Score) return 1;
		else if (_a.Score < _b.Score) return -1;
		else return 0;
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == this) 
		{
			_properties.DamageRegularMin = m.DragMinDamage;
			_properties.DamageRegularMax = m.DragMaxDamage;
		}
	};
});