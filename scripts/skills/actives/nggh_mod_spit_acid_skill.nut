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

	function onAdded()
	{
		this.m.DamageType.clear();
		this.m.DamageType.add(::Const.Damage.DamageType.Burning);
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
				text = "[color=" + ::Const.UI.Color.DamageValue + "]Your health is low[/color]."
			});
		}

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.getContainer().getActor().getHitpoints() >= this.m.HpCost * 3;
	}

	function hasLinwurmArmor( _target, _bodyPart )
	{
		if (_bodyPart == ::Const.BodyPart.Body && !_target.getFlags().has("body_immune_to_acid"))
			return false;

		if (_bodyPart != ::Const.BodyPart.Head && !_target.getFlags().has("head_immune_to_acid"))
			return false

		return _bodyPart < 2 && _target.getArmor(_bodyPart) > 0;
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			User = _user,
			TargetTile = _targetTile,
		};

		_user.setHitpoints(_user.getHitpoints() - this.m.HpCost);

		if ((!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer) && ::Tactical.TurnSequenceBar.getActiveEntity().getID() == this.getContainer().getActor().getID())
		{
			this.getContainer().setBusy(true);
			local d = _user.getTile().getDirectionTo(_targetTile) + 3;
			d = d > 5 ? d - 6 : d;

			if (_user.getTile().hasNextTile(d))
				::Tactical.getShaker().shake(_user, _user.getTile().getNextTile(d), 6);

			::Time.scheduleEvent(::TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);
			return true;
		}
		
		this.onDelayedEffect(tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		this.getContainer().setBusy(false);
		this.onApplyAcid(_tag.User, _tag.TargetTile);

		for( local i = 0; i < 6; ++i )
		{
			if (!_tag.TargetTile.hasNextTile(i))
				continue;

			if (::Math.rand(1, 100) > 45)
				continue;

			local nextTile = _tag.TargetTile.getNextTile(i);
			
			if (nextTile.Level > _tag.TargetTile.Level)
				continue;
			
			this.onApplyAcid(_tag.User, nextTile);
		}
	}

	function onApplyAcid( _user, _tile )
	{
		if (_tile.IsEmpty || !_tile.IsOccupiedByActor) {
			for( local i = 0; i < ::Const.Tactical.AcidParticles.len(); ++i )
			{
				::Tactical.spawnParticleEffect(true, ::Const.Tactical.AcidParticles[i].Brushes, _tile, ::Const.Tactical.AcidParticles[i].Delay, ::Const.Tactical.AcidParticles[i].Quantity, ::Const.Tactical.AcidParticles[i].LifeTimeQuantity, ::Const.Tactical.AcidParticles[i].SpawnRate, ::Const.Tactical.AcidParticles[i].Stages);
			}
			return;
		}

		if (_tile.getEntity().getFlags().has("lindwurm")
			return;
		
		_user.spawnBloodPool(_tile, ::Math.rand(::Const.Combat.BloodPoolsAtDeathMin, ::Const.Combat.BloodPoolsAtDeathMax));
		this.attackEntity(_user, _tile.getEntity());
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_targetEntity == null || _skill != this)
			return;

		_hitInfo.InjuryThresholdMult *= 0.5;

		if ((_hitInfo.BodyPart == ::Const.BodyPart.Body && _targetEntity.getFlags().has("body_immune_to_acid") && _targetEntity.getArmor(::Const.BodyPart.Body) > 0) || (_hitInfo.BodyPart == ::Const.BodyPart.Head && _targetEntity.getFlags().has("head_immune_to_acid") && _targetEntity.getArmor(::Const.BodyPart.Head) > 0))
		{
			_hitInfo.DamageRegular *= 0.25;
			_hitInfo.DamageArmor = 0;
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill != this)
			return;

		if (_targetEntity == null || _targetEntity.isDying() || !_targetEntity.isAlive())
			return;

		if (this.hasLinwurmArmor(_targetEntity, _bodyPart))
			return;
		
		local poison = _targetEntity.getSkills().getSkillByID("effects.acid");

		if (poison == null)
			_targetEntity.getSkills().add(::new("scripts/skills/effects/acid_effect"));
		else
			poison.resetTime();

		this.spawnIcon("status_effect_78", _targetEntity.getTile());

		if (_damageInflictedHitpoints == 0 || _bodyPart == ::Const.BodyPart.Head)
			return;

		::Tactical.EventLog.log("The acidic blood splashes to " + ::Const.UI.getColorizedEntityName(_targetEntity) + "\'s face");
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
				_properties.DamageTotalMult = 0.0; 
		}
	}

	function onTargetSelected( _targetTile )
	{
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		
		for( local i = 0; i < 6; ++i )
		{
			if (!_targetTile.hasNextTile(i))
				continue;

			local tile = _targetTile.getNextTile(i);
			::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);	
		}
	}

});

