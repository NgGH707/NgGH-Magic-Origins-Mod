this.mind_break_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.mind_break";
		this.m.Name = "Mind Break";
		this.m.Description = "Slowly breaking the mental health of your prey with an unseen sinister force. No perverted stuffs here!";
		this.m.KilledString = "Mind Broken";
		this.m.Icon = "skills/active_mind_break.png";
		this.m.IconDisabled = "skills/active_mind_break_sw.png";
		this.m.Overlay = "active_mind_break";
		this.m.SoundOnUse = [
			"sounds/enemies/horror_spell_02.wav",
			"sounds/enemies/horror_spell_03.wav"
		];
		this.m.IsUsingActorPitch = true;
		this.m.IsSerialized = false;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 400;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 4;
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getFlags().getAsInt("bewitched") == this.Const.EntityType.LegendDemonAlp)
		{
			this.m.Order = this.Const.SkillOrder.OffensiveTargeted - 2;
		}
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts [color=" + this.Const.UI.Color.PositiveValue + "]Mind Broken[/color] effect which lowers your target Resolve"
			}
		]);
		
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};

		for( local i = 0; i < this.Const.Tactical.DazeParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DazeParticles[i].Brushes, _targetTile, this.Const.Tactical.DazeParticles[i].Delay, this.Const.Tactical.DazeParticles[i].Quantity, this.Const.Tactical.DazeParticles[i].LifeTimeQuantity, this.Const.Tactical.DazeParticles[i].SpawnRate, this.Const.Tactical.DazeParticles[i].Stages);
		}

		if (_targetTile.IsVisibleForPlayer || !_user.isHiddenToPlayer())
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, this.onDelayedEffect.bindenv(this), tag);
		}
		else
		{
			this.onDelayedEffect(tag);
		}

		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _user = _tag.User;
		local _targetEntity = _tag.TargetTile.getEntity();
		local ret = _tag.Skill.attackEntity(_user, _targetEntity);

		if (!_user.isAlive() || _user.isDying())
		{
			return;
		}

		if (ret && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			local mind_break = _targetEntity.getSkills().getSkillByID("effects.mind_break");

			if (mind_break != null)
			{
				_targetEntity.checkMorale(-1, 5 - mind_break.m.Count, this.Const.MoraleCheckType.MentalAttack);
			}

			_targetEntity.getSkills().add(this.new("scripts/skills/effects/mind_break_effect"));
		}
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 5;
			_properties.DamageRegularMax = 10;
			_properties.DamageArmorMult = 0;
			_properties.MeleeDamageMult /= 0.9;
			_properties.IsIgnoringArmorOnAttack = true;
			_properties.HitChance[this.Const.BodyPart.Head] += 100;
		}
	}

});

