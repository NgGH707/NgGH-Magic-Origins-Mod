this.nggh_mod_bomb_bag <- this.inherit("scripts/items/ammo/ammo", {
	m = {},
	function create()
	{
		this.m.ID = "ammo.mortar";
		this.m.Name = "Mortar Supply Bag";
		this.m.Description = "A strong bag contains black powder and some mortar shells, used for reloading a mortar, and very heavy. Is automatically refilled after each battle if you have enough ammunition.";
		this.m.Icon = "accessory/legend_pack_large.png";
		this.m.IconEmpty = "accessory/legend_pack_large.png";
		this.m.SlotType = this.Const.ItemSlot.Ammo;
		this.m.ItemType = this.Const.Items.ItemType.Ammo;
		this.m.AmmoType = this.Const.Items.AmmoType.Powder;
		this.m.ShowOnCharacter = false;
		this.m.ShowQuiver = false;
		this.m.Value = 1000;
		this.m.Ammo = 4;
		this.m.AmmoMax = 4;
		this.m.StaminaModifier = -6;
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
		
		if (this.getStaminaModifier() < 0)
		{
			result.push({
				id = 8,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Maximum Fatigue [color=" + this.Const.UI.Color.NegativeValue + "]" + this.getStaminaModifier() + "[/color]"
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

	function getStaminaModifier()
	{
		return this.m.StaminaModifier * this.m.Ammo;
	}
	
	function onUpdateProperties( _properties )
	{
		_properties.Stamina -= this.getStaminaModifier();
	}
	
	function onEquip()
	{
		this.ammo.onEquip();
		this.addSkill(this.new("scripts/skills/actives/load_mortar"));
	}

});

