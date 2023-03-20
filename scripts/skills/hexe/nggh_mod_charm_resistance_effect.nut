this.nggh_mod_charm_resistance_effect <- ::inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2,
	},
	function create()
	{
		this.m.ID = "effects.charm_resistance";
		this.m.Name = "Charm Resistance";
		this.m.Icon = "skills/status_effect_85.png";
		this.m.IconMini = "status_effect_85_mini";
		this.m.Overlay = "status_effect_85";
		this.m.SoundOnUse = "";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsStacking = true;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 2;
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 1.67;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

