this.perk_nggh_charm_enemy_alp <- ::inherit("scripts/skills/skill", {
	m = {
		Bonus = 10,
	},
	function create()
	{
		this.m.ID = "perk.charm_enemy_alp";
		this.m.Name = ::Const.Strings.PerkName.NggHCharmEnemyAlp;
		this.m.Description = ::Const.Strings.PerkDescription.NggHCharmEnemyAlp;
		this.m.Icon = "ui/perks/charmed_alps_01.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
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
		_properties.MoraleCheckBravery[1] += 15;
	}

});

