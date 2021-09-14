this.orc_warrior_light_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		local variants = [
			1,
			1,
			4,
			4
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.head.orc_warrior_light_helmet";
		this.m.Name = "Looted Nasal Helmet";
		this.m.Description = "A makeshift helmet crafted from looted nasal helmet of his opponents. Quite light.";
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 250;
		this.m.ConditionMax = 250;
		this.m.StaminaModifier = -18;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_03_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_orc_03_helmet_0" + this.m.Variant + "_damaged";

		if (this.m.Variant != 1)
		{
			this.m.SpriteCorpse = "bust_orc_03_helmet_0" + this.m.Variant + "_dead";
		}
		else
		{
			this.m.SpriteCorpse = "";
		}
		
		this.m.Icon = "helmets/inventory_orc_03_helmet_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

