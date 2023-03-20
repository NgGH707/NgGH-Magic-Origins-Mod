this.nggh_mod_goblin_skirmisher_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [1, 2, 3];
		this.m.Variant = ::MSU.Array.rand(this.m.Variants);
		this.updateVariant();
		this.m.ID = "armor.body.goblin_skirmisher_armor";
		this.m.Name = "Goblin Camouflage Outfit";
		this.m.Description = "A simple leather cloth that was fashioned to look like bushes.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorLeatherImpact;
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
		this.m.Sprite = "bust_goblin_04_armor_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_goblin_04_armor_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_goblin_04_armor_0" + this.m.Variant + "_dead";
		this.m.Icon = "armor/icon_goblin_04_armor_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		c.getActor().getFlags().add("skirmisher_armor");
	}

	function onUnequip()
	{
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		c.getActor().getFlags().remove("skirmisher_armor");
		this.legend_armor.onUnequip();
	}

	function getTooltip()
	{
		local result = this.legend_armor.getTooltip();
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

		if (c.getActor().getFlags().has("skirmisher_helmet"))
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
		this.legend_armor.onUpdateProperties(_properties);
		_properties.RangedDefense += 5;
		_properties.TargetAttractionMult *= 0.9;

		local actor = this.getContainer().getActor();

		if (!actor.getFlags().has("skirmisher_helmet"))
		{
			return;
		}

		_properties.RangedSkill += 5;
		_properties.RangedDefense += 5;
		_properties.IsStealthy = true;
	}

	function onTurnEnd()
	{
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		if (!c.getActor().getFlags().has("skirmisher_armor") || !c.getActor().getFlags().has("skirmisher_helmet"))
		{
			return;
		}

		c.getActor().updateVisibility(c.getActor().getTile(), c.getActor().getCurrentProperties().getVision(), c.getActor().getFaction());
	}

	function onCombatStarted()
	{
		this.legend_armor.onCombatStarted();
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		if (!c.getActor().getFlags().has("skirmisher_armor") || !c.getActor().getFlags().has("skirmisher_helmet"))
		{
			return;
		}

		local actor = c.getActor();
		local myTile = c.getActor().getTile();

		if (!::Const.Goblin.SkirmisherArmorSpawnHiding(myTile))
		{
			return;
		}

		actor.updateVisibility(myTile, actor.getCurrentProperties().getVision(), actor.getFaction());
		actor.getSkills().add(::new(::Const.Movement.HiddenStatusEffect));
	}

});

