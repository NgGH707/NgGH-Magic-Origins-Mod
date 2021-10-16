this.legend_greenwood_schrat_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.legend_greenwood_schrat";
		this.m.Name = "Greenwood Schrat\'s Shield";
		this.m.Description = "A green living shield make out of living greenwood";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		//this.m.IsAllowedInBag = false;
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.Value = 0;
		this.m.MeleeDefense = 40;
		this.m.RangedDefense = 40;
		this.m.StaminaModifier = 0;
		this.m.Condition = 64;
		this.m.ConditionMax = 64;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_schrat_green_shield_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_schrat_green_shield_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "bust_schrat_shield_0" + this.m.Variant + "_dead";
		this.m.IconLarge = "shields/inventory_schrat_shield_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_schrat_shield_0" + this.m.Variant + ".png";
	}
	
	function getTooltip()
	{
		local result = this.shield.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Regenerates itself by [color=" + this.Const.UI.Color.PositiveValue + "]4[/color] points of durability each turn."
		});
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/warning.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]Will be removed after battle[/color]"
		});
		return result;
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

	function onTurnStart()
	{
		this.m.Condition = this.Math.min(this.m.ConditionMax, this.m.Condition + 4);
		this.updateAppearance();
	}

	function onCombatFinished()
	{
		if (this.isInBag())
		{
			this.getContainer().removeFromBag(this);
		}
		else 
		{
		    this.getContainer().unequip(this);
		}
	}

});

