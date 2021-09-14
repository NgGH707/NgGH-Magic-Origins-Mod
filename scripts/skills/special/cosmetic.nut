this.cosmetic <- this.inherit("scripts/skills/skill", {
	function create()
	{
		this.m.ID = "special.cosmetic";
		this.m.Name = "Cosplay";
		this.m.Icon = "skills/status_effect_cosmetic.png";
		this.m.Description = "This hat gonna be good on my head. Looks! How pretty i am!";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.Trait | this.Const.SkillType.Alert;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Doesn\'t gain any armor from helmet and armor"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Doesn\'t suffer any fatigue or vision penalty from helmet and armor"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can still gain any special effect or rune effect from helmet and armor"
			}
		];
	}

	function onAdded()
	{
		this.getContainer().getActor().getItems().setCosplaying(true);
	}

	function onRemoved()
	{
		this.getContainer().getActor().getItems().setCosplaying(false);
	}

	function isHidden()
	{
		local h = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		local a = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Body);

		if (h == null && a == null)
		{
			this.m.IsHidden = true;
		}
		else
		{
			this.m.IsHidden = false;
		}

		return this.m.IsHidden;
	}

	function onAfterUpdate( _properties )
	{
		local h = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		local a = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Body);

		if (h == null && a == null)
		{
			return;
		}

		local staminaMult = 1.0;
		local armor = 0;
		local armorMax = 0;
		local stamia = 0;
		local vision = 0

		if (this.getContainer().hasSkill("perk.brawny"))
		{
			staminaMult = 0.7;
		}

		if (h != null)
		{
			armor += h.getArmor();
			armorMax += h.getArmorMax();
			stamia += h.getStaminaModifier();
			vision = h.getVision();
		}

		if (a != null)
		{
			armor += a.getArmor();
			armorMax += a.getArmorMax();
			stamia += a.getStaminaModifier();
		}

		_properties.Armor[this.Const.BodyPart.Head] -= armor;
		_properties.ArmorMax[this.Const.BodyPart.Head] -= armorMax;
		_properties.Stamina -= this.Math.ceil(stamia * staminaMult);
		_properties.Vision -= vision;
	}

});

