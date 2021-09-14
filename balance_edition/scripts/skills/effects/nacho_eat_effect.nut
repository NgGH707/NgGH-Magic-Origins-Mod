this.nacho_eat_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.nacho_eat";
		this.m.Name = "Strengthen";
		this.m.Icon = "ui/perks/perk_energize_meal.png";
		this.m.IconMini = "perk_energize_meal_mini";
		this.m.Overlay = "perk_energize_meal";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Delicious! This meal has given this character a healthier body for [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.TurnsLeft + "[/color] more turn(s). This effect can be stacked.";
	}

	function onAdded()
	{
		this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] Attack Damage"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] Fatigue Recovery per turn"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Resolve"
			},
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
		_properties.FatigueRecoveryRate += 3;
		_properties.DamageTotalMult *= 1.15;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

