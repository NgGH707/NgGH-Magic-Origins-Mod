this.nggh_mod_RSW_unstable <- ::inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false
	},
	function create()
	{
		this.m.ID = "special.mod_RSW_unstable";
		this.m.Name = "Rune Sigil: Unstable";
		this.m.Description = "Rune Sigil: Unstable";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_targetEntity == null || _skill == null)
		{
			return;
		}

		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null)
		{
			return;
		}

		local roll = ::Math.rand(1, 100);

		if (roll > 90)
		{
			_hitInfo.DamageRegular *= 3.0;
			_hitInfo.DamageArmor *= 3.0;
			this.spawnIcon("status_effect_106", _targetEntity.getTile());
			::Tactical.EventLog.logEx("It\'s a devastating strike thanks to the rune on your weapon");
		}
		else if (roll <= 10)
		{
			_hitInfo.DamageRegular /= 3.0;
			_hitInfo.DamageArmor /= 3.0;
			this.spawnIcon("status_effect_111", _targetEntity.getTile());
			::Tactical.EventLog.logEx("It\'s a pathetic strike all due to the rune on your weapon");
		}		
	}

});

