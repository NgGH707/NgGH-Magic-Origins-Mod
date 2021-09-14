this.perk_ironside <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.ironside";
		this.m.Name = this.Const.Strings.PerkName.Ironside;
		this.m.Description = this.Const.Strings.PerkDescription.Ironside;
		this.m.Icon = "skills/passive_03.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function getDescription()
	{
		local bonus = this.getBonus() * 100;
		return "This character gains [color=" + this.Const.UI.Color.PositiveValue + "]" + bonus + "%[/color] damage reduction because of adjacent opponents.";
	}

	function getBonus()
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return 0;
		}
		
		return this.getContainer().getActor().getSurroundedCount() * 0.05;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		_properties.DamageReceivedTotalMult -= this.getBonus();
	}

});

