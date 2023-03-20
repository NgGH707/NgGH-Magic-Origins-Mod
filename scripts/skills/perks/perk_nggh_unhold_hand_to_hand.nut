this.perk_nggh_unhold_hand_to_hand <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.unhold_hand_to_hand";
		this.m.Name = ::Const.Strings.PerkName.NggHUnholdUnarmedAttack;
		this.m.Description = ::Const.Strings.PerkDescription.NggHUnholdUnarmedAttack;
		this.m.Icon = "ui/perks/perk_unhold_hand_to_hand.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.unhold_hand_to_hand"))
		{
			this.getContainer().add(::new("scripts/skills/actives/nggh_mod_unhold_hand_to_hand"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.unhold_hand_to_hand");
	}

});

