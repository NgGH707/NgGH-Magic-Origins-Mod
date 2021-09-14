this.orc_young_light_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.orc_young_light_armor";
		this.m.Name = "Hide Armor";
		this.m.Description = "A makeshift hide armor. Crudely made but still pretty tough.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = -10;
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
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

