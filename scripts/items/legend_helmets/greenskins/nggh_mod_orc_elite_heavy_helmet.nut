this.nggh_mod_orc_elite_heavy_helmet <- ::inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.head.orc_elite_heavy_helmet";
		this.m.Name = "Bloody Metal Plate Helmet";
		this.m.Description = "A makeshift helmet which is dyed in blood. It is stink but has exceptional durability.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 540;
		this.m.ConditionMax = 540;
		this.m.StaminaModifier = -35;
		
		this.m.Blocked[::Const.Items.HelmetUpgrades.Helm] = true;
		this.m.Blocked[::Const.Items.HelmetUpgrades.Top] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_elite_helmet_01";
		this.m.SpriteDamaged = "bust_orc_elite_helmet_01_damaged";
		this.m.SpriteCorpse = "bust_orc_elite_helmet_01_dead";
		this.m.Icon = "helmets/inventory_orc_elite_helmet_01.png";
	}

	function onEquip()
	{
		this.legend_helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

});

