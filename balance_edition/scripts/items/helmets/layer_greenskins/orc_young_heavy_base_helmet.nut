this.orc_young_heavy_base_helmet <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [
			3
		];
		this.m.Variant = 3;
		this.updateVariant();
		this.m.ID = "armor.head.orc_young_heavy_helmet";
		this.m.Name = "Metal Plated Helmet";
		this.m.Description = "A makeshift helmet made entirely from metal plates, offers great protection.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -10;
		this.blockUpgrades();
		this.m.Blocked[this.Const.Items.HelmetUpgrades.Rune] = false;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_01_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_orc_01_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_orc_01_helmet_0" + this.m.Variant + "_dead";
		this.m.Icon = "helmets/inventory_orc_01_helmet_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.legend_helmet.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

