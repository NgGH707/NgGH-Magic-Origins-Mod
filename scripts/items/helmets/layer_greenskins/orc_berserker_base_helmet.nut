this.orc_berserker_base_helmet <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [
			1
		];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.head.orc_berserker_helmet";
		this.m.Name = "Bone Head Gear";
		this.m.Description = "A helmet made out of bones. A precious trophy of a brave warrior.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ImpactSound = [
			"sounds/enemies/skeleton_hurt_03.wav"
		];
		this.m.InventorySound = [
			"sounds/enemies/skeleton_hurt_03.wav"
		];
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -10;
		this.blockUpgrades();
		this.m.Blocked[this.Const.Items.HelmetUpgrades.Rune] = false;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_02_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_orc_02_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_orc_02_helmet_0" + this.m.Variant + "_dead";
		this.m.Icon = "helmets/inventory_orc_02_helmet_01.png";
	}

	function getLootLayers()
	{
		if (this.Math.rand(1, 10) <= 5 && ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen")
		{
			return [
				this
			];
		}

		return [
			this.new("scripts/items/legend_helmets/vanity/legend_helmet_orc_bones")
		];
	}

});

