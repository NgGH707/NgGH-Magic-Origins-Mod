this.nggh_mod_orc_warrior_light_helmet <- ::inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [1, 4];
		this.m.Variant = ::MSU.Array.rand(this.m.Variants);
		this.updateVariant();
		this.m.ID = "armor.head.orc_warrior_light_helmet";
		this.m.Name = "Looted Nasal Helmet";
		this.m.Description = "A makeshift helmet crafted from looted nasal helmet of his opponents, quite light.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 250;
		this.m.ConditionMax = 250;
		this.m.StaminaModifier = -15;
		
		this.m.Blocked[::Const.Items.HelmetUpgrades.Helm] = true;
		this.m.Blocked[::Const.Items.HelmetUpgrades.Top] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_03_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_orc_03_helmet_0" + this.m.Variant + "_damaged";

		if (this.m.Variant != 1)
		{
			this.m.SpriteCorpse = "bust_orc_03_helmet_0" + this.m.Variant + "_dead";
		}
		else
		{
			this.m.SpriteCorpse = "";
		}
		
		this.m.Icon = "helmets/inventory_orc_03_helmet_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.legend_helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

});

