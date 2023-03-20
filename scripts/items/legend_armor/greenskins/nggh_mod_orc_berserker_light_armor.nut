this.nggh_mod_orc_berserker_light_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.body.orc_berserker_light_armor";
		this.m.Name = "Trophy Bones";
		this.m.Description = "A harness made out of the bone of what is seemed as battle trophy. A token to honor its owner warrior skill.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ["sounds/enemies/skeleton_hurt_03.wav"];
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 75;
		this.m.ConditionMax = 75;
		this.m.StaminaModifier = -5;

		this.m.Blocked[::Const.Items.ArmorUpgrades.Chain] = true;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Plate] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_02_armor_01";
		this.m.SpriteDamaged = "bust_orc_02_armor_01_damaged";
		this.m.SpriteCorpse = "bust_orc_02_armor_01_dead";
		this.m.Icon = "armor/icon_orc_02_armor_01.png";
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
		result.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "No morale check triggered upon allies dying or fleeing"
			},
			/*
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Does not protect from effects that target morale directly, like Fearsome"
			}
			*/
		]);

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

	function onUpdateProperties( _properties )
	{
		this.legend_armor.onUpdateProperties(_properties);
		//_properties.IsAffectedByLosingHitpoints = false;
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByFleeingAllies = false;
	}

});

