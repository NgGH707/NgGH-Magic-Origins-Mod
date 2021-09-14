this.goblin_leader_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.goblin_leader_armor";
		this.m.Name = "Overseer Battle Armor";
		this.m.Description = "A sturdy metal armor with added padding, decorated to show off the authority of its wearer.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Condition = 180;
		this.m.ConditionMax = 180;
		this.m.StaminaModifier = -9;
		this.m.Value = 40;
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
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

