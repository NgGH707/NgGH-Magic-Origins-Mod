::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_white_wolf_howl_skill", function(q) 
{
	q.m.IsSpent <- false;

	q.create = @(__original) function()
	{
		__original();
		m.Order = ::Const.SkillOrder.Any;
		m.Description = "A fearsome howl that boosts the fighting spirit of its pack members.";
		m.Icon = "skills/active_22.png";
		m.IconDisabled = "skills/active_22_sw.png";
		m.FatigueCost = 35;
		m.MaxRange = 4;
	}

	q.getTooltip = function()
	{
		local ret = getDefaultUtilityTooltip();

		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has an effective range of [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles radius"
		});

		if (m.IsSpent)
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can only be used once per battle[/color]"
			});

		return ret;
	}

	q.isUsable <- function()
	{
		return skill.isUsable() && !m.IsSpent;
	}

	q.onUse = @() function( _user, _targetTile )
	{
		foreach( a in ::Tactical.Entities.getAlliedActors(_user.getFaction(), _user.getTile(), getMaxRange()) )
		{
			if (a.getID() == _user.getID())
				continue;
			
			a.getSkills().removeByID("effects.sleeping");
			spawnIcon("status_effect_06", a.getTile());
			a.checkMorale(1, 2000);
		}

		m.IsSpent = true;
		return true;
	}

	q.onCombatStarted <- function()
	{
		m.IsSpent = false;
	}
	
	q.onCombatFinished <- function()
	{
		m.IsSpent = false;
	}
	
});