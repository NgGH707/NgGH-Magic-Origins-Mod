this.perk_charm_enemy_goblin <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.charm_enemy_goblin";
		this.m.Name = this.Const.Strings.PerkName.CharmEnemyGoblin;
		this.m.Description = this.Const.Strings.PerkDescription.CharmEnemyGoblin;
		this.m.Icon = "ui/perks/charmed_goblin_01.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onUpdate( _properties )
	{
		_properties.RangedDefense += 10;
		_properties.IsImmuneToOverwhelm = true;
	}
	
});