this.nggh_mod_goblin_skirmisher_helmet <- ::inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [1, 2, 3];
		this.m.Variant = ::MSU.Array.rand(this.m.Variants);
		this.updateVariant();
		this.m.ID = "armor.head.goblin_skirmisher_helmet";
		this.m.Name = "Camouflage Hood";
		this.m.Description = "A hood that was made to help the wearer disguise as a bush.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 50;
		this.m.ConditionMax = 50;
		this.m.StaminaModifier = 0;
		this.m.Value = 40;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Chain] = true;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Plate] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_04_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_goblin_04_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_goblin_04_helmet_0" + this.m.Variant + "_dead";
		this.m.Icon = "helmets/inventory_goblin_04_helmet_0" + this.m.Variant + ".png";
	}

	function getLootLayers()
	{
		if (::Nggh_MagicConcept.isHexeOrigin() && ::Math.rand(1, 100) <= 50)
		{
			return [this];
		}
		
		return [::Const.World.Common.pickHelmet([[1, "legend_goblin_skirmisher_helmet"]])];
	}

	function onEquip()
	{
		this.legend_helmet.onEquip();
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		c.getActor().getFlags().add("skirmisher_helmet");
	}

	function onUnequip()
	{
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		c.getActor().getFlags().remove("skirmisher_helmet");
		this.legend_helmet.onUnequip();
	}

	function getTooltip()
	{
		local result = this.legend_helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+5[/color] Ranged Defense"
		});
		
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return result;
		}

		if (c.getActor().getFlags().has("skirmisher_armor"))
		{
			result.extend([
				{
					id = 11,
					type = "text",
					text = "[u][size=14]Set effect[/size][/u]"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + ::Const.UI.Color.PositiveValue + "]+5[/color] Ranged Skill"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + ::Const.UI.Color.PositiveValue + "]+5[/color] Ranged Defense"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Will always start combat inside a bush"
				}
			]);
		}

		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.legend_helmet.onUpdateProperties(_properties);
		_properties.RangedDefense += 5;
		_properties.TargetAttractionMult *= 0.9;
	}

});

