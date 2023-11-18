this.perk_nggh_bdsm_whip_mastery <- ::inherit("scripts/skills/skill", {
	m = {
		AffectedSkills = [
			"actives.disarm",
			"actives.legend_ninetails_disarm",
			"actives.legend_flaggelate",
			"actives.whip"
		],
	},
	function create()
	{
		this.m.ID = "perk.bdsm_whip_mastery";
		this.m.Name = ::Const.Strings.PerkName.NggH_BDSM_WhipMastery;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_BDSM_WhipMastery;
		this.m.Icon = "ui/perks/perk_whip_mastery.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInCleavers = true;
		_properties.IsSpecializedInWhips = true;
 	}

 	function onAfterUpdate( _properties )
 	{
 		foreach (id in this.m.AffectedSkills)
 		{
 			local skill = this.getContainer().getSkillByID(id);

 			if (skill != null)
 				skill.m.ActionPointCost -= 1;
 		}
 	}

 	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || [
			"actives.whip",
			"actives.legend_flaggelate",
		].find(_skill.getID()) == null) return;

		if (_targetEntity == null) return;
		
		local skills = _targetEntity.getSkills();
		local n = skills.getNumOfSkill("effects.bleeding");
		n += skills.getNumOfSkill("effects.legend_grazed_effect");
		n += skills.getNumOfSkill("ptr_internal_hemorrhage");
		_properties.MeleeDamageMult *= 1.0 + (0.05 * n);
	}

});

