this.nggh_mod_orc_berserker_medium_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [2];
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ID = "armor.body.orc_berserker_medium_armor";
		this.m.Name = "Bone Armor";
		this.m.Description = "An armor made out of the bone of whatever thing it is. A valuable item to show its owner standing in the horde.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ["sounds/enemies/skeleton_hurt_03.wav"];
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 125;
		this.m.ConditionMax = 125;
		this.m.StaminaModifier = -10;

		this.m.Blocked[::Const.Items.ArmorUpgrades.Chain] = true;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Plate] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_02_armor_02";
		this.m.SpriteDamaged = "bust_orc_02_armor_02_damaged";
		this.m.SpriteCorpse = "bust_orc_02_armor_02_dead";
		this.m.Icon = "armor/icon_orc_02_armor_02.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();

		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().add("berserker_armor");
		}
	}

	function onUnequip()
	{
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().remove("berserker_armor");
		}

		this.legend_armor.onUnequip();
	}

	function getTooltip()
	{
		local result = this.legend_armor.getTooltip();
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+50[/color] Resolve"
		});

		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return result;
		}

		if (c.getActor().getFlags().has("berserker_helmet"))
		{
			result.extend([
				{
					id = 11,
					type = "text",
					text = "[u][size=14]Set effect[/size][/u]"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Cannot be reduced to [color=" + ::Const.UI.Color.NegativeValue + "]" + ::Const.MoraleStateName[::Const.Orc.BerserkerArmorMoraleThreshold - 1] + "[/color] morale, only [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Const.MoraleStateName[::Const.Orc.BerserkerArmorMoraleThreshold] + "[/color]"
				}
			]);
		}

		return result;
	}

	function onUpdateProperties ( _properties )
	{
		this.legend_armor.onUpdateProperties(_properties);
		_properties.Bravery += 50;
	}

});

