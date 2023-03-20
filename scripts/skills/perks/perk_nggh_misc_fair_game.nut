this.perk_nggh_misc_fair_game <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.fair_game";
		this.m.Name = ::Const.Strings.PerkName.NggHMiscFairGame;
		this.m.Description = ::Const.Strings.PerkDescription.NggHMiscFairGame;
		this.m.Icon = "ui/perks/perk_fair_game.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += 25;
		_properties.RangedSkill += 25;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_targetEntity == null || _skill == null)
		{
			return;
		}

		local rolled = ::Math.rand(1, 100);
		local chance = 50;

		if (rolled <= chance)
		{
			_hitInfo.DamageRegular *= 1.5;
			_hitInfo.DamageArmor *= 1.5;
			this.spawnIcon("status_effect_106", _targetEntity.getTile());
			::Tactical.EventLog.logEx("It\'s a devastating hit (Chance: " + chance + ", Rolled: " + rolled + ")");
		}
		else
		{
			_hitInfo.DamageRegular *= 0.5;
			_hitInfo.DamageArmor *= 0.5;
		    this.spawnIcon("status_effect_111", _targetEntity.getTile());
		    ::Tactical.EventLog.logEx("It\'s a pathetic hit (Chance: " + chance + ", Rolled: " + rolled + ")");
		}
	}

});

