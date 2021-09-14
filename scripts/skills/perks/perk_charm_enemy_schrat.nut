this.perk_charm_enemy_schrat <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.charm_enemy_schrat";
		this.m.Name = this.Const.Strings.PerkName.CharmEnemySchrat;
		this.m.Description = this.Const.Strings.PerkDescription.CharmEnemySchrat;
		this.m.Icon = "ui/perks/charmed_schrat_01.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onUpdate( _properties )
	{
		_properties.DamageReceivedRegularMult *= 0.9;
		_properties.MeleeDefense += 4;
		_properties.RangedDefense += 4;
	}
	
});