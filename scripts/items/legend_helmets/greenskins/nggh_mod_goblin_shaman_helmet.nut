this.nggh_mod_goblin_shaman_helmet <- ::inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.head.goblin_shaman_helmet";
		this.m.Name = "Ritual Headpiece";
		this.m.Description = "A ceremonial piece for the shaman";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ImpactSound = ::Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 75;
		this.m.ConditionMax = 75;
		this.m.StaminaModifier = -1;
		this.m.Value = 40;

		this.m.Blocked[::Const.Items.HelmetUpgrades.Helm] = true;
		this.m.Blocked[::Const.Items.HelmetUpgrades.Top] = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_02_helmet_01";
		this.m.SpriteDamaged = "bust_goblin_02_helmet_01_damaged";
		this.m.SpriteCorpse = "bust_goblin_02_helmet_01_dead";
		this.m.Icon = "helmets/inventory_goblin_02_helmet_01.png";
	}

	function getLootLayers()
	{
		if (::Nggh_MagicConcept.isHexeOrigin() && ::Math.rand(1, 100) <= 50)
		{
			return [this];
		}

		return [::new("scripts/items/legend_helmets/vanity/legend_helmet_goblin_bones")];
	}

	function onEquip()
	{
		this.legend_helmet.onEquip();
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		c.getActor().getFlags().add("shaman_helmet");

		if (!c.getActor().getFlags().has("shaman_armor"))
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

		c.getActor().getFlags().remove("shaman_helmet");

		local perk = c.getActor().getSkills().getSkillByID("perk.legend_mind_over_body");

		if (perk != null && !perk.isSerialized())
		{
			c.getActor().getSkills().remove(perk);
		}

		this.legend_helmet.onUnequip();
	}

	function getTooltip()
	{
		local result = this.legend_helmet.getTooltip();
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

		if (c.getActor().getFlags().has("shaman_armor"))
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
		this.legend_helmet.onUpdateProperties(_properties);
		_properties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack] += 25;
	}

});

