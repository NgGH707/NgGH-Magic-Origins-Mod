this.perk_nggh_simp_level_up <- ::inherit("scripts/skills/skill", {
	m = {
		LearntPerkAtLevel = 1,
		RequiredLevels = 2,
	},
	function create()
	{
		this.m.ID = "perk.simp_level_up";
		this.m.Name = ::Const.Strings.PerkName.NggH_Simp_LevelUp;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_Simp_LevelUp;
		this.m.Icon = "ui/perks/perk_simp_level_up.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
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

		local simp = this.getContainer().getSkillByID("effects.simp");

		if (simp != null)
			simp.gainSimpLevel();

		this.getContainer().getActor().m.PerkPointsSpent += 1;
		this.m.LearntPerkAtLevel = this.getContainer().getActor().getLevel();
		this.m.IsNew = false;
	}

	function onUpdateLevel()
	{
		local simp = this.getContainer().getSkillByID("effects.simp");

		if (simp == null)
			return;

		local lv = this.getContainer().getActor().getLevel();

		if (lv < this.m.LearntPerkAtLevel)
			return;

		if ((lv - this.m.LearntPerkAtLevel) % this.m.RequiredLevels != 0)
			return;

		simp.gainSimpLevel();
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU8(this.m.LearntPerkAtLevel);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.LearntPerkAtLevel = _in.readU8();
	}

});

