this.named_bone_platings_upgrade <- this.inherit("scripts/items/armor_upgrades/named/named_armor_upgrade", {
	m = {},
	function create()
	{
		this.named_armor_upgrade.create();
		this.m.ID = "named_armor_upgrade.bone_platings";
		this.m.DefaultName = "Bone Plating";
		this.m.Description = "Crafted from strong but surprisingly light bones, these ornate platings make for an ablative armor to be worn ontop of regular armor.";
		this.m.ArmorDescription = "A layer of ornate bone plates is attached to this armor.";
		this.m.Icon = "armor_upgrades/named_upgrade_06.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_named_upgrade_06.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_named_upgrade_06.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_06_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_06_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_06_back_dead";
		this.m.Value = 850;
		this.m.ConditionModifier = 10;
		this.m.StaminaModifier = -2;
		this.m.SpecialValue = 1;
		this.randomizeValues();
	}

	function randomizeValues()
	{
		this.m.StaminaModifier = this.Math.min(0, this.m.StaminaModifier + this.Math.rand(0, 1));
		this.m.ConditionModifier = this.Math.floor(this.m.ConditionModifier * this.Math.rand(115, 140) * 0.01) * 1.0;
		this.m.SpecialValue = this.Math.rand(1, 2);
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
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color] Maximum Fatigue"
		});
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Can Completely absorbs " + (this.m.SpecialValue == 2 ? "up to [color=" + this.Const.UI.Color.NegativeValue + "]2[/color] hits" : "[color=" + this.Const.UI.Color.NegativeValue + "]1[/color] hit") + " of every combat encounter which doesn\'t ignore armor"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Can Completely absorbs " + (this.m.SpecialValue == 2 ? "up to [color=" + this.Const.UI.Color.NegativeValue + "]2[/color] hits" : "[color=" + this.Const.UI.Color.NegativeValue + "]1[/color] hit") + " of every combat encounter which doesn\'t ignore armor"
		});
	}

	function onCombatStarted()
	{
		local bone_plating = this.new("scripts/skills/effects/mod_bone_plating_effect");
		bone_plating.setCount(this.m.SpecialValue);
		this.addSkill(bone_plating);
	}

});

