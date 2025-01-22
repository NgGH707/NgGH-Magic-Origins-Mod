perk_nggh_alp_nightmare_mastery <- ::inherit("scripts/skills/skill", {
	m = {
		HPDrainMin = 15,
		HPDrainMax = 25,
		BonusConvertRate = 0.1
	},
	function getBonus()
	{
		return m.BonusConvertRate;
	}

	function create()
	{
		m.ID = "perk.mastery_nightmare";
		m.Name = ::Const.Strings.PerkName.NggHAlpNightmareSpec;
		m.Description = ::Const.Strings.PerkDescription.NggHAlpNightmareSpec;
		m.Icon = "ui/perks/perk_mastery_nightmare.png";
		m.Type = ::Const.SkillType.Perk;
		m.Order = ::Const.SkillOrder.Perk;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInMagic = true;
	}

	function onAfterUpdate( _properties )
	{
		local skill = getContainer().hasSkill("actives.nightmare");

		if (skill == null) return;

		skill.m.FatigueCostMult *= ::Const.Combat.WeaponSpecFatigueMult;
		skill.m.ConvertRate += getBonus();
	}
	
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == null || _skill.getID() != "actives.nightmare" || _damageInflictedHitpoints <= 0)
			return;

		local actor = getContainer().getActor();

		if (actor.getHitpoints() >= actor.getHitpointsMax())
			return;

		local heal = ::Math.max(1, ::Math.round(_damageInflictedHitpoints * ::Math.rand(HPDrainMin, HPDrainMax) * 0.01));

		if (!actor.isHiddenToPlayer()) {
			spawnIcon("status_effect_81", actor.getTile());
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " heals for " + ::Math.min(actor.getHitpointsMax() - actor.getHitpoints(), heal) + " points");
		}

		actor.setHitpoints(::Math.min(actor.getHitpointsMax(), actor.getHitpoints() + heal));
	}

});

