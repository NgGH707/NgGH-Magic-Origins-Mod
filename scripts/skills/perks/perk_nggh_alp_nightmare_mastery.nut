this.perk_nggh_alp_nightmare_mastery <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.mastery_nightmare";
		this.m.Name = ::Const.Strings.PerkName.NggHAlpNightmareSpec;
		this.m.Description = ::Const.Strings.PerkDescription.NggHAlpNightmareSpec;
		this.m.Icon = "ui/perks/perk_mastery_nightmare.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInMagic = true;
	}
	
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == null || _skill.getID() != "actives.nightmare")
		{
			return;
		}
		
		if (_damageInflictedHitpoints <= 0)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (actor.getHitpoints() >= actor.getHitpointsMax())
		{
			return;
		}

		local heal = ::Math.max(1, ::Math.round(_damageInflictedHitpoints * ::Math.rand(15, 25) * 0.01));
		this.spawnIcon("status_effect_81", actor.getTile());

		if (!actor.isHiddenToPlayer())
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " heals for " + ::Math.min(actor.getHitpointsMax() - actor.getHitpoints(), heal) + " points");
		}

		actor.setHitpoints(::Math.min(actor.getHitpointsMax(), actor.getHitpoints() + heal));
	}

});

