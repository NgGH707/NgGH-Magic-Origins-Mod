this.berserker_rage_racial <- this.inherit("scripts/skills/skill", {
	m = {
		RageStacks = 0,
		LastRageSoundTime = 0
	},
	
	function getRageStacks()
	{
		return this.m.RageStacks;
	}
	
	function create()
	{
		this.m.ID = "racial.berserker_rage";
		this.m.Name = "Rage";
		this.m.Icon = "skills/status_effect_34.png";
		this.m.IconMini = "status_effect_34_mini";
		this.m.Overlay = "status_effect_34";
		this.m.SoundOnUse = [
			"sounds/enemies/skeleton_rise_01.wav",
			"sounds/enemies/skeleton_rise_02.wav",
			"sounds/enemies/skeleton_rise_03.wav",
			"sounds/enemies/skeleton_rise_04.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.Racial;
		this.m.IsActive = false;
	}

	function getDescription()
	{
		return "Accumulating rage everytime land a hit, kill an enemy or taken a hit from enemy. Stacks of rage give this character more attack power, more accuracy, more resilient. Lose [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] - [color=" + this.Const.UI.Color.NegativeValue + "]3[/color] stacks at the start of the round.";
	}
	
	function getTooltip()
	{
		local i = this.Math.max(30, (1.0 - 0.02 * this.m.RageStacks) * 100);
		
		local ret = [
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
				id = 7,
				type = "text",
				icon = "ui/icons/mood_01.png",
				text = "Currently have [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.RageStacks + "[/color] stack(s) of rage"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RageStacks + "[/color] Attack Damage"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RageStacks + "[/color] Melee Skill"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RageStacks + "[/color] Ranged Skill"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Only take [color=" + this.Const.UI.Color.PositiveValue + "]" + i + "%[/color] damage from all sources"
			}
		];
		
		return ret;
	}

	function addRage( _r )
	{
		this.m.RageStacks = this.Math.max(0, this.m.RageStacks + _r);
		local actor = this.getContainer().getActor();

		if (!actor.isHiddenToPlayer())
		{
			if (this.m.SoundOnUse.len() != 0 && this.Time.getVirtualTimeF() - this.m.LastRageSoundTime > 5.0)
			{
				this.m.LastRageSoundTime = this.Time.getVirtualTimeF();
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * (this.Math.rand(75, 100) * 0.01), actor.getPos(), this.Math.rand(75, 100) * 0.01);
			}
			
			if (_r > 0)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " gains rage!");
			}
			else
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " loses some rage!");
			}
		}
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = this.m.RageStacks == 0;
		local actor = this.getContainer().getActor();
		local HP = 1 - (actor.getHitpoints() / actor.getHitpointsMax());
		_properties.DamageReceivedTotalMult *= this.Math.maxf(0.3, 1.0 - 0.02 * this.m.RageStacks);
		_properties.MoraleCheckBraveryMult[1] *= 10000.0;
		_properties.DamageRegularMin += this.m.RageStacks;
		_properties.DamageRegularMax += this.m.RageStacks;
		_properties.MeleeSkill += this.m.RageStacks;
		_properties.RangedSkill += this.m.RageStacks;
		_properties.MeleeSkillMult *= this.Math.minf(1.25, 1.0 + HP);
		_properties.RangedSkillMult *= this.Math.minf(1.25, 1.0 + HP);
	}

	function onRoundEnd()
	{
		return;
		local r = this.Math.rand(-2, -1);
		this.logDebug("This Earthen Puppet loses rage!");
		this.addRage(r);
	}
	
	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints > 0 || _damageArmor > 0)
		{
			this.addRage(2);
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.addRage(1);
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		this.addRage(3);
	}

});

