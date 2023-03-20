this.perk_nggh_spider_bite <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.spider_bite";
		this.m.Name = ::Const.Strings.PerkName.NggHSpiderBite;
		this.m.Description = ::Const.Strings.PerkDescription.NggHSpiderBite;
		this.m.Icon = "ui/perks/perk_spider_bite.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onUpdate( _properties )
	{
		_properties.DamageDirectAdd += 0.15;
		_properties.DamageRegularMin += 1;
		_properties.DamageRegularMax += 5;
	}
	
	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (::Math.rand(1, 100) > 25)
		{
			return;
		}
		
		local DamDirect = 1.0;
		
		if (_hitInfo.DamageDirect > _skill.m.DirectDamageMult)
		{
			DamDirect += _hitInfo.DamageDirect - _skill.m.DirectDamageMult;
		}
		
		_hitInfo.DamageArmor = 0;
		_hitInfo.DamageDirect = DamDirect;
		_hitInfo.DamageMinimum = ::Math.floor(_hitInfo.DamageRegular * 0.1);
		this.spawnIcon("status_effect_106", _targetEntity.getTile());
	}

});

