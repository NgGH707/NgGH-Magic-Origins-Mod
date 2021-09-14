this.orc_berserker_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		local variants = [
			1
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.head.orc_berserker_helmet";
		this.m.Name = "Bone Head Gear";
		this.m.Description = "A helmet made out of bones. A precious trophy of a brave warrior.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = [
			"sounds/enemies/skeleton_hurt_03.wav"
		];
		this.m.InventorySound = [
			"sounds/enemies/skeleton_hurt_03.wav"
		];
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -10;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_02_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_orc_02_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_orc_02_helmet_0" + this.m.Variant + "_dead";
		this.m.Icon = "helmets/inventory_orc_02_helmet_01.png";
	}

	function onEquip()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

