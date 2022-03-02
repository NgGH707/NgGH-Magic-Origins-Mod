this.named_light_padding_replacement_upgrade <- this.inherit("scripts/items/armor_upgrades/named/named_armor_upgrade", {
	m = {
		PreviousValue = 0
	},
	function create()
	{
		this.named_armor_upgrade.create();
		this.m.ID = "named_armor_upgrade.light_padding_replacement";
		this.m.DefaultName = "Silk Padding";
		this.m.Description = "Crafted from exotic materials, this replacement padding can provide the same amount of protection as regular padding at less weight.";
		this.m.ArmorDescription = "This armor has its padding replaced by a lighter but no less durable one.";
		this.m.Icon = "armor_upgrades/named_upgrade_05.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_05.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_05.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_05_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_05_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_05_back_dead";
		this.m.Value = 650;
		this.m.ConditionModifier = 5;
		this.m.StaminaModifier = 0;
		this.m.SpecialValue = 20;
		this.randomizeValues();
	}

	function randomizeValues()
	{
		this.named_armor_upgrade.randomizeValues();
		this.m.SpecialValue = this.Math.min(30, this.Math.ceil(this.m.SpecialValue * this.Math.rand(110, 130) * 0.01));
	}

	function getTooltip()
	{
		local result = this.named_armor_upgrade.getTooltip();
		result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(this.m.ConditionModifier) + "[/color] Durability"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "Reduces an armor\'s penalty to Maximum Fatigue by [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.SpecialValue + "%[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "Reduces an armor\'s penalty to Maximum Fatigue by [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.SpecialValue + "%[/color]"
		});
	}

	function onAdded()
	{
		this.m.StaminaModifier = -1 * this.Math.floor(this.m.Armor.m.StaminaModifier * this.m.SpecialValue * 0.01);
		this.named_armor_upgrade.onAdded();
	}

	function onRemoved()
	{
		this.m.StaminaModifier = 0;
		this.named_armor_upgrade.onRemoved();
	}

});

