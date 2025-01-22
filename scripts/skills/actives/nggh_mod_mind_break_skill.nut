nggh_mod_mind_break_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		m.ID = "actives.mind_break";
		m.Name = "Mind Break";
		m.Description = "Slowly breaking the mental health of your prey with an unseen sinister force. No perverted stuffs here!";
		m.KilledString = "Mind Broken";
		m.Icon = "skills/active_mind_break.png";
		m.IconDisabled = "skills/active_mind_break_sw.png";
		m.Overlay = "active_mind_break";
		m.SoundOnUse = [
			"sounds/enemies/horror_spell_02.wav",
			"sounds/enemies/horror_spell_03.wav"
		];
		m.IsUsingActorPitch = true;
		m.IsSerialized = false;
		m.Type = ::Const.SkillType.Active;
		m.Order = ::Const.SkillOrder.UtilityTargeted;
		m.Delay = 400;
		m.IsActive = true;
		m.IsTargeted = true;
		m.IsStacking = false;
		m.IsAttack = true;
		m.IsUsingHitchance = false;
		m.IsIgnoredAsAOO = false;
		m.IsUsingHitchance = false;
		m.IsDoingForwardMove = true;
		m.IsVisibleTileNeeded = false;
		m.DirectDamageMult = 1.0;
		m.ActionPointCost = 4;
		m.FatigueCost = 8;
		m.MinRange = 1;
		m.MaxRange = 2;
		m.MaxLevelDifference = 4;
	}

	function onAdded()
	{
		if (getContainer().getActor().getFlags().getAsInt("Type") == ::Const.EntityType.LegendDemonAlp)
			m.Order = ::Const.SkillOrder.OffensiveTargeted - 2;
	}
	
	function getTooltip()
	{
		local ret = getDefaultTooltip();

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
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
			::Time.scheduleEvent(::TimeUnit.Virtual, 200, onDelayedEffect.bindenv(this), tag);
		else
			onDelayedEffect(tag);

		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _user = _tag.User;
		local _targetEntity = _tag.TargetTile.getEntity();

		if (_targetEntity.getCurrentProperties().MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0) {
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " doesn\'t feel anything");
			return;
		}

		local ret = attackEntity(_user, _targetEntity);

		if (!_user.isAlive() || _user.isDying())
			return;

		if (ret && _targetEntity.isAlive() && !_targetEntity.isDying()) {
			local mind_break = _targetEntity.getSkills().getSkillByID("effects.mind_break");

			if (mind_break != null)
				_targetEntity.checkMorale(-1, 30 - mind_break.m.Count, ::Const.MoraleCheckType.MentalAttack);

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

			if (::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue())
				_properties.MeleeDamageMult /= 0.85;
		}
	}

});

