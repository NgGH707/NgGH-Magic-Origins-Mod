this.goblin_medium_base_armor <- this.inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [
			3
		];
		this.m.Variant = 3;
		this.updateVariant();
		this.m.ID = "armor.body.goblin_medium_armor";
		this.m.Name = "Goblin Leather Armor";
		this.m.Description = "A thick small leather armor covered with additional leather patches.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Condition = 70;
		this.m.ConditionMax = 70;
		this.m.StaminaModifier = -3;
		this.m.Value = 40;
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
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

