this.goblin_leader_base_helmet <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [
			1
		];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.IsDroppedAsLoot = true;
		this.m.ID = "armor.head.goblin_leader_helmet";
		this.m.Name = "Overseer Helmet";
		this.m.Description = "A helmet befits for an overseer";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Condition = 100;
		this.m.ConditionMax = 100;
		this.m.StaminaModifier = -5;
		this.m.Value = 40;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_03_helmet_01";
		this.m.SpriteDamaged = "bust_goblin_03_helmet_01_damaged";
		this.m.SpriteCorpse = "bust_goblin_03_helmet_01_dead";
		this.m.Icon = "helmets/inventory_goblin_03_helmet_01.png";
	}

	function getLootLayers()
	{
		if (this.Math.rand(1, 10) <= 3 && ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen")
		{
			return [
				this
			];
		}

		return [
			this.new("scripts/items/legend_helmets/top/legend_helmet_goblin_spiked_helm")
		];
	}

});

