this.sleeping_effect <- this.inherit("scripts/skills/skill", {
	m = {
		PreventWakeUp = false,
		AppliedMoraleCheck = false,
		TurnsSleeping = 0,
		TurnApplied = 0,
		TurnsLeft = 4
	},
	function getTurnsSleeping()
	{
		return this.m.TurnsSleeping;
	}

	function getTurnApplied()
	{
		return this.m.TurnApplied;
	}

	function create()
	{
		this.m.ID = "effects.sleeping";
		this.m.Name = "Sleeping";
		this.m.Icon = "skills/status_effect_82.png";
		this.m.IconMini = "status_effect_82_mini";
		this.m.Overlay = "status_effect_82";
		this.m.SoundOnUse = [
			"sounds/enemies/sleeping_01.wav",
			"sounds/enemies/sleeping_02.wav",
			"sounds/enemies/sleeping_03.wav",
			"sounds/enemies/sleeping_04.wav",
			"sounds/enemies/sleeping_05.wav",
			"sounds/enemies/sleeping_06.wav",
			"sounds/enemies/sleeping_07.wav",
			"sounds/enemies/sleeping_08.wav",
			"sounds/enemies/sleeping_09.wav",
			"sounds/enemies/sleeping_10.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "This character has fallen into unnatural sleep and is unable to act. They\'ll wake up after [color=" + this.Const.UI.Color.NegativeValue + "]" + (this.m.TurnsLeft - 1) + "[/color] more turn(s), but can also be forcibly awoken by allies and will wake up when taking any amount of damage.\n\nThe higher a character\'s resolve, the higher the chance to resist the urge to sleep.";
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
				id = 9,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-100[/color] Initiative"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can take damage from Alps"
			}
		];
	}

	function onAdded()
	{
		this.m.TurnApplied = this.Time.getRound();
		local actor = this.m.Container.getActor();
		this.m.Container.removeByID("effects.shieldwall");
		this.m.Container.removeByID("effects.spearwall");
		this.m.Container.removeByID("effects.riposte");
		this.m.Container.removeByID("effects.return_favor");
		local actor = this.getContainer().getActor();
		actor.getFlags().set("Sleeping", true);
		this.Tactical.TurnSequenceBar.pushEntityBack(this.getContainer().getActor().getID());

		if (this.m.SoundOnUse.len() != 0 && this.Math.rand(1, 100) <= 33)
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.0, this.getContainer().getActor().getPos());
		}

		this.m.TurnsLeft = this.Math.max(1, 3 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
	}

	function onBeforeActivation()
	{
		++this.m.TurnsSleeping;

		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		actor.setActionPoints(0);

		if (this.m.SoundOnUse.len() != 0 && this.Math.rand(1, 100) <= 50)
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.0, this.getContainer().getActor().getPos());
		}
	}

	function onResumeTurn()
	{
		this.onTurnStart();
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		if (actor.hasSprite("status_stunned"))
		{
			actor.getSprite("status_stunned").Visible = false;
		}

		actor.getFlags().set("Sleeping", false);
		
		if (actor.getFlags().has("human"))
		{
			if (actor.hasSprite("closed_eyes"))
			{
				actor.getSprite("closed_eyes").Visible = false;
			}
			
			if ("setEyesClosed" in actor.get())
			{
				actor.setEyesClosed(false);
			}
		}

		actor.setDirty(true);
		
		if (this.m.AppliedMoraleCheck && actor.isAlive() && !actor.isDying())
		{
			actor.checkMorale(-1, -10, this.Const.MoraleCheckType.MentalAttack);
			actor.checkMorale(-1, -5, this.Const.MoraleCheckType.MentalAttack);
		}
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		_properties.IsStunned = true;
		_properties.Initiative -= 100;

		if (actor.hasSprite("status_stunned"))
		{
			actor.getSprite("status_stunned").setBrush(actor.isAlliedWithPlayer() ? "bust_sleep" : "bust_sleep_mirrored");
			actor.getSprite("status_stunned").Visible = true;
			
			if (actor.getFlags().has("human"))
			{
				if (actor.hasSprite("closed_eyes"))
				{
					actor.getSprite("closed_eyes").Visible = true;
				}
				
				if ("setEyesClosed" in actor.get())
				{
					actor.setEyesClosed(true);
				}
			}

			actor.setDirty(true);
		}
	}
	
	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _skill != null && _skill.getID() == "actives.nightmare")
		{
			local specialized = _attacker.getSkills().hasSkill("perk.after_wake");
			this.m.PreventWakeUp = specialized && this.Math.rand(1, 100) <= 40;
			this.m.AppliedMoraleCheck = specialized && !this.m.PreventWakeUp;
		}
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints > 0 && !this.m.PreventWakeUp)
		{
			this.removeSelf();
		}

		this.m.PreventWakeUp = false;
	}

});

