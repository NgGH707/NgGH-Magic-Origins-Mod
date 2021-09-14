this.goblin_shaman_base_helmet <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [
			1
		];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.IsDroppedAsLoot = true;
		this.m.ID = "armor.head.goblin_shaman_helmet";
		this.m.Name = "Ritual Headpiece";
		this.m.Description = "A ceremonial piece for shaman";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Condition = 45;
		this.m.ConditionMax = 45;
		this.m.StaminaModifier = 0;
		this.m.Value = 40;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_02_helmet_01";
		this.m.SpriteDamaged = "bust_goblin_02_helmet_01_damaged";
		this.m.SpriteCorpse = "bust_goblin_02_helmet_01_dead";
		this.m.Icon = "helmets/inventory_goblin_02_helmet_01.png";
	}

	function getLootLayers()
	{
		if (this.Math.rand(1, 10) <= 3 && ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen")
		{
			return [
				this
			];
		}
		
		return [
			this.new("scripts/items/legend_helmets/vanity/legend_helmet_goblin_bones")
		];
	}

});

