this.nggh_mod_goblin_medium_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [3];
		this.m.Variant = 3;
		this.updateVariant();
		this.m.ID = "armor.body.goblin_medium_armor";
		this.m.Name = "Goblin Leather Armor";
		this.m.Description = "A thick small leather armor covered with additional leather patches.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 70;
		this.m.ConditionMax = 70;
		this.m.StaminaModifier = -3;
		this.m.Value = 40;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Plate] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_01_armor_03";
		this.m.SpriteDamaged = "bust_goblin_01_armor_03_damaged";
		this.m.SpriteCorpse = "bust_goblin_01_armor_03_dead";
		this.m.Icon = "armor/icon_goblin_01_armor_03.png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

});

