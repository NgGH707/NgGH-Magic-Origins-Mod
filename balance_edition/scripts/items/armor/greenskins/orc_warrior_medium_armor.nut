this.orc_warrior_medium_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.orc_warrior_medium_armor";
		this.m.Name = "Looted Reinforced Mail";
		this.m.Description = "A makeshift armor made from various remains of looted armor from many of his battles. It is not very heavy.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 350;
		this.m.ConditionMax = 350;
		this.m.StaminaModifier = -31;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_03_armor_02";
		this.m.SpriteDamaged = "bust_orc_03_armor_02_damaged";
		this.m.SpriteCorpse = "bust_orc_03_armor_02_dead";
		this.m.Icon = "armor/icon_orc_03_armor_02.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

