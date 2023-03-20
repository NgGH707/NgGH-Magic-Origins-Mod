this.perk_nggh_charm_enemy_direwolf <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.charm_enemy_direwolf";
		this.m.Name = ::Const.Strings.PerkName.NggHCharmEnemyDirewolf;
		this.m.Description = ::Const.Strings.PerkDescription.NggHCharmEnemyDirewolf;
		this.m.Icon = "ui/perks/charmed_direwolf_01.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onUpdate( _properties )
	{
		_properties.InitiativeMult *= 1.08;
		_properties.MovementFatigueCostAdditional -= 2;
	}
	
});