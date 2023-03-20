this.nggh_mod_spit_acid_skill <- ::inherit("scripts/skills/skill", {
	m = {
		HpCost = 60
	},
	function create()
	{
		this.m.ID = "actives.spit_acid";
		this.m.Name = "Spit Acidic Blood";
		this.m.Description = "Use your own acidic blood as a ranged attack by spitting it at your target. Be careful it can easily splash to others nearby.";
		this.m.Icon = "ui/perks/active_lindwurm_acid.png";
		this.m.IconDisabled = "ui/perks/active_lindwurm_acid_sw.png";
		this.m.Overlay = "active_lindwurm_acid";
		this.m.SoundOnUse = [
			"sounds/enemies/lindwurm_gorge_01.wav",
			"sounds/enemies/lindwurm_gorge_02.wav",
			"sounds/enemies/lindwurm_gorge_03.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted + 1;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsShowingProjectile = false;
		this.m.IsDoingForwardMove = true;
		this.m.IsUsingActorPitch = true;
		this.m.InjuriesOnBody = [
			{
				ID = "injury.burnt_legs",
				Threshold = 0.25,
				Script = "injury/burnt_legs_injury"
			},
			{
				ID = "injury.burnt_hands",
				Threshold = 0.5,
				Script = "injury/burnt_hands_injury"
			}
		];
		this.m.InjuriesOnHead = [
			{
				ID = "injury.burnt_face",
				Threshold = 0.25,
				Script = "injury/burnt_face_injury"
			},
		];
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 33;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/health.png",
				text = "Costs [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.HpCost + "[/color] hitpoints to use"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Reduces the target\'s armor by [color=" + ::Const.UI.Color.DamageValue + "]20%[/color] each turn for 3 turns."
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + ::Const.UI.Color.DamageValue + "]45%[/color] chance to hit bystanders at the same or lower height level as well."
			}
		]);

		if (this.getContainer().getActor().getHitpoints() < this.m.HpCost * 3)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/wanring.png",
				text = "[color=" + ::Const.UI.Color.DamageValue + "]You are at low health level[/color]."
			});
		}

		return ret;
	}

	function applyAcid( _user, _target )
	{
		if (_target.getFlags().has("lindwurm"))
		{
			return;
		}

		local ret = this.attackEntity(_user, _target);

		if (!_target.isAlive() || _target.isDying())
		{
			return;
		}

		if ((_target.getFlags().has("body_immune_to_acid") && _target.getArmor(::Const.BodyPart.Body) > 0) && (_target.getFlags().has("head_immune_to_acid") && _target.getArmor(::Const.BodyPart.Head) > 0))
		{
			return;
		}

		local poison = _target.getSkills().getSkillByID("effects.acid");

		if (poison == null)
		{
			_target.getSkills().add(::new("scripts/skills/effects/acid_effect"));
		}
		else
		{
			poison.resetTime();
		}

		this.spawnIcon("status_effect_78", _target.getTile());
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.getContainer().getActor().getHitpoints() >= this.m.HpCost * 3;
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			User = _user,
			TargetTile = _targetTile
		};

		_user.setHitpoints(_user.getHitpoints() - this.m.HpCost);

		if ((!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer) && ::Tactical.TurnSequenceBar.getActiveEntity().getID() == this.getContainer().getActor().getID())
		{
			this.getContainer().setBusy(true);
			local d = _user.getTile().getDirectionTo(_targetTile) + 3;
			d = d > 5 ? d - 6 : d;

			if (_user.getTile().hasNextTile(d))
			{
				::Tactical.getShaker().shake(_user, _user.getTile().getNextTile(d), 6);
			}

			::Time.scheduleEvent(::TimeUnit.Virtual, 500, this.onApplyAcid.bindenv(this), tag);
			return true;
		}
		else
		{
			return this.onApplyAcid(tag);
		}
	}

	function onApplyAcid( _tag )
	{
		local targetEntity = _tag.TargetTile.getEntity();
		this.getContainer().setBusy(false);
		this.applyAcid(_tag.User, targetEntity);
		_tag.User.spawnBloodPool(_tag.TargetTile, ::Math.rand(::Const.Combat.BloodPoolsAtDeathMin, ::Const.Combat.BloodPoolsAtDeathMax));

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_tag.TargetTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = _tag.TargetTile.getNextTile(i);

				if (::Math.rand(1, 100) > 45)
				{
				}
				else if (nextTile.Level > _tag.TargetTile.Level)
				{
				}
				else if (!nextTile.IsOccupiedByActor)
				{
					for( local i = 0; i < ::Const.Tactical.AcidParticles.len(); ++i )
					{
						::Tactical.spawnParticleEffect(true, ::Const.Tactical.AcidParticles[i].Brushes, nextTile, ::Const.Tactical.AcidParticles[i].Delay, ::Const.Tactical.AcidParticles[i].Quantity, ::Const.Tactical.AcidParticles[i].LifeTimeQuantity, ::Const.Tactical.AcidParticles[i].SpawnRate, ::Const.Tactical.AcidParticles[i].Stages);
					}
				}
				else
				{
					local entity = nextTile.getEntity();
					this.applyAcid(_tag.User, entity);
					_tag.User.spawnBloodPool(_tag.TargetTile, ::Math.rand(::Const.Combat.BloodPoolsAtDeathMin - 1, ::Const.Combat.BloodPoolsAtDeathMax - 2));
				}
			}
		}
	}

	function onTargetSelected( _targetTile )
	{
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		
		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);	
			}
		}
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill == this)
		{
			_hitInfo.InjuryThresholdMult *= 0.5;
		}
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_targetEntity == null || _skill != this)
		{
			return;
		}

		if (_hitInfo.BodyPart == ::Const.BodyPart.Body && _targetEntity.getFlags().has("body_immune_to_acid") && _targetEntity.getArmor(::Const.BodyPart.Body) > 0)
		{
			_hitInfo.DamageRegular *= 0.25;
			_hitInfo.DamageArmor = 0;
		}

		if (_hitInfo.BodyPart == ::Const.BodyPart.Head && _targetEntity.getFlags().has("head_immune_to_acid") && _targetEntity.getArmor(::Const.BodyPart.Head) > 0)
		{
			_hitInfo.DamageRegular *= 0.25;
			_hitInfo.DamageArmor = 0;
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill != this)
		{
			return;
		}

		if (_damageInflictedHitpoints == 0)
		{
			return;
		}

		if (_bodyPart != ::Const.BodyPart.Head)
		{
			return;
		}

		if (_targetEntity == null || _targetEntity.isDying() || !_targetEntity.isAlive())
		{
			return;
		}

		if (_targetEntity.getFlags().has("head_immune_to_acid") && _targetEntity.getArmor(::Const.BodyPart.Head) > 0)
		{
			return;
		}

		::Tactical.EventLog.log("The acidic blood splashes to " + ::Const.UI.getColorizedEntityName(_targetEntity) "\'s face");
		_targetEntity.getSkills().add(::new("scripts/skills/effects/nggh_mod_blind_effect"));
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill -= 5;
			_properties.DamageRegularMin += 50;
			_properties.DamageRegularMax += 70;
			_properties.DamageArmorMult *= 0.5;
			_properties.HitChance[::Const.BodyPart.Head] -= 5;
			_properties.HitChance[::Const.BodyPart.Body] += 5;

			if (_targetEntity != null && _targetEntity.getFlags().has("lindwurm"))
			{
				_properties.DamageTotalMult = 0.0; 
			}
		}
	}

});

