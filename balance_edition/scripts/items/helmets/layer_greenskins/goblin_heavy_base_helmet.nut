this.goblin_heavy_base_helmet <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [
			2
		];
		this.m.Variant = 2;
		this.updateVariant();
		this.m.IsDroppedAsLoot = true;
		this.m.ID = "armor.head.goblin_heavy_helmet";
		this.m.Name = "Goblin Helmet";
		this.m.Description = "A helmet made for the elite troops";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Condition = 70;
		this.m.ConditionMax = 70;
		this.m.StaminaModifier = -4;
		this.m.Value = 40;
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
		return [
			this.Const.World.Common.pickHelmet([
				[
					1,
					"legend_goblin_heavy_helmet"
				]
			])
		];
	}

});

