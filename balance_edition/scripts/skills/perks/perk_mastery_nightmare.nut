this.perk_mastery_nightmare <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.mastery_nightmare";
		this.m.Name = this.Const.Strings.PerkName.NightmareSpec;
		this.m.Description = this.Const.Strings.PerkDescription.NightmareSpec;
		this.m.Icon = "ui/perks/perk_mastery_nightmare.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
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

		local actor = this.m.Container.getActor();

		if (actor.getHitpoints() == actor.getHitpointsMax())
		{
			return;
		}

		local heal = this.Math.max(1, this.Math.round(_damageInflictedHitpoints * this.Math.rand(25, 33) * 0.01));
		this.spawnIcon("status_effect_81", actor.getTile());

		if (!actor.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " heals for " + this.Math.min(actor.getHitpointsMax() - actor.getHitpoints(), heal) + " points");
		}

		actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + heal));
		actor.onUpdateInjuryLayer();
	}

});

