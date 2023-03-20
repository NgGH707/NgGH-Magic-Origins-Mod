this.nggh_mod_orc_warrior_medium_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [2];
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ID = "armor.body.orc_warrior_medium_armor";
		this.m.Name = "Looted Reinforced Mail";
		this.m.Description = "A makeshift armor made from various armor remains from many battles, offers decent protection.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 350;
		this.m.ConditionMax = 350;
		this.m.StaminaModifier = -26;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Chain] = true;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Plate] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_03_armor_02";
		this.m.SpriteDamaged = "bust_orc_03_armor_02_damaged";
		this.m.SpriteCorpse = "bust_orc_03_armor_02_dead";
		this.m.Icon = "armor/icon_orc_03_armor_02.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

});

