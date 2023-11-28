this.perk_nggh_unhold_unarmed_training <- ::inherit("scripts/skills/skill", {
	m = {
		DamageCap = 75,
		ConvertRate = 0.05,
		AffectedSkills = [
			"actives.unhold_hand_to_hand",
			"actives.sweep_zoc",
			"actives.sweep",
		]
	},
	function create()
	{
		this.m.ID = "perk.unhold_unarmed_training";
		this.m.Name = ::Const.Strings.PerkName.NggH_Unhold_UnarmedTraining;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_Unhold_UnarmedTraining;
		this.m.Icon = "ui/perks/unarmed_training.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.First + 2;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null)
			return;

		if (this.m.AffectedSkills.find(_skill.getID()) == null)
			return;

		if (_skill.getID() == "actives.unhold_hand_to_hand")
			_properties.DamageArmorMult += 0.1;
		
		local damage = ::Math.min(this.m.DamageCap, ::Math.max(5, this.getContainer().getActor().getHitpoints() * this.m.ConvertRate));
		_properties.DamageRegularMin += damage;
		_properties.DamageRegularMax += damage;
	}

});

