this.nggh_mod_named_white_wolf_pelt_upgrade <- ::inherit("scripts/items/armor_upgrades/named/nggh_mod_named_armor_upgrade", {
	m = {},
	function create()
	{
		this.nggh_mod_named_armor_upgrade.create();
		this.m.ID = "named_armor_upgrade.legend_white_wolf_pelt";
		this.m.DefaultName = "Pelt Mantle";
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
		this.m.SpecialValue = 15;
		this.m.ConditionModifier = 30;
		this.m.StaminaModifier = 0;
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
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Reduces the Resolve of any opponent engaged in melee by [color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Reduces the Resolve of any opponent engaged in melee by [color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "[/color]"
		});
	}

	function onUpdateProperties( _properties )
	{
		this.nggh_mod_named_armor_upgrade.onUpdateProperties(_properties);
		_properties.Threat += this.m.SpecialValue;
	}

});

