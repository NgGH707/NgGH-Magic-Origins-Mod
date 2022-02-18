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

				if (bro.getSkills().hasSkill("actives.mc_earthen_puppet"))
				{
					hexeOriginMult *= 2.0;
				}
				
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
		local update = obj.update;
		obj.update = function( _worldState )
		{
			if (this.World.getTime().Hours != this.m.LastHourUpdated && this.m.IsConsumingAssets)
			{
				local roster = this.World.getPlayerRoster().getAll();
				local hasButcher = false;
				local butchers = [
					"background.female_butcher",
		            "background.butcher",
		            "background.hunter",
		            "background.legend_cannibal",
		            "background.legend_preserver",
				];

				foreach( bro in roster )
				{
					local d = bro.getHitpointsMax() - bro.getHitpoints();
					local NineLives = bro.getSkills().getSkillByID("perk.nine_lives");

					if (bro.getHitpoints() < bro.getHitpointsMax() && ("getHealthRecoverMult" in bro))
					{
						bro.setHitpoints(this.Math.minf(bro.getHitpointsMax(), bro.getHitpoints() + this.Const.World.Assets.HitpointsPerHour * bro.getHealthRecoverMult() * this.Const.Difficulty.HealMult[this.World.Assets.getEconomicDifficulty()] * this.m.HitpointsPerHourMult));
					}
					
					if (this.isKindOf(bro, "player_beast"))
					{
						bro.restoreArmor();
					}

					if (!hasButcher && butchers.find(bro.getBackground().getID()) != null)
					{
						hasButcher = true;
					}

					if (NineLives != null && this.World.getTime().Hours % 12 == 0)
					{
						NineLives.restoreLife()
					}
				}

				if (this.World.getTime().Hours % 4 == 0)
				{
					if (this.getOrigin().getID() == "scenario.hexen")
					{
						this.checkSuicide();
					}
				}

				local checkDecay = this.World.getTime().Hours % 4 == 0;
				local stashmaxbutcheringpotential = this.Math.ceil(roster.len() * this.Const.Difficulty.ButcherMult[this.World.Assets.getEconomicDifficulty()] * this.m.HitpointsPerHourMult * 4 * (hasButcher ? 1.25 : 1.0));
				local stash = this.getStash();
				local butcher_products = [];

				foreach (index, item in stash.getItems())
				{
					if (item == null)
					{
						continue;
					}

					if (!item.isItemType(this.Const.Items.ItemType.Corpse))
					{
						continue;
					}

					if (!this.isCamping() && item.isToBeButchered() && stashmaxbutcheringpotential > 0)
					{
						local needed =  item.getCondition() - item.getConditionHasBeenProcessed();
						local d = this.Math.ceil(this.Math.minf(stashmaxbutcheringpotential, needed));

						if (d > 0)
						{
							local mod = item.getConditionMax() >= 500 ? 0.67 : 1.0;
							item.setProcessedCondition(item.getConditionHasBeenProcessed() + d);
							stashmaxbutcheringpotential = stashmaxbutcheringpotential - this.Math.floor(d * mod);
						}

						if (d <= 0 || item.getConditionHasBeenProcessed() >= item.getCondition())
			            {
			                local products =  item.onButchered();
			                if (products.len() > 0) butcher_products.extend(products);
			                item.setGarbage();
			            }
					}
					
					if (!item.isGarbage() && checkDecay) item.onLoseCondition();
				}

				stash.collectGarbage();
				local emptySlots = stash.getNumberOfEmptySlots();

				foreach (p in butcher_products)
                {
                    if (--emptySlots >= 0) stash.add(p);
                }
			}

			update(_worldState);
		};
		
		obj.checkSuicide <- function()
		{
			if (!this.World.Events.canFireEvent())
			{
				return;
			}

			local roster = this.World.getPlayerRoster().getAll();
			local candidates = [];
			local deserters = [];
			local deserting_chance = this.World.Flags.get("isExposed") ? 75 : 10;

			foreach( bro in roster )
			{
				if (bro.getFlags().has("IsPlayerCharacter"))
				{
					continue;
				}

				if (bro.getSkills().hasSkill("effects.fake_charmed_broken"))
				{
					if (this.Math.rand(1, 100) <= deserting_chance)
					{
						deserters.push(bro);
					}
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

			if (deserters.len() != 0) 
			{
				local bro = deserters[this.Math.rand(0, deserters.len() - 1)];

				if (this.World.getPlayerRoster().getSize() > 1)
				{
					local event = this.World.Events.getEvent("event.desertion");
					event.setDeserter(bro);
					this.World.Events.fire("event.desertion", false);
				}
				else
				{
					this.World.State.showGameFinishScreen(false);
				}
			}
			else if (candidates.len() != 0)
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


	::mods_hookNewObject("states/world/camp_manager", function(obj)
	{
		local tent = this.new("scripts/entity/world/camp/buildings/butcher_building");
		tent.setCamp(obj);
		obj.m.Tents.insert(obj.m.Tents.len() - 2, tent);
	
		local ws_onDeserialize = obj.onDeserialize;
		obj.onDeserialize = function( _in )
		{
			ws_onDeserialize(_in);

			if (this.getBuildingByID(this.Const.World.CampBuildings.Butcher) == null)
			{
				local tent = this.new("scripts/entity/world/camp/buildings/butcher_building");
				tent.setCamp(this);
				this.m.Tents.insert(this.m.Tents.len() - 2, tent);
			}
		};
	});

	local attached_locations = [
		"trapper_location",
		"leather_tanner_location",
		"hunters_cabin_location",
		"goat_herd_location",
		"goat_herd_oriental_location",
	];

	foreach (name in attached_locations)
	{
		::mods_hookExactClass("entity/world/attached_location", function(obj)
		{
			local ws_onUpdateShopList = obj.onUpdateShopList;
			obj.onUpdateShopList = function( _id, _list )
			{
				if (_id == "building.marketplace")
				{
					_list.push({
						R = 80,
						P = 1.0,
						S = "tents/tent_butcher"
					});
				}

				ws_onUpdateShopList(_id, _list);
			}
		});
	}


	::mods_hookNewObject("entity/tactical/tactical_entity_manager", function(obj) 
	{
		local ws_onResurrect = obj.onResurrect;
		obj.onResurrect = function( _info, _force = false )
		{
			if (!("PlayerID" in _info))
			{
				return ws_onResurrect(_info, _force);
			}
			
			if (this.Tactical.State.m.TacticalDialogScreen.isVisible() || this.Tactical.State.m.TacticalDialogScreen.isAnimating())
			{
				this.Time.scheduleEvent(this.TimeUnit.Rounds, 1, this.Tactical.Entities.resurrect, _info);
				return null;
			}

			if (this.Tactical.Entities.isCombatFinished() || !_force && this.Tactical.Entities.isEnemyRetreating())
			{
				return null;
			}

			local targetTile = _info.Tile;

			if (!targetTile.IsEmpty)
			{
				local knockToTile;

				for( local i = 0; i < this.Const.Direction.COUNT; i = ++i )
				{
					if (!targetTile.hasNextTile(i))
					{
					}
					else
					{
						local newTile = targetTile.getNextTile(i);

						if (!newTile.IsEmpty || newTile.IsCorpseSpawned)
						{
						}
						else if (newTile.Level > targetTile.Level + 1)
						{
						}
						else
						{
							knockToTile = newTile;
							break;
						}
					}
				}

				if (knockToTile == null)
				{
					this.Time.scheduleEvent(this.TimeUnit.Rounds, 1, this.Tactical.Entities.resurrect, _info);
					return null;
				}

				this.Tactical.getNavigator().teleport(targetTile.getEntity(), knockToTile, null, null, true);

				if (_info.Tile.IsVisibleForPlayer)
				{
					this.Tactical.CameraDirector.pushMoveToTileEvent(0, _info.Tile, -1, this.onResurrect.bindenv(this), _info, 200, this.Const.Tactical.Settings.CameraNextEventDelay);
					this.Tactical.CameraDirector.addDelay(0.2);
				}
				else if (knockToTile.IsVisibleForPlayer)
				{
					this.Tactical.CameraDirector.pushMoveToTileEvent(0, knockToTile, -1, this.onResurrect.bindenv(this), _info, 200, this.Const.Tactical.Settings.CameraNextEventDelay);
					this.Tactical.CameraDirector.addDelay(0.2);
				}
				else
				{
					this.Tactical.CameraDirector.pushIdleEvent(0, this.onResurrect.bindenv(this), _info, 200, this.Const.Tactical.Settings.CameraNextEventDelay);
					this.Tactical.CameraDirector.addDelay(0.2);
				}

				return null;
			}

			local survivor = this.Tactical.getSurvivorRoster().getAll();
			local player;

			foreach ( s in survivor )
			{
				if (s.getID() == _info.PlayerID)
				{
					player = s;
					break;
				}
			}

			if (player == null)
			{
				return null;
			}

			this.Tactical.Entities.removeCorpse(targetTile);
			targetTile.clear(this.Const.Tactical.DetailFlag.Corpse);
			targetTile.Properties.remove("Corpse");
			targetTile.Properties.remove("IsSpawningFlies");
			this.Const.Movement.AnnounceDiscoveredEntities = false;
			this.Tactical.addEntityToMap(player, targetTile.Coords.X, targetTile.Coords.Y);
			this.Const.Movement.AnnounceDiscoveredEntities = true;
			player.onResurrected(_info);
			player.riseFromGround();

			if (!player.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(entity) + " has risen from the dead");
			}

			return player;
		};

		obj.resurrect = function( _info, _delay = 0 )
		{
			if (_info.Type == "" && !("PlayerID" in _info))
			{
				return;
			}

			if (!this.MSU.Tile.canResurrectOnTile(_info.Tile, true))
			{
				return;
			}

			if (_info.Tile.IsVisibleForPlayer)
			{
				this.Tactical.CameraDirector.addMoveToTileEvent(_delay, _info.Tile, -1, this.onResurrect.bindenv(this), _info, this.Const.Tactical.Settings.CameraWaitForEventDelay, this.Const.Tactical.Settings.CameraNextEventDelay);
				this.Tactical.CameraDirector.addDelay(1.5);
			}
			else
			{
				this.onResurrect(_info);

				if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().isPlayerControlled())
				{
					this.Tactical.TurnSequenceBar.getActiveEntity().setDirty(true);
				}
			}
		}
	});


	//
	::mods_hookNewObject("scenarios/world/legends_necro_scenario", function(obj) 
	{
		local ws_onSpawnAssets = obj.onSpawnAssets;
		obj.onSpawnAssets = function()
		{
			ws_onSpawnAssets();
			local roster = this.World.getPlayerRoster();
			local bro;

			foreach ( b in roster.getAll() )
			{
				if (b.getSkills().hasSkill("trait.legend_rotten_flesh"))
				{
					bro = b;
					break;
				}
			}

			if (bro != null)
			{
				roster.remove(bro);
			}
			
			bro = roster.create("scripts/entity/tactical/undead_player");
			bro.setStartValuesEx();
			bro.getBackground().m.RawDescription = "Once a proud necromancer, %name% took three pupils under their wing to train the next generation of great necromancers. What %name% did not seeing coming is a heart attack - one that left them like a corpse like they used to command. With this macabre irony in mind, they now serve their students in unlife as little more than fodder.";
			bro.getBackground().buildDescription(true);
			bro.setPlaceInFormation(12);
			bro.setVeteranPerks(2);

			if (this.Math.rand(1, 100) <= 40)
			{
				bro = roster.create("scripts/entity/tactical/ghost_player");
				bro.setStartValuesEx();
				bro.getBackground().m.RawDescription = "Once a proud necromancer, %name% took three pupils under their wing to train the next generation of great necromancers. What %name% did not seeing coming is a heart attack - one that left them like a corpse like they used to command. With this macabre irony in mind, they now serve their students in unlife as little more than fodder.";
				bro.getBackground().buildDescription(true);
				bro.setPlaceInFormation(13);
				bro.setVeteranPerks(2);
				this.World.Assets.getStash().add(this.new("scripts/items/misc/petrified_scream_item"));
			}
		}

		local ws_onUpdateDraftList = obj.onUpdateDraftList;
		obj.onUpdateDraftList = function( _list, _gender = null )
		{
			ws_onUpdateDraftList(_list, _gender);

			while(_list.find("legend_puppet_background") != null)
			{
				_list.remove(_list.find("legend_puppet_background"));
			}
		};

		local ws_onHiredByScenario = obj.onHiredByScenario;
		obj.onHiredByScenario = function( bro )
		{
			if (bro.getFlags().has("undead"))
			{
				bro.getSprite("socket").setBrush("bust_base_undead");
			}
			else
			{
				ws_onHiredByScenario(bro);
			}
		};

		local ws_onUpdateHiringRoster = obj.onUpdateHiringRoster;
		obj.onUpdateHiringRoster = function( _roster )
		{
			ws_onUpdateHiringRoster(_roster);
			local chance = 20;

			for (local i = 0; i < 3; ++i)
			{
				if (this.Math.rand(1, 100) <= chance)
				{
					local undead = _roster.create("scripts/entity/tactical/undead_player");
					undead.setStartValuesEx();
					chance -= 5;
				}
			}
		};
	});

	delete this.HexenHooks.hookPlayerPartyAndAssets;
}