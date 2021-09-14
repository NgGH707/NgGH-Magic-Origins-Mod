this.perk_charm_enemy_alps <- this.inherit("scripts/skills/skill", {
	m = {
		Bonus = 10,
	},
	function create()
	{
		this.m.ID = "perk.charm_enemy_alps";
		this.m.Name = this.Const.Strings.PerkName.CharmEnemyAlps;
		this.m.Description = this.Const.Strings.PerkDescription.CharmEnemyAlps;
		this.m.Icon = "ui/perks/charmed_alps_01.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function getBonus()
	{
		return this.m.Bonus;
	}
	
	function onUpdate( _properties )
	{
		_properties.MoraleCheckBravery[1] += 10;
	}

});

