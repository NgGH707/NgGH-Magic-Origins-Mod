this.nggh_mod_named_hyena_fur_upgrade <- ::inherit("scripts/items/armor_upgrades/named/nggh_mod_named_armor_upgrade", {
	m = {},
	function create()
	{
		this.nggh_mod_named_armor_upgrade.create();
		this.m.ID = "named_armor_upgrade.hyena_fur";
		this.m.DefaultName = "Fur Mantle";
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
		this.m.Value = 1000;
		this.m.ConditionModifier = 15;
		this.m.StaminaModifier = 0;
		this.m.SpecialValue = 15;
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
		_properties.Initiative += this.m.SpecialValue();
	}

});

