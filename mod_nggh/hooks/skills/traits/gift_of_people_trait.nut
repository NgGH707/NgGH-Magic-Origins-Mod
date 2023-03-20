::mods_hookExactClass("skills/traits/gift_of_people_trait", function (obj)
{
	obj.onCombatStarted = function()
	{
		this.skill.onCombatStarted();

		if (::Math.rand(1, 10) < 10)
		{
			return;
		}

		local ownID = this.getContainer().getActor().getID();

		foreach( ally in ::Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction()) )
		{
			if (ally.getID() == ownID)
			{
				continue;
			}

			local ally_morale = ally.getMoraleState();

			if (ally_morale == ::Const.MoraleState.Ignore)
			{
				continue;
			}

			if (ally_morale < ::Const.MoraleState.Confident)
			{
				ally.setMoraleState(ally_morale + 1);
			}
		}
	}
});