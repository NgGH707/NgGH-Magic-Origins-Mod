this.getroottable().HexenHooks.hookCharacterScreenAndStates <- function ()
{
	//help siege weapon toggle "bring in batte" or "put in reserve" and make charmed simp does not cost any crowns to kick them out of party
	::mods_hookNewObject("ui/screens/character/character_screen", function ( obj )
	{
		obj.general_onEquipStashItem = function( _data )
		{
			local data = this.helper_queryStashItemData(_data);

			if ("error" in data)
			{
				return data;
			}

			local targetItems = this.helper_queryEquipmentTargetItems(data.inventory, data.sourceItem);
			local allowed = this.helper_isActionAllowed(data.entity, [
				data.sourceItem,
				targetItems.firstItem,
				targetItems.secondItem
			], false);

			if (allowed != null)
			{
				return allowed;
			}

			if (!this.Tactical.isActive() && data.sourceItem.isUsable())
			{
				if (data.sourceItem.onUse(data.inventory.getActor()))
				{
					data.stash.removeByIndex(data.sourceIndex);
					data.inventory.getActor().getSkills().update();

					if (data.sourceItem.isIndestructible())
					{
						local item = data.sourceItem.onUseIndestructibleItem();

						if (item != null)
						{
							this.World.Assets.getStash().insert(item, data.sourceIndex);
						}
					}
					return this.UIDataHelper.convertStashAndEntityToUIData(data.entity, null, false, this.m.InventoryFilter);
				}
				else
				{
					return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToEquipStashItem);
				}
			}

			if (!data.stash.isResizable() && data.stash.getNumberOfEmptySlots() < targetItems.slotsNeeded - 1)
			{
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.NotEnoughStashSpace);
			}

			if (targetItems.firstItem != null)
			{
				if (!targetItems.firstItem.isInBag() && !data.inventory.unequip(targetItems.firstItem) || targetItems.firstItem.isInBag() && !data.inventory.removeFromBag(targetItems.firstItem))
				{
					return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromTargetSlot);
				}

				if (targetItems.secondItem != null)
				{
					if (data.inventory.unequip(targetItems.secondItem) == false)
					{
						data.inventory.equip(targetItems.firstItem);
						return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromTargetSlot);
					}
				}
			}

			if (data.stash.removeByIndex(data.sourceIndex) == null)
			{
				if (targetItems != null && targetItems.firstItem != null)
				{
					data.inventory.equip(targetItems.firstItem);

					if (targetItems.secondItem != null)
					{
						data.inventory.equip(targetItems.secondItem);
					}
				}

				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromSourceSlot);
			}

			if (data.inventory.equip(data.sourceItem) == false)
			{
				data.stash.insert(data.sourceItem, data.sourceIndex);

				if (targetItems != null && targetItems.firstItem != null)
				{
					data.inventory.equip(targetItems.firstItem);

					if (targetItems.secondItem != null)
					{
						data.inventory.equip(targetItems.secondItem);
					}
				}

				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToEquipBagItem);
			}

			if (targetItems != null && targetItems.firstItem != null)
			{
				local firstItemIdx = data.sourceIndex;

				if (data.swapItem == true)
				{
					data.stash.insert(targetItems.firstItem, data.sourceIndex);
				}
				else
				{
					firstItemIdx = data.stash.add(targetItems.firstItem);

					if (firstItemIdx == null)
					{
						data.inventory.unequip(data.sourceItem);
						data.stash.insert(data.sourceItem, data.sourceIndex);
						data.inventory.equip(targetItems.firstItem);

						if (targetItems.secondItem != null)
						{
							data.inventory.equip(targetItems.secondItem);
						}

						return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToPutItemIntoBag);
					}
				}

				local secondItemIdx = data.stash.add(targetItems.secondItem);

				if (targetItems.secondItem != null && secondItemIdx == null)
				{
					data.stash.removeByIndex(firstItemIdx);
					data.inventory.unequip(data.sourceItem);
					data.stash.insert(data.sourceItem, data.sourceIndex);
					data.inventory.equip(targetItems.firstItem);

					if (targetItems.secondItem != null)
					{
						data.inventory.equip(targetItems.secondItem);
					}

					return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToPutItemIntoBag);
				}
			}

			data.sourceItem.playInventorySound(this.Const.Items.InventoryEventType.Equipped);
			this.helper_payForAction(data.entity, [
				data.sourceItem,
				targetItems.firstItem,
				targetItems.secondItem
			]);

			if (this.Tactical.isActive())
			{
				return this.UIDataHelper.convertStashAndEntityToUIData(data.entity, this.Tactical.TurnSequenceBar.getActiveEntity(), false, this.m.InventoryFilter);
			}
			else
			{
				return this.UIDataHelper.convertStashAndEntityToUIData(data.entity, null, false, this.m.InventoryFilter);
			}
		}

		obj.onDismissCharacter = function( _data )
		{
			local bro = this.Tactical.getEntityByID(_data[0]);
			local payCompensation = _data[1];

			if (bro != null)
			{
				this.World.Statistics.getFlags().increment("BrosDismissed");

				if (bro.getSkills().hasSkillOfType(this.Const.SkillType.PermanentInjury) && (bro.getBackground().getID() != "background.slave" || this.World.Assets.getOrigin().getID() == "scenario.sato_escaped_slaves"))
				{
					this.World.Statistics.getFlags().increment("BrosWithPermanentInjuryDismissed");
				}

				if (bro.getDailyCost() == 0)
				{
				}
				else if (payCompensation)
				{
					this.World.Assets.addMoney(-10 * this.Math.max(1, bro.getDaysWithCompany()));

					if (bro.getBackground().getID() == "background.slave")
					{
						local playerRoster = this.World.getPlayerRoster().getAll();

						foreach( other in playerRoster )
						{
							if (bro.getID() == other.getID())
							{
								continue;
							}

							if (other.getBackground().getID() == "background.slave")
							{
								other.improveMood(this.Const.MoodChange.SlaveCompensated, "Glad to see " + bro.getName() + " get reparations for his time");
							}
						}
					}
				}
				else if (bro.getBackground().getID() == "background.slave")
				{
				}
				else if (bro.getLevel() >= 11 && !this.World.Statistics.hasNews("dismiss_legend") && this.World.getPlayerRoster().getSize() > 1)
				{
					local news = this.World.Statistics.createNews();
					news.set("Name", bro.getName());
					this.World.Statistics.addNews("dismiss_legend", news);
				}
				else if (bro.getDaysWithCompany() >= 50 && !this.World.Statistics.hasNews("dismiss_veteran") && this.World.getPlayerRoster().getSize() > 1 && this.Math.rand(1, 100) <= 33)
				{
					local news = this.World.Statistics.createNews();
					news.set("Name", bro.getName());
					this.World.Statistics.addNews("dismiss_veteran", news);
				}
				else if (bro.getLevel() >= 3 && bro.getSkills().hasSkillOfType(this.Const.SkillType.PermanentInjury) && !this.World.Statistics.hasNews("dismiss_injured") && this.World.getPlayerRoster().getSize() > 1 && this.Math.rand(1, 100) <= 33)
				{
					local news = this.World.Statistics.createNews();
					news.set("Name", bro.getName());
					this.World.Statistics.addNews("dismiss_injured", news);
				}
				else if (bro.getDaysWithCompany() >= 7)
				{
					local playerRoster = this.World.getPlayerRoster().getAll();

					foreach( other in playerRoster )
					{
						if (bro.getID() == other.getID())
						{
							continue;
						}

						if (bro.getDaysWithCompany() >= 50)
						{
							other.worsenMood(this.Const.MoodChange.VeteranDismissed, "Dismissed " + bro.getName());
						}
						else
						{
							other.worsenMood(this.Const.MoodChange.BrotherDismissed, "Dismissed " + bro.getName());
						}
					}
				}

				bro.getItems().transferToStash(this.World.Assets.getStash());
				this.World.getPlayerRoster().remove(bro);

				if (this.World.State.getPlayer() != null)
				{
					this.World.State.getPlayer().calculateModifiers();
				}

				this.loadData();
				this.World.State.updateTopbarAssets();
			}
		}

		obj.tactical_onQueryBrothersList = function()
		{
			local entities = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
			local pets = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.PlayerAnimals);

			if (entities != null && entities.len() > 0)
			{
				local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();
				local result = [];
				local extra;

				foreach( entity in entities )
				{
					if (entity.isSummoned())
					{
						if (entity.isPlayerControlled() && entity.getID() == activeEntity.getID())
						{
							extra = entity;
						}

						continue;
					}

					result.push(this.UIDataHelper.convertEntityToUIData(entity, activeEntity));
				}

				foreach( entity in entities )
				{
					if (entity.isSummoned() && entity.isPlayerControlled() && entity.getID() == activeEntity.getID())
					{
						extra = entity;
						break;
					}
				}

				if (result.len() <= 26 && extra != null)
				{
					result.push(this.UIDataHelper.convertEntityToUIData(extra, activeEntity));
				}

				return result;
			}

			return null;
		}
	});

	::mods_hookNewObjectOnce("states/main_menu_state", function( obj )
	{
		local onCreditsPressed = obj.main_menu_module_onCreditsPressed;
		obj.main_menu_module_onCreditsPressed = function()
		{
			this.getroottable().UnlockSecret = !this.getroottable().UnlockSecret;
			
			if (!this.getroottable().AddedSecret)
			{
				this.getroottable().AddedSecret = true;
				this.m.ScenarioManager.m.Scenarios.sort(this.m.ScenarioManager.onOrderCompare);
				this.m.MainMenuScreen.getNewCampaignMenuModule().setStartingScenarios(this.m.ScenarioManager.getScenariosForUI());
				this.logDebug("mod_nggh_magic_concept - Unlocking Secret: " + this.getroottable().UnlockSecret);
			}
			
			onCreditsPressed();
		}
	});
	::mods_hookNewObject("scenarios/scenario_manager", function ( obj )
	{
		local s = this.new("scripts/entity/tactical/minions/special/dev_files/nggh_dev_scenario");
		obj.m.Scenarios.push(s);
	});
	::mods_hookNewObject("entity/world/locations/legendary/kraken_cult_location", function ( obj )
	{
		local ws_onSpawned = obj.onSpawned; 
		obj.onSpawned = function()
		{
			ws_onSpawned();

			if (this.World.Flags.get("IsKrakenOrigin"))
			{	
				local self = this;
				local tilePos = this.getTile().Pos;
         		this.World.State.getPlayer().setPos(tilePos);
         		this.World.setPlayerPos(tilePos);
         		this.World.getCamera().setPos(tilePos);
				this.onDiscovered();

				this.Time.scheduleEvent(this.TimeUnit.Real, 1100, function ( _tag )
				{
					this.World.State.enterLocation(self);
				}, null);
			}
		}
	});

	::mods_hookExactClass("events/events/dlc2/location/kraken_cult_enter_event", function (obj) 
	{
		local determineStartScreen = obj.onDetermineStartScreen;
		obj.onDetermineStartScreen = function()
		{
			if (this.World.Flags.get("IsKrakenOrigin"))
			{
				return "H";
			}

			return onDetermineStartScreen();
		}

		local screens = ::mods_getField(obj, "Screens");
		screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_103.png[/img]{You watch as one of the helpers suddenly lifts into the air, and in the green light you see the slick tentacle drag him backward and it seems as though the earth itself opens up, and a thousand wet boughs and branches crinkle and drip, and rows upon rows of fangs bristle, clattering against one another as though shouldering for a slice, and the helper is thrown into it the maw and the gums twist and he is disrobed and defleshed and delimbed and destroyed. The woman chomps on another mushroom and then her hands caress bulbs of green, and you can see the tentacles slithering beneath each.%SPEECH_ON%Join us, sellsword! Let the Beast of Beasts have its feast!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s Duel!",
					function getResult( _event )
					{
						this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Events.showCombatDialog(false, true, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	});

	//add siege weapon in battle and automatically put them in formation
	::mods_hookNewObject("states/tactical_state", function ( obj )
	{
		obj.getSiegeWeapons <- function()
		{
			local stash = this.World.Assets.getStash();
			local siege_weapons = [];

			foreach ( _item in stash.getItems() )
			{
				if (_item == null)
				{
					continue;
				}

				if (_item.getID() != "misc.mc_mortar" && _item.getID() != "misc.mc_catapult")
				{
					continue;
				}

				if (_item.isBroughtInBattle())
				{
					siege_weapons.push(_item);
				}

				if (siege_weapons.len() >= 5)
				{
					break;
				}
			}

			return siege_weapons;
		};

		obj.addSeigeWeaponInBattle <- function( _properties )
		{
			this.logInfo("initMap");

			if (_properties != null && (_properties.IsArenaMode || _properties.InCombatAlready))
			{
				return;
			}

			local stash = this.World.Assets.getStash();
			local siege_weapons = this.getSiegeWeapons();

			if (siege_weapons.len() == 0)
			{
				return;
			}

			if (!("Loot" in _properties))
			{
				_properties.Loot <- [];
			}

			foreach ( _i in siege_weapons )
			{
				this.logInfo("add siege weapon in battle: " + _i.getName());
				local script = this.IO.scriptFilenameByHash(_i.ClassNameHash);
				_properties.Loot.push(script);

				local entity = _i.getEntityData();
				//entity.Faction <- this.Const.FactionType.Neutral;
				_properties.Entities.push(_i.getEntityData());
				
				stash.remove(_i);
			}
		};

		local oldFunction = obj.initMap;
		obj.initMap = function()
		{
			this.addSeigeWeaponInBattle(this.m.StrategicProperties);
			oldFunction();
		};

		obj.tactical_flee_screen_onFleePressed = function()
		{
			this.Sound.play("sounds/retreat_01.wav", 0.75);

			if (this.isScenarioMode() || this.isEveryoneSafe())
			{
				this.m.IsFleeing = true;
				this.m.MenuStack.pop();
				this.m.TacticalDialogScreen.hide();
				this.m.TacticalScreen.hide();
				this.Time.clearEvents();
				this.setPause(true);
				this.flee();
			}
			else if (!this.m.IsAutoRetreat)
			{
				this.m.IsAutoRetreat = true;
				this.m.MenuStack.pop();
				this.Settings.getTempGameplaySettings().FasterPlayerMovement = true;
				this.Settings.getTempGameplaySettings().FasterAIMovement = true;
				this.Tactical.getCamera().zoomTo(this.Math.maxf(this.Tactical.getCamera().Zoom, 1.5), 1.0);
				this.Time.setVirtualSpeed(1.5);
				local alive = this.Tactical.Entities.getAllInstancesAsArray();

				foreach( bro in alive )
				{
					if (bro.isAlive())
					{
						bro.onFactionChanged();

						if (this.isKindOf(bro, "player"))
						{
							if (bro.getFlags().has("egg"))
							{
								bro.getAIAgent().setUseHeat(true);
								bro.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 1.0;
								bro.onRetreating();
							}
							else if (bro.getFlags().has("boss") && bro.getFlags().has("kraken"))
							{
								bro.killSilently();
							}
							else if (bro.getSkills().hasSkill("effects.charmed"))
							{
								local agent = bro.getSkills().getSkillByID("effects.charmed").m.OriginalAgent;
								agent.setUseHeat(true);
								agent.getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 1.0;
							}
							else
							{
								bro.getAIAgent().setUseHeat(true);
								bro.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 1.0;
							}

							this.Tactical.TurnSequenceBar.updateEntity(bro.getID());
						}
						else if (bro.getFaction() == this.Const.Faction.PlayerAnimals)
						{
							bro.getAIAgent().setUseHeat(true);
							bro.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 1.0;
							this.Tactical.TurnSequenceBar.updateEntity(bro.getID());
						}
						else if (bro.getSkills().hasSkill("effects.charmed"))
						{
							bro.killSilently();
						}
					}
				}

				local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();

				if (activeEntity != null && activeEntity.getFaction() == this.Const.Faction.PlayerAnimals)
				{
					this.Tactical.TurnSequenceBar.initNextTurn();
				}
				else if (activeEntity != null && activeEntity.isPlayerControlled())
				{
					activeEntity.getAIAgent().setFinished(false);
				}

				this.updateCurrentEntity();
			}
		}

		obj.gatherBrothers = function ( _isVictory )
		{
			this.m.CombatResultRoster = [];
			this.Tactical.CombatResultRoster <- this.m.CombatResultRoster;
			local alive = this.Tactical.Entities.getAllInstancesAsArray();

			foreach( bro in alive )
			{
				if (bro.getFlags().has("spider") && bro.isAlive())
				{
					local accessory = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

					if (accessory != null && accessory.getID() == "accessory.carried_egg")
					{
						local e = accessory.getEntity();
						e.onBeforeCombatResult();
						this.m.CombatResultRoster.push(e);
						accessory.m.Entity = null;
						accessory.onDone();
					}
				}

				if (bro.isAlive() && this.isKindOf(bro, "player"))
				{
					bro.onBeforeCombatResult();

					if (bro.isAlive() && !bro.isGuest() && bro.isPlayerControlled())
					{
						this.m.CombatResultRoster.push(bro);
					}
				}
			}

			local dead = this.Tactical.getCasualtyRoster().getAll();
			local survivor = this.Tactical.getSurvivorRoster().getAll();
			local retreated = this.Tactical.getRetreatRoster().getAll();
			local isArena = this.m.StrategicProperties != null && this.m.StrategicProperties.IsArenaMode;

			if (_isVictory || isArena)
			{
				foreach( s in survivor )
				{
					s.setIsAlive(true);
					s.onBeforeCombatResult();

					foreach( i, d in dead )
					{
						if (s.getID() == d.getOriginalID())
						{
							dead.remove(i);
							this.Tactical.getCasualtyRoster().remove(d);
							break;
						}
					}
				}

				this.m.CombatResultRoster.extend(survivor);
			}
			else
			{
				foreach( bro in survivor )
				{
					local fallen = {
						Name = bro.getName(),
						Time = this.World.getTime().Days,
						TimeWithCompany = this.Math.max(1, bro.getDaysWithCompany()),
						Kills = bro.getLifetimeStats().Kills,
						Battles = bro.getLifetimeStats().Battles,
						KilledBy = "Left to die",
						Expendable = bro.getBackground().getID() == "background.slave"
					};
					this.World.Statistics.addFallen(bro);
					this.World.getPlayerRoster().remove(bro);
					bro.die();
				}
			}

			foreach( s in retreated )
			{
				s.onBeforeCombatResult();
			}

			this.m.CombatResultRoster.extend(retreated);
			this.m.CombatResultRoster.extend(dead);

			if (!this.isScenarioMode() && dead.len() > 1 && dead.len() >= this.m.CombatResultRoster.len() / 2)
			{
				this.updateAchievement("TimeToRebuild", 1, 1);
			}

			if (!this.isScenarioMode() && this.World.getPlayerRoster().getSize() == 0 && this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians) != null && this.m.Factions.getHostileFactionWithMostInstances() == this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getID())
			{
				this.updateAchievement("GiveMeBackMyLegions", 1, 1);
			}
		};
	});

	delete this.HexenHooks.hookCharacterScreenAndStates;
}