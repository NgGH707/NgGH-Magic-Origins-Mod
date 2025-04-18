nggh_mod_RSH_night_vision <- ::inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false,
	},
	function create()
	{
		::Legends.Effects.onCreate(this, ::Legends.Effect.NgGHRshNightVision);
		m.Description = "Rune Sigil: Night Vision";
		m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.VeryLast;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = true;
	}

	function onUpdate( _properties )
	{
		if (!m.IsForceEnabled && ::MSU.isNull(getItem()))
			return;

		_properties.IsAffectedByNight = false;
	}

	function onCombatStarted()
	{
		if (!m.IsForceEnabled && ::MSU.isNull(getItem()))
			return;

		getContainer().removeByID("special.night");
	}

});

