this.nggh_mod_goblin_shaman_armor <- ::inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.body.goblin_shaman_armor";
		this.m.Name = "Ritual Armor";
		this.m.Description = "A ceremonial piece for shaman";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.SlotType = ::Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = ::Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 75;
		this.m.ConditionMax = 75;
		this.m.StaminaModifier = -1;
		this.m.Value = 40;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Chain] = true;
		this.m.Blocked[::Const.Items.ArmorUpgrades.Plate] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_02_armor_01";
		this.m.SpriteDamaged = "bust_goblin_02_armor_01_damaged";
		this.m.SpriteCorpse = "bust_goblin_02_armor_01_dead";
		this.m.Icon = "armor/icon_goblin_02_armor_01.png";
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

		c.getActor().getFlags().add("shaman_armor");
		
		if (!c.getActor().getFlags().has("shaman_helmet"))
		{
			return;
		}

		local perk = ::new("scripts/skills/perks/perk_legend_mind_over_body");
		perk.m.IsSerialized = false;
		this.addSkill(perk);
	}

	function onUnequip()
	{
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		c.getActor().getFlags().remove("shaman_armor");

		local perk = c.getActor().getSkills().getSkillByID("perk.legend_mind_over_body");

		if (perk != null && !perk.isSerialized())
		{
			c.getActor().getSkills().remove(perk);
		}

		this.legend_armor.onUnequip();
	}

	function getTooltip()
	{
		local result = this.legend_armor.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+25[/color] Resolve at morale checks against fear, panic or mind control effects."
		});
		
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return result;
		}

		if (c.getActor().getFlags().has("shaman_helmet"))
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
					text = "Grants [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Const.Strings.PerkName.LegendMindOverBody + "[/color] perk"
				}
			]);
		}

		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.legend_armor.onUpdateProperties(_properties);
		_properties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack] += 25;
	}

});

