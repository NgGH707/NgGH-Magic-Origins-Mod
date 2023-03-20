this.perk_nggh_goblin_mount_training <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.mount_training";
		this.m.Name = ::Const.Strings.PerkName.NggHGoblinMountTraining;
		this.m.Description = ::Const.Strings.PerkDescription.NggHGoblinMountTraining;
		this.m.Icon = "ui/perks/impulse_perk.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local item = actor.getItems().getItemAtSlot(::Const.ItemSlot.Accessory);

		if (item != null)
		{
			actor.getMount().onAccessoryEquip(item);
		}
	}

	function onRemoved()
	{
		this.getContainer().getActor().getMount().onAccessoryUnequip();
	}

});

