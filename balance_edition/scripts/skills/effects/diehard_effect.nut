this.diehard_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLefts = 4
	},
	function create()
	{
		this.m.ID = "effects.diehard";
		this.m.Name = "Beat The Odds";
		this.m.Description = "";
		this.m.Icon = "ui/perks/perk_07.png";
		this.m.IconMini = "perk_07_mini";
		this.m.Overlay = "perk_07";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Death has failed to claim this character all due to the power of a runestone, and came back with a surge of resilience. Wear off after [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLefts + "[/color] turn(s)."
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
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedTotalMult *= 0.5;
		_properties.IsImmuneToStun = true;
		_properties.IsImmuneToKnockBackAndGrab = true;
		_properties.IsImmuneToDisarm = true;
		_properties.IsImmuneToBleeding = true;
		_properties.IsImmuneToPoison = true;
	}

	function onTurnStart()
	{
		if (--this.m.TurnsLefts <= 0)
		{
			this.removeSelf();
		}
	}

});

