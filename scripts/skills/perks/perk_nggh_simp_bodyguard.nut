this.perk_nggh_simp_bodyguard <- ::inherit("scripts/skills/skill", {
	m = {
		BaseBonus = 3,
		Distance = 3,
	},
	function create()
	{
		this.m.ID = "perk.simp_bodyguard";
		this.m.Name = ::Const.Strings.PerkName.NggH_Simp_Bodyguard;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_Simp_Bodyguard;
		this.m.Icon = "ui/perks/perk_simp_bodyguard.png";
		this.m.IconMini = "perk_simp_bodyguard_mini";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function getDescription()
	{
		return "At your service, My Queen!";
	}

	function getBonus()
	{
		local simp = this.getContainer().getSkillByID("effects.simp");

		if (simp == null)
			return 0;

		return this.m.BaseBonus + simp.getSimpLevel();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local bonus = this.getBonus();

		if (bonus == 0)
			return ret;

		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "%[/color] Melee Skill"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "%[/color] Ranged Skill"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "%[/color] Melee Defense"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "%[/color] Ranged Defense"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "%[/color] Resolve"
			}
		]);

		return ret;
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			this.m.IsHidden = true;
			return;
		}

		local actor = this.getContainer().getActor();
		local allies = ::Tactical.Entities.getFactionActors(actor.getFaction(), actor.getTile(), this.m.Distance);
		local isValid = false;

		foreach( ally in allies )
		{
			if (!ally.getFlags().has("Hexe"))
				continue;

			isValid = true;
			break;
		}
		
		this.m.IsHidden = !isValid;

		if (!isValid)
			return;

		local bonus = this.getBonus();
		_properties.MeleeSkillMult *= 1.0 + 0.01 * bonus;
		_properties.RangedSkillMult *= 1.0 + 0.01 * bonus;
		_properties.MeleeDefenseMult *= 1.0 + 0.01 * bonus;
		_properties.RangedDefenseMult *= 1.0 + 0.01 * bonus;
		_properties.BraveryMult *= 1.0 + 0.01 * bonus;
	}

	function onCombatFinished()
	{
		this.m.IsHidden = true;
	}

});

