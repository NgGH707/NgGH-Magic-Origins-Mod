this.goblin_skirmisher_base_helmet <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [
			1,
			2,
			3
		];
		this.m.Variant = this.m.Variants[this.Math.rand(0, this.m.Variants.len() - 1)];
		this.updateVariant();
		this.m.IsDroppedAsLoot = true;
		this.m.ID = "armor.head.goblin_skirmisher_helmet";
		this.m.Name = "Camouflage Hood";
		this.m.Description = "A hood that has been made to help the wear disguise as a bush";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Condition = 35;
		this.m.ConditionMax = 35;
		this.m.StaminaModifier = 0;
		this.m.Value = 40;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_04_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_goblin_04_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_goblin_04_helmet_0" + this.m.Variant + "_dead";
		this.m.Icon = "helmets/inventory_goblin_04_helmet_0" + this.m.Variant + ".png";
	}

	function getLootLayers()
	{
		return [
			this.Const.World.Common.pickHelmet([
				[
					1,
					"legend_goblin_skirmisher_helmet"
				]
			])
		];
	}

});

