this.perk_nggh_simp_no_food_only_love <- ::inherit("scripts/skills/skill", {
	m = {
		HasRefund = false,
	},
	function create()
	{
		this.m.ID = "perk.simp_no_food_only_love";
		this.m.Name = ::Const.Strings.PerkName.NggH_Simp_NoFoodOnlyLove;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_Simp_NoFoodOnlyLove;
		this.m.Icon = "ui/perks/perk_simp_no_food_only_love.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.IsNew)
			return;

		if (!::MSU.isKindOf(this.getContainer().getActor(), "player"))
			return;

		if (this.getContainer().getActor().getBackground() == null)
			return;

		foreach (row in this.getContainer().getActor().getBackground().m.PerkTree)
		{
			foreach (perk in row)
			{
				if (perk.ID != this.m.ID)
					continue;

				perk.IsRefundable = false;
				break;
			}
		}

		this.getContainer().getActor().m.PerkPointsSpent += 1;
		this.m.IsNew = false;
	}

	function refund()
	{
		if (this.m.HasRefund)
			return;

		this.m.HasRefund = true;
		this.getContainer().getActor().m.PerkPoints += 1;
	}

	function onAfterUpdate( _properties )
	{
		local simp = this.getContainer().getSkillByID("effects.simp");

		if (simp == null || simp.getSimpLevel() < 1)
			return;

		_properties.XPGainMult *= 0.5;
		_properties.DailyFood *= 0.0;
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeBool(this.m.HasRefund);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.HasRefund = _in.readBool();
	}

});

