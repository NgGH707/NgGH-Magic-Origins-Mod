this.mc_focus <- this.inherit("scripts/skills/skill", {
	m = {
		Count = 1,
	},
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
		return "This character has gathered all his mental strength and willpower to enhance his resolve until his next turn.";
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (this.m.Count * 5) + "[/color] Resolve"
			}
		];
	}

	function onRefresh()
	{
		this.m.Count = this.Math.min(99, this.m.Count + 1);
	}

	function onUpdate( _properties )
	{
		_properties.TargetAttractionMult *= 1.1 + (0.01 * this.m.Count);
		_properties.BraveryMult *= 1.0 + (0.05 * this.m.Count);
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

