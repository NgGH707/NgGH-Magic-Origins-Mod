this.nggh_mod_unhold_helmet_light <- ::inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [2];
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ID = "armor.head.unhold_helmet_light";
		this.m.Name = "Unhold Restrainting Headgear";
		this.m.Description = "Barbarians of the north often use this to restraint captured unhold.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.HideCharacterHead = false;
		this.m.HideHelmetIfDestroyed = false;
		this.m.ImpactSound = ::Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Value = 0;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = 0;
		this.m.Vision = 0;
		this.m.Blocked[::Const.Items.HelmetUpgrades.Helm] = true;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_armored_unhold_head_" + variant;
		this.m.SpriteDamaged = "bust_armored_unhold_head_" + variant;
		this.m.SpriteCorpse = "bust_armored_unhold_head_" + variant + "_dead";
		this.m.Icon = "helmets/inventory_armored_unhold_head_02.png";
	}

	function getLootLayers()
	{
		if (::Nggh_MagicConcept.isHexeOrigin() && ::Math.rand(1, 100) <= 50)
		{
			return [this];
		}
		
		return [::new("scripts/items/legend_helmets/top/legend_helmet_unhold_head_chain")];
	}

});

