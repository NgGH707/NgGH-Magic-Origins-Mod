this.mc_focus <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.mc_focus";
		this.m.Name = "Concentrate";
		this.m.Icon = "skills/effect_mc_04.png";
		this.m.IconMini = "effect_mc_04_mini";
		this.m.Overlay = "effect_mc_04";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "This character has gathered all their mental strength and willpower to enhance their magic skills until their next turn.";
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
		];
	}

	function onUpdate( _properties )
	{
		_properties.TargetAttractionMult *= 1.1;
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
		this.removeSelf();
	}

});

