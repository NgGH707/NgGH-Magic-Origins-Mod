this.nggh_mod_unhold_armor_light <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.ID = "armor.body.unhold_armor_light";
		this.m.Name = "Unhold Restrainting Chain";
		this.m.Description = "Barbarians of the north often use this to restraint their unholds like hounds.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.Variants = [2];
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ImpactSound = ::Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Value = 0;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = 0;
		this.blockUpgrades();
		this.m.Blocked[::Const.Items.ArmorUpgrades.Rune] = false;
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
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

});

