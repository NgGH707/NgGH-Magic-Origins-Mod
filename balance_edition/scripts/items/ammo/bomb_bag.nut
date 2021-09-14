this.bomb_bag <- this.inherit("scripts/items/ammo/ammo", {
	m = {},
	function create()
	{
		this.m.ID = "ammo.mortar";
		this.m.Name = "Cannon Balls Bag";
		this.m.Description = "A bag contains black powder and some cannon balls, used for reloading a mortar, and very heavy. Is automatically refilled after each battle if you have enough ammunition.";
		this.m.Icon = "ammo/powder_bag.png";
		this.m.IconEmpty = "ammo/powder_bag_empty.png";
		this.m.SlotType = this.Const.ItemSlot.Ammo;
		this.m.ItemType = this.Const.Items.ItemType.Ammo;
		this.m.AmmoType = this.Const.Items.AmmoType.Powder;
		this.m.ShowOnCharacter = false;
		this.m.ShowQuiver = false;
		this.m.Value = 1000;
		this.m.Ammo = 3;
		this.m.AmmoMax = 3;
		this.m.StaminaModifier = -18;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.AddGenericSkill = true;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});
		
		if (this.m.StaminaModifier < 0)
		{
			result.push({
				id = 8,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Maximum Fatigue [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color]"
			});
		}

		if (this.m.Ammo != 0)
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "Contains ammo supplies for [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Ammo + "[/color] uses"
			});
		}
		else
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Is empty and useless[/color]"
			});
		}

		return result;
	}
	
	function onUpdateProperties( _properties )
	{
		this.m.StaminaModifier = -6 * this.m.Ammo;
		_properties.Stamina -= 6 * this.m.Ammo;
	}
	
	function onEquip()
	{
		this.ammo.onEquip();
		this.addSkill(this.new("scripts/skills/actives/load_mortar"));
	}

});

