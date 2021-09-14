this.unhold_armor_light <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.unhold_armor_light";
		this.m.Name = "Unhold Restrainting Chain";
		this.m.Description = "Barbarians of the north often use this to restraint their unholds like hound.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 0;
		this.m.Condition = 35;
		this.m.ConditionMax = 35;
		this.m.StaminaModifier = 0;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_armored_unhold_body_" + variant;
		this.m.SpriteDamaged = "bust_armored_unhold_body_" + variant;
		this.m.SpriteCorpse = "bust_armored_unhold_body_" + variant + "_dead";
		this.m.Icon = "armor/icon_armored_unhold_body_02.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

