this.perk_nggh_serpent_drag <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.serpent_drag";
		this.m.Name = ::Const.Strings.PerkName.NggHSerpentDrag;
		this.m.Description = ::Const.Strings.PerkDescription.NggHSerpentDrag;
		this.m.Icon = "ui/perks/perk_serpent_drag.png";
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

