this.luck_stone_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.luck_stone";
		this.m.Name = "Blessed Stone of Luck";
		this.m.Description = "A stone brings great luck to its owner, give them a second chance in critical moments. Of course, it will not give you another life.";
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool | this.Const.Items.ItemType.Accessory;
		this.m.IsAllowedInBag = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/luck_stone.png";
		this.m.StaminaModifier = -2;
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
				icon = "ui/icons/special.png",
				text = "Gives a [color=" + this.Const.UI.Color.PositiveValue + "]15%[/color] chance to have any attacker require two successful attack rolls in order to hit"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "GIves a [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] chance to have any negative morale check require two successful rolls in order to have any effect"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Gives a [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color] chance to reduce [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] damage taken of incoming attack"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Brings [color=" + this.Const.UI.Color.PositiveValue + "]Luck[/color]"
			}
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
		
		_properties.RerollDefenseChance += 15;
		_properties.RerollMoraleChance += 50;
		_properties.ThresholdToReceiveInjuryMult *= 1.5;
		_properties.SurviveWithInjuryChanceMult *= 10000.0;
	}
	
	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		local luck = this.Math.rand(0, 100);
		
		if (luck <= 25)
		{
			_properties.DamageReceivedTotalMult *= 0.5;
			this.logDebug("Mod Mage Trio - successful critical hit");
			this.Tactical.EventLog.log("Lucky! the stone use its power to lesser the blow");
		}
	}

});

