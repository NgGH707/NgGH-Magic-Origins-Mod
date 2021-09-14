this.goblin_light_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		local variants = [
			1,
			1,
			3
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.head.goblin_light_helmet";
		this.m.Name = "Goblin Leather Cap";
		this.m.Description = "A sturdy leather cap that is only fitted for a child.";
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
		this.m.Sprite = "bust_goblin_01_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_goblin_01_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_goblin_01_helmet_0" + this.m.Variant + "_dead";
		this.m.Icon = "helmets/inventory_goblin_01_helmet_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

