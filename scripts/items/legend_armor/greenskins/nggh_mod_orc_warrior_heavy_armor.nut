this.nggh_mod_orc_warrior_heavy_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [3, 4, 5];
		this.m.Variant = ::MSU.Array.rand(this.m.Variants);
		this.updateVariant();
		this.m.ID = "armor.body.orc_warrior_heavy_armor";
		this.m.Name = "Looted Plate Armor";
		this.m.Description = "A makeshift armor made from various armor remains from many battles.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 400;
		this.m.ConditionMax = 400;
		this.m.StaminaModifier = -30;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Chain] = true;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Plate] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_03_armor_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_orc_03_armor_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_orc_03_armor_0" + this.m.Variant + "_dead";
		this.m.Icon = "armor/icon_orc_03_armor_0" + this.m.Variant + ".png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

});

