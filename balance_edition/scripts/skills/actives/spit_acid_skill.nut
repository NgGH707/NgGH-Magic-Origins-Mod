this.spit_acid_skill <- this.inherit("scripts/skills/skill", {
	m = {
		HpCost = 50
	},
	function create()
	{
		this.m.ID = "actives.spit_acid";
		this.m.Name = "Spit Acid Blood";
		this.m.Description = "Use your own acidic blood as a ranged attack by spitting it at your target. Be careful it can easily splash to others";
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
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 1;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsUsingHitchance = false;
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
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 25;
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
				text = "Costs [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.HpCost + "[/color] hitpoints to use"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Reduces the target\'s armor by [color=" + this.Const.UI.Color.DamageValue + "]20%[/color] each turn for 3 turns."
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + this.Const.UI.Color.DamageValue + "]33%[/color] chance to hit bystanders at the same or lower height level as well."
			}
		]);

		if (this.getContainer().getActor().getHitpoints() < this.m.HpCost + 10)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/wanring.png",
				text = "[color=" + this.Const.UI.Color.DamageValue + "]You are at low health[/color]."
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

		if ((_target.getFlags().has("body_immune_to_acid") || _target.getArmor(this.Const.BodyPart.Body) <= 0) && (_target.getFlags().has("head_immune_to_acid") || _target.getArmor(this.Const.BodyPart.Head) <= 0))
		{
			return;
		}

		local poison = _target.getSkills().getSkillByID("effects.acid");

		if (poison == null)
		{
			_target.getSkills().add(this.new("scripts/skills/effects/acid_effect"));
		}
		else
		{
			poison.resetTime();
		}

		this.spawnIcon("status_effect_78", _target.getTile());
		this.attackEntity(_user, _target);
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.getContainer().getActor().getHitpoints() >= this.m.HpCost + 10;
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};

		_user.setHitpoints(_user.getHitpoints() - this.m.HpCost);

		if ((!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer) && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == this.getContainer().getActor().getID())
		{
			this.getContainer().setBusy(true);
			local d = _user.getTile().getDirectionTo(_targetTile) + 3;
			d = d > 5 ? d - 6 : d;

			if (_user.getTile().hasNextTile(d))
			{
				this.Tactical.getShaker().shake(_user, _user.getTile().getNextTile(d), 6);
			}

			this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onApplyAcid.bindenv(this), tag);
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
		_tag.Skill.getContainer().setBusy(false);
		_tag.Skill.applyAcid(_tag.User, targetEntity);
		_tag.User.spawnSmashSplatters(_tag.TargetTile, this.Const.Combat.BloodSplattersAtDeathMult * _tag.User.m.DeathBloodAmount);
		_tag.User.spawnBloodPool(_tag.TargetTile, this.Math.rand(this.Const.Combat.BloodPoolsAtDeathMin, this.Const.Combat.BloodPoolsAtDeathMax));

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_tag.TargetTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = _tag.TargetTile.getNextTile(i);

				if (this.Math.rand(1, 100) > 33)
				{
				}
				else if (nextTile.Level > _tag.TargetTile.Level)
				{
				}
				else if (!nextTile.IsOccupiedByActor)
				{
					for( local i = 0; i < this.Const.Tactical.AcidParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(true, this.Const.Tactical.AcidParticles[i].Brushes, nextTile, this.Const.Tactical.AcidParticles[i].Delay, this.Const.Tactical.AcidParticles[i].Quantity, this.Const.Tactical.AcidParticles[i].LifeTimeQuantity, this.Const.Tactical.AcidParticles[i].SpawnRate, this.Const.Tactical.AcidParticles[i].Stages);
					}
				}
				else
				{
					local entity = nextTile.getEntity();
					_tag.Skill.applyAcid(_tag.User, entity);
				}
			}
		}
	}

	function onTargetSelected( _targetTile )
	{
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		
		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);	
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

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 20;
			_properties.DamageTotalMult *= 0.5;
			_properties.DamageArmorMult *= 0.5;
		}
	}

});

