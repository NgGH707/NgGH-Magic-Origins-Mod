this.goblin_light_base_helmet <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [
			1,
			3
		];
		this.m.Variant = this.m.Variants[this.Math.rand(0, this.m.Variants.len() - 1)];
		this.updateVariant();
		this.m.IsDroppedAsLoot = true;
		this.m.ID = "armor.head.goblin_light_helmet";
		this.m.Name = "Goblin Leather Cap";
		this.m.Description = "A sturdy leather cap that is only fitted for a child.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Condition = 50;
		this.m.ConditionMax = 50;
		this.m.StaminaModifier = 0;
		this.m.Value = 40;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_01_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_goblin_01_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_goblin_01_helmet_0" + this.m.Variant + "_dead";
		this.m.Icon = "helmets/inventory_goblin_01_helmet_0" + this.m.Variant + ".png";
	}

	function getLootLayers()
	{
		local L = [
			this.new("scripts/items/legend_helmets/hood/legend_helmet_cloth_cap")
		];

		if (this.Math.rand(0, 1) == 0)
		{
			L.push(this.new("scripts/items/legend_helmets/top/legend_helmet_goblin_leather_mask"));
		}
		else
		{
			L.push(this.new("scripts/items/legend_helmets/top/legend_helmet_goblin_leather_helm"));
		}

		if (this.Math.rand(0, 1) == 0)
		{
		}
		else
		{
			L.push(this.new("scripts/items/legend_helmets/vanity_lower/legend_helmet_goblin_tail"));
		}

		return L;
	}

});

