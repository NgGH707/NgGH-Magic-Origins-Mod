this.nggh_mod_goblin_light_helmet <- ::inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [1, 3];
		this.m.Variant = ::MSU.Array.rand(this.m.Variants);
		this.updateVariant();
		this.m.ID = "armor.head.goblin_light_helmet";
		this.m.Name = "Goblin Leather Cap";
		this.m.Description = "A sturdy leather cap that is only fitted for a child.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ImpactSound = ::Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = ::Const.Sound.ClothEquip;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
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
		if (::Nggh_MagicConcept.isHexeOrigin() && ::Math.rand(1, 100) <= 50)
		{
			return [this];
		}

		return [::Const.World.Common.pickHelmet([[1, "legend_goblin_light_helmet"]])]
	}

});

