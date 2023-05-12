this.perk_nggh_bdsm_bondage <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bdsm_bondage";
		this.m.Name = ::Const.Strings.PerkName.NggH_BDSM_Bondage;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_BDSM_Bondage;
		this.m.Icon = "ui/perks/perk_bdsm_bondage.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

 	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || _targetEntity == null) return;

		if (!_targetEntity.getCurrentProperties().IsRooted) return;
		
		switch(_skill.getID())
		{
		case "actives.whip":
		case "actives.legend_flaggelate":
			_properties.MeleeDamageMult *= 1.23;
			_properties.DamageDirectAdd += 0.15;
			break;

		case "actives.disarm":
		case "actives.legend_ninetails_disarm":
			_properties.MeleeSkill += 10;
			break;
		}
	}

});

