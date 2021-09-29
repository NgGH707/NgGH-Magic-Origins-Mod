this.perk_kraken_swing <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.kraken_swing";
		this.m.Name = this.Const.Strings.PerkName.KrakenSwing;
		this.m.Description = this.Const.Strings.PerkDescription.KrakenSwing;
		this.m.Icon = "ui/perks/perk_kraken_sweep.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.sweep") && this.m.Container.getActor().getFlags().has("kraken_tentacle"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/mod_kraken_swing_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.sweep");
	}

});

