this.unhold_armor_base_heavy <- this.inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.ID = "armor.body.unhold_armor_heavy";
		this.m.Name = "Unhold Plated Battle Gear";
		this.m.Description = "Crude armor made from metal plate for a giant creature, very durable.";
		this.m.Variants = [1];
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorUnholdImpact;
		this.m.InventorySound = this.Const.Sound.ArmorUnholdImpact;
		this.m.Value = 0;
		this.m.Condition = 400;
		this.m.ConditionMax = 400;
		this.m.StaminaModifier = -25;
		this.blockUpgrades();
		this.m.Blocked[this.Const.Items.ArmorUpgrades.Rune] = false;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_armored_unhold_body_01";
		this.m.SpriteDamaged = "bust_armored_unhold_body_01";
		this.m.SpriteCorpse = "bust_armored_unhold_body_01_dead";
		this.m.Icon = "armor/icon_armored_unhold_body_01.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

