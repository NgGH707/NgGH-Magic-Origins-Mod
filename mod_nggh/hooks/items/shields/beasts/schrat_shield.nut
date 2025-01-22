::Nggh_MagicConcept.HooksMod.hook("scripts/items/shields/beasts/schrat_shield", function(q) 
{
    q.create = @(__original) function()
	{
		__original();
		m.Variants = [1];
		m.Description = "A wooden shield made out of living wood.";
	}

	q.updateVariant = @(__original) function()
	{
		__original();
		m.ShieldDecal = "bust_schrat_shield_0" + m.Variant + "_dead";
		m.IconLarge = "shields/inventory_schrat_shield_0" + m.Variant + ".png";
		m.Icon = "shields/icon_schrat_shield_0" + m.Variant + ".png";
	}

	q.getTooltip <- function()
	{
		local result = shield.getTooltip();
		result.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Regenerates [color=" + ::Const.UI.Color.PositiveValue + "]4[/color] points of durability each turn."
			},
			{
				id = 100,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Will be removed after battle[/color]"
			}
		]);
		return result;
	}

	q.onEquip <- function()
	{
		shield.onEquip();
		addSkill(::new("scripts/skills/actives/shieldwall"));
		addSkill(::new("scripts/skills/actives/knock_back"));
	}

	q.onTurnStart <- function()
	{
		m.Condition = ::Math.min(m.ConditionMax, m.Condition + 4);
		updateAppearance();
	}

	q.onCombatFinished <- function()
	{
		if (isInBag()) getContainer().removeFromBag(this);
		else getContainer().unequip(this);
	}
	
});