this.perk_wolf_rider <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.wolf_rider";
		this.m.Name = this.Const.Strings.PerkName.GoblinWolfRider;
		this.m.Description = this.Const.Strings.PerkDescription.GoblinWolfRider;
		this.m.Icon = "ui/perks/impulse_perk.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

		if (item != null)
		{
			actor.m.Mount.onAccessoryEquip(item);
		}
	}

});

