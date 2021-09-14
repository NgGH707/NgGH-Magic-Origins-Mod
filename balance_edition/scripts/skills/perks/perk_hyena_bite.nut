this.perk_hyena_bite <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.hyena_bite";
		this.m.Name = this.Const.Strings.PerkName.HyenaBite;
		this.m.Description = this.Const.Strings.PerkDescription.HyenaBite;
		this.m.Icon = "ui/perks/perk_hyena_bite.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInCleavers = true;
	}

});

