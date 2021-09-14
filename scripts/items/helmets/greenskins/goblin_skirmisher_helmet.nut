this.goblin_skirmisher_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "armor.head.goblin_skirmisher_helmet";
		this.m.Name = "Camouflage Hood";
		this.m.Description = "A hood that has been made to help the wear disguise as a bush";
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
		this.m.Sprite = "bust_goblin_04_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_goblin_04_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_goblin_04_helmet_0" + this.m.Variant + "_dead";
		this.m.Icon = "helmets/inventory_goblin_04_helmet_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

