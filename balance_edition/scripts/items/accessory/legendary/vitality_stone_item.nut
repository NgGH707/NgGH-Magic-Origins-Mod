this.vitality_stone_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.vitality_stone";
		this.m.Name = "Blessed Stone of Vitality";
		this.m.Description = "A stone that gives its owner outstanding endurance and physical attributes.";
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool | this.Const.Items.ItemType.Accessory;
		this.m.IsAllowedInBag = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/vitality_stone.png";
		this.m.StaminaModifier = 0;
		this.m.Value = 1000;
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
		
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

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
		
		result.extend([
			{
				id = 8,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25[/color] Hitpoints"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Only takes [color=" + this.Const.UI.Color.PositiveValue + "]75%[/color] of any Damage taken."
			},
		]);
		
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/perfect_focus_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		
		if (!this.isEquipped())
		{
			return;
		}
		
		_properties.Hitpoints += 25;
		_properties.DamageReceivedTotalMult *= 0.75;
	}

});

