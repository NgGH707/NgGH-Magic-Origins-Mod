this.perk_nggh_serpent_venom <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.serpent_venom";
		this.m.Name = ::Const.Strings.PerkName.NggHSerpentVenom;
		this.m.Description = ::Const.Strings.PerkDescription.NggHSerpentVenom;
		this.m.Icon = "ui/perks/perk_venomous.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == null || _skill.getID() != "actives.serpent_bite")
			return;

		if (!_targetEntity.isAlive())
			return;
		
		if (_targetEntity.getCurrentProperties().IsImmuneToPoison || _targetEntity.getHitpoints() <= 0 || _damageInflictedHitpoints <= ::Const.Combat.PoisonEffectMinDamage)
			return;

		if (_targetEntity.getFlags().has("undead"))
			return;

		if (!_targetEntity.isHiddenToPlayer())
		{
			if (this.m.SoundOnUse.len() != 0)
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
		}

		local poison = _targetEntity.getSkills().getSkillByID("effects.spider_poison");

		if (poison == null)
		{
			poison = ::new("scripts/skills/effects/spider_poison_effect");
			poison.m.IsStacking = false;
			poison.setDamage(20);
			poison.setActor(this.getContainer().getActor());
			_targetEntity.getSkills().add(poison);
			poison.m.TurnsLeft = 1;
			return;
		}
		
		poison.setActor(this.getContainer().getActor());

		if (poison.getDamage() < 20)
		{
			poison.setDamage(20);
			poison.m.IsStacking = false;
			poison.m.TurnsLeft = 1;
		}
	}

});

