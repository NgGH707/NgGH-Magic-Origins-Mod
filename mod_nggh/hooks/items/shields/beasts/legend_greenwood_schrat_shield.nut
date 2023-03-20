::mods_hookExactClass("items/shields/beasts/legend_greenwood_schrat_shield", function(obj) 
{
    local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Variants = [1];
		this.m.Description = "A wooden shield made out of living wood.";
	}

	local ws_updateVariant = obj.updateVariant;
	obj.updateVariant = function()
	{
		ws_updateVariant();
		this.m.ShieldDecal = "bust_schrat_shield_0" + this.m.Variant + "_dead";
		this.m.IconLarge = "shields/inventory_schrat_shield_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_schrat_shield_0" + this.m.Variant + ".png";
	}

	obj.getTooltip <- function()
	{
		local result = this.shield.getTooltip();
		result.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Regenerates itself by [color=" + ::Const.UI.Color.PositiveValue + "]4[/color] points of durability each turn."
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Automatically removed after battle[/color]"
			}
		]);
		return result;
	}

	obj.onEquip <- function()
	{
		this.shield.onEquip();
		this.addSkill(::new("scripts/skills/actives/shieldwall"));
		this.addSkill(::new("scripts/skills/actives/knock_back"));
	}

	obj.onTurnStart <- function()
	{
		this.m.Condition = ::Math.min(this.m.ConditionMax, this.m.Condition + 4);
		this.updateAppearance();
	}

	obj.onCombatFinished <- function()
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