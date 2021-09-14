this.orc_warrior_heavy_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		local variants = [
			3,
			6
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.head.orc_warrior_heavy_helmet";
		this.m.Name = "Metal Plate Helmet";
		this.m.Description = "A makeshift helmet made entirely from metal plates, offers great protection.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 380;
		this.m.ConditionMax = 380;
		this.m.StaminaModifier = -26;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_03_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_orc_03_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_orc_03_helmet_0" + this.m.Variant + "_dead";
		this.m.Icon = "helmets/inventory_orc_03_helmet_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

