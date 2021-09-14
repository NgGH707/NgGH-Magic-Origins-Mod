this.perk_charm_enemy_spider <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.charm_enemy_spider";
		this.m.Name = this.Const.Strings.PerkName.CharmEnemySpider;
		this.m.Description = this.Const.Strings.PerkDescription.CharmEnemySpider;
		this.m.Icon = "ui/perks/charmed_spider_01.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onUpdate( _properties )
	{
		_properties.IsImmuneToRoot = true;
	}
	
});