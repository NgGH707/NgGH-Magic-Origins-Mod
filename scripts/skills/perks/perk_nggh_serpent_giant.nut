perk_nggh_serpent_giant <- ::inherit("scripts/skills/skill", {
	m = {
		Mult = 0.5
	},
	function getMult()
	{
		return m.Mult;
	}

	function create()
	{
		m.ID = "perk.serpent_giant";
		m.Name = ::Const.Strings.PerkName.NggHSerpentGiant;
		m.Description = ::Const.Strings.PerkDescription.NggHSerpentGiant;
		m.Icon = "ui/perks/perk_giant_serpent.png";
		m.Type = ::Const.SkillType.Perk;
		m.Order = ::Const.SkillOrder.Perk;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInShields = true;
	}

	function onAfterUpdate( _properties )
	{
		local skill = getContainer().getSkillByID("actives.serpent_hook");

		if (skill == null) return;

		skill.m.DragMinDamage += 5;
		skill.m.DragMinDamage += 5;
	}

});

