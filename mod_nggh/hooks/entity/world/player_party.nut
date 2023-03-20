::mods_hookExactClass("entity/world/player_party", function ( obj )
{
	obj.updateStrength = function()
	{
		this.m.Strength = 0.0;
		local roster = ::World.getPlayerRoster().getAll();

		if (roster.len() > ::World.Assets.getBrothersScaleMax())
		{
			roster.sort(this.onLevelCompare);
		}
		if (roster.len() < ::World.Assets.getBrothersScaleMin())
		{
			this.m.Strength += 10.0 * (::World.Assets.getBrothersScaleMin() - roster.len());
		}

		if (::World.Assets.getOrigin() == null)
		{
			this.m.Strength * 0.8;
			return;
		}

		local broScale = 1.0;
		if (::World.Assets.getOrigin().getID() == "scenario.militia")
		{
			broScale = 0.66;
		}

		if (::World.Assets.getOrigin().getID() == "scenario.lone_wolf")
		{
			broScale = 1.66;
		}

		local zombieSummonLevel = 0
		local skeletonSummonLevel = 0

		local count = 0;
		foreach( i, bro in roster )
		{
			if (i >= 25)
			{
				break;
			}

			if (bro.getSkills().hasSkill("perk.legend_pacifist"))
			{
				continue;
			}

			local mult = 1.0;
			local brolevel = bro.getLevel();

			if (bro.getFlags().has("nggh_character"))
			{
				mult *= bro.getStrengthMult();
			}

			/*
			if (bro.isMounted())
			{
				mult *= 1.25;
			}
			*/

			if (bro.getSkills().hasSkill("racial.champion"))
			{
				mult *= 1.4;
			}

			if (this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Easy)
			{
				this.m.Strength += (3 + ((brolevel / 4) + (brolevel - 1)) * 1.5) * broScale * mult;
			}
			else if (this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Normal)
			{
				this.m.Strength += (10 + ((brolevel / 2) + (brolevel - 1)) * 2) * broScale * mult;
			}
			else if (this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Hard)
			{
				this.m.Strength += (6 + (count / 2) + ((brolevel / 2) + (pow(brolevel,1.2)))) * broScale * mult;
			}
			else if (this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary )
			{
				this.m.Strength += (count + (brolevel + (pow(brolevel,1.2)))) * broScale * mult;
			}

			// item scaling
			local mainhand = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local offhand = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			local body = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
			local head = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
			local mainhandvalue = 0;
			local offhandvalue = 0;
			local bodyvalue = 0;
			local headvalue = 0;
			local gearMult = 1.0;

			if (bro.getSkills().hasSkill("special.cosmetic"))
			{
				gearMult = 0.0;
			}

			if (mainhand != null)
			{
				mainhandvalue += (mainhand.getSellPrice())  / 1000;
			}

			if (offhand != null)
			{
				offhandvalue += (offhand.getSellPrice()) / 1000;
			}

			if (body != null)
			{
				bodyvalue += (body.getSellPrice()) / 1000;
			}

			if (head != null)
			{
				headvalue += (head.getSellPrice()) / 1000;
			}

			this.m.Strength += mainhandvalue + offhandvalue + (bodyvalue + headvalue) * gearMult;
			// item scaling end

			if (bro.getSkills().hasSkill("perk.legend_spawn_zombie_high"))
			{
				zombieSummonLevel = 7;
			}
			else if (bro.getSkills().hasSkill("perk.legend_spawn_zombie_med"))
			{
				zombieSummonLevel = 5;
			}
			else if (bro.getSkills().hasSkill("perk.legend_spawn_zombie_low"))
			{
				zombieSummonLevel = 2;
			}

			if (bro.getSkills().hasSkill("perk.legend_spawn_skeleton_high"))
			{
				skeletonSummonLevel = 7;
			}
			else if (bro.getSkills().hasSkill("perk.legend_spawn_skeleton_med"))
			{
				skeletonSummonLevel = 5;
			}
			else if (bro.getSkills().hasSkill("perk.legend_spawn_skeleton_low"))
			{
				skeletonSummonLevel = 2;
			}

			count++;
		}

		if (zombieSummonLevel == 0 && skeletonSummonLevel == 0)
		{
			return
		}

		//When playing a warlock build, we need to account for the summons he can add
		local stash = this.World.Assets.getStash().getItems();

		local zCount = 0
		local sCount = 0
		foreach (item in stash)
		{
			if (item == null)
			{
				continue;
			}

			switch( item.getID())
			{
				case "spawns.zombie":
					if (zombieSummonLevel == 0)
					{
						continue
					}
					++zCount;

					break;
				case "spawns.skeleton":
					if (skeletonSummonLevel == 0)
					{
						continue
					}
					++sCount;
					break;
			}
		}

		if (zCount > 1)
		{
			zCount = this.Math.floor(zCount / 2.0);
			for (local i = 0; i < zCount; ++i)
			{
				this.m.Strength += 3 + (((zombieSummonLevel / 2) + (zombieSummonLevel - 1)) * 2.0);
			}
		}
		if (sCount > 1)
		{
			sCount = this.Math.floor(sCount / 2.0);
			for (local i = 0; i < sCount; ++i)
			{
				this.m.Strength += 3 + (((skeletonSummonLevel / 2) + (skeletonSummonLevel - 1)) * 2.0);
			}
		}
	}
});