this.nggh_mod_mind_break_skill <- ::inherit("scripts/skills/skill", {
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
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
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
		this.m.FatigueCost = 8;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 4;
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getFlags().getAsInt("Type") == ::Const.EntityType.LegendDemonAlp)
		{
			this.m.Order = ::Const.SkillOrder.OffensiveTargeted - 2;
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
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts [color=" + ::Const.UI.Color.PositiveValue + "]Mind Broken[/color] effect which lowers the target Resolve"
			}
		]);
		
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			User = _user,
			TargetTile = _targetTile
		};

		::Tactical.spawnSpriteEffect("effect_skull_03", ::createColor("#ffffff"), _targetTile, 0, 40, 1.0, 0.25, 0, 400, 300);

		if (_targetTile.IsVisibleForPlayer || !_user.isHiddenToPlayer())
		{
			::Time.scheduleEvent(::TimeUnit.Virtual, 200, this.onDelayedEffect.bindenv(this), tag);
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

		if (_targetEntity.getCurrentProperties().MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " doesn\'t feel anything");
			return;
		}

		local ret = this.attackEntity(_user, _targetEntity);

		if (!_user.isAlive() || _user.isDying())
		{
			return;
		}

		if (ret && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			local mind_break = _targetEntity.getSkills().getSkillByID("effects.mind_break");

			if (mind_break != null)
			{
				_targetEntity.checkMorale(-1, 30 - mind_break.m.Count, ::Const.MoraleCheckType.MentalAttack);
			}

			_targetEntity.getSkills().add(::new("scripts/skills/effects/nggh_mod_mind_break_effect"));
		}
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 5;
			_properties.DamageRegularMax = 10;
			_properties.DamageArmorMult = 0;
			_properties.IsIgnoringArmorOnAttack = true;
			_properties.HitChance[::Const.BodyPart.Head] += 100;

			if (!::Nggh_MagicConcept.IsOPMode)
			{
				_properties.MeleeDamageMult /= 0.85;
			}
		}
	}

});

