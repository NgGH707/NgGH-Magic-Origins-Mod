this.perk_unhold_fling <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.unhold_fling";
		this.m.Name = this.Const.Strings.PerkName.UnholdFling;
		this.m.Description = this.Const.Strings.PerkDescription.UnholdFling;
		this.m.Icon = "ui/perks/perk_unhold_fling.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInThrowing = true;
	}

});

