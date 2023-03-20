this.perk_nggh_serpent_giant <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.serpent_giant";
		this.m.Name = ::Const.Strings.PerkName.NggHSerpentGiant;
		this.m.Description = ::Const.Strings.PerkDescription.NggHSerpentGiant;
		this.m.Icon = "ui/perks/perk_giant_serpent.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInShields = true;
	}

});

