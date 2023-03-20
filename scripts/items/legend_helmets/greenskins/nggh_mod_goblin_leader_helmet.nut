this.nggh_mod_goblin_leader_helmet <- ::inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.IsDroppedAsLoot = true;
		this.m.ID = "armor.head.goblin_leader_helmet";
		this.m.Name = "Overseer Helm";
		this.m.Description = "A helmet befits for an overseer";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 125;
		this.m.ConditionMax = 125;
		this.m.StaminaModifier = -7;
		this.m.Value = 40;

		this.m.Blocked[::Const.Items.HelmetUpgrades.Helm] = true;
		this.m.Blocked[::Const.Items.HelmetUpgrades.Top] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_03_helmet_01";
		this.m.SpriteDamaged = "bust_goblin_03_helmet_01_damaged";
		this.m.SpriteCorpse = "bust_goblin_03_helmet_01_dead";
		this.m.Icon = "helmets/inventory_goblin_03_helmet_01.png";
	}

	function getLootLayers()
	{
		if (::Nggh_MagicConcept.isHexeOrigin() && ::Math.rand(1, 100) <= 50)
		{
			return [this];
		}
		
		return [::new("scripts/items/legend_helmets/top/legend_helmet_goblin_spiked_helm")];
	}

});

