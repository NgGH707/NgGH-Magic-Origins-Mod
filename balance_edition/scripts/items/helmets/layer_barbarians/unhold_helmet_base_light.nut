this.unhold_helmet_base_light <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [
			2
		];
		this.m.ID = "armor.head.unhold_helmet_light";
		this.m.Name = "Unhold Restrainting Headgear";
		this.m.Description = "Barbarians of the north often use this to restraint captured unhold.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.HideCharacterHead = false;
		this.m.HideHelmetIfDestroyed = false;
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 0;
		this.m.Condition = 55;
		this.m.ConditionMax = 55;
		this.m.StaminaModifier = 0;
		this.m.Vision = 0;
		this.m.Blocked[this.Const.Items.HelmetUpgrades.Helm] = true;
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
		if (this.Math.rand(1, 10) <= 5 && ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen")
		{
			return [
				this
			];
		}
		
		return [
			this.new("scripts/items/legend_helmets/top/legend_helmet_unhold_head_chain")
		];
	}

});

