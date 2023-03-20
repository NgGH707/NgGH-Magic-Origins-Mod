this.nggh_mod_orc_warlord_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.body.orc_warlord_armor";
		this.m.Name = "Warlord Battle Gear";
		this.m.Description = "A makeshift armor made from the armors of his greatest trophy.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 600;
		this.m.ConditionMax = 600;
		this.m.StaminaModifier = -50;
		this.blockUpgrades();
		this.m.Blocked[::Const.Items.ArmorUpgrades.Rune] = false;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_04_armor_01";
		this.m.SpriteDamaged = "bust_orc_04_armor_01_damaged";
		this.m.SpriteCorpse = "bust_orc_04_armor_01_dead";
		this.m.Icon = "armor/icon_orc_04_armor_01.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

	function getTooltip()
	{
		local result = this.legend_armor.getTooltip();
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+10%[/color] Resolve"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.legend_armor.onUpdateProperties(_properties);
		_properties.BraveryMult *= 1.1;
	}

});

