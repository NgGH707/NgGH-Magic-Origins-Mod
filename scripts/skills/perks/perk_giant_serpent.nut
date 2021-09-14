this.perk_giant_serpent <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.serpent_giant";
		this.m.Name = this.Const.Strings.PerkName.SerpentGiant;
		this.m.Description = this.Const.Strings.PerkDescription.SerpentGiant;
		this.m.Icon = "ui/perks/perk_giant_serpent.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInShields = true;
	}

});

