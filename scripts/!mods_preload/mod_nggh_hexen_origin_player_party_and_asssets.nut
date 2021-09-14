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
				
				if (this.isKindOf(bro, "mortar_entity"))
				{
					continue;
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
	::mods_hookNewObject("states/world/asset_manager", function ( obj )
	{
		obj.updateLook = function( _updateTo = -1 )
		{
			if (_updateTo != -1)
			{
				this.m.Look = _updateTo;
			}
			
			if (this.m.Look > 9000)
			{
				if (this.World.State.getPlayer() != null)
				{
					this.World.State.getPlayer().getSprite("body").setBrush("figure_player_" + this.m.Look);
				}
				
				return;
			}

			this.World.State.getPlayer().setBaseImage(this.m.Look);
		}
		
		obj.update = function( _worldState )
		{
			if (this.World.getTime().Days > this.m.LastDayPaid && this.World.getTime().Hours > 8 && this.m.IsConsumingAssets)
			{
				this.m.LastDayPaid = this.World.getTime().Days;

				if (this.m.BusinessReputation > 0)
				{
					this.m.BusinessReputation = this.Math.max(0, this.m.BusinessReputation + this.Const.World.Assets.ReputationDaily);
				}

				this.World.Retinue.onNewDay();

				if (this.World.Flags.get("IsGoldenGoose") == true)
				{
					this.addMoney(30);
				}

				local roster = this.World.getPlayerRoster().getAll();
				local mood = 0;
				local slaves = 0;
				local nonSlaves = 0;

				if (this.m.Origin.getID() == "scenario.manhunters")
				{
					foreach( bro in roster )
					{
						if (bro.getBackground().getID() == "background.slave")
						{
							slaves = ++slaves;
							slaves = slaves;
						}
						else
						{
							nonSlaves = ++nonSlaves;
							nonSlaves = nonSlaves;
						}
					}
				}

				local items = this.World.Assets.getStash().getItems();

				foreach( item in items )
				{
					if (item == null)
					{
						continue;
					}

					item.onNewDay();
				}

				local companyRep = this.World.Assets.getMoralReputation() / 10;

				foreach( bro in roster )
				{
					bro.getSkills().onNewDay();
					bro.updateInjuryVisuals();

					if (this.World.Assets.getOrigin().getID() == "scenario.legends_troupe")
					{
						this.addMoney(10);
					}

					if (bro.getDailyCost() > 0 && this.m.Money < bro.getDailyCost())
					{
						if (bro.getSkills().hasSkill("trait.greedy"))
						{
							bro.worsenMood(this.Const.MoodChange.NotPaidGreedy, "Did not get paid");
						}
						else
						{
							bro.worsenMood(this.Const.MoodChange.NotPaid, "Did not get paid");
						}
					}

					if (bro.getSkills().hasSkill("perk.legend_pacifist"))
					{
						local hireTime = bro.getHireTime();
						local currentTime = this.World.getTime().Time;
						local servedTime = currentTime - hireTime;
						local servedDays = servedTime / this.World.getTime().SecondsPerDay;

						if (servedDays * 7 < bro.getLifetimeStats().Kills)
						{
							bro.worsenMood(this.Const.MoodChange.BattleWithoutMe, "Remembers being forced to kill against their wishes");
						}
					}

					if (this.m.IsUsingProvisions && this.m.Food < bro.getDailyFood())
					{
						if (bro.getSkills().hasSkill("trait.spartan"))
						{
							bro.worsenMood(this.Const.MoodChange.NotEatenSpartan, "Went hungry");
						}
						else if (bro.getSkills().hasSkill("trait.gluttonous"))
						{
							bro.worsenMood(this.Const.MoodChange.NotEatenGluttonous, "Went hungry");
						}
						else
						{
							bro.worsenMood(this.Const.MoodChange.NotEaten, "Went hungry");
						}
					}

					if (this.m.Origin.getID() == "scenario.manhunters" && slaves <= nonSlaves)
					{
						if (bro.getBackground().getID() != "background.slave")
						{
							bro.worsenMood(this.Const.MoodChange.TooFewSlaves, "Too few indebted in the company");
						}
					}

					this.m.Money -= bro.getDailyCost();
					mood = mood + bro.getMoodState();
				}

				this.Sound.play(this.Const.Sound.MoneyTransaction[this.Math.rand(0, this.Const.Sound.MoneyTransaction.len() - 1)], this.Const.Sound.Volume.Inventory);
				this.m.AverageMoodState = this.Math.round(mood / roster.len());
				_worldState.updateTopbarAssets();

				if (this.m.EconomicDifficulty >= 1 && this.m.CombatDifficulty >= 1)
				{
					if (this.World.getTime().Days >= 365)
					{
						this.updateAchievement("Anniversary", 1, 1);
					}
					else if (this.World.getTime().Days >= 100)
					{
						this.updateAchievement("Campaigner", 1, 1);
					}
					else if (this.World.getTime().Days >= 10)
					{
						this.updateAchievement("Survivor", 1, 1);
					}
				}
			}

			if (this.World.getTime().Hours != this.m.LastHourUpdated && this.m.IsConsumingAssets)
			{
				this.m.LastHourUpdated = this.World.getTime().Hours;
				this.consumeFood();
				local roster = this.World.getPlayerRoster().getAll();
				local campMultiplier = this.isCamping() ? 1.5 : 1.0;

				foreach( bro in roster )
				{
					local d = bro.getHitpointsMax() - bro.getHitpoints();

					if (bro.getHitpoints() < bro.getHitpointsMax())
					{
						if (this.isKindOf(bro, "mortar_entity"))
						{
						}
						else if (bro.getFlags().has("undead"))
						{
							bro.setHitpoints(this.Math.minf(bro.getHitpointsMax(), bro.getHitpoints() + this.Const.World.Assets.HitpointsPerHour / 10 * this.Const.Difficulty.HealMult[this.World.Assets.getEconomicDifficulty()] * this.m.HitpointsPerHourMult));
						}
						else if ("getHealthRecoverMult" in bro)
						{
							bro.setHitpoints(this.Math.minf(bro.getHitpointsMax(), bro.getHitpoints() + this.Const.World.Assets.HitpointsPerHour * bro.getHealthRecoverMult() * this.Const.Difficulty.HealMult[this.World.Assets.getEconomicDifficulty()] * this.m.HitpointsPerHourMult));
						}
						else
						{
							bro.setHitpoints(this.Math.minf(bro.getHitpointsMax(), bro.getHitpoints() + this.Const.World.Assets.HitpointsPerHour * this.Const.Difficulty.HealMult[this.World.Assets.getEconomicDifficulty()] * this.m.HitpointsPerHourMult));
						}
					}
					
					if (this.isKindOf(bro, "player_beast"))
					{
						bro.restoreArmor();
					}
				}

				foreach( bro in roster )
				{
					local perkMod = 1.0;

					if (this.m.ArmorParts == 0)
					{
						break;
					}

					if (this.isCamping())
					{
						break;
					}

					local items = bro.getItems().getAllItems();
					local updateBro = false;
					local skills = [
						"perk.legend_tools_spares",
						"perk.legend_tools_drawers"
					];

					foreach( s in skills )
					{
						local skill = bro.getSkills().getSkillByID(s);

						if (skill != null)
						{
							perkMod = perkMod * (1 - skill.getModifier() * 0.01);
						}
					}

					foreach( item in items )
					{
						if (item.getRepair() < item.getRepairMax())
						{
							local d = this.Math.ceil(this.Math.minf(this.Const.World.Assets.ArmorPerHour * this.Const.Difficulty.RepairMult[this.World.Assets.getEconomicDifficulty()] * this.m.RepairSpeedMult, item.getRepairMax() - item.getRepair()));
							item.onRepair(item.getRepair() + d);
							this.m.ArmorParts = this.Math.maxf(0, this.m.ArmorParts - d * this.m.ArmorPartsPerArmor * perkMod);
							updateBro = true;
						}

						if (item.getRepair() >= item.getRepairMax())
						{
							item.setToBeRepaired(false, 0);
						}

						if (this.m.ArmorParts == 0)
						{
							break;
						}

						if (updateBro)
						{
							break;
						}
					}

					if (updateBro)
					{
						bro.getSkills().update();
					}
				}

				local items = this.m.Stash.getItems();
				local stashmaxrepairpotential = this.Math.ceil(roster.len() * this.Const.Difficulty.RepairMult[this.World.Assets.getEconomicDifficulty()] * this.m.RepairSpeedMult * this.Const.World.Assets.ArmorPerHour);

				foreach( item in items )
				{
					if (this.isCamping())
					{
						break;
					}

					if (this.m.ArmorParts == 0)
					{
						break;
					}

					if (stashmaxrepairpotential <= 0)
					{
						break;
					}

					if (item == null)
					{
						continue;
					}

					if (item.isToBeRepaired())
					{
						if (item.getRepair() < item.getRepairMax())
						{
							local d = this.Math.ceil(this.Math.minf(stashmaxrepairpotential, item.getRepairMax() - item.getRepair()));
							item.onRepair(item.getRepair() + d);
							this.m.ArmorParts = this.Math.maxf(0, this.m.ArmorParts - d * this.m.ArmorPartsPerArmor);
							stashmaxrepairpotential = stashmaxrepairpotential - d;
						}

						if (item.getRepair() >= item.getRepairMax())
						{
							item.setToBeRepaired(false, 0);
						}
					}
				}

				if (this.World.getTime().Hours % 4 == 0)
				{
					if (this.getOrigin().getID() == "scenario.hexen")
					{
						this.checkSuicide();
					}
					
					this.checkDesertion();
					
					local towns = this.World.EntityManager.getSettlements();
					local playerTile = this.World.State.getPlayer().getTile();
					local town;

					foreach( t in towns )
					{
						if (t.getSize() >= 2 && !t.isMilitary() && t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
						{
							town = t;
							break;
						}
					}

					foreach( bro in roster )
					{
						bro.recoverMood();

						if (town != null && bro.getMoodState() <= this.Const.MoodState.Neutral)
						{
							bro.improveMood(this.Const.MoodChange.NearCity, "Has enjoyed the visit to " + town.getName());
						}
					}
				}

				_worldState.updateTopbarAssets();
			}

			if (this.World.getTime().Days > this.m.LastDayResourcesUpdated + 7)
			{
				this.m.LastDayResourcesUpdated = this.World.getTime().Days;

				foreach( t in this.World.EntityManager.getSettlements() )
				{
					t.addNewResources();
				}
			}

			if (this.LegendsMod.Configs().m.IsHelmets == 1)
			{
				this.LegendsMod.Configs().m.IsHelmets += this.Const.DLC.Wildmen && this.Const.DLC.Desert ? 1 : 0;
			}

			local excluded_contracts = [
				"contract.patrol",
				"contract.escort_envoy"
			];
			local activeContract = this.World.Contracts.getActiveContract();

			if (activeContract && this.World.FactionManager.getFaction(activeContract.getFaction()).m.Type == this.Const.FactionType.NobleHouse && excluded_contracts.find(activeContract.m.Type) == null && (activeContract.getActiveState().ID == "Return" || activeContract.m.Type == "contract.big_game_hunt" && activeContract.getActiveState().Flags.get("HeadsCollected") != 0))
			{
				local contract_faction = this.World.FactionManager.getFaction(activeContract.getFaction());
				local towns = contract_faction.getSettlements();

				if (!activeContract.m.Flags.get("UpdatedBulletpoints"))
				{
					activeContract.m.BulletpointsObjectives.pop();

					if (activeContract.m.Type == "contract.big_game_hunt")
					{
						activeContract.m.BulletpointsObjectives.push("Return to any town of " + contract_faction.getName() + " to get paid");
					}
					else
					{
						activeContract.m.BulletpointsObjectives.push("Return to any town of " + contract_faction.getName());
					}

					activeContract.m.Flags.set("UpdatedBulletpoints", true);

					foreach( town in towns )
					{
						town.getSprite("selection").Visible = true;
					}

					this.World.State.getWorldScreen().updateContract(activeContract);
				}

				foreach( town in towns )
				{
					if (activeContract.isPlayerAt(town))
					{
						activeContract.m.Home = this.WeakTableRef(town);
						break;
					}
				}
			}
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