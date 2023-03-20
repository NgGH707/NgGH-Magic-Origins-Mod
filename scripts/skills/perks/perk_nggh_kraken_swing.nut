this.perk_nggh_kraken_swing <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.kraken_swing";
		this.m.Name = ::Const.Strings.PerkName.NggHKrakenSwing;
		this.m.Description = ::Const.Strings.PerkDescription.NggHKrakenSwing;
		this.m.Icon = "ui/perks/perk_kraken_sweep.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.sweep") && this.getContainer().getActor().getFlags().has("kraken_tentacle"))
		{
			this.getContainer().add(::new("scripts/skills/actives/nggh_mod_kraken_swing_skill"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.sweep");
	}

});

