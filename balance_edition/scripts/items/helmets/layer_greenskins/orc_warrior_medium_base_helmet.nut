this.orc_warrior_medium_base_helmet <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [
			2,
			5
		];
		this.m.Variant = this.m.Variants[this.Math.rand(0, this.m.Variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.head.orc_warrior_medium_helmet";
		this.m.Name = "Looted Kettle Hat";
		this.m.Description = "A makeshift helmet crafted from looted kettle hat of his fallen opponents. Quite durable.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 325;
		this.m.ConditionMax = 325;
		this.m.StaminaModifier = -22;
		this.blockUpgrades();
		this.m.Blocked[this.Const.Items.HelmetUpgrades.Rune] = false;
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
		this.legend_helmet.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

