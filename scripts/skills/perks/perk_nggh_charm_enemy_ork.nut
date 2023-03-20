this.perk_nggh_charm_enemy_ork <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.charm_enemy_ork";
		this.m.Name = ::Const.Strings.PerkName.NggHCharmEnemyOrk;
		this.m.Description = ::Const.Strings.PerkDescription.NggHCharmEnemyOrk;
		this.m.Icon = "ui/perks/charmed_ork_01.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onAfterUpdate( _properties )
	{
		_properties.FatigueToInitiativeRate *= 0.5;
	}
	
});