::mods_hookExactClass("skills/traits/gift_of_people_trait", function (obj)
{
	obj.m.Bonus <- 5;
	obj.getBonus <- function()
	{
		return this.m.Bonus;
	};
	local ws_getTooltip = obj.getTooltip;
	obj.getTooltip = function()
	{
		local ret = ws_getTooltip();

		if (this.getContainer().hasSkill("spells.charm"))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]+" + this.m.Bonus + "%[/color] to successfully charm a target"
			});
		}

		return ret;
	};

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