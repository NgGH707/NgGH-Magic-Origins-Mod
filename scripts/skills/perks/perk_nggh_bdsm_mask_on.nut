this.perk_nggh_bdsm_mask_on <- ::inherit("scripts/skills/skill", {
	m = {
		Bonus = 0,
	},
	function create()
	{
		this.m.ID = "perk.bdsm_mask_on";
		this.m.Name = ::Const.Strings.PerkName.NggH_BDSM_MaskOn;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_BDSM_MaskOn;
		this.m.Icon = "ui/perks/perk_bdsm_mask_on.png";
		this.m.IconMini = "perk_bdsm_mask_on_mini";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function getDescription()
	{
		return "Mask on! whip ready! Honey, we will have some fun time soon.";
	}

	function getTooltip()
	{
		local tooltip = this.skill.getTooltip();

		if (this.m.Bonus > 0)
		{
			tooltip.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (this.m.Bonus * 5) + "%[/color] Resolve"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]Whip[/color] and [color=" + ::Const.UI.Color.NegativeValue + "]Disarm[/color] active skills build up [color=" + ::Const.UI.Color.PositiveValue + "]" + this.m.Bonus + "[/color] less Fatigue"
				},
			]);
		}
		else
		{
			tooltip.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/tooltips/bravery.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.Bonus * 5) + "%[/color] Resolve"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]Whip[/color] and [color=" + ::Const.UI.Color.NegativeValue + "]Disarm[/color] active skills build up [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.Bonus + "[/color] more Fatigue"
				},
			]);
		}

		return tooltip;
	}

	function isHidden()
	{
		return this.getBonus() == 0;
	}

	function getBonus()
	{
		return this.m.Bonus;
	}

	function updateBonus()
	{
		local h = this.getContainer().getActor().getHeadItem();

		if (h == null)
		{
			this.m.Bonus = 0;
			return;
		}

		local v = h.getVision();
		this.m.Bonus = v > 0 ? -v : ::Math.abs(v);
	}

	function onAdded()
	{
		this.updateBonus();
	}

	function onUpdate( _properties )
	{
		this.updateBonus();

		_properties.BraveryMult *= 1.0 + (this.m.Bonus * 0.05);
 	}

});

