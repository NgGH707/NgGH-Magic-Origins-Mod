this.nggh_mod_cosmetic <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.cosmetic";
		this.m.Name = "Cosmetic";
		this.m.Icon = "skills/status_effect_cosmetic.png";
		this.m.Description = "This hat gonna look good on my head. Looks! How pretty i am!";
		this.m.Type = ::Const.SkillType.Special | ::Const.SkillType.Trait | ::Const.SkillType.Alert;
		this.m.Order = ::Const.SkillOrder.Last;
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
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Doesn\'t gain any armor from helmet or armor pieces[/color]"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Doesn\'t suffer any fatigue or vision penalty from helmet or armor pieces[/color]"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Can still gain any special effect or rune effect from helmet and armor pieces[/color]"
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
		if (!::Nggh_MagicConcept.IsCosmeticEnable)
		{
			return true;
		}

		local actor = this.getContainer().getActor();
		return actor.getHeadItem() == null && actor.getBodyItem() == null;
	}

	function onAfterUpdate( _properties )
	{
		if (!::Nggh_MagicConcept.IsCosmeticEnable)
		{
			return;
		}

		local actor = this.getContainer().getActor();
		local h = actor.getHeadItem();
		local a = actor.getBodyItem();

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

		_properties.Armor[::Const.BodyPart.Head] -= armor;
		_properties.ArmorMax[::Const.BodyPart.Head] -= armorMax;
		_properties.Stamina -= ::Math.ceil(stamia * staminaMult);
		_properties.Vision -= vision;
	}

});

