this.nggh_mod_named_lindwurm_scales_legend_upgrade <- ::inherit("scripts/items/legend_armor/legend_named_armor_upgrade", {
	m = {
		DefaultName = "Scale Cloak"
	},
	function create()
	{
		this.legend_named_armor_upgrade.create();
		this.m.ID = "legend_named_armor_upgrade.lindwurm_scales";
		this.m.Type = ::Const.Items.ArmorUpgrades.Attachment;
		this.m.Name = "Lindwurm Scale Cloak";
		this.m.Description = "A cloak made out of the scales of a Lindwurm. Not only is it a rare and impressive trophy, it also offers additional protection and is untouchable by corroding Lindwurm blood.";
		this.m.ArmorDescription = "A cloak made out of Lindwurm scales is worn over this armor for additional protection, including from the corrosive effects of Lindwurm blood.";
		this.m.Icon = "armor_upgrades/named_upgrade_04.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_04.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_04.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_04_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_04_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_04_back_dead";
		this.m.Value = 1800;
		this.m.Condition = 25;
		this.m.ConditionMax = 25;
		this.m.ConditionModifier = 25;
		this.m.StaminaModifier = -2;
		this.randomizeValues();
	}

	function randomizeValues()
	{
		this.m.StaminaModifier = ::Math.min(0, this.m.StaminaModifier + ::Math.rand(0, 2));
		this.m.Condition = ::Math.floor(this.m.Condition * ::Math.rand(115, 133) * 0.01) * 1.0;
		this.m.ConditionMax = this.m.Condition;
	}

	function setName( _prefix = "" )
	{
		if (this.m.DefaultName.len() == 0)
		{
			this.m.Name = _prefix;
			return;
		}

		if (_prefix.len() == 0)
		{
			this.m.Name = this.m.DefaultName;
			return;
		}

		this.m.Name = _prefix + "\'s " + this.m.DefaultName;
	}

	function getTooltip()
	{
		local result = this.legend_named_armor_upgrade.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Unaffected by acidic Lindwurm blood"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Unaffected by acidic Lindwurm blood"
		});
	}

	function onEquip()
	{
		this.legend_named_armor_upgrade.onEquip();
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().add("body_immune_to_acid");
		}
	}

	function onUnequip()
	{
		local c = this.m.Armor.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().remove("body_immune_to_acid");
		}
		this.legend_named_armor_upgrade.onUnequip();
	}
});
