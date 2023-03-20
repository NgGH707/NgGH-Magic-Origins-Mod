this.nggh_mod_orc_warlord_helmet <- ::inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.head.orc_warlord_helmet";
		this.m.Name = "Warlord Battle Helm";
		this.m.Description = "A makeshift helmet made out of looted armors from the toughest opponents that the owner of this helmet has fought.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 500;
		this.m.ConditionMax = 500;
		this.m.StaminaModifier = -25;

		this.m.Blocked[::Const.Items.HelmetUpgrades.Helm] = true;
		this.m.Blocked[::Const.Items.HelmetUpgrades.Top] = true;
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
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

});

