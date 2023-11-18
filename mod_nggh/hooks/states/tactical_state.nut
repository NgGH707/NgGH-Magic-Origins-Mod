::mods_hookExactClass("states/tactical_state", function(obj)
{
	local ws_initMap = obj.initMap;
	obj.initMap = function()
	{
		this.m.Factions.calculateRandomizedStatsScaling();

		if (this.m.StrategicProperties != null && !this.m.StrategicProperties.IsPlayerInitiated && !this.m.StrategicProperties.InCombatAlready)
		{
			foreach ( p in this.m.StrategicProperties.Parties ) 
			{
				if (p.getFlags().has("WitchHunters")) // witch hunter party will always surround player no matter what
				{
					this.m.StrategicProperties.PlayerDeploymentType = ::Const.Tactical.DeploymentType.Center;
					this.m.StrategicProperties.EnemyDeploymentType = ::Const.Tactical.DeploymentType.Circle;
				}
			}
		}

		ws_initMap();
	};

	local ws_tactical_flee_screen_onFleePressed = obj.tactical_flee_screen_onFleePressed;
	obj.tactical_flee_screen_onFleePressed = function()
	{
		if (!this.isScenarioMode() && !this.isEveryoneSafe() && !this.m.IsAutoRetreat)
		{
			local alive = this.Tactical.Entities.getAllInstancesAsArray();

			foreach( a in alive )
			{
				if (a.isAlive())
				{
					if (a.getFaction() == ::Const.Faction.Player && a.getFlags().has("egg") || a.getFlags().has("kraken"))
					{
						a.onRetreating();
					}
					else if (a.getFaction() == ::Const.Faction.PlayerAnimals)
					{
						if (a.isSummoned() && a.getAIAgent().getID() == ::Const.AI.Agent.ID.Player)
						{
							a.getAIAgent().setUseHeat(true);
							a.getAIAgent().getProperties().BehaviorMult[::Const.AI.Behavior.ID.Retreat] = 1.0;
						}
						
						::Tactical.TurnSequenceBar.updateEntity(a.getID());
					}
				}
			}
		}

		ws_tactical_flee_screen_onFleePressed();
	};

	local ws_gatherLoot = obj.gatherLoot;
	obj.gatherLoot = function()
	{
		ws_gatherLoot();

		foreach ( item in this.m.StrategicProperties.LootWithoutScript )
		{
			this.m.CombatResultLoot.push(item);
		}
		
		this.m.CombatResultLoot.sort();
	};
	
	/*
	local ws_setActionStateBySkill = obj.setActionStateBySkill;
	obj.setActionStateBySkill = function( _activeEntity, _skill )
	{
		ws_setActionStateBySkill(_activeEntity, _skill);

		if (_skill.isMagicSkill() && this.m.SelectedSkillID == _skill.getID() && this.m.CurrentActionState == ::Const.Tactical.ActionState.SkillSelected)
		{
			::Tactical.TurnSequenceBar.setActiveEntityMagicPointsCostsPreview({
				MagicPoints = _skill.getMagicPointsCost(),
				SkillID = _skill.getID()
			});
		}
	}

	local ws_cancelEntitySkill = obj.cancelEntitySkill;
	obj.cancelEntitySkill = function( _activeEntity )
	{
		local skill = _activeEntity.getSkills().getSkillByID(this.m.SelectedSkillID);

		if (skill != null && skill.isMagicSkill())
		{
			::Tactical.TurnSequenceBar.resetActiveEntityMagicPointsCostsPreview();
		}

		ws_cancelEntitySkill(_activeEntity);
	}
	*/
});