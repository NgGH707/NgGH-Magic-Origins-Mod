this.nggh_mod_orc_berserker_helmet <- ::inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.head.orc_berserker_helmet";
		this.m.Name = "Bone Head Gear";
		this.m.Description = "A helmet made out of bones. A precious trophy of a brave warrior.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ImpactSound = ["sounds/enemies/skeleton_hurt_03.wav"];
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -10;

		this.m.Blocked[::Const.Items.HelmetUpgrades.Helm] = true;
		this.m.Blocked[::Const.Items.HelmetUpgrades.Top] = true;
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
		if (::Nggh_MagicConcept.isHexeOrigin() && ::Math.rand(1, 100) <= 50)
		{
			return [this];
		}

		return [::new("scripts/items/legend_helmets/vanity/legend_helmet_orc_bones")];
	}

	function onEquip()
	{
		this.legend_helmet.onEquip();
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().add("berserker_helmet");
		}
	}

	function onUnequip()
	{
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().remove("berserker_helmet");
		}

		this.legend_helmet.onUnequip();
	}

	function getTooltip()
	{
		local result = this.legend_helmet.getTooltip();
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/morale.png",
			text = "Will always start combat at confident morale"
		});

		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return result;
		}

		if (c.getActor().getFlags().has("berserker_armor"))
		{
			result.extend([
				{
					id = 11,
					type = "text",
					text = "[u][size=14]Set effect[/size][/u]"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Cannot be reduced to [color=" + ::Const.UI.Color.NegativeValue + "]" + ::Const.MoraleStateName[::Const.Orc.BerserkerArmorMoraleThreshold - 1] + "[/color] morale, only [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Const.MoraleStateName[::Const.Orc.BerserkerArmorMoraleThreshold] + "[/color]"
				}
			]);
		}

		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.legend_helmet.onUpdateProperties(_properties);
		local actor = this.getContainer().getActor();

		if (!actor.getFlags().has("berserker_armor"))
		{
			return;
		}

		if (actor.getMoraleState() >= ::Const.Orc.BerserkerArmorMoraleThreshold)
		{
			return;
		}

		actor.setMoraleState(::Const.Orc.BerserkerArmorMoraleThreshold);
		actor.setDirty(true);
	}

	function onCombatStarted()
	{
		this.legend_helmet.onCombatStarted();
		local actor = this.getContainer().getActor();

		if (actor.getMoraleState() == ::Const.MoraleState.Ignore)
		{
			return;
		}

		actor.setMoraleState(::Const.MoraleState.Confident);
	}

});

