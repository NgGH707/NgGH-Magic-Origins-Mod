this.frenzy_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2,
		SkillCount = 0,
		LastTargetID = 0,
		IsCombatOver = false,
	},
	function create()
	{
		this.m.ID = "effects.frenzy";
		this.m.Name = "Frenziness";
		this.m.Icon = "ui/perks/perk_madden.png";
		this.m.IconMini = "perk_madden_mini";
		this.m.Overlay = "perk_madden";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "RAAAARGH! This character is in a frenzy state for [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.TurnsLeft + "[/color] more turn(s). Becomes too reckless but at the same time shows unimaginable strength.";
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+40%[/color] Attack Damage"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+50%[/color] Initiative"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] Melee Defense"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/shield_damage.png",
				text = "Receives [color=" + this.Const.UI.Color.NegativeValue + "]15%[/color] more of any damage"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "All skills cost [color=" + this.Const.UI.Color.PositiveValue + "]1[/color] less AP"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can applied additional [color=" + this.Const.UI.Color.PositiveValue + "]Overwhelmed[/color] debuff on your victim"
			},
		];
	}

	function onUpdate( _properties )
	{
		_properties.AdditionalActionPointCost -= 1;
		_properties.MeleeDamageMult *= 1.4;
		_properties.InitiativeMult *= 1.5;
		_properties.DamageReceivedTotalMult *= 1.15;
		_properties.MeleeDefenseMult *= 0.75;
		_properties.TargetAttractionMult *= 1.25;
		_properties.FatalityChanceMult *= 10000.0;
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
			_targetEntity.getSkills().add(this.new("scripts/skills/effects/overwhelmed_effect"));
		}
	}

	function onRemoved()
	{
		if (this.m.IsCombatOver)
		{
			return;
		}

		if (this.getContainer().hasSkill("effects.nacho_eat"))
		{
			this.m.Container.add(this.new("scripts/skills/effects/dazed_effect"));
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " is dazed " + " for 2 turns");
		}
		else 
		{
		    this.m.Container.add(this.new("scripts/skills/effects/stunned_effect"));
		    this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " is stunned " + " for 1 turn");
		}
	}

	function onCombatFinished()
	{
		this.m.IsCombatOver = true;
		this.skill.onCombatFinished();
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

