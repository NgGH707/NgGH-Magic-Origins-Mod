::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/insects_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		//m.IsMagicSkill = true;
		//m.MagicPointsCost = 6;
		//m.IsRequireStaff = true;
		m.Description = "Call a swarm of insects to swarm around a target. I hopp it\'s a cockroach swarm. Can\'t be used while engaging in melee.";
		m.Icon = "skills/active_69.png";
		m.IconDisabled = "skills/active_69_sw.png";
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		ret.insert(3, {
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
		});

		if (::Tactical.isActive() && getContainer().getActor().isEngagedInMelee())
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
			});
		
		return ret;
	}
	
});