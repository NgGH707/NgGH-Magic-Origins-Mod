this.perk_snake_venom <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.snake_venom";
		this.m.Name = this.Const.Strings.PerkName.SerpentVenom;
		this.m.Description = this.Const.Strings.PerkDescription.SerpentVenom;
		this.m.Icon = "ui/perks/perk_venomous.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == null || _skill.getID() != "actives.serpent_bite")
		{
			return;
		}

		if (!_targetEntity.isAlive())
		{
			return;
		}
		
		if (_targetEntity.getCurrentProperties().IsImmuneToPoison || _targetEntity.getHitpoints() <= 0 || _damageInflictedHitpoints <= this.Const.Combat.PoisonEffectMinDamage)
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

		local poison = _targetEntity.getSkills().getSkillByID("effects.spider_poison");
		local id = this.getContainer().getActor().getID();

		if (poison == null)
		{
			local effect = this.new("scripts/skills/effects/spider_poison_effect");
			effect.setDamage(20);
			effect.setActorID(id);
			effect.m.TurnsLeft = 1;
			_targetEntity.getSkills().add(effect);
		}
		else
		{
			poison.resetTime();
			poison.setActorID(id);

			if (poison.getDamage() < 20)
			{
				poison.setDamage(20);
			}

			poison.m.TurnsLeft = this.Math.min(2, poison.m.TurnsLeft);
		}
	}

});

