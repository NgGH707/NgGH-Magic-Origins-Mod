::mods_hookExactClass("entity/world/player_party", function ( obj )
{
	obj.updateStrength = function()
	{
		this.m.Strength = 0.0;
		local roster = ::World.getPlayerRoster().getAll();

		if (roster.len() > ::World.Assets.getBrothersScaleMax())
			roster.sort(this.onLevelCompare);
		
		if (roster.len() < ::World.Assets.getBrothersScaleMin())
			this.m.Strength += 10.0 * (::World.Assets.getBrothersScaleMin() - roster.len());

		if (::World.Assets.getOrigin() == null)
		{
			this.m.Strength * 0.8;
			return;
		}

		local broScale = 1.0;
		local zombieSummonLevel = 0, skeletonSummonLevel = 0 count = 0;

		if (::World.Assets.getOrigin().getID() == "scenario.militia")
			broScale = 0.66;
		else if (::World.Assets.getOrigin().getID() == "scenario.lone_wolf")
			broScale = 1.66;

		foreach( i, bro in roster )
		{
			if (i >= ::World.Assets.getBrothersScaleMax())
				break;

			if (bro.getSkills().hasSkill("perk.legend_pacifist"))
				continue;

			local mult = 1.0;
			local brolevel = bro.getLevel();

			if (bro.getFlags().has("nggh_character"))
				mult *= bro.getStrengthMult();

			if (bro.getSkills().hasSkill("racial.champion"))
				mult *= 1.25;

			switch(::World.Assets.getCombatDifficulty())
			{
			case ::Const.Difficulty.Easy:
				this.m.Strength += (3 + ((brolevel / 4) + (brolevel - 1)) * 1.5) * broScale * mult;
				break;

			case ::Const.Difficulty.Normal:
				this.m.Strength += (10 + ((brolevel / 2) + (brolevel - 1)) * 2) * broScale * mult;
				break;

			case ::Const.Difficulty.Hard:
				this.m.Strength += (6 + (count / 2) + ((brolevel / 2) + (pow(brolevel,1.2)))) * broScale * mult;
				break;

			case ::Const.Difficulty.Legendary:
				this.m.Strength += (count + (brolevel + (pow(brolevel,1.2)))) * broScale * mult;
				break;
			}

			// item scaling
			local gearValue = 0;
			local gearMult = 1.0;

			if (::Nggh_MagicConcept.IsCosmeticEnable && bro.getSkills().hasSkill("special.cosmetic"))
				gearMult = 0.0;

			for(local i = ::Const.ItemSlot.Mainhand; i <= ::Const.ItemSlot.Head; ++i)
			{
				local item = bro.getItems().getItemAtSlot(i);

				if (item == null) continue;

				gearValue += ::Math.floor(item.getValue() * ::Const.World.Assets.BaseSellPrice);
			}

			this.m.Strength += gearValue * gearMult / 1000;
			// item scaling end
		}
	}
});