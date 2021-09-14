this.goblin_heavy_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.updateVariant();
		this.m.ID = "armor.head.goblin_heavy_helmet";
		this.m.Name = "Goblin Helmet";
		this.m.Description = "A helmet made for the elite troops";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Condition = 90;
		this.m.ConditionMax = 90;
		this.m.StaminaModifier = -4;
		this.m.Value = 40;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_01_helmet_02";
		this.m.SpriteDamaged = "bust_goblin_01_helmet_02_damaged";
		this.m.SpriteCorpse = "bust_goblin_01_helmet_02_dead";
		this.m.Icon = "helmets/inventory_goblin_01_helmet_02.png";
	}

	function onEquip()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

