this.getroottable().HexenHooks.hookItem <- function ()
{
	//Change this goblin balls sprite so it doesn't look too weird when your goblin is on a mount
	::mods_hookExactClass("items/weapons/greenskins/goblin_spiked_balls", function(obj) 
	{
		local oldFunction = obj.create;
		obj.create = function()
		{
			oldFunction();
			this.m.ArmamentIcon = "icon_goblin_balls";
		}
	});

	::mods_hookExactClass("items/item_container", function ( o )
	{
		o.drop <- function ( item )
		{
			if (!this.m.Actor.isPlacedOnMap())
			{
				return;
			}

			local _tile = this.m.Actor.getTile();
			item.m.IsDroppedAsLoot = true;
			item.drop(_tile);
			_tile.IsContainingItemsFlipped = true;
		};
		local equipfn = o.equip;
		o.equip = function ( _item )
		{
			if (_item == null)
			{
				return false;
			}

			if (this.getActor().getFlags().has("human"))
			{
				local invalid_armor = [
					"armor.body.legend_orc_behemoth_armor",
					"armor.body.orc_berserker_light_armor",
					"armor.body.orc_berserker_medium_armor",
					"armor.body.orc_elite_heavy_armor",
					"armor.body.orc_warlord_armor",
					"armor.body.orc_warrior_heavy_armor",
					"armor.body.orc_warrior_light_armor",
					"armor.body.orc_warrior_medium_armor",
					"armor.body.orc_young_heavy_armor",
					"armor.body.orc_young_light_armor",
					"armor.body.orc_young_medium_armor",
					"armor.body.orc_young_very_light_armor",
					"armor.body.goblin_heavy_armor",
					"armor.body.goblin_leader_armor",
					"armor.body.goblin_light_armor",
					"armor.body.goblin_medium_armor",
					"armor.body.goblin_shaman_armor",
					"armor.body.goblin_skirmisher_armor",
					"armor.body.unhold_armor_heavy",
					"armor.body.unhold_armor_light",
				];

				if (_item.isItemType(this.Const.Items.ItemType.Armor) && invalid_armor.find(_item.getID()) != null)
				{
					return false;	
				}

				local invalid_helmet = [
					"armor.head.orc_berserker_helmet",
					"armor.head.orc_warrior_heavy_helmet",
					"armor.head.orc_warrior_light_helmet",
					"armor.head.orc_warrior_medium_helmet",
					"armor.head.orc_young_heavy_helmet",
					"armor.head.orc_young_light_helmet",
					"armor.head.orc_young_medium_helmet",
					"armor.head.orc_elite_heavy_helmet",
					"armor.head.legend_orc_behemoth_helmet",
					"armor.head.orc_warlord_helmet",
					"armor.head.goblin_heavy_helmet",
					"armor.head.goblin_leader_helmet",
					"armor.head.goblin_light_helmet",
					"armor.head.goblin_shaman_helmet",
					"armor.head.goblin_skirmisher_helmet",
					"armor.head.unhold_helmet_heavy",
					"armor.head.unhold_helmet_light",
				];

				if (_item.isItemType(this.Const.Items.ItemType.Helmet) && invalid_helmet.find(_item.getID()) != null)
				{
					return false;
				}
			}

			return equipfn(_item);
		};
		o.unequipNoUpdate <- function ( _item )
		{
			if (_item == null || _item == -1)
			{
				return;
			}

			if (_item.getCurrentSlotType() == this.Const.ItemSlot.None || _item.getCurrentSlotType() == this.Const.ItemSlot.Bag)
			{
				this.logWarning("Attempted to unequip item " + _item.getName() + ", but is not equipped");
				return false;
			}

			for( local i = 0; i < this.m.Items[_item.getSlotType()].len(); i = i )
			{
				if (this.m.Items[_item.getSlotType()][i] == _item)
				{
					this.m.Items[_item.getSlotType()][i] = null;

					if (_item.getBlockedSlotType() != null)
					{
						for( local i = 0; i < this.m.Items[_item.getBlockedSlotType()].len(); i = i )
						{
							if (this.m.Items[_item.getBlockedSlotType()][i] == -1)
							{
								this.m.Items[_item.getBlockedSlotType()][i] = null;
								break;
							}

							i = ++i;
						}
					}

					return true;
				}

				i = ++i;
			}

			return false;
		};
		o.transferToList <- function ( _stash )
		{
			for( local i = 0; i < this.Const.ItemSlot.COUNT; i = i )
			{
				for( local j = 0; j < this.m.Items[i].len(); j = j )
				{
					if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
					{
					}
					else
					{
						local item = this.m.Items[i][j];

						if (item.isEquipped())
						{
							this.unequip(item);
						}
						else
						{
							this.removeFromBag(item);
						}

						_stash.push(item);
					}

					j = ++j;
				}

				i = ++i;
			}
		};
	});

	//show blocked equipment slot
	::mods_hookNewObject("ui/global/data_helper", function ( obj )
	{
		local ws_convertEntityToUIData = obj.convertEntityToUIData;
		obj.convertEntityToUIData = function( _entity, _activeEntity )
		{
			if (_entity.isSummoned() || !this.isKindOf(_entity, "player"))
			{
				local result = {
					id = _entity.getID(),
					flags = {},
					character = {},
					stats = {},
					activeSkills = {},
					passiveSkills = {},
					statusEffects = {},
					injuries = [],
					perks = [],
					perkTree = [],
					equipment = {},
					bag = [],
					ground = []
				};
				this.addFlagsToUIData(_entity, _activeEntity, result.flags);
				this.addCharacterToUIData(_entity, result.character);
				this.addStatsToUIData(_entity, result.stats);
				local skills = _entity.getSkills();
				this.addSkillsToUIData(skills.querySortedByItems(this.Const.SkillType.Active), result.activeSkills);
				this.addSkillsToUIData(skills.querySortedByItems(this.Const.SkillType.Trait | this.Const.SkillType.PermanentInjury), result.passiveSkills);
				local injuries = skills.query(this.Const.SkillType.TemporaryInjury | this.Const.SkillType.SemiInjury);

				foreach( i in injuries )
				{
					result.injuries.push({
						id = i.getID(),
						imagePath = i.getIconColored()
					});
				}

				this.addSkillsToUIData(skills.querySortedByItems(this.Const.SkillType.StatusEffect, this.Const.SkillType.Trait), result.passiveSkills);
				this.addPerksToUIData(_entity, skills.query(this.Const.SkillType.Perk, true), result.perks);
				local items = _entity.getItems();
				this.convertPaperdollEquipmentToUIData(items, result.equipment);
				this.convertBagItemsToUIData(items, result.bag);

				if (this.Tactical.isActive() && _entity.getTile() != null)
				{
					this.convertItemsToUIData(_entity.getTile().Items, result.ground);
					result.ground.push(null);
				}

				return result;
			}

			return ws_convertEntityToUIData(_entity, _activeEntity);
		}

		local ws_addCharacterToUIData = obj.addCharacterToUIData;
		obj.addCharacterToUIData = function( _entity, _target )
		{
			if (_entity.isSummoned())
			{
				_target.name <- _entity.getNameOnly();
				_target.title <- _entity.getTitle();
				_target.imagePath <- _entity.getImagePath();
				_target.imageOffsetX <- _entity.getImageOffsetX();
				_target.imageOffsetY <- _entity.getImageOffsetY();
				_target.perkPoints <- 0;
				_target.perkPointsSpent <- 0;
				_target.level <- 1;
				_target.levelUp <- null;
				_target.daysWithCompany <- 1;
				_target.xpValue <- 0;
				_target.xpValueMax <- 999999;
				_target.dailyMoneyCost <- 0;
				_target.daysWounded <- 0;
				_target.leveledUp <- false;
				_target.moodIcon <- "ui/icons/mood_04.png";
				_target.isPlayerCharacter <- false;
				_target.background <- "";
				_target.inReserves <- false;
				_target.stabled <- false;
				_target.riderID <- "";
				return;
			}

			ws_addCharacterToUIData(_entity, _target);
		}
		
		obj.convertBlockedSlotsToUIData <- function( _items, _target )
		{
			if (_items == null)
			{
				return;
			}

			_target.body <- _items.isThisSlotBlocked(this.Const.ItemSlot.Body);
			_target.head <- _items.isThisSlotBlocked(this.Const.ItemSlot.Head)
			_target.mainhand <- _items.isThisSlotBlocked(this.Const.ItemSlot.Mainhand);
			_target.offhand <- _items.isThisSlotBlocked(this.Const.ItemSlot.Offhand);
			_target.accessory <- _items.isThisSlotBlocked(this.Const.ItemSlot.Accessory);
			_target.ammo <- _items.isThisSlotBlocked(this.Const.ItemSlot.Ammo);
		}

		local ws_convertEntityToUIData = obj.convertEntityToUIData;
		obj.convertEntityToUIData = function( _entity, _activeEntity )
		{
			local result = ws_convertEntityToUIData(_entity, _activeEntity);
			local items = _entity.getItems();

			if (items != null && this.isKindOf(items, "nggh707_item_container"))
			{
				result.restriction <- {};
				this.convertBlockedSlotsToUIData(items, result.restriction);
			}

			return result;
		}
	});

	delete this.HexenHooks.hookItem;
}