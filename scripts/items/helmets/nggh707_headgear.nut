this.nggh707_headgear <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.noble_headgear";
		this.m.Name = "";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.Variant = 3;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 20;
		this.m.Condition = 150;
		this.m.ConditionMax = 150;
		this.m.StaminaModifier = 0;
		this.m.Vision = 0;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_helmet_noble_" + variant;
	}

});

