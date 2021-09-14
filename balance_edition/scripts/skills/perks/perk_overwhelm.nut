this.perk_overwhelm <- this.inherit("scripts/skills/skill", {
	m = {
		SkillCount = 0,
		LastTargetID = 0
	},
	function create()
	{
		this.m.ID = "perk.overwhelm";
		this.m.Name = this.Const.Strings.PerkName.Overwhelm;
		this.m.Description = this.Const.Strings.PerkDescription.Overwhelm;
		this.m.Icon = "ui/perks/perk_62.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (this.Tactical.TurnSequenceBar.getActiveEntity() == null || this.Tactical.TurnSequenceBar.getActiveEntity().getID() != this.getContainer().getActor().getID())
		{
			return;
		}

		if (!_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			return;
		}
		
		if (_targetEntity.getCurrentProperties().IsImmuneToOverwhelm)
		{
			return;
		}
	
		if (!_targetEntity.isTurnStarted() && !_targetEntity.isTurnDone())
		{
			if (this.m.SkillCount == this.Const.SkillCounter && this.m.LastTargetID == _targetEntity.getID())
			{
				return;
			}

			this.m.SkillCount = this.Const.SkillCounter;
			this.m.LastTargetID = _targetEntity.getID();
			_targetEntity.getSkills().add(this.new("scripts/skills/effects/overwhelmed_effect"));
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (this.Tactical.TurnSequenceBar.getActiveEntity() == null || this.Tactical.TurnSequenceBar.getActiveEntity().getID() != this.getContainer().getActor().getID())
		{
			return;
		}

		if (!_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			return;
		}
		
		if (_targetEntity.getCurrentProperties().IsImmuneToOverwhelm)
		{
			return;
		}

		if (!_targetEntity.isTurnStarted() && !_targetEntity.isTurnDone())
		{
			if (this.m.SkillCount == this.Const.SkillCounter && this.m.LastTargetID == _targetEntity.getID())
			{
				return;
			}

			this.m.SkillCount = this.Const.SkillCounter;
			this.m.LastTargetID = _targetEntity.getID();
			this.m.SkillCount = this.Const.SkillCounter;
			_targetEntity.getSkills().add(this.new("scripts/skills/effects/overwhelmed_effect"));
		}
	}

	function onCombatStarted()
	{
		this.m.SkillCount = 0;
		this.m.LastTargetID = 0;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.SkillCount = 0;
		this.m.LastTargetID = 0;
	}

});

