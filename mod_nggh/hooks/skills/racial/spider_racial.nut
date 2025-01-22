::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/spider_racial", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Webknecht Venom";
		m.Description = "A giant spider is dangerous to play with, especially when it has deadly venom.";
		m.Icon = "skills/status_effect_54.png";
		m.IconMini = "status_effect_54_mini";
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	q.getTooltip <- function()
	{
		local poison = 5;

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			poison *= 2.0;

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
				text = "Inflicts [color=" + ::Const.UI.Color.DamageValue + "]" + poison + "[/color] poison damage per turn, for " + (getContainer().getActor().getCurrentProperties().IsSpecializedInDaggers ? 3 : 4) + " turns"
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
		
		if (_damageInflictedHitpoints < ::Const.Combat.PoisonEffectMinDamage || _targetEntity.getHitpoints() <= 0)
			return;

		if (!_targetEntity.isHiddenToPlayer()) {
			if (m.SoundOnUse.len() != 0)
				::Sound.play(::MSU.Array.rand(m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
			spawnIcon("status_effect_54", _targetEntity.getTile());
		}

		local poison = ::new("scripts/skills/effects/spider_poison_effect");
		poison.m.IsSuperPoison = getContainer().getActor().getCurrentProperties().IsSpecializedInDaggers;
		poison.setActor(getContainer().getActor());
		_targetEntity.getSkills().add(poison);

		if (poison.m.IsSuperPoison)
			poison.m.TurnsLeft += 1;
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