this.legend_orc_behemoth_base_helmet <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [
			1
		];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.head.legend_orc_behemoth_helmet";
		this.m.Name = "Behemoth Helmet";
		this.m.Description = "A giant helmet make for the toughest, the most badass champion.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -18;
		this.blockUpgrades();
		this.m.Blocked[this.Const.Items.HelmetUpgrades.Rune] = false;
	}

	function updateVariant()
	{
		this.m.Sprite = "legend_orc_behemoth_helmet_01";
		this.m.SpriteDamaged = "legend_orc_behemoth_helmet_01_damaged";
		this.m.SpriteCorpse = "legend_orc_behemoth_helmet_01_dead";
		this.m.Icon = "helmets/inventory_legend_orc_behemoth_helmet_01.png";
	}

	function onEquip()
	{
		this.legend_helmet.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

