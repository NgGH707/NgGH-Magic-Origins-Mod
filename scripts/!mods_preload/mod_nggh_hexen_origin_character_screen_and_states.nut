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

		obj.executeEntitySkill = function( _activeEntity, _targetTile )
		{
			local skill = _activeEntity.getSkills().getSkillByID(this.m.SelectedSkillID);

			if (skill != null && skill.isUsable() && skill.isAffordable())
			{
				if (_targetTile == null || skill.isTargeted() && this.wasInCameraMovementMode())
				{
					return;
				}

				if (skill.isUsableOn(_targetTile))
				{
					if (!_targetTile.IsEmpty)
					{
						local targetEntity = _targetTile.getEntity();

						if (this.Tactical.getCamera().Level < _targetTile.Level)
						{
							this.Tactical.getCamera().Level = this.Tactical.getCamera().getBestLevelForTile(_targetTile);
						}

						if (this.isKindOf(targetEntity, "actor"))
						{
							this.logDebug("[" + _activeEntity.getName() + "] executes skill [" + skill.getName() + "] on target [" + targetEntity.getName() + "]");
						}
					}

					skill.use(_targetTile);

					if (_activeEntity.isAlive())
					{
						this.Tactical.TurnSequenceBar.updateEntity(_activeEntity.getID());

						if (_activeEntity.getFlags().has("can_mount") && this.Const.UnleashSkills.find(skill.getID()) != null)
						{
							_activeEntity.m.Mount.onDismountPet();
						}
					}

					this.Tooltip.reload();
					this.Tactical.TurnSequenceBar.deselectActiveSkill();
					this.Tactical.getHighlighter().clear();
					this.m.CurrentActionState = null;
					this.m.SelectedSkillID = null;
					this.updateCursorAndTooltip();
				}
				else
				{
					this.Cursor.setCursor(this.Const.UI.Cursor.Denied);
					this.Tactical.EventLog.log("[color=" + this.Const.UI.Color.NegativeValue + "]Invalid target![/color]");
				}
			}
		}
	});

	delete this.HexenHooks.hookCharacterScreenAndStates;
}