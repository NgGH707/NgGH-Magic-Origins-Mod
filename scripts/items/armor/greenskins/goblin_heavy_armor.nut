this.goblin_heavy_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		local variants = [
			2,
			4
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.body.goblin_heavy_armor";
		this.m.Name = "Goblin Reinforced Leather Armor";
		this.m.Description = "An armor made for the elite troops";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Condition = 95;
		this.m.ConditionMax = 95;
		this.m.StaminaModifier = -5;
		this.m.Value = 40;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_01_armor_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_goblin_01_armor_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_goblin_01_armor_0" + this.m.Variant + "_dead";
		this.m.Icon = "armor/icon_goblin_01_armor_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

