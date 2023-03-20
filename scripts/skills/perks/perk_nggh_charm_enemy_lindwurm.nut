this.perk_nggh_charm_enemy_lindwurm <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.charm_enemy_lindwurm";
		this.m.Name = ::Const.Strings.PerkName.NggHCharmEnemyLindwurm;
		this.m.Description = ::Const.Strings.PerkDescription.NggHCharmEnemyLindwurm;
		this.m.Icon = "ui/perks/charmed_lindwurm_01.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onAfterUpdate( _properties )
	{
		local resolve = this.getContainer().getActor().getBravery();
		_properties.Threat += ::Math.round(resolve * 0.1);
	}
	
});