this.mod_RSH_night_vision <- this.inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false,
	},
	function create()
	{
		this.m.ID = "special.mod_RSH_night_vision";
		this.m.Name = "Rune Sigil: Night Vision";
		this.m.Description = "Rune Sigil: Night Vision";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
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

});

