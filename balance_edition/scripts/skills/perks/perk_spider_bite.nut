this.perk_spider_bite <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.spider_bite";
		this.m.Name = this.Const.Strings.PerkName.SpiderBite;
		this.m.Description = this.Const.Strings.PerkDescription.SpiderBite;
		this.m.Icon = "ui/perks/perk_spider_bite.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onUpdate( _properties )
	{
		_properties.DamageDirectAdd += 0.10;
		_properties.DamageRegularMin += 6;
		_properties.DamageRegularMax += 12;
	}
	
	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (this.Math.rand(1, 100) > 34)
		{
			return;
		}
		
		local DamDirect = 1.0;
		
		if (_hitInfo.DamageDirect > _skill.m.DirectDamageMult)
		{
			DamDirect += _hitInfo.DamageDirect - _skill.m.DirectDamageMult;
		}
		
		_hitInfo.DamageArmor = 0;
		_hitInfo.DamageMinimum = 15;
		_hitInfo.DamageDirect = DamDirect;
		this.spawnIcon("status_effect_106", _targetEntity.getTile());
	}

});

