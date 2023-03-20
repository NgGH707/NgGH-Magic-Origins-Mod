this.nggh_mod_orc_warrior_heavy_helmet <- ::inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [3, 6];
		this.m.Variant = ::MSU.Array.rand(this.m.Variants);
		this.updateVariant();
		this.m.ID = "armor.head.orc_warrior_heavy_helmet";
		this.m.Name = "Metal Plate Helmet";
		this.m.Description = "A makeshift helmet made entirely from metal plates, offers great protection.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 360;
		this.m.ConditionMax = 360;
		this.m.StaminaModifier = -23;
		
		this.m.Blocked[::Const.Items.HelmetUpgrades.Helm] = true;
		this.m.Blocked[::Const.Items.HelmetUpgrades.Top] = true;
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
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

});

