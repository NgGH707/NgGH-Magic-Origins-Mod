this.perk_nggh_charm_enemy_spider <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.charm_enemy_spider";
		this.m.Name = ::Const.Strings.PerkName.NggHCharmEnemySpider;
		this.m.Description = ::Const.Strings.PerkDescription.NggHCharmEnemySpider;
		this.m.Icon = "ui/perks/charmed_spider_01.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onUpdate( _properties )
	{
		_properties.IsImmuneToRoot = true;
	}
	
});