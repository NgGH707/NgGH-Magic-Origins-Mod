this.legend_redback_spider_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.legend_redback_spider";
		this.m.Name = "Redback Poison";
		this.m.Description = "An even more dangerous giant spider to play with. Its poison is the deadliest.";
		this.m.Icon = "skills/status_effect_54.png";
		this.m.IconMini = "status_effect_54_mini";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/giant_spider_poison_01.wav",
			"sounds/enemies/dlc2/giant_spider_poison_02.wav"
		];
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
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
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has extremely potent poison"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]100%[/color] more direct damage against targets that have Trapped in Web, Net, Vines status effects"
			}
		];
	}
	
	function onAdded()
	{
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			return;
		}
		
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.getContainer().update();
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity.getCurrentProperties().IsImmuneToPoison || _damageInflictedHitpoints <= this.Const.Combat.PoisonEffectMinDamage || _targetEntity.getHitpoints() <= 0)
		{
			return;
		}

		if (!_targetEntity.isAlive() || _targetEntity.isDying())
		{
			return;
		}

		if (_targetEntity.getFlags().has("undead"))
		{
			return;
		}

		if (!_targetEntity.isHiddenToPlayer())
		{
			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());
			}

			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
		}

		this.spawnIcon("status_effect_54", _targetEntity.getTile());
		local properties = this.getContainer().getActor().getCurrentProperties();
		local poison = _targetEntity.getSkills().getSkillByID("effects.legend_redback_spider_poison");

		if (!_targetEntity.getSkills().hasSkill("effects.stunned") && !_targetEntity.getCurrentProperties().IsImmuneToStun)
		{
			_targetEntity.getSkills().add(this.new("scripts/skills/effects/stunned_effect"));
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " is stunned");
		}

		if (poison == null)
		{
			local effect = this.new("scripts/skills/effects/legend_redback_spider_poison_effect");
			effect.setDamage(properties.IsSpecializedInDaggers ? effect.getDamage() * 2 : 1);
			effect.setActorID(this.getContainer().getActor().getID());
			_targetEntity.getSkills().add(effect);
		}
		else
		{
			poison.resetTime();
			poison.setActorID(this.getContainer().getActor().getID());
			
			if (properties.IsSpecializedInDaggers && this.Math.rand(1, 10) <= 5)
			{
				poison.setDamage(poison.getDamage() + 1);
			}
		}
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return;
		}
		
		local num = this.Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction()).len();
		
		_properties.Bravery += (num - 1) * 3;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}
		
		local targetStatus = _targetEntity.getCurrentProperties();
		
		if (targetStatus.IsRooted && !targetStatus.IsImmuneToRoot)
		{
			_properties.DamageDirectMult *= 2.0;
		}
	}

});

