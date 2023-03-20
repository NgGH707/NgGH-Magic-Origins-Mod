this.perk_nggh_charm_enemy_goblin <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.charm_enemy_goblin";
		this.m.Name = ::Const.Strings.PerkName.NggHCharmEnemyGoblin;
		this.m.Description = ::Const.Strings.PerkDescription.NggHCharmEnemyGoblin;
		this.m.Icon = "ui/perks/charmed_goblin_01.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
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