this.nggh_mod_goblin_heavy_helmet <- ::inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [2];
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ID = "armor.head.goblin_heavy_helmet";
		this.m.Name = "Goblin Helm";
		this.m.Description = "A helmet made for the elite troops";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ImpactSound = ::Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 90;
		this.m.ConditionMax = 90;
		this.m.StaminaModifier = -4;
		this.m.Value = 40;

		this.m.Blocked[::Const.Items.HelmetUpgrades.Helm] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_01_helmet_02";
		this.m.SpriteDamaged = "bust_goblin_01_helmet_02_damaged";
		this.m.SpriteCorpse = "bust_goblin_01_helmet_02_dead";
		this.m.Icon = "helmets/inventory_goblin_01_helmet_02.png";
	}

	function getLootLayers()
	{
		if (::Nggh_MagicConcept.isHexeOrigin() && ::Math.rand(1, 100) <= 50)
		{
			return [this];
		}
		
		return [::Const.World.Common.pickHelmet([[1, "legend_goblin_heavy_helmet"]])];
	}

});

