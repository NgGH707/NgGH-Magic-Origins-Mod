this.getroottable().HexenHooks.hookCharacterScreenAndStates <- function ()
{
	//help siege weapon toggle "bring in batte" or "put in reserve" and make charmed simp does not cost any crowns to kick them out of party
	::mods_hookNewObject("ui/screens/character/character_screen", function ( obj )
	{
		local ws_onToggleInventoryItem = obj.onToggleInventoryItem;
		obj.onToggleInventoryItem = function( _data )
		{
			local result = {
				repair = false,
				salvage = false
			};

			local itemId = _data[0];
			local entityId = _data[1];

			if (this.Tactical.isActive())
			{
				return result;
			}

			local obj = null;
			local item = null;
			local index = 0;
			if (entityId != null)
			{
				obj = this.Tactical.getEntityByID(entityId).getItems().getItemByInstanceID(itemId);
				if (obj != null)
				{
					item = obj;
				}
			}
			else
			{
				obj = this.Stash.getItemByInstanceID(itemId);
				if (obj != null)
				{
					item = obj.item;
					index = obj.index;
				}
			}

			if (item != null && item.isItemType(this.Const.Items.ItemType.Corpse))
			{
				if (item.m.MedicinePerDay == 0)
				{
					if (!item.isToBeButchered())
					{
						item.setToBeButchered(true, index);
					}
					else
					{
						item.setToBeButchered(false, 0);
					}

					return {
						repair = false,
						salvage = item.isToBeSalvaged()
					};
				}

				if (!item.isMaintained() && !item.isToBeButchered())
				{
					item.setToBeMaintain(true);
				}
				else if (item.isMaintained())
				{
					item.setToBeMaintain(false);
					item.setToBeButchered(true, index);
				}
				else
				{
					item.setToBeMaintain(false);
					item.setToBeButchered(false, 0);
				}

				return {
					repair = item.isMaintained(),
					salvage = item.isToBeSalvaged(),
				};
			}
			
			return ws_onToggleInventoryItem(_data);
		};

		local ws_general_onEquipStashItem = obj.general_onEquipStashItem;
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

			if (!this.Tactical.isActive() && data.sourceItem.isUsable() && data.sourceItem.isIndestructible())
			{
				if (data.sourceItem.onUse(data.inventory.getActor()))
				{
					data.stash.removeByIndex(data.sourceIndex);
					data.inventory.getActor().getSkills().update();
					local item = data.sourceItem.onUseIndestructibleItem();

					if (item != null)
					{
						this.World.Assets.getStash().insert(item, data.sourceIndex);
					}

					return this.UIDataHelper.convertStashAndEntityToUIData(data.entity, null, false, this.m.InventoryFilter);
				}
				else
				{
					return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToEquipStashItem);
				}
			}

			return ws_general_onEquipStashItem(_data);
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
				local extra = [];

				foreach( entity in entities )
				{
					if (entity.isSummoned())
					{
						if (entity.isPlayerControlled() && entity.getID() == activeEntity.getID())
						{
							extra.push(entity);
						}

						continue;
					}

					result.push(this.UIDataHelper.convertEntityToUIData(entity, activeEntity));
				}

				foreach( entity in pets )
				{
					if (entity.isSummoned() && entity.isPlayerControlled())
					{
						if (entity.getID() == activeEntity.getID())
						{
							extra.push(entity);
						}
						else
						{
							extra.insert(0, entity);
						}
					}
				}

				foreach ( i, pet in extra ) 
				{
				    if (result.len() <= 26)
				    {
				    	result.push(this.UIDataHelper.convertEntityToUIData(pet, activeEntity));
				    }
				    else
				    {
				    	break;
				    }
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
		local determineStartScreen = ::mods_getMember(obj, "onDetermineStartScreen");
		obj.onDetermineStartScreen = function()
		{
			if (this.World.Flags.get("IsKrakenOrigin"))
			{
				return "H";
			}

			return determineStartScreen();
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

		local ws_initMap = obj.initMap;
		obj.initMap = function()
		{
			if (this.m.StrategicProperties != null && !this.m.StrategicProperties.IsPlayerInitiated && !this.m.StrategicProperties.InCombatAlready)
			{
				foreach ( p in this.m.StrategicProperties.Parties ) 
				{
					if (p.getFlags().has("WitchHunters"))
					{
						this.m.StrategicProperties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						this.m.StrategicProperties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
					}
				}
			}

			this.addSeigeWeaponInBattle(this.m.StrategicProperties);
			ws_initMap();
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
						else if (bro.getSkills().hasSkill("effects.charmed"))
						{
							bro.killSilently();
						}
					}
				}

				local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();

				if (activeEntity != null)
				{
					if (activeEntity.getFaction() == this.Const.Faction.PlayerAnimals)
					{
						this.Tactical.TurnSequenceBar.initNextTurn();
					}
					else if (activeEntity.isPlayerControlled()) 
					{
					    activeEntity.getAIAgent().setFinished(false);
					}
				}

				this.updateCurrentEntity();
			}
		};

		obj.gatherLoot = function()
		{
			local playerKills = 0;

			foreach( bro in this.m.CombatResultRoster )
			{
				playerKills = playerKills + bro.getCombatStats().Kills;
			}

			if (!this.isScenarioMode())
			{
				this.World.Statistics.getFlags().set("LastCombatKills", playerKills);
			}

			local isArena = !this.isScenarioMode() && this.m.StrategicProperties != null && this.m.StrategicProperties.IsArenaMode;

			if (!isArena && !this.isScenarioMode() && this.m.StrategicProperties != null && this.m.StrategicProperties.IsLootingProhibited)
			{
				return;
			}

			local loot = [];
			local size = this.Tactical.getMapSize();

			for( local x = 0; x < size.X; x = ++x )
			{
				for( local y = 0; y < size.Y; y = ++y )
				{
					local tile = this.Tactical.getTileSquare(x, y);

					if (tile.IsContainingItems)
					{
						foreach( item in tile.Items )
						{
							if (isArena && item.getLastEquippedByFaction() != 1)
							{
								continue;
							}

							item.onCombatFinished();
							loot.push(item);
						}
					}

					if (tile.Properties.has("Corpse") && !tile.Properties.has("IsSummoned"))
					{
						if (tile.Properties.get("Corpse").Items != null)
						{
							local items = tile.Properties.get("Corpse").Items.getAllItems();

							foreach( item in items )
							{

								if (isArena && item.getLastEquippedByFaction() != 1)
								{
									continue;
								}

								item.onCombatFinished();
								if (!item.isChangeableInBattle(null) && item.isDroppedAsLoot())
								{
									if (item.getCondition() > 1 && item.getConditionMax() > 1 && item.getCondition() > item.getConditionMax() * 0.66 && this.Math.rand(1, 100) <= 66)
									{
										local c = this.Math.minf(item.getCondition(), this.Math.rand(this.Math.maxf(10, item.getConditionMax() * 0.35), item.getConditionMax()));
										item.setCondition(c);
									}

									item.removeFromContainer();
									foreach (i in item.getLootLayers())
									{
										loot.push(i);
									}

								}
							}
						}

						if (tile.Properties.get("Corpse").CorpseAsItem != null && !tile.Properties.get("Corpse").CorpseAsItem.isGarbage())
						{
							local corpse = tile.Properties.get("Corpse").CorpseAsItem;
							if (this.Math.rand(1, 100) <= 50 || corpse.m.IsBoss) loot.push(corpse);
						}
					}
				}
			}

			if (!isArena && this.m.StrategicProperties != null)
			{
				local player = this.World.State.getPlayer();

				foreach( party in this.m.StrategicProperties.Parties )
				{
					if (party.getTroops().len() == 0 && party.isAlive() && !party.isAlliedWithPlayer() && party.isDroppingLoot() && (playerKills > 0 || this.m.IsDeveloperModeEnabled))
					{
						party.onDropLootForPlayer(loot);
					}
				}

				foreach( item in this.m.StrategicProperties.Loot )
				{
					loot.push(this.new(item));
				}

				foreach ( item in this.m.StrategicProperties.LootWithoutScript )
				{
					loot.push(item);
				}
			}

			if (!isArena && !this.isScenarioMode())
			{
				if (this.Tactical.Entities.getAmmoSpent() > 0 && this.World.Assets.m.IsRecoveringAmmo)
				{
					local amount = this.Math.max(1, this.Tactical.Entities.getAmmoSpent() * 0.2);
					amount = this.Math.rand(amount / 2, amount);

					if (amount > 0)
					{
						local ammo = this.new("scripts/items/supplies/ammo_item");
						ammo.setAmount(amount);
						loot.push(ammo);
					}
				}

				if (this.Tactical.Entities.getArmorParts() > 0 && this.World.Assets.m.IsRecoveringArmor)
				{
					local amount = this.Math.min(60, this.Math.max(1, this.Tactical.Entities.getArmorParts() * this.Const.World.Assets.ArmorPartsPerArmor * 0.15));
					amount = this.Math.rand(amount / 2, amount);

					if (amount > 0)
					{
						local parts = this.new("scripts/items/supplies/armor_parts_item");
						parts.setAmount(amount);
						loot.push(parts);
					}
				}
			}

			this.m.CombatResultLoot.assign(loot);
			this.m.CombatResultLoot.sort();
		};
	});

	::mods_hookNewObject("ui/screens/tactical/tactical_combat_result_screen", function(obj)
	{
		obj.onLootAllItemsButtonPressed = function()
		{
			if (this.Tactical.CombatResultLoot.isEmpty())
			{
				return this.Const.UI.convertErrorToUIData(this.Const.UI.Error.FoundLootListIsEmpty);
			}

			if (!this.Stash.hasEmptySlot())
			{
				return this.Const.UI.convertErrorToUIData(this.Const.UI.Error.NotEnoughStashSpace);
			}

			local isAutoLoot = this.Settings.getGameplaySettings().AutoLoot;
			local foundLootItems = this.Tactical.CombatResultLoot.getItems();
			local stashItems = this.Stash.getItems();
			local lastStashIdx = 0;
			local soundPlayed = false;
			local freeSlotFound = false;
			local foundLootLen = foundLootItems.len();

			for( local i = 0; i < foundLootItems.len(); i = ++i )
			{
				if (foundLootItems[i] != null)
				{
					if (isAutoLoot && foundLootItems[i].isItemType(this.Const.Items.ItemType.Corpse))
					{
						continue;
					}

					for( local j = lastStashIdx; j < stashItems.len(); j = ++j )
					{
						if (stashItems[j] == null)
						{
							freeSlotFound = true;
							stashItems[j] = foundLootItems[i];
							foundLootItems[i] = null;
							lastStashIdx = j + 1;
							stashItems[j].onAddedToStash(this.Stash.getID());

							if (!soundPlayed)
							{
								soundPlayed = true;
								stashItems[j].playInventorySound(this.Const.Items.InventoryEventType.PlacedInBag);
							}

							break;
						}
					}
				}
			}

			this.Tactical.CombatResultLoot.shrink();

			if (freeSlotFound == false)
			{
				return this.Const.UI.convertErrorToUIData(this.Const.UI.Error.NotEnoughStashSpace);
			}
			else
			{
				return {
					stash = this.UIDataHelper.convertStashToUIData(true),
					foundLoot = this.UIDataHelper.convertCombatResultLootToUIData()
				};
			}
		}
	});

	::mods_hookNewObject("ui/screens/world/camp_screen", function(obj)
	{
		obj.m.ButcherDialogModule <- null;
		obj.m.ButcherDialogModule = this.new("scripts/ui/screens/world/modules/camp_screen/camp_butcher_dialog_module");
		obj.m.ButcherDialogModule.setParent(obj);
		obj.m.ButcherDialogModule.connectUI(obj.m.JSHandle);

		obj.getButcherDialogModule <- function()
		{
			return this.m.ButcherDialogModule;
		};

		local ws_destroy = obj.destroy;
		obj.destroy = function()
		{
			this.m.ButcherDialogModule.destroy();
			this.m.ButcherDialogModule = null;
			ws_destroy();
		};

		local ws_clear = obj.clear;
		obj.clear = function()
		{
			ws_clear();
			this.m.ButcherDialogModule.clear();
		};

		local ws_showLastActiveDialog = obj.showLastActiveDialog;
		obj.showLastActiveDialog = function()
		{
			if (this.m.LastActiveModule == this.m.ButcherDialogModule)
			{
				this.showButcherDialog();
			}
			else
			{
				ws_showLastActiveDialog();
			}
		};

		local ws_showTentBuildingDialog = obj.showTentBuildingDialog;
		obj.showTentBuildingDialog = function(_id)
		{
			if (_id == this.Const.World.CampBuildings.Butcher)
			{
				this.showButcherDialog();
			}
			else
			{
				ws_showTentBuildingDialog(_id);
			}
		};

		obj.showButcherDialog <- function()
		{
			if (this.m.JSHandle != null && this.isVisible())
			{
				this.m.LastActiveModule = this.m.ButcherDialogModule;
				this.Tooltip.hide();
				this.m.JSHandle.asyncCall("showButcherDialog", this.m.ButcherDialogModule.onShow());
			}
		};
	});

	::mods_hookNewObjectOnce("ui/screens/tooltip/tooltip_events", function( obj ) 
	{
		local ws_strategic_queryUIItemTooltipData = obj.strategic_queryUIItemTooltipData;
		obj.strategic_queryUIItemTooltipData = function( _entityId, _itemId, _itemOwner )
		{
			local tooltip = ws_strategic_queryUIItemTooltipData(_entityId, _itemId, _itemOwner);
			if(tooltip != null) return tooltip;

			if (_itemOwner == "butcher_database")
			{
				local database = this.World.Camp.getBuildingByID(this.Const.World.CampBuildings.Butcher).m.Database;
				local item = database.getItemByID(_itemId);
				return item != null ? item.getTooltip() : null;
			}

			return null;
		}

	 	local ws_general_queryUIElementTooltipData = obj.general_queryUIElementTooltipData;
	 	obj.general_queryUIElementTooltipData = function(_entityId, _elementId, _elementOwner)
	 	{
	 		local tooltip = ws_general_queryUIElementTooltipData(_entityId, _elementId, _elementOwner);
			if(tooltip != null) return tooltip;

			switch (_elementId)
			{
			case "butcher.Bros":
				local tent = this.World.Camp.getBuildingByID(this.Const.World.CampBuildings.Butcher);
				local butcher = tent.getModifiers();
				local ret = [
					{
						id = 1,
						type = "title",
						text = "Assigned Brothers"
					},
					{
						id = 2,
						type = "description",
						text = "Number of people assigned to butcher duty. The more assigned, the quicker the process."
					},
					{
						id = 3,
						type = "text",
						icon = "ui/icons/repair_item.png",
						text = "Total butcher modifier is [color=" + this.Const.UI.Color.PositiveValue + "]" + butcher.Craft + " units per hour[/color]"
					}
				];
				foreach(i, bro in butcher.Modifiers )
				{
					ret.push({
						id = i + 4,
						type = "text",
						icon = "ui/icons/special.png",
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + bro[0] + " units/hour [/color] " + bro[1] + " (" + bro[2] + ")"
					});
				}
				return ret;

			case "butcher.Time":
				return [
					{
						id = 1,
						type = "title",
						text = "Time Required"
					},
					{
						id = 2,
						type = "description",
						text = "Total number of hours required to buthcer all the queued items. Assign more people to this task to decrease the amout of time required. Some backgrounds are quicker than others!"
					}
				];

			case "camp-screen.butcher.assignall.button":
				return [
					{
						id = 1,
						type = "title",
						text = "Assign All"
					},
					{
						id = 2,
						type = "description",
						text = "Add all items to the butcher queue."
					}
				];

			case "camp-screen.butcher.removeall.button":
				return [
					{
						id = 1,
						type = "title",
						text = "Remove all"
					},
					{
						id = 2,
						type = "description",
						text = "Remove all items from the butcher queue."
					}
				];

			case this.Const.World.CampBuildings.Butcher:
				return this.World.Camp.getBuildingByID(_elementId).getTooltip();
		
			default:
				return null;
			}

			return null;
	 	};

	 	local ws_tactical_helper_addHintsToTooltip = obj.tactical_helper_addHintsToTooltip;
		obj.tactical_helper_addHintsToTooltip = function( _activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked = false )
		{
			if (!_item.isItemType(this.Const.Items.ItemType.Corpse))
			{
				return ws_tactical_helper_addHintsToTooltip(_activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked);
			}

			local stashLocked = true;

			if (this.Stash != null)
			{
				stashLocked = this.Stash.isLocked();
			}

			local tooltip = _item.getTooltip();

			if (stashLocked == true && _ignoreStashLocked == false)
			{
				if (_item.isChangeableInBattle(_entity) == false)
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/icon_locked.png",
						text = this.Const.Strings.Tooltip.Tactical.Hint_CannotChangeItemInCombat
					});
					return tooltip;
				}

				if (_activeEntity == null || _entity != null && _activeEntity != null && _entity.getID() != _activeEntity.getID())
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/icon_locked.png",
						text = this.Const.Strings.Tooltip.Tactical.Hint_OnlyActiveCharacterCanChangeItemsInCombat
					});
					return tooltip;
				}

				if (_activeEntity != null && _activeEntity.getItems().isActionAffordable([
					_item
				]) == false)
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/tooltips/warning.png",
						text = "Not enough Action Points to change items ([b][color=" + this.Const.UI.Color.NegativeValue + "]" + _activeEntity.getItems().getActionCost([
							_item
						]) + "[/color][/b] required)"
					});
					return tooltip;
				}
			}

			switch(_itemOwner)
			{
			case "entity":
				if (_item.getCurrentSlotType() == this.Const.ItemSlot.Bag && _item.getSlotType() != this.Const.ItemSlot.None)
				{
					if (stashLocked == true)
					{
						if (_item.getSlotType() != this.Const.ItemSlot.Bag && (_entity.getItems().getItemAtSlot(_item.getSlotType()) == null || _entity.getItems().getItemAtSlot(_item.getSlotType()) == "-1" || _entity.getItems().getItemAtSlot(_item.getSlotType()).isAllowedInBag(_entity)))
						{
							tooltip.push({
								id = 1,
								type = "hint",
								icon = "ui/icons/mouse_right_button.png",
								text = "Equip item ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
									_item,
									_entity.getItems().getItemAtSlot(_item.getSlotType()),
									_entity.getItems().getItemAtSlot(_item.getBlockedSlotType())
								]) + "[/color][/b] AP)"
							});
						}

						tooltip.push({
							id = 2,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl.png",
							text = "Drop item on ground ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
								_item
							]) + "[/color][/b] AP)"
						});
					}
					else
					{
						if (_item.getSlotType() != this.Const.ItemSlot.Bag && (_entity.getItems().getItemAtSlot(_item.getSlotType()) == null || _entity.getItems().getItemAtSlot(_item.getSlotType()) == "-1" || _entity.getItems().getItemAtSlot(_item.getSlotType()).isAllowedInBag(_entity)))
						{
							tooltip.push({
								id = 1,
								type = "hint",
								icon = "ui/icons/mouse_right_button.png",
								text = "Equip item"
							});
						}

						tooltip.push({
							id = 2,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl.png",
							text = "Place item in stash"
						});
					}
				}
				else if (stashLocked == true)
				{
					if (_item.isChangeableInBattle(_entity) && _item.isAllowedInBag(_entity) && _entity.getItems().hasEmptySlot(this.Const.ItemSlot.Bag))
					{
						tooltip.push({
							id = 1,
							type = "hint",
							icon = "ui/icons/mouse_right_button.png",
							text = "Place item in bag ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
								_item
							]) + "[/color][/b] AP)"
						});
					}

					tooltip.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/mouse_right_button_ctrl.png",
						text = "Drop item on ground ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
							_item
						]) + "[/color][/b] AP)"
					});
				}
				else
				{
					if (_item.isChangeableInBattle(_activeEntity) && _item.isAllowedInBag(_activeEntity))
					{
						tooltip.push({
							id = 1,
							type = "hint",
							icon = "ui/icons/mouse_right_button.png",
							text = "Place item in bag"
						});
					}

					tooltip.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/mouse_right_button_ctrl.png",
						text = "Place item in stash"
					});
				}

				break;

			case "ground":
			case "character-screen-inventory-list-module.ground":
				if (_item.isChangeableInBattle(_entity))
				{
					if (_item.getSlotType() != this.Const.ItemSlot.None)
					{
						tooltip.push({
							id = 1,
							type = "hint",
							icon = "ui/icons/mouse_right_button.png",
							text = "Equip item ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
								_item,
								_entity.getItems().getItemAtSlot(_item.getSlotType()),
								_entity.getItems().getItemAtSlot(_item.getBlockedSlotType())
							]) + "[/color][/b] AP)"
						});
					}

					if (_item.isAllowedInBag(_entity))
					{
						tooltip.push({
							id = 2,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl.png",
							text = "Place item in bag ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
								_item
							]) + "[/color][/b] AP)"
						});
					}
				}

				break;

			case "stash":
			case "character-screen-inventory-list-module.stash":
				if (_item.isChangeableInBattle(_entity) == true && _item.isAllowedInBag(_entity))
				{
					tooltip.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/mouse_right_button_ctrl.png",
						text = "Place item in bag"
					});
				}
				if (_item.m.MedicinePerDay != 0)
				{
					if (_item.isMaintained())
					{
						tooltip.push({
							id = 1,
							type = "hint",
							icon = "ui/icons/mouse_right_button_alt.png",
							text = "Set item to be preserved"
						});
					}
					else
					{
						tooltip.push({
							id = 1,
							type = "hint",
							icon = "ui/icons/mouse_right_button_alt.png",
							text = "Set item to be butchered"
						});
					}
				}
				else
				{
					if (!_item.isToBeButchered())
					{
						tooltip.push({
							id = 1,
							type = "hint",
							icon = "ui/icons/mouse_right_button_alt.png",
							text = "Set item to be butchered"
						});
					}
				}
				break;

			case "tactical-combat-result-screen.stash":
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "Drop item on the ground"
				});
				break;

			case "tactical-combat-result-screen.found-loot":
				if (this.Stash.hasEmptySlot())
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/mouse_right_button.png",
						text = "Put item into stash"
					});
				}
				else
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/tooltips/warning.png",
						text = "Stash is full"
					});
				}

				break;

			case "camp-screen-repair-dialog-module.stash":
			case "camp-screen-workshop-dialog-module.stash":
			case "world-town-screen-shop-dialog-module.stash":
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "Sell item for [img]gfx/ui/tooltips/money.png[/img]" + _item.getSellPrice()
				});

				if (this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().getCurrentBuilding() != null && this.World.State.getCurrentTown().getCurrentBuilding().isRepairOffered() && _item.getRepairMax() > 1 && _item.getRepair() < _item.getRepairMax())
				{
					local price = (_item.getRepairMax() - _item.getRepair()) * this.Const.World.Assets.CostToRepairPerPoint;
					local value = _item.m.Value * (1.0 - _item.getRepair() / _item.getRepairMax()) * 0.2 * this.World.State.getCurrentTown().getPriceMult() * this.Const.Difficulty.SellPriceMult[this.World.Assets.getEconomicDifficulty()];
					price = this.Math.max(price, value);

					if (this.World.Assets.getMoney() >= price)
					{
						tooltip.push({
							id = 3,
							type = "hint",
							icon = "ui/icons/mouse_right_button_alt.png",
							text = "Pay [img]gfx/ui/tooltips/money.png[/img]" + price + " to have it repaired"
						});
					}
					else
					{
						tooltip.push({
							id = 3,
							type = "hint",
							icon = "ui/tooltips/warning.png",
							text = "Not enough crowns to pay for repairs!"
						});
					}
				}

				break;

			case "camp-screen-repair-dialog-module.shop":
			case "camp-screen-workshop-dialog-module.shop":
			case "world-town-screen-shop-dialog-module.shop":
				if (this.Stash.hasEmptySlot())
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/mouse_right_button.png",
						text = "Buy item for [img]gfx/ui/tooltips/money.png[/img]" + _item.getBuyPrice()
					});
				}
				else
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/tooltips/warning.png",
						text = "Stash is full"
					});
				}

				break;
			}

			return tooltip;
		};
	});

	delete this.HexenHooks.hookCharacterScreenAndStates;
}