this.perk_nggh_unhold_fling <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.unhold_fling";
		this.m.Name = ::Const.Strings.PerkName.NggHUnholdFling;
		this.m.Description = ::Const.Strings.PerkDescription.NggHUnholdFling;
		this.m.Icon = "ui/perks/perk_unhold_fling.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInThrowing = true;
	}

});

