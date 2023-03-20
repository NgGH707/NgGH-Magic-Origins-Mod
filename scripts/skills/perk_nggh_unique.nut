this.perk_nggh_unique <- ::inherit("scripts/skills/skill", {
	m = {
		PerkGroup = null,
	},

	function onAdded()
	{
		foreach (row in this.m.PerkGroup.Tree)
		{
			foreach (perkConst in row)
			{
				local def = ::Const.Perks.PerkDefObjects[perkConst];

				if (def.ID == this.getID()) continue;

				local perk = ::new("scripts/skills/perk_nggh_locked");
				perk.setDescription(def.Tooltip);
				perk.setID(def.ID);
				this.getContainer().add(perk);
			}
		}
	}

	function onRemoved()
	{
		foreach (row in this.m.PerkGroup.Tree)
		{
			foreach (perkConst in row)
			{
				local def = ::Const.Perks.PerkDefObjects[perkConst];

				if (def.ID == this.getID()) continue;

				this.getContainer().removeByID(def.ID);
			}
		}
	}

});

