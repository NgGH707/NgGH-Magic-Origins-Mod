::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/legend_redback_spider_racial", function(q) 
{
	//obj.m.StunChance <- 100;
	q.m.IsPlayer <- false;

	q.getStunChance <- function()
	{
		return !m.IsPlayer || !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 100 : 50;
	}

	q.create = @(__original) function()
	{
		__original();
		m.Name = "Redback Venom";
		m.Description = "An even more dangerous giant spider to play with. Its venom is the deadliest and capable of causing paralysis.";
		m.Icon = "skills/status_effect_54.png";
		m.IconMini = "status_effect_54_mini";
		//m.StunChance = !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 100 : 50;
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	q.onAdded <- function()
	{
		m.IsPlayer = ::MSU.isKindOf(getContainer().getActor(), "player");
	}

	q.getTooltip <- function()
	{
		return [
			{
				id = 1,
				type = "title",
				text = getName()
			},
			{
				id = 2,
				type = "description",
				text = getDescription()
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
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]" + getStunChance() + "%[/color] chance to stun on hit"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts [color=" + ::Const.UI.Color.DamageValue + "]100%[/color] more direct damage against targets that are [color=" + ::Const.UI.Color.NegativeValue + "]Trapped[/color] in Web, Net, Vines"
			}
		];
	}

	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == null || !_targetEntity.isAlive() || _targetEntity.isDying())
			return;

		if (_targetEntity.getCurrentProperties().IsImmuneToPoison || _targetEntity.getFlags().has("undead"))
			return;

		if (_damageInflictedHitpoints <= ::Const.Combat.PoisonEffectMinDamage || _targetEntity.getHitpoints() <= 0)
			return;

		if (!_targetEntity.isHiddenToPlayer()) {
			if (m.SoundOnUse.len() != 0)
				::Sound.play(::MSU.Array.rand(m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
			spawnIcon("status_effect_54", _targetEntity.getTile());
		}
		
		local properties = getContainer().getActor().getCurrentProperties();
		
		if (!_targetEntity.getSkills().hasSkill("effects.stunned") && !_targetEntity.getCurrentProperties().IsImmuneToStun && ::Math.rand(1, 100) <= getStunChance()) {
			_targetEntity.getSkills().add(::new("scripts/skills/effects/stunned_effect"));

			if (!_targetEntity.isHiddenToPlayer())
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is stunned");
		}

		local poison = _targetEntity.getSkills().getSkillByID("effects.legend_redback_spider_poison");

		if (poison == null) {
			local effect = ::new("scripts/skills/effects/legend_redback_spider_poison_effect");
			effect.m.IsSuperPoison = properties.IsSpecializedInDaggers;
			effect.setActor(getContainer().getActor());
			_targetEntity.getSkills().add(effect);
			return;
		}
		
		poison.resetTime();
		poison.setActor(getContainer().getActor());

		if (properties.IsSpecializedInDaggers)
			poison.m.IsSuperPoison = true;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		if (::Tactical.isActive() && getContainer().getActor().isPlacedOnMap())
			__original(_properties);
	}

	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null) return;
		
		if (_targetEntity.getCurrentProperties().IsRooted) _properties.DamageDirectMult *= 2.0;
		else if (_targetEntity.getCurrentProperties().IsStunned) _properties.DamageDirectMult *= 1.5;

		if (!_properties.IsSpecializedInDaggers || !_targetEntity.getCurrentProperties().IsWeakenByPoison)
			return;

		local n = _targetEntity.getSkills().getNumOfSkill("effects.spider_poison") + _targetEntity.getSkills().getNumOfSkill("effects.legend_redback_spider_poison");
		_properties.DamageRegularMult *= 1.0 + 0.02 * n;
	}

});