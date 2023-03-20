this.perk_nggh_misc_nighttime <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.nighttime";
		this.m.Name = ::Const.Strings.PerkName.NggHMiscNighttime;
		this.m.Description = ::Const.Strings.PerkDescription.NggHMiscNighttime;
		this.m.Icon = "skills/status_effect_35.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
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
		if (!::World.getTime().IsDaytime)
		{
			this.getContainer().add(::new("scripts/skills/effects/nggh_mod_favoured_night_effect"));
		}

		this.getContainer().removeByID("special.night");
	}

	function onRemoved()
	{
		this.getContainer().removeByID("effects.favoured_night");
	}

});

