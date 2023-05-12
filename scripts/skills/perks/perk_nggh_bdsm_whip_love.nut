this.perk_nggh_bdsm_whip_love <- ::inherit("scripts/skills/skill", {
	m = {
		ConvertRate = 0.12
	},
	function create()
	{
		this.m.ID = "perk.bdsm_whip_love";
		this.m.Name = ::Const.Strings.PerkName.NggH_BDSM_WhipLove;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_BDSM_WhipLove;
		this.m.Icon = "ui/perks/perk_bdsm_love_is_pain.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

 	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || [
			"actives.whip",
			"actives.legend_flaggelate",
		].find(_skill.getID()) == null) return;
		
		local damage = ::Math.min(30, ::Math.round(this.getContainer().getActor().getCurrentProperties().getBravery() * this.m.ConvertRate));
		_properties.DamageRegularMin += damage;
		_properties.DamageRegularMax += damage;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == null || [
			"actives.whip",
			"actives.legend_flaggelate",
		].find(_skill.getID()) == null) return;

		if (!_targetEntity.isAlive() || _targetEntity.isDying()) return;

		_targetEntity.getFlags().increment("whipped");
	} 

});

