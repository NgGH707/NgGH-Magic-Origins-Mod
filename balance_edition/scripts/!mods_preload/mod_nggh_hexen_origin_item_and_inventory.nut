this.getroottable().HexenHooks.hookItem <- function ()
{
	this.Const.Items.addNewItemType("Ancient");
	local pretext = "scripts/";
	local ancient_weapons = this.IO.enumerateFiles(pretext + "items/weapons/ancient/");
	ancient_weapons.extend([
		"items/weapons/named/legend_named_gladius",
		"items/weapons/named/named_bladed_pike",
		"items/weapons/named/named_crypt_cleaver",
		"items/weapons/named/named_khopesh",
		"items/weapons/named/named_legend_great_khopesh",
		"items/weapons/named/named_warscythe",
	]);

	foreach (directory in ancient_weapons)
	{
		local idx = directory.find(pretext);

		if (idx != null)
		{
			directory = directory.slice(idx + pretext.len());
		}

		::mods_hookNewObject(directory, function(obj) 
		{
			obj.addItemType(this.Const.Items.ItemType.Ancient);
		});
	}

	
	// change this goblin balls sprite so it doesn't look too weird when your goblin is on a mount
	::mods_hookExactClass("items/weapons/greenskins/goblin_spiked_balls", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.ArmamentIcon = "icon_goblin_balls";
		}
	});


	//
	::mods_hookExactClass("items/weapons/greenskins/goblin_staff", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.WeaponType = this.Const.Items.WeaponType.Staff | this.Const.Items.WeaponType.MagicStaff;
			this.setupCategories();
		};
		obj.onEquip = function()
		{
			this.weapon.onEquip();
			local s = this.new("scripts/skills/actives/legend_staff_bash");
			s.m.FatigueCost = 12;
			s.m.MaxRange = 1;
			this.addSkill(s);

			s = this.new("scripts/skills/actives/legend_staff_knock_out");
			s.m.FatigueCost = 25;
			s.m.MaxRange = 1;
			this.addSkill(s);

			if (::mods_getRegisteredMod("mod_legends_PTR") != null)
			{
				this.addSkill(this.new("scripts/skills/actives/ptr_staff_sweep_skill"));
			}
		};
	});


	// allow enemy to spawn dog on death
	::mods_hookBaseClass("items/accessory/accessory_dog", function(obj) 
	{
	    obj = obj[obj.SuperName];
		obj.onActorDied = function( _onTile )
		{
			if (!this.isUnleashed() && _onTile != null)
			{
				local faction = this.getContainer().getActor().getFaction();
				local entity = this.Tactical.spawnEntity(this.getScript(), _onTile.Coords.X, _onTile.Coords.Y);
				entity.setItem(this);
				entity.setName(this.getName());
				entity.setVariant(this.getVariant());
				if (this.getContainer().getActor().getSkills().hasSkill("perk.legend_dogwhisperer"))
				{
					entity.getSkills().add(this.new("scripts/skills/perks/perk_fortified_mind"));
					entity.getSkills().add(this.new("scripts/skills/perks/perk_colossus"));
					entity.getSkills().add(this.new("scripts/skills/perks/perk_underdog"));
				}

				this.setEntity(entity);
				entity.setFaction(faction == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : faction);

				if (this.m.ArmorScript != null)
				{
					local item = this.new(this.m.ArmorScript);
					entity.getItems().equip(item);
				}

				this.Sound.play(this.m.UnleashSounds[this.Math.rand(0, this.m.UnleashSounds.len() - 1)], this.Const.Sound.Volume.Skill, _onTile.Pos);
			}
		}
	});


	//
	::mods_hookNewObject("items/item_container", function ( obj )
	{
		local ws_equip = obj.equip;
		obj.equip = function ( _item )
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

			return ws_equip(_item);
		};

		if (!("drop" in obj))
		{
			obj.drop <- function ( item )
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
		}

		if (!("unequipNoUpdate" in obj))
		{
			obj.unequipNoUpdate <- function ( _item )
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
		}

		if (!("transferToList" in obj))
		{
			obj.transferToList <- function ( _stash )
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
		}
	});

	::mods_hookNewObject("items/stash_container", function(obj)
	{
		obj.m.IsUpdating <- false;

		local ws_makeEmptySlots = obj.makeEmptySlots;
		obj.makeEmptySlots = function( _n )
		{
			ws_makeEmptySlots(_n);
			this.collectGarbage();
		};

		local ws_add = obj.add;
		obj.add = function( _item )
		{
			local adding = ws_add(_item);
			this.collectGarbage();
			return adding;
		};

		/*local ws_insert = obj.insert;
		obj.insert = function( _item, _index )
		{
			local inserting = ws_insert(_item, _index);
			this.collectGarbage();
			return inserting;
		};

		local ws_remove = obj.remove;
		obj.remove = function( _item )
		{
			local removing = ws_remove(_item);
			this.collectGarbage();
			return removing;
		};

		local ws_removeByID = obj.removeByID;
		obj.removeByID = function( _id )
		{
			local removing = ws_removeByID(_id);
			this.collectGarbage();
			return removing;
		};*/
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
			if (_entity.isSummoned() || !this.isKindOf(_entity, "player"))
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
				result.restriction.Icon <- "missing_component_70x70.png";
				result.restriction.IconLarge <- "missing_component_140x70.png";
				this.convertBlockedSlotsToUIData(items, result.restriction);
			}

			return result;
		}
	});

	delete this.HexenHooks.hookItem;
}