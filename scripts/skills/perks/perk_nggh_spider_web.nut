this.perk_nggh_spider_web <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.spider_web";
		this.m.Name = ::Const.Strings.PerkName.NggHSpiderWeb;
		this.m.Description = ::Const.Strings.PerkDescription.NggHSpiderWeb;
		this.m.Icon = "ui/perks/perk_spider_web.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
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
		local currentFatPerc = ::Math.minf(1.0, ((actor.getFatigue() - c) / ::Math.maxf(1.0, (actor.getFatigueMax() - c))));
		local ret = -1 * ::Math.max(0, ::Math.round(40 * (1 - currentFatPerc)));
		::logInfo("Web penalty to break free chance: " + ret + "%");
		return ret;
	}

});

