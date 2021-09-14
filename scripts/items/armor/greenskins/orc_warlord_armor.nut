this.orc_warlord_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.orc_warlord_armor";
		this.m.Name = "Warlord Battle Gear";
		this.m.Description = "A makeshift armor made from the armors of his greatest trophy.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 500;
		this.m.ConditionMax = 500;
		this.m.StaminaModifier = -40;
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
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

