this.orc_young_medium_base_helmet <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [
			2
		];
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ID = "armor.head.orc_young_medium_helmet";
		this.m.Name = "Hide Head Gear";
		this.m.Description = "A hide helmet that offers better protection.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = -5;
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

