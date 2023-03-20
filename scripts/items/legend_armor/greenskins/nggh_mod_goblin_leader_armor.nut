this.nggh_mod_goblin_leader_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.body.goblin_leader_armor";
		this.m.Name = "Overseer Battle Armor";
		this.m.Description = "A sturdy metal armor with added padding, decorated to show off the authority of its owner.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 125;
		this.m.ConditionMax = 125;
		this.m.StaminaModifier = -9;
		this.m.Value = 40;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Plate] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_03_armor_01";
		this.m.SpriteDamaged = "bust_goblin_03_armor_01_damaged";
		this.m.SpriteCorpse = "bust_goblin_03_armor_01_dead";
		this.m.Icon = "armor/icon_goblin_03_armor_01.png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

});

