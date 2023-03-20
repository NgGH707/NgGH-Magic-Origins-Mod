this.nggh_mod_orc_elite_heavy_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.body.orc_elite_heavy_armor";
		this.m.Name = "Bloody Looted Plate Armor";
		this.m.Description = "A makeshift armor made from various armor remains many battles. It has been dyed red by blood.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 550;
		this.m.ConditionMax = 550;
		this.m.StaminaModifier = -45;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Chain] = true;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Plate] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_elite_armor_01";
		this.m.SpriteDamaged = "bust_orc_elite_armor_01_damaged";
		this.m.SpriteCorpse = "bust_orc_elite_armor_01_dead";
		this.m.Icon = "armor/icon_orc_elite_armor_01.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

});

