this.perk_uproot <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.uproot";
		this.m.Name = this.Const.Strings.PerkName.SchratUproot;
		this.m.Description = this.Const.Strings.PerkDescription.SchratUproot;
		this.m.Icon = "ui/perks/perk_uproot.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInSpears = true;
	}

});

