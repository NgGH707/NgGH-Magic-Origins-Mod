this.perk_charm_enemy_lindwurm <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.charm_enemy_lindwurm";
		this.m.Name = this.Const.Strings.PerkName.CharmEnemyLindwurm;
		this.m.Description = this.Const.Strings.PerkDescription.CharmEnemyLindwurm;
		this.m.Icon = "ui/perks/charmed_lindwurm_01.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onAfterUpdate( _properties )
	{
		local resolve = this.getContainer().getActor().getBravery();
		_properties.Threat += this.Math.round(resolve * 0.1);
	}
	
});