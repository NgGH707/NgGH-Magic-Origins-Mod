this.orc_berserker_medium_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.orc_berserker_medium_armor";
		this.m.Name = "Bone Armor";
		this.m.Description = "An armor made out of the bone of whatever thing it is. A valuable item to show its wear staning in the horde.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = [
			"sounds/enemies/skeleton_hurt_03.wav"
		];
		this.m.InventorySound = [
			"sounds/enemies/skeleton_hurt_03.wav"
		];
		this.m.Condition = 110;
		this.m.ConditionMax = 110;
		this.m.StaminaModifier = -10;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_02_armor_02";
		this.m.SpriteDamaged = "bust_orc_02_armor_02_damaged";
		this.m.SpriteCorpse = "bust_orc_02_armor_02_dead";
		this.m.Icon = "armor/icon_orc_02_armor_02.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

