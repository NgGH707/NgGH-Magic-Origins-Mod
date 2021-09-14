this.perk_charm_enemy_ork <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.charm_enemy_ork";
		this.m.Name = this.Const.Strings.PerkName.CharmEnemyOrk;
		this.m.Description = this.Const.Strings.PerkDescription.CharmEnemyOrk;
		this.m.Icon = "ui/perks/charmed_ork_01.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onAfterUpdate( _properties )
	{
		_properties.FatigueToInitiativeRate *= 0.40;
	}
	
});