this.mod_named_armor_white_wolf_pelt_upgrade <- this.inherit("scripts/items/legend_armor/legend_named_armor_upgrade", {
	m = {
		DefaultName = "Pelt Mantle",
		SpecialValue = 10
	},
	function create()
	{
		this.legend_named_armor_upgrade.create();
		this.m.ID = "legend_named_armor_upgrade.legend_white_wolf_pelt";
		this.m.Type = this.Const.Items.ArmorUpgrades.Attachment;
		this.m.Name = "White Wolf Pelt Mantle";
		this.m.Description = "A pelt taken from a white wolf, cured and sewn together to be worn as a beast hunter\'s trophy around the neck. Donning the skin of a beast like this can turn one into an imposing figure.";
		this.m.ArmorDescription = "A mantle of the white wolf has been attached to this armor, which transforms the wearer into an imposing figure.";
		this.m.Icon = "armor_upgrades/named_upgrade_white_wolf.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_white_wolf.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_white_wolf.png";
		this.m.SpriteFront = "upgrade_white_wolf_front";
		this.m.SpriteBack = "upgrade_white_wolf_back";
		this.m.SpriteDamagedFront = "upgrade_white_wolf_front_damaged";
		this.m.SpriteDamagedBack = "upgrade_white_wolf_back";
		this.m.SpriteCorpseFront = "upgrade_white_wolf_front_dead";
		this.m.SpriteCorpseBack = "upgrade_white_wolf_back_dead";
		this.m.Value = 6000;
		this.m.Condition = 25;
		this.m.ConditionMax = 25;
		this.m.ConditionModifier = 25;
		this.m.StaminaModifier = -1;
		this.randomizeValues();
	}

	function randomizeValues()
	{
		this.legend_named_armor_upgrade.randomizeValues();
		this.m.SpecialValue = this.Math.min(30, this.Math.ceil(this.m.SpecialValue * this.Math.rand(120, 150) * 0.01));
	}

	function setName( _prefix = "" )
	{
		this.m.Name = _prefix + "\'s " + this.m.DefaultName;
	}

	function getTooltip()
	{
		local result = this.legend_named_armor_upgrade.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Reduces the Resolve of any opponent engaged in melee by [color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Reduces the Resolve of any opponent engaged in melee by [color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "[/color]"
		});
	}

	function onUpdateProperties( _properties )
	{
		this.legend_named_armor_upgrade.onUpdateProperties(_properties);
		_properties.Threat += this.m.SpecialValue;
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

