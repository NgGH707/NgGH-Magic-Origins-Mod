this.nggh_mod_named_hyena_fur_legend_upgrade <- ::inherit("scripts/items/legend_armor/legend_named_armor_upgrade", {
	m = {
		DefaultName = "Fur Mantle"
		SpecialValue = 15
	},
	function create()
	{
		this.legend_named_armor_upgrade.create();
		this.m.ID = "legend_named_armor_upgrade.hyena_fur";
		this.m.Type = ::Const.Items.ArmorUpgrades.Attachment;
		this.m.Name = "Hyena Fur Mantle";
		this.m.Description = "Furs taken from ferocious hyenas, cured and sewn together to be worn as a beast hunter\'s trophy around the neck. Donning the skin of a beast like this bolsters one\'s drive to action.";
		this.m.ArmorDescription = "A mantle of hyena furs has been attached to this armor, which bolsters the wearer\'s drive to action.";
		this.m.Icon = "armor_upgrades/named_upgrade_26.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_26.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_26.png";
		this.m.SpriteFront = "upgrade_26_front";
		this.m.SpriteBack = "upgrade_26_back";
		this.m.SpriteDamagedFront = "upgrade_26_front_damaged";
		this.m.SpriteDamagedBack = "upgrade_26_back";
		this.m.SpriteCorpseFront = "upgrade_26_front_dead";
		this.m.SpriteCorpseBack = "upgrade_26_back_dead";
		this.m.Value = 600;
		this.m.Condition = 15;
		this.m.ConditionMax = 15;
		this.m.ConditionModifier = 15;
		this.m.StaminaModifier = 0;
		this.randomizeValues();
	}

	function randomizeValues()
	{
		this.m.SpecialValue = ::Math.min(30, ::Math.floor(this.m.SpecialValue * ::Math.rand(115, 140) * 0.01));
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
			icon = "ui/icons/initiative.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + this.m.SpecialValue + "[/color] Initiative"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + this.m.SpecialValue + "[/color] Initiative"
		});
	}

	function onUpdateProperties( _properties )
	{
		this.legend_named_armor_upgrade.onUpdateProperties(_properties);
		_properties.Initiative += this.m.SpecialValue;
	}

	function onSerialize( _out )
	{
		_out.writeI16(this.m.SpecialValue);
		this.legend_named_armor_upgrade.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.SpecialValue = _in.readI16();
		this.legend_named_armor_upgrade.onDeserialize(_in);
	}

});

