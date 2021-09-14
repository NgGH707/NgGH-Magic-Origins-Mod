this.perk_unhold_hand_to_hand<- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.unhold_hand_to_hand";
		this.m.Name = this.Const.Strings.PerkName.UnholdUnarmedAttack;
		this.m.Description = this.Const.Strings.PerkDescription.UnholdUnarmedAttack;
		this.m.Icon = "ui/perks/perk_unhold_hand_to_hand.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.unhold_hand_to_hand"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/unhold_hand_to_hand"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.unhold_hand_to_hand");
	}

});

