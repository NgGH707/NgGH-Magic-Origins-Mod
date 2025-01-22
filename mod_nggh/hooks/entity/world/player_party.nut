::Nggh_MagicConcept.HooksMod.hook("scripts/entity/world/player_party", function ( q )
{
	q.updateStrength = @(__original) function()
	{
		__original();

		local count = 0;
		local enableCosmetic = ::Nggh_MagicConcept.Mod.ModSettings.getSetting("cosmetic_helmet").getValue();
		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (count >= ::World.Assets.getBrothersScaleMax())
				break;

			if (bro.getSkills().hasSkill("perk.legend_pacifist"))
				continue;

			local mult = 1.0, brolevel = bro.getLevel();

			if (bro.getFlags().has("nggh_character"))
				mult *= bro.getStrengthMult();

			if (bro.getSkills().hasSkill("racial.champion"))
				mult *= 1.25;

			++count;
			mult -= 1.0;
			switch(::World.Assets.getCombatDifficulty())
			{
			case ::Const.Difficulty.Easy:
				m.Strength += (3 + ((brolevel / 4) + (brolevel - 1)) * 1.5) * mult;
				break;

			case ::Const.Difficulty.Normal:
				m.Strength += (10 + ((brolevel / 2) + (brolevel - 1)) * 2) * mult;
				break;

			case ::Const.Difficulty.Hard:
				m.Strength += (6 + (count / 2) + ((brolevel / 2) + (pow(brolevel,1.2))))* mult;
				break;

			case ::Const.Difficulty.Legendary:
				m.Strength += (count + (brolevel + (pow(brolevel,1.2)))) * mult;
				break;
			}

			if (!enableCosmetic || !bro.getSkills().hasSkill("special.cosmetic"))
				continue;

			// item scaling
			local gearValue = 0, gearMult = 1.0;

			for(local i = ::Const.ItemSlot.Mainhand; i <= ::Const.ItemSlot.Head; ++i)
			{
				local item = bro.getItems().getItemAtSlot(i);

				if (item == null) continue;

				gearValue += ::Math.floor(item.getValue() * ::Const.World.Assets.BaseSellPrice);
			}

			m.Strength -= gearValue * gearMult / 1000;
		}
	}
});