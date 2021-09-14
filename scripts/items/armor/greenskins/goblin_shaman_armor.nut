this.goblin_shaman_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.goblin_shaman_armor";
		this.m.Name = "Ritual Armor";
		this.m.Description = "A ceremonial piece for shaman";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Condition = 45;
		this.m.ConditionMax = 45;
		this.m.StaminaModifier = 0;
		this.m.Value = 40;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_02_armor_01";
		this.m.SpriteDamaged = "bust_goblin_02_armor_01_damaged";
		this.m.SpriteCorpse = "bust_goblin_02_armor_01_dead";
		this.m.Icon = "armor/icon_goblin_02_armor_01.png";
	}

	function onEquip()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

