this.perk_nighttime <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.nighttime";
		this.m.Name = this.Const.Strings.PerkName.Nighttime;
		this.m.Description = this.Const.Strings.PerkDescription.Nighttime;
		this.m.Icon = "skills/status_effect_35.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsAffectedByNight = false;
	}

	function onCombatStarted()
	{
		if (!this.World.getTime().IsDaytime)
		{
			this.getContainer().add(this.new("scripts/skills/effects/favoured_night_effect"));
		}

		this.getContainer().removeByID("special.night");
	}

	function onRemoved()
	{
		this.getContainer().removeByID("effects.favoured_night");
	}

});

