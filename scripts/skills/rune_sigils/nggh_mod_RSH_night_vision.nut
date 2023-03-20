this.nggh_mod_RSH_night_vision <- ::inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false,
	},
	function create()
	{
		this.m.ID = "special.mod_RSH_night_vision";
		this.m.Name = "Rune Sigil: Night Vision";
		this.m.Description = "Rune Sigil: Night Vision";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function onUpdate( _properties )
	{
		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null)
		{
			return;
		}

		_properties.IsAffectedByNight = false;
	}

	function onCombatStarted()
	{
		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null)
		{
			return;
		}

		this.getContainer().removeByID("special.night");
	}

});

