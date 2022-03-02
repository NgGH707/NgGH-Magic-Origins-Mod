this.mod_named_unhold_fur_upgrade <- this.inherit("scripts/items/legend_armor/legend_named_armor_upgrade", {
	m = {
		DefaultName = "Fur Cloak",
		SpecialValue = 20
	},
	function create()
	{
		this.legend_named_armor_upgrade.create();
		this.m.ID = "legend_named_armor_upgrade.unhold_fur";
		this.m.Type = this.Const.Items.ArmorUpgrades.Attachment;
		this.m.Name = "Unhold Fur Cloak";
		this.m.Description = "A thick cloak made out of a Frost Unhold\'s majestic white fur. Can be worn atop any armor to make the wearer more resilient against ranged weapons.";
		this.m.ArmorDescription = "A cloak of thick white fur has been attached to this armor to make it more resilient against ranged weapons.";
		this.m.Icon = "armor_upgrades/named_upgrade_02.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/named_icon_upgrade_02.png";
		this.m.OverlayIconLarge = "armor_upgrades/named_inventory_upgrade_02.png";
		this.m.SpriteFront = "upgrade_02_front";
		this.m.SpriteBack = "upgrade_02_back";
		this.m.SpriteDamagedFront = "upgrade_02_front_damaged";
		this.m.SpriteDamagedBack = "upgrade_02_back";
		this.m.SpriteCorpseFront = "upgrade_02_front_dead";
		this.m.SpriteCorpseBack = "upgrade_02_back_dead";
		this.m.Value = 1000;
		this.m.Condition = 10;
		this.m.ConditionMax = 10;
		this.m.ConditionModifier = 10;
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
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Reduces any ranged damage to the body by [color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "%[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Reduces any ranged damage to the body by [color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "%[/color]"
		});
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.BodyPart == this.Const.BodyPart.Body)
		{
			_properties.DamageReceivedRangedMult *= 1.0 - this.m.SpecialValue * 0.01;
		}
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

