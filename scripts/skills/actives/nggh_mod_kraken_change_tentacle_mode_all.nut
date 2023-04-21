this.nggh_mod_kraken_change_tentacle_mode_all <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.kraken_change_tentacle_mode_all";
		this.m.Name = "Change Tentacle Mode (All)";
		this.m.Description = "Switching between the Ensnaring and Attacking modes of all tentacles on the map.";
		this.m.Icon = "skills/active_change_tentacle_mode_all.png";
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Last + 2;
		this.m.IsSerialized = false;
		this.m.IsHidden = true;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
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

	function onUse( _user, _targetTile )
	{
		local id = _user.getID();

		foreach (i, a in ::Tactical.Entities.getAllInstancesAsArray())
		{
		    if (!a.getFlags().has("Source") || a.getFlags().get("Source") != id)
		    {
		    	continue;
		    }

			a.setMode(a.getMode() == ::Const.KrakenTentacleMode.Ensnaring ? ::Const.KrakenTentacleMode.Attacking : ::Const.KrakenTentacleMode.Ensnaring)
		}

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

