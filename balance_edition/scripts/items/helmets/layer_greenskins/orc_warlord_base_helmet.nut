this.orc_warlord_base_helmet <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [
			1
		];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.head.orc_warlord_helmet";
		this.m.Name = "Warlord Looted Helmet";
		this.m.Description = "A makeshift helmet made out of looted armor from the tough opponents he had fought.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 500;
		this.m.ConditionMax = 500;
		this.m.StaminaModifier = -35;
		this.blockUpgrades();
		this.m.Blocked[this.Const.Items.HelmetUpgrades.Rune] = false;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_04_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_orc_04_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_orc_04_helmet_0" + this.m.Variant + "_dead";
		this.m.Icon = "helmets/inventory_orc_04_helmet_01.png";
	}

	function onEquip()
	{
		this.legend_helmet.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

