this.perk_nggh_egg_attach <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.attach_egg";
		this.m.Name = ::Const.Strings.PerkName.NggHEggAttachSpider;
		this.m.Description = ::Const.Strings.PerkDescription.NggHEggAttachSpider;
		this.m.Icon = "ui/perks/perk_attach_egg.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.attach_egg"))
		{
			this.getContainer().add(::new("scripts/skills/eggs/nggh_mod_attach_egg"));
		}

		if (!this.getContainer().hasSkill("actives.unleash_tempo_spider"))
		{
			this.getContainer().add(::new("scripts/skills/eggs/nggh_mod_unleash_temp_spider"));
		}

		local actor = this.getContainer().getActor();
		local item = actor.getItems().getItemAtSlot(::Const.ItemSlot.Accessory);

		if (item != null)
		{
			actor.getMount().onAccessoryEquip(item);
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.attach_egg");
		this.getContainer().removeByID("actives.unleash_tempo_spider");
		this.getContainer().getActor().getMount().onAccessoryUnequip();
	}

});

