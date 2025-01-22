::Nggh_MagicConcept.HooksMod.hook("scripts/states/tactical_state", function(q)
{
	q.initMap = @(__original) function()
	{
		m.Factions.calculateRandomizedStatsScaling();

		if (m.StrategicProperties != null && !m.StrategicProperties.IsPlayerInitiated && !m.StrategicProperties.InCombatAlready) {
			foreach ( p in m.StrategicProperties.Parties ) 
			{
				if (p.getFlags().has("WitchHunters")) { // witch hunter party will always surround player no matter what
					m.StrategicProperties.PlayerDeploymentType = ::Const.Tactical.DeploymentType.Center;
					m.StrategicProperties.EnemyDeploymentType = ::Const.Tactical.DeploymentType.Circle;
				}
			}
		}

		__original();
	}

	q.tactical_flee_screen_onFleePressed = @(__original) function()
	{
		if (!isScenarioMode() && !isEveryoneSafe() && !m.IsAutoRetreat) {

			foreach( a in ::Tactical.Entities.getAllInstancesAsArray() )
			{
				if (!a.isAlive())
					continue;

				if (a.getFaction() == ::Const.Faction.Player && a.getFlags().has("egg") || a.getFlags().has("kraken"))
					a.onRetreating();
				else if (a.getFaction() == ::Const.Faction.PlayerAnimals) {
					if (a.isSummoned() && a.getAIAgent().getID() == ::Const.AI.Agent.ID.Player) {
						a.getAIAgent().setUseHeat(true);
						a.getAIAgent().getProperties().BehaviorMult[::Const.AI.Behavior.ID.Retreat] = 1.0;
					}
					
					::Tactical.TurnSequenceBar.updateEntity(a.getID());
				}
			}
		}

		__original();
	}

	q.gatherLoot = @(__original) function()
	{
		__original();

		foreach ( item in m.StrategicProperties.LootWithoutScript )
		{
			m.CombatResultLoot.push(item);
		}
		
		m.CombatResultLoot.sort();
	};
	
	/*
	q.setActionStateBySkill = @(__original) function( _activeEntity, _skill )
	{
		__original(_activeEntity, _skill);

		if (_skill.isMagicSkill() && this.m.SelectedSkillID == _skill.getID() && this.m.CurrentActionState == ::Const.Tactical.ActionState.SkillSelected) {
			::Tactical.TurnSequenceBar.setActiveEntityMagicPointsCostsPreview({
				MagicPoints = _skill.getMagicPointsCost(),
				SkillID = _skill.getID()
			});
		}
	}
	
	q.cancelEntitySkill = @(__original) function( _activeEntity )
	{
		local skill = _activeEntity.getSkills().getSkillByID(this.m.SelectedSkillID);

		if (skill != null && skill.isMagicSkill())
			::Tactical.TurnSequenceBar.resetActiveEntityMagicPointsCostsPreview();

		__original(_activeEntity);
	}
	*/
});