this.orc_elite_heavy_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.orc_elite_heavy_armor";
		this.m.Name = "Bloody Looted Plate Armor";
		this.m.Description = "A makeshift armor made from various remains of looted armor from many of his battles. It has been dyed red by blood.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 500;
		this.m.ConditionMax = 500;
		this.m.StaminaModifier = -45;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_elite_armor_01";
		this.m.SpriteDamaged = "bust_orc_elite_armor_01_damaged";
		this.m.SpriteCorpse = "bust_orc_elite_armor_01_dead";
		this.m.Icon = "armor/icon_orc_elite_armor_01.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

