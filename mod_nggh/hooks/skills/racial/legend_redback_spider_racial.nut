::mods_hookExactClass("skills/racial/legend_redback_spider_racial", function(obj) 
{
	//obj.m.StunChance <- 100;
	obj.m.IsPlayer <- false;

	obj.getStunChance <- function()
	{
		return !this.m.IsPlayer || ::Nggh_MagicConcept.IsOPMode ? 100 : 50;
	}

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Redback Venom";
		this.m.Description = "An even more dangerous giant spider to play with. Its venom is the deadliest and capable of causing paralysis.";
		this.m.Icon = "skills/status_effect_54.png";
		this.m.IconMini = "status_effect_54_mini";
		//this.m.StunChance = ::Nggh_MagicConcept.IsOPMode ? 100 : 50;
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	};
	obj.onAdded <- function()
	{
		this.m.IsPlayer = this.getContainer().getActor().isPlayerControlled();
	}
	obj.getTooltip <- function()
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
				text = "Has an extremely potent venom"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getStunChance() + "%[/color] chance to stun on hit"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts [color=" + ::Const.UI.Color.DamageValue + "]100%[/color] more direct damage against targets that are [color=" + ::Const.UI.Color.NegativeValue + "]Trapped[/color] in Web, Net, Vines"
			}
		];
	};
	obj.onTargetHit = function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity.getCurrentProperties().IsImmuneToPoison)
		{
			return;
		}

		if (_damageInflictedHitpoints <= ::Const.Combat.PoisonEffectMinDamage || _targetEntity.getHitpoints() <= 0)
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
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());
			}

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
		}

		this.spawnIcon("status_effect_54", _targetEntity.getTile());
		local properties = this.getContainer().getActor().getCurrentProperties();
		local poison = _targetEntity.getSkills().getSkillByID("effects.legend_redback_spider_poison");

		if (!_targetEntity.getSkills().hasSkill("effects.stunned") && !_targetEntity.getCurrentProperties().IsImmuneToStun && ::Math.rand(1, 100) <= this.getStunChance())
		{
			_targetEntity.getSkills().add(::new("scripts/skills/effects/stunned_effect"));
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is stunned");
		}

		if (poison == null)
		{
			local effect = ::new("scripts/skills/effects/legend_redback_spider_poison_effect");
			effect.setDamage(properties.IsSpecializedInDaggers ? effect.getDamage() * 2 : 1);
			effect.setActorID(this.getContainer().getActor().getID());
			_targetEntity.getSkills().add(effect);
		}
		else
		{
			poison.resetTime();
			poison.setActorID(this.getContainer().getActor().getID());
			
			if (properties.IsSpecializedInDaggers && ::Math.rand(1, 100) <= 50)
			{
				poison.setDamage(poison.getDamage() + 1);
			}
		}
	};
	obj.onUpdate = function( _properties )
	{
		if (!::Tactical.isActive()) return;
		
		_properties.Bravery += (::Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction()).len() - 1) * 3;
	};
	obj.onAnySkillUsed = function( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null) return;
		
		if (_targetEntity.getCurrentProperties().IsRooted)
		{
			_properties.DamageDirectMult *= 2.0;
		}
		else if (_targetEntity.getCurrentProperties().IsStunned)
		{
			_properties.DamageDirectMult *= 1.33;
		}
	};
});