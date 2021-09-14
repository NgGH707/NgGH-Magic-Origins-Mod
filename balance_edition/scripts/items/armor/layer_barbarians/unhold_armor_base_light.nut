this.unhold_armor_base_light <- this.inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.ID = "armor.body.unhold_armor_light";
		this.m.Name = "Unhold Restrainting Chain";
		this.m.Description = "Barbarians of the north often use this to restraint their unholds like hound.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.Variants = [2];
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 0;
		this.m.Condition = 55;
		this.m.ConditionMax = 55;
		this.m.StaminaModifier = 0;
		this.blockUpgrades();
		this.m.Blocked[this.Const.Items.ArmorUpgrades.Rune] = false;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_armored_unhold_body_02";
		this.m.SpriteDamaged = "bust_armored_unhold_body_02";
		this.m.SpriteCorpse = "bust_armored_unhold_body_02_dead";
		this.m.Icon = "armor/icon_armored_unhold_body_02.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

