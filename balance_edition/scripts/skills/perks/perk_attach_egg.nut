this.perk_attach_egg <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.attach_egg";
		this.m.Name = this.Const.Strings.PerkName.EggAttachSpider;
		this.m.Description = this.Const.Strings.PerkDescription.EggAttachSpider;
		this.m.Icon = "ui/perks/perk_attach_egg.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.attach_egg"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/attach_egg"));
		}

		if (!this.m.Container.hasSkill("actives.unleash_tempo_spider"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/unleash_tempo_spider"));
		}

		local actor = this.getContainer().getActor();
		local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

		if (item != null)
		{
			actor.m.Mount.onAccessoryEquip(item);
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.attach_egg");
		this.m.Container.removeByID("actives.unleash_tempo_spider");

		local actor = this.getContainer().getActor();
		local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

		if (item != null)
		{
			actor.m.Mount.onAccessoryUnequip(item);
		}
	}

});

