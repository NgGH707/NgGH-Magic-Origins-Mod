this.nggh_mod_orc_young_medium_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [3];
		this.m.Variant = 3;
		this.updateVariant();
		this.m.ID = "armor.body.orc_young_medium_armor";
		this.m.Name = "Tough Hide Armor";
		this.m.Description = "A makeshift hide armor. But with hide at better quality.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 80;
		this.m.ConditionMax = 80;
		this.m.StaminaModifier = -11;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_01_armor_03";
		this.m.SpriteDamaged = "bust_orc_01_armor_03_damaged";
		this.m.SpriteCorpse = "bust_orc_01_armor_03_dead";
		this.m.Icon = "armor/icon_orc_01_armor_03.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
	
});

