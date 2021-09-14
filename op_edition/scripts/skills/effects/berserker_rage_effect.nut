this.berserker_rage_effect <- this.inherit("scripts/skills/skill", {
	m = {
		RageStacks = 0,
		LastRageSoundTime = 0
	},
	function create()
	{
		this.m.ID = "effects.berserker_rage";
		this.m.Name = "Rage";
		this.m.Icon = "skills/status_effect_34.png";
		this.m.IconMini = "status_effect_34_mini";
		this.m.Overlay = "status_effect_34";
		this.m.SoundOnUse = [
			"sounds/enemies/orc_rage_01.wav",
			"sounds/enemies/orc_rage_02.wav",
			"sounds/enemies/orc_rage_03.wav",
			"sounds/enemies/orc_rage_04.wav",
			"sounds/enemies/orc_rage_05.wav",
			"sounds/enemies/orc_rage_06.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
	}

	function getDescription()
	{
		return "A wrathful being can easily deal desvastating damage. Gain rage whenever this character hits or kills a target.";
	}
	
	function onAdded()
	{
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			return;
		}
		
		this.m.RageStacks = 1;
		this.getContainer().update();
	}
	
	function getTooltip()
	{
		local i = this.Math.maxf(50, (1.0 - 0.01 * this.m.RageStacks) * 100);
		
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RageStacks + "[/color] bonus damage"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RageStacks + "[/color] Resolve"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RageStacks + "[/color] Initiative"
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
		this.m.RageStacks += _r;
		local actor = this.getContainer().getActor();

		if (!actor.isHiddenToPlayer())
		{
			if (this.m.SoundOnUse.len() != 0 && this.Time.getVirtualTimeF() - this.m.LastRageSoundTime > 5.0)
			{
				this.m.LastRageSoundTime = this.Time.getVirtualTimeF();
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * (this.Math.rand(75, 100) * 0.01), actor.getPos(), this.Math.rand(75, 100) * 0.01);
			}

			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " gains rage!");
		}

		this.getContainer().getActor().updateRageVisuals(this.m.RageStacks);
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = this.m.RageStacks == 0;
		local max = 0.3;
		local percen = 0.02;
		_properties.DamageReceivedTotalMult *= this.Math.maxf(max, 1.0 - percen * this.m.RageStacks);
		_properties.Bravery += 1 * this.m.RageStacks;
		_properties.DamageRegularMin += 1 * this.m.RageStacks;
		_properties.DamageRegularMax += 1 * this.m.RageStacks;
		_properties.Initiative += 1 * this.m.RageStacks;
	}

	function onTurnStart()
	{
		this.m.RageStacks = this.Math.max(0, this.m.RageStacks - 1);
		this.getContainer().getActor().updateRageVisuals(this.m.RageStacks);
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.addRage(2);
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		this.addRage(5);
	}
	
	function onCombatStarted()
	{
		this.m.RageStacks = 0;
	}
	
	function onCombatFinished()
	{
		this.m.RageStacks = 1;
	}

});

