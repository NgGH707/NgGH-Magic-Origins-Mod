::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/crack_the_whip_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Whip the air, making an astonishing sound that reminding your beasts who is the boss here.";
		m.Icon = "skills/active_162.png";
		m.IconDisabled = "skills/active_162_sw.png";
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player"))
			setBaseValue("FatigueCost", 15);
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();

		ret.extend([
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Resets the morale of the all beasts to \'Steady\' if currently below"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Removes the Sleeping status effect of all allies"
			}
		]);
		
		if (m.IsUsed)
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can only be used once per turn[/color]"
			});

		return ret;
	}

	q.isUsable = @(__original) function()
	{
		if (getContainer().getActor().isPlayerControlled())
			return skill.isUsable() && !m.IsUsed && !getContainer().getActor().isEngagedInMelee();

		return __original();
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		local ret = __original(_user, _targetTile);

		if (!_user.isPlayerControlled())
			return ret;

		foreach( a in ::Tactical.Entities.getInstancesOfFaction(_user.getFaction()) )
		{
			a.getSkills().removeByID("effects.sleeping");

			if (a.getType() == ::Const.EntityType.BarbarianUnhold || a.getType() == ::Const.EntityType.BarbarianUnholdFrost || !::MSU.isKindOf(a, "nggh_mod_player_beast"))
				continue;

			if (a.getMoraleState() < ::Const.MoraleState.Steady)
				a.setMoraleState(::Const.MoraleState.Steady);
				
			spawnIcon("status_effect_106", a.getTile());
		}

		return ret;
	};
});