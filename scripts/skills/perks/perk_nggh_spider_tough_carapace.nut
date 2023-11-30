this.perk_nggh_spider_tough_carapace <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.spider_tough_carapace";
		this.m.Name = ::Const.Strings.PerkName.NggH_Spider_ToughCarapace;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_Spider_ToughCarapace;
		this.m.Icon = "ui/perks/perk_spider_tough_carapace.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID())
			return;

		if (_skill != null && !_skill.isAttack()) 
			return;
		
		_properties.DamageReceivedArmorMult *= 0.5;
		_properties.DamageReceivedDirectMult *= 0.67;
	}

});

