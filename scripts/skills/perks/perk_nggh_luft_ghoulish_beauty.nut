this.perk_nggh_luft_ghoulish_beauty <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.appearance_charm";
		this.m.Name = ::Const.Strings.PerkName.NggHLuftGhoulBeauty;
		this.m.Description = ::Const.Strings.PerkDescription.NggHLuftGhoulBeauty;
		this.m.Icon = "ui/perks/perk_ghoulish_beauty.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

