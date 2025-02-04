::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/throw_dirt_skill", function ( q )
{
	q.create = @(__original) function()
	{
		ws_create();
		m.Description = "Play nice would not grant you victory everytime, a little dirty trick can easily boost your win chance. Wild Nomad uses sand-attack!!!";
		m.Icon = "skills/active_215.png";
		m.IconDisabled = "skills/active_215_sw.png";
		m.IsUsingHitchance = false;
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Throws dirt or sand at the enemy face"
		});
		return ret;
	}

	q.isUsable = @() function()
	{
		return skill.isUsable();
	}

	q.onAfterUpdate <- function( _properties )
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player"))
			m.FatigueCost += 7;
	}

});