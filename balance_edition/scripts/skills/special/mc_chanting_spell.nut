this.mc_chanting_spell <- this.inherit("scripts/skills/skill", {
	m = {
		Spell = "",
	},

	function setSpell(_s)
	{
		this.m.Spell = _s.getName();
	}

	function create()
	{
		this.m.ID = "special.mc_chanting";
		this.m.Name = "Chanting";
		this.m.Icon = "skills/status_effect_chanting.png";
		this.m.IconMini = "mini_prayer_purple";
		this.m.Overlay = "prayer_purple";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getName()
	{
		return this.m.Name + " " + this.m.Spell;
	}

	function getDescription()
	{
		return "Not all magic can be used immediately, some of them require a bit of preparation in order to cast. Be careful pain can interrupt chanting.";
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
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.TargetAttractionMult *= 1.1;
		_properties.FatigueRecoveryRate -= 5;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints >= this.Const.Combat.InjuryMinDamage)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " lost concentration");
			}

			this.removeSelf();
		}
	}

	function onTurnStart()
	{
		local effects = [
			"effects.stunned",
			"effects.dazed",
			"effects.legend_dazed",
			"effects.legend_baffled",
			"effects.sleeping",
		];

		foreach ( e in effects) 
		{
		    if (this.getContainer().hasSkill(e))
			{
				this.removeSelf();
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " lost concentration");
				break;
			}
		}
	}

});

