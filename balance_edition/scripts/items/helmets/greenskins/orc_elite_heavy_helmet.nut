this.orc_elite_heavy_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.updateVariant();
		this.m.ID = "armor.head.orc_elite_heavy_helmet";
		this.m.Name = "Bloody Metal Plate Helmet";
		this.m.Description = "A makeshift helmet which is dyed in blood. It is stink but has exceptional durability.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 440;
		this.m.ConditionMax = 440;
		this.m.StaminaModifier = -35;
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
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

