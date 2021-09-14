this.goblin_shaman_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.updateVariant();
		this.m.ID = "armor.head.goblin_shaman_helmet";
		this.m.Name = "Ritual Headpiece";
		this.m.Description = "A ceremonial piece for shaman";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Condition = 35;
		this.m.ConditionMax = 35;
		this.m.StaminaModifier = 0;
		this.m.Value = 40;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_02_helmet_01";
		this.m.SpriteDamaged = "bust_goblin_02_helmet_01_damaged";
		this.m.SpriteCorpse = "bust_goblin_02_helmet_01_dead";
		this.m.Icon = "helmets/inventory_goblin_02_helmet_01.png";
	}

	function onEquip()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

