this.getroottable().HexenHooks.hookPlayerPartyAndAssets <- function ()
{
	//update a new party strength calculation for hexe origin
	::mods_hookNewObject("entity/world/player_party", function ( obj )
	{
		local oldFunction = ::mods_getMember(obj, "updateStrength");
		
		local newFunction = function()
		{
			this.m.Strength = 0.0;
			local roster = this.World.getPlayerRoster().getAll();

			if (roster.len() > this.World.Assets.getBrothersScaleMax())
			{
				roster.sort(this.onLevelCompare);
			}

			if (roster.len() < this.World.Assets.getBrothersScaleMin())
			{
				this.m.Strength += 10.0 * (this.World.Assets.getBrothersScaleMin() - roster.len());
			}

			if (this.World.Assets.getOrigin() == null)
			{
				this.m.Strength * 0.8;
				return;
			}

			local broScale = 1.0;

			if (this.World.Assets.getOrigin().getID() == "scenario.militia")
			{
				broScale = 0.66;
			}

			local zombieSummonLevel = 0;
			local skeletonSummonLevel = 0;
			local count = 0;

			foreach( i, bro in roster )
			{
				if (i >= 27)
				{
					break;
				}
				
				if (bro.getSkills().hasSkill("perk.legend_pacifist"))
				{
					continue;
				}

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
				
				local hexeOriginMult = 1.0;
				
				if (bro.getFlags().has("bewitched"))
				{
					if ("getStrength" in bro)
					{
						hexeOriginMult = bro.getStrength();
					}
					else 
					{
						hexeOriginMult = 1.1;    
					}
				}
				
				hexeOriginMult = hexeOriginMult * (bro.getSkills().hasSkill("racial.champion") ? 1.33 : 1.0);
				local brolevel = bro.getLevel();

				if (this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Easy)
				{
					this.m.Strength += (3 + (brolevel / 4 + (brolevel - 1)) * 1.5) * broScale * hexeOriginMult;
				}
				else if (this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Normal)
				{
					this.m.Strength += (10 + (brolevel / 2 + (brolevel - 1)) * 2) * broScale * hexeOriginMult;
				}
				else if (this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Hard)
				{
					this.m.Strength += (6 + count / 2 + (brolevel / 2 + this.pow(brolevel, 1.2))) * broScale * hexeOriginMult;
				}
				else if (this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
				{
					this.m.Strength += (count + (brolevel + this.pow(brolevel, 1.2))) * broScale * hexeOriginMult;
				}

				if (this.LegendsMod.Configs().LegendItemScalingEnabled())
				{
					local mult = 1.0;
					local mainhand = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
					local offhand = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
					local body = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
					local head = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
					local mainhandvalue = 0;
					local offhandvalue = 0;
					local bodyvalue = 0;
					local headvalue = 0;

					if (bro.getSkills().hasSkill("special.cosmetic"))
					{
						mult = 0.0;
					}

					if (mainhand != null)
					{
						mainhandvalue = mainhandvalue + mainhand.getSellPrice() / 1000;
					}

					if (offhand != null)
					{
						offhandvalue = offhandvalue + offhand.getSellPrice() / 1000;
					}

					if (body != null)
					{
						bodyvalue = (bodyvalue + body.getSellPrice() / 1000) * mult;
					}

					if (head != null)
					{
						headvalue = (headvalue + head.getSellPrice() / 1000) * mult;
					}

					local gearvalue = mainhandvalue + offhandvalue + bodyvalue + headvalue;
					this.m.Strength += gearvalue;
				}

				count++;
			}

			if (zombieSummonLevel == 0 && skeletonSummonLevel == 0)
			{
				return;
			}

			local stash = this.World.Assets.getStash().getItems();
			local zCount = 0;
			local sCount = 0;

			foreach( item in stash )
			{
				if (item == null)
				{
					continue;
				}

				switch(item.getID())
				{
				case "spawns.zombie":
					if (zombieSummonLevel == 0)
					{
						continue;
					}

					zCount = ++zCount;
					break;

				case "spawns.skeleton":
					if (skeletonSummonLevel == 0)
					{
						continue;
					}

					sCount = ++sCount;
					break;
				}
			}

			if (zCount > 1)
			{
				zCount = this.Math.floor(zCount / 2.0);

				for( local i = 0; i < zCount; i = i )
				{
					this.m.Strength += 3 + (zombieSummonLevel / 2 + (zombieSummonLevel - 1)) * 2.0;
					i = ++i;
				}
			}

			if (sCount > 1)
			{
				sCount = this.Math.floor(sCount / 2.0);

				for( local i = 0; i < sCount; i = i )
				{
					this.m.Strength += 3 + (skeletonSummonLevel / 2 + (skeletonSummonLevel - 1)) * 2.0;
					i = ++i;
				}
			}
		};
		
		obj.updateStrength = function()
		{
			newFunction();
		}
	});

	//Hook to help non-human have more suitable health recovery
	::mods_hookNewObjectOnce("states/world/asset_manager", function ( obj )
	{	
		local updateLook = obj.updateLook;
		obj.updateLook = function( _updateTo = -1 )
		{
			if (_updateTo > 9000)
			{
				this.m.Look = _updateTo;

				if (this.World.State.getPlayer() != null)
				{
					this.World.State.getPlayer().getSprite("body").setBrush("figure_player_" + this.m.Look);
				}
				
				return;
			}

			updateLook(_updateTo);
		}
		
		local update = obj.update;
		obj.update = function( _worldState )
		{
			if (this.World.getTime().Hours != this.m.LastHourUpdated && this.m.IsConsumingAssets)
			{
				local roster = this.World.getPlayerRoster().getAll();

				foreach( bro in roster )
				{
					local d = bro.getHitpointsMax() - bro.getHitpoints();

					if (bro.getHitpoints() < bro.getHitpointsMax() && ("getHealthRecoverMult" in bro))
					{
						bro.setHitpoints(this.Math.minf(bro.getHitpointsMax(), bro.getHitpoints() + this.Const.World.Assets.HitpointsPerHour * bro.getHealthRecoverMult() * this.Const.Difficulty.HealMult[this.World.Assets.getEconomicDifficulty()] * this.m.HitpointsPerHourMult));
					}
					
					if (this.isKindOf(bro, "player_beast"))
					{
						bro.restoreArmor();
					}
				}
			}

			if (this.World.getTime().Hours % 4 == 0)
			{
				if (this.getOrigin().getID() == "scenario.hexen")
				{
					this.checkSuicide();
				}
			}

			update(_worldState);
		}
		
		obj.checkSuicide <- function()
		{
			if (!this.World.Events.canFireEvent())
			{
				return;
			}

			local roster = this.World.getPlayerRoster().getAll();
			local candidates = [];

			foreach( bro in roster )
			{
				if (bro.getFlags().has("IsPlayerCharacter"))
				{
					continue;
				}

				if (bro.getMood() < 1.0)
				{
					local chance = (1.0 - bro.getMood()) * 115;

					if (this.Math.rand(1, 100) <= chance)
					{
						candidates.push(bro);
					}
				}
			}

			if (candidates.len() != 0)
			{
				local bro = candidates[this.Math.rand(0, candidates.len() - 1)];

				if (this.World.getPlayerRoster().getSize() > 1)
				{
					local event = this.World.Events.getEvent("event.suicide");
					event.setSuicider(bro);
					this.World.Events.fire("event.suicide", false);
				}
				else
				{
					this.World.State.showGameFinishScreen(false);
				}
			}
		}
		
	});

	delete this.HexenHooks.hookPlayerPartyAndAssets;
}