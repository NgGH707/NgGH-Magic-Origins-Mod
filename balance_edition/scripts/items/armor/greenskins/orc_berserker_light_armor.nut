this.orc_berserker_light_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.orc_berserker_light_armor";
		this.m.Name = "Trophy Bones";
		this.m.Description = "A harness made out of the bone of what this warrior had ever hunted. A token to honor its warrior skill.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = [
			"sounds/enemies/skeleton_hurt_03.wav"
		];
		this.m.InventorySound = [
			"sounds/enemies/skeleton_hurt_03.wav"
		];
		this.m.Condition = 50;
		this.m.ConditionMax = 50;
		this.m.StaminaModifier = -5;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_02_armor_01";
		this.m.SpriteDamaged = "bust_orc_02_armor_01_damaged";
		this.m.SpriteCorpse = "bust_orc_02_armor_01_dead";
		this.m.Icon = "armor/icon_orc_02_armor_01.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

