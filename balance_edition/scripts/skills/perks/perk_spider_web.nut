this.perk_spider_web <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.spider_web";
		this.m.Name = this.Const.Strings.PerkName.SpiderWeb;
		this.m.Description = this.Const.Strings.PerkDescription.SpiderWeb;
		this.m.Icon = "ui/perks/perk_spider_web.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function getModifier()
	{
		local web = this.getContainer().getSkillByID("actives.web");
		
		if (web != null)
		{
			return web.getFatigueCost();
		}
		
		return 0;
	}

	function getPenalty()
	{
		local c = this.getModifier();
		local actor = this.getContainer().getActor();
		local currentFatPerc = this.Math.minf(1.0, ((actor.m.Fatigue - c) / this.Math.maxf(1.0, (actor.getFatigueMax() - c))));
		local ret = -1 * this.Math.max(0, this.Math.round(50 * (1 - currentFatPerc)));
		this.logInfo("Web penalty to break free chance:" + ret + "%");
		return ret;
	}

});

