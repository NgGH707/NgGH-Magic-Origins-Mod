this.nggh_mod_afterimage_effect <- ::inherit("scripts/skills/skill", {
	m = {
		Count = 1,
		TurnsLeft = 1,
	},
	function create()
	{
		this.m.ID = "effects.afterimage";
		this.m.Name = "Afterimage";
		this.m.Icon = "skills/status_effect_102.png";
		this.m.IconMini = "status_effect_102_mini";
		this.m.Overlay = "status_effect_102";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getName()
	{
		if (this.m.Count <= 1)
		{
			return this.m.Name;
		}
		else
		{
			return this.m.Name + " (x" + this.m.Count + ")";
		}
	}

	function getDescription()
	{
		return "This character creates afterimage when teleporting, making it harder for the enemy to hit you. This effect will wear off at the start of your next turn.";
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
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (15 + 5 * this.m.Count) + "[/color] Melee Defense"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (15 + 5 * this.m.Count) + "[/color] Ranged Defense"
			},
		];
	}

	function onRefresh()
	{
		++this.m.Count;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense += 15 + 5 * this.m.Count;
		_properties.RangedDefense += 15 + 5 * this.m.Count;
	}

	function onTurnStart()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

