this.nggh_mod_kraken_change_tentacle_mode_single <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.kraken_change_tentacle_mode_single";
		this.m.Name = "Change Tentacle Mode";
		this.m.Description = "Switching between the Ensnaring and Attacking modes of a targeted tentacle on the map.";
		this.m.Icon = "skills/active_change_tentacle_mode_single.png";
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Last + 1;
		this.m.IsSerialized = false;
		this.m.IsHidden = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsRangeLimitsEnforced = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
	}

	function isHidden()
	{
		return this.skill.isHidden() || !this.getContainer().getActor().getFlags().get("tentacle_autopilot");
	}

	function getIcon()
	{
		return this.m.Icon;
	}

	function getTooltip()
	{
		return [
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
		];
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local entity = _targetTile.getEntity();

		if (!entity.getFlags().has("Source"))
		{
			return false;
		}

		return entity.getFlags().get("Source") == this.getContainer().getActor().getID();
	}

	function onUse( _user, _targetTile )
	{
		_targetTile.getEntity().setMode(_targetTile.getEntity().getMode() == ::Const.KrakenTentacleMode.Ensnaring ? ::Const.KrakenTentacleMode.Attacking : ::Const.KrakenTentacleMode.Ensnaring)
		return true;
	}

	function onCombatStarted()
	{
		this.m.IsHidden = false;
	}

	function onCombatFinished()
	{
		this.m.IsHidden = true;
	}


});