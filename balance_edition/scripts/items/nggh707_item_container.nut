this.nggh707_item_container <- this.inherit("scripts/items/item_container", {
	m = {
		LockedSlots = [],
		IsCosplaying = false,
		IsGoblin = false,
	},

	function setActor( _a )
	{
		this.m.Actor = this.WeakTableRef(_a);
		this.m.IsGoblin = _a != null && _a.getFlags().has("goblin");
	}

	function create()
	{
		this.item_container.create();
		this.m.LockedSlots = [];
		for ( local i = 0 ; i < 6 ; i = i )
		{
			this.m.LockedSlots.push(false);
			i = ++i;
		}
	}

	function setCosplaying( _f )
	{
		this.m.IsCosplaying = _f;
	}

	function isThisSlotBlocked( _slot )
	{
		if (typeof _slot != "integer")
		{
			return false;
		}
		
		if (_slot >= this.m.LockedSlots.len() || _slot < 0)
		{
			return false;
		}

		return this.m.LockedSlots[_slot];
	}

	function blockThisSlot( _slot )
	{
		if (typeof _slot != "integer")
		{
			return;
		}

		if (_slot >= this.m.LockedSlots.len() || _slot < 0)
		{
			return;
		}

		this.m.LockedSlots[_slot] = true;
	}

	function blockAllSlots()
	{
		for ( local i = 0 ; i < 6 ; i = i )
		{
			this.m.LockedSlots[i] = true;
			i = ++i;
		}
	}

	function equip( _item )
	{
		if (_item == null)
		{
			return false;
		}

		if (_item.getSlotType() == this.Const.ItemSlot.None)
		{
			return false;
		}

		if (_item.getCurrentSlotType() != this.Const.ItemSlot.None)
		{
			this.logWarning("Attempted to equip item " + _item.getName() + ", but it is already placed somewhere else");
			return false;
		}

		if (this.isThisSlotBlocked(_item.getSlotType()))
		{
			return false;
		}

		if (!this.getActor().canEquipThis(_item))
		{
			return false;
		}

		if (!this.getActor().getFlags().has("IsHorseRider"))
		{
			if (_item.getItemType() == this.Const.Items.ItemType.HorseArmor && !this.getActor().getFlags().has("IsHorse") || _item.getItemType() != this.Const.Items.ItemType.HorseArmor && this.getActor().getFlags().has("IsHorse"))
			{
				return false;
			}

			if (_item.getItemType() == this.Const.Items.ItemType.HorseHelmet && !this.getActor().getFlags().has("IsHorse") || _item.getItemType() != this.Const.Items.ItemType.HorseHelmet && this.getActor().getFlags().has("IsHorse"))
			{
				return false;
			}
		}

		local vacancy = -1;

		for( local i = 0; i < this.m.Items[_item.getSlotType()].len(); i = i )
		{
			if (this.m.Items[_item.getSlotType()][i] == null)
			{
				vacancy = i;
				break;
			}

			i = ++i;
		}

		local blocked = -1;

		if (_item.getBlockedSlotType() != null)
		{
			for( local i = 0; i < this.m.Items[_item.getBlockedSlotType()].len(); i = i )
			{
				if (this.m.Items[_item.getBlockedSlotType()][i] == null)
				{
					blocked = i;
					break;
				}

				i = ++i;
			}
		}

		if (vacancy != -1 && (_item.getBlockedSlotType() == null || blocked != -1))
		{
			if (_item.getContainer() != null)
			{
				_item.getContainer().unequip(_item);
			}

			this.m.Items[_item.getSlotType()][vacancy] = _item;

			if (_item.getBlockedSlotType() != null)
			{
				this.m.Items[_item.getBlockedSlotType()][blocked] = -1;
			}

			_item.setContainer(this);
			_item.setCurrentSlotType(_item.getSlotType());

			if (_item.getSlotType() == this.Const.ItemSlot.Bag)
			{
				_item.onPutIntoBag();
			}
			else
			{
				if (!this.getActor().getFlags().has("human") || this.getActor().getFlags().has("Hexe"))
				{
					this.getActor().onActorEquip(_item);
				}

				_item.onEquip();

				if (!this.getActor().getFlags().has("human") || this.getActor().getFlags().has("Hexe"))
				{
					this.getActor().onActorAfterEquip(_item);
				}
			}

			this.m.Actor.getSkills().update();
			return true;
		}
		else
		{
			return false;
		}
	}

	function unequip( _item )
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

		if (!this.getActor().canUnequipThis(_item))
		{
			return false;
		}

		for( local i = 0; i < this.m.Items[_item.getSlotType()].len(); i = i )
		{
			if (this.m.Items[_item.getSlotType()][i] == _item)
			{
				if (!this.getActor().getFlags().has("human") || this.getActor().getFlags().has("Hexe"))
				{
					this.getActor().onActorUnequip(_item);
				}

				_item.onUnequip();
				_item.setContainer(null);
				_item.setCurrentSlotType(this.Const.ItemSlot.None);
				this.m.Items[_item.getSlotType()][i] = null;

				if (!this.getActor().getFlags().has("human") || this.getActor().getFlags().has("Hexe"))
				{
					this.getActor().onActorAfterUnequip(_item);
				}

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

				if (this.m.Actor != null && !this.m.Actor.isNull() && this.m.Actor.isAlive())
				{
					this.m.Actor.getSkills().update();
				}

				return true;
			}

			i = ++i;
		}

		return false;
	}

	function swap( _itemA, _itemB )
	{
		if (_itemA.getSlotType() != _itemB.getSlotType())
		{
			this.logWarning("Unable to swap, items don\'t use the same slot!");
			return false;
		}

		if (_itemA.isEquipped())
		{
			this.unequip(_itemA);

			if (_itemB.isInBag())
			{
				this.removeFromBag(_itemB);
				this.addToBag(_itemA);
			}

			this.equip(_itemB);
		}
		else if (_itemB.isEquipped())
		{
			this.unequip(_itemB);

			if (_itemA.isInBag())
			{
				this.removeFromBag(_itemA);
				this.addToBag(_itemB);
			}

			this.equip(_itemA);
		}
		else
		{
			this.logWarning("Neither item is equipped, unable to swap!");
			return false;
		}

		return true;
	}

	function drop( item )
	{
		if (!this.m.Actor.isPlacedOnMap())
		{
			return;
		}

		local _tile = this.m.Actor.getTile();
		item.m.IsDroppedAsLoot = true;
		item.drop(_tile);
		_tile.IsContainingItemsFlipped = true;
	}
	
	function unequipNoUpdate( _item )
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
	}

	function transferToList( _stash )
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
	}

	function onActorDied( _onTile )
	{
		this.m.IsUpdating = true;

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = i )
		{
			for( local j = 0; j < this.m.Items[i].len(); j = j )
			{
				if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
				{
				}
				else
				{
					this.m.Items[i][j].onActorDied(_onTile);

					if (this.m.IsGoblin)
					{
						this.m.Actor.m.Mount.onActorDied(_onTile);
					}
				}

				j = ++j;
			}

			i = ++i;
		}

		this.m.IsUpdating = false;
	}

	function onDamageReceived( _damage, _fatalityType, _slotType, _attacker )
	{
		if (this.m.IsCosplaying && _damage > 1)
		{
			_damage = 1;
		}

		this.item_container.onDamageReceived(_damage, _fatalityType, _slotType, _attacker);
	}

});

