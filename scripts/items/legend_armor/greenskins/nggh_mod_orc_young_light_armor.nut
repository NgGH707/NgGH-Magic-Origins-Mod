this.nggh_mod_orc_young_light_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [2];
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ID = "armor.body.orc_young_light_armor";
		this.m.Name = "Hide Armor";
		this.m.Description = "A makeshift hide armor. Crudely made but still pretty tough.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = -9;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_01_armor_02";
		this.m.SpriteDamaged = "bust_orc_01_armor_02_damaged";
		this.m.SpriteCorpse = "bust_orc_01_armor_02_dead";
		this.m.Icon = "armor/icon_orc_01_armor_02.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

});

