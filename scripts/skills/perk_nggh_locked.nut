this.perk_nggh_locked <- ::inherit("scripts/skills/skill", {
	m = {
		IsVisualsUpdated = false,
		OldTooltip = "",
		OldIcon = "",
	},
	function setID( _id )
	{
		this.m.ID = _id;
	}

	function setDescription( _d )
	{
		this.m.Description = _d;
	}

	function isVisualsUpdated()
	{
		return this.m.IsVisualsUpdated;
	}

	function create()
	{
		this.m.Icon = "ui/perks/perk_locked.png";
		this.m.IconDisabled = this.m.Icon;
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		this.updatePerkVisuals();
	}

	function onRemoved()
	{
		this.resetPerkVisuals();
	}

	function updatePerkVisuals()
	{
		foreach (row in this.getContainer().getActor().getBackground().m.PerkTree)
		{
			foreach (perk in row)
			{
				if (perk.ID == this.m.ID)
				{
					this.m.OldIcon = perk.Icon;
					this.m.OldTooltip = perk.Tooltip;

					perk.Icon = this.m.Icon;
					perk.Tooltip = "[color=" + ::Const.UI.Color.NegativeValue + "][b](This perk is locked)[/b][/color]\n\n" + this.m.Description;
					perk.IsRefundable = false;
				}
			}
		}

		this.m.IsVisualsUpdated = true;
	}

	function resetPerkVisuals()
	{
		foreach (row in this.getContainer().getActor().getBackground().m.PerkTree)
		{
			foreach (perk in row)
			{
				if (perk.ID == this.m.ID)
				{
					perk.Icon = this.m.OldIcon;
					perk.Tooltip = this.m.OldTooltip;
					perk.IsRefundable = true;
				}
			}
		}

		this.m.OldIcon = null;
		this.m.OldTooltip = null;
		this.m.IsVisualsUpdated = false;
	}

});

