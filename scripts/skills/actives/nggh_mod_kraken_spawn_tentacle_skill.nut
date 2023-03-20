this.nggh_mod_kraken_spawn_tentacle_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.kraken_spawn_tentacle";
		this.m.Name = "Regrow Tentacle";
		this.m.Description = "Instantly regrow your tentacle to hunt for prey.";
		this.m.Icon = "skills/active_149.png";
		this.m.IconDisabled = "skills/active_149_sw.png";
		this.m.Overlay = "active_149";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/krake_hurt_01.wav",
			"sounds/enemies/dlc2/krake_hurt_02.wav",
			"sounds/enemies/dlc2/krake_hurt_03.wav",
			"sounds/enemies/dlc2/krake_hurt_04.wav",
			"sounds/enemies/dlc2/krake_hurt_05.wav"
		];
		this.m.SoundVolume = 0.66;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsDoingForwardMove = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 1;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 10;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Current tentacle(s): [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getContainer().getActor().getTentacles().len() + "[/color]"
		});
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (!_targetTile.IsEmpty)
		{
			return false;
		}

		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		return this.getContainer().getActor().canSpawnMoreTentacle();
	}

	function onUse( _user, _targetTile )
	{
		::Time.scheduleEvent(::TimeUnit.Virtual, 500, _user.spawnTentacle.bindenv(_user.get()), _targetTile);
		return true;
	}

	function onTargetSelected( _targetTile ) {}

});

