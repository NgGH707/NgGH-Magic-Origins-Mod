::mods_hookExactClass("skills/actives/insects_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		//this.m.IsMagicSkill = true;
		//this.m.MagicPointsCost = 6;
		//this.m.IsRequireStaff = true;
		this.m.Description = "Call a swarm of insects to swarm around a target. I hopp it\'s a cockroach swarm. Can\'t be used while engaging in melee.";
		this.m.Icon = "skills/active_69.png";
		this.m.IconDisabled = "skills/active_69_sw.png";
	};

	local ws_getTooltip = obj.getTooltip;
	obj.getTooltip = function()
	{
		local ret = ws_getTooltip();
		ret.insert(3, {
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
		});
		if (::Tactical.isActive() && this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
			});
		}
		return ret;
	};
});