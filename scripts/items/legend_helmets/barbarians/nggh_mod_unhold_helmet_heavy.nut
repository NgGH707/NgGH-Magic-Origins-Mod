this.nggh_mod_unhold_helmet_heavy <- ::inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.head.unhold_helmet_heavy";
		this.m.Name = "Unhold Metal Helmet";
		this.m.Description = "Heavy metal helmet for a giant, offers great protection.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.HideCharacterHead = false;
		this.m.HideHelmetIfDestroyed = false;
		this.m.ImpactSound = ::Const.Sound.ArmorUnholdImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Value = 0;
		this.m.Condition = 400;
		this.m.ConditionMax = 400;
		this.m.StaminaModifier = -35;
		this.m.Vision = -2;
		this.blockUpgrades();
		this.m.Blocked[::Const.Items.HelmetUpgrades.Rune] = false;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_armored_unhold_head_" + variant;
		this.m.SpriteDamaged = "bust_armored_unhold_head_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_armored_unhold_head_" + variant + "_dead";
		this.m.Icon = "helmets/inventory_armored_unhold_head_01.png";
	}

	function getLootLayers()
	{
		if (::Nggh_MagicConcept.isHexeOrigin() && ::Math.rand(1, 100) <= 50)
		{
			return [this];
		}

		return [::new("scripts/items/legend_helmets/top/legend_helmet_unhold_head_spike")];
	}

});

