this.nggh_mod_named_horn_plate_upgrade <- ::inherit("scripts/items/armor_upgrades/named/nggh_mod_named_armor_upgrade", {
	m = {},
	function create()
	{
		this.nggh_mod_named_armor_upgrade.create();
		this.m.ID = "named_armor_upgrade.horn_plate";
		this.m.DefaultName = "Horn Plate";
		this.m.Description = "These segments of horn plate are made from one of the hardest yet flexible materials nature has to offer. Worn over common armor, they can help to deflect incoming blows.";
		this.m.ArmorDescription = "Segments of horn plate provide additional protection.";
		this.m.Icon = "armor_upgrades/named_upgrade_22.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_22.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_22.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_22_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_22_back";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_22_back_dead";
		this.m.Value = 5000;
		this.m.ConditionModifier = 30;
		this.m.SpecialValue = 10;
		this.randomizeValues();
	}

	function randomizeValues()
	{
		this.nggh_mod_named_armor_upgrade.randomizeValues();
		this.m.SpecialValue = ::Math.min(25, ::Math.ceil(this.m.SpecialValue * ::Math.rand(115, 140) * 0.01));
	}

	function getTooltip()
	{
		local result = this.nggh_mod_named_armor_upgrade.getTooltip();
		result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(this.m.ConditionModifier) + "[/color] Durability"
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Reduces any melee damage to the body by [color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "%[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Reduces any melee damage to the body by [color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "%[/color]"
		});
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.BodyPart != ::Const.BodyPart.Body)
		{
			return;
		}

		_properties.DamageReceivedMeleeMult *= 1.0 - this.m.SpecialValue * 0.01;
	}

});

