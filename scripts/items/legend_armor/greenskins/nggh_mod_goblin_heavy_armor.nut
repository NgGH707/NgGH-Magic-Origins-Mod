this.nggh_mod_goblin_heavy_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [2, 4];
		this.m.Variant = ::MSU.Array.rand(this.m.Variants);
		this.updateVariant();
		this.m.ID = "armor.body.goblin_heavy_armor";
		this.m.Name = "Goblin Reinforced Leather Armor";
		this.m.Description = "An armor made for the elite troops";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 80;
		this.m.ConditionMax = 80;
		this.m.StaminaModifier = -6;
		this.m.Value = 40;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Plate] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_01_armor_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_goblin_01_armor_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_goblin_01_armor_0" + this.m.Variant + "_dead";
		this.m.Icon = "armor/icon_goblin_01_armor_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

});

