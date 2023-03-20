this.perk_nggh_luft_innocent_look <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.words_charm";
		this.m.Name = ::Const.Strings.PerkName.NggHLuftInnocentLook;
		this.m.Description = ::Const.Strings.PerkDescription.NggHLuftInnocentLook;
		this.m.Icon = "ui/perks/perk_innocent_look.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 1.05;
		_properties.StaminaMult *= 1.05;
	}

});

