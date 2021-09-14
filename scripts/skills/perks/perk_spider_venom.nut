this.perk_spider_venom <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.spider_venom";
		this.m.Name = this.Const.Strings.PerkName.SpiderVenom;
		this.m.Description = this.Const.Strings.PerkDescription.SpiderVenom;
		this.m.Icon = "ui/perks/perk_venomous.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInDaggers = true;
	}

});

