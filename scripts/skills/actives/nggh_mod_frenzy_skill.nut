this.nggh_mod_frenzy_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.frenzy";
		this.m.Name = "Frenzy";
		this.m.Description = "Enters a state of frenzines. Becomes reckless but gains fearsome physical strength, enough to rip a human in half. Suffers an aftermath effect when the frenziness wears off.";
		this.m.Icon = "ui/perks/perk_madden_active.png";
		this.m.IconDisabled = "ui/perks/perk_madden_active_sw.png";
		this.m.Overlay = "perk_madden_active";
		this.m.SoundOnUse = [
			"sounds/enemies/ghoul_hurt_13.wav",
			"sounds/enemies/ghoul_hurt_14.wav",
			"sounds/enemies/ghoul_hurt_15.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 25;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function onAdded()
	{
		local AI = this.getContainer().getActor().getAIAgent();

		if (AI != null && AI.getID() != ::Const.AI.Agent.ID.Player && AI.findBehavior(::Const.AI.Behavior.ID.Warcry) == null)
		{
			AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_warcry"));
		}
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();

		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+15%[/color] Attack Damage"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+15%[/color] Melee Skill"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+50%[/color] Initiative"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-50%[/color] Melee Defense"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "All skills cost [color=" + ::Const.UI.Color.PositiveValue + "]1[/color] less AP"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can applied additional [color=" + ::Const.UI.Color.PositiveValue + "]Overwhelmed[/color] effect on target"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Becomes immune to knocked back or grab"
			}
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Becomes immune to stun"
			},
		]);

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.frenzy") && !this.getContainer().hasSkill("effects.dazed");
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		if (!this.getContainer().hasSkill("effects.frenzy"))
		{
			this.getContainer().add(::new("scripts/skills/effects/nggh_mod_frenzy_effect"));
			return true;
		}

		return false;
	}

});

