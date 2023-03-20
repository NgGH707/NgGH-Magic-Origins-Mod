this.nggh_mod_legend_orc_behemoth_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.body.legend_orc_behemoth_armor";
		this.m.Name = "Looted Reinforced Mail";
		this.m.Description = "A huge armor made for the champion of all orcs.";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -35;
		this.blockUpgrades();
		this.m.Blocked[::Const.Items.ArmorUpgrades.Rune] = false;
	}

	function updateVariant()
	{
		this.m.Sprite = "legend_orc_behemoth_armour_01";
		this.m.SpriteDamaged = "legend_orc_behemoth_armour_01_damaged";
		this.m.SpriteCorpse = "legend_orc_behemoth_armour_01_dead";
		this.m.Icon = "armor/icon_legend_orc_behemoth_armour_01.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

});

