this.goblin_leader_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.updateVariant();
		this.m.ID = "armor.head.goblin_leader_helmet";
		this.m.Name = "Overseer Helmet";
		this.m.Description = "A helmet befits for an overseer";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -6;
		this.m.Value = 40;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_03_helmet_01";
		this.m.SpriteDamaged = "bust_goblin_03_helmet_01_damaged";
		this.m.SpriteCorpse = "bust_goblin_03_helmet_01_dead";
		this.m.Icon = "helmets/inventory_goblin_03_helmet_01.png";
	}

	function onEquip()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

