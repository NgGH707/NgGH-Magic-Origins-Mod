this.perk_serpent_drag <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.serpent_drag";
		this.m.Name = this.Const.Strings.PerkName.SerpentDrag;
		this.m.Description = this.Const.Strings.PerkDescription.SerpentDrag;
		this.m.Icon = "ui/perks/perk_serpent_drag.png";
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

