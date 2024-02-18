::mods_hookNewObject("items/item_container", function ( obj )
{
	obj.m.IsCosplaying <- false;

	obj.setCosplaying <- function( _f )
	{
		this.m.IsCosplaying = _f;
	}

	local ws_onDamageReceived = obj.onDamageReceived;
	obj.onDamageReceived = function( _damage, _fatalityType, _slotType, _attacker )
	{
		// make cosmetic item to lose next to no durability
		if (this.m.IsCosplaying)
			_damage = 1;

		ws_onDamageReceived(_damage, _fatalityType, _slotType, _attacker);
	}

	local ws_onActorDied = obj.onActorDied;
	obj.onActorDied = function( _onTile )
	{
		ws_onActorDied(_onTile);

		if (!::MSU.isNull(this.m.Actor) && this.m.Actor.isMounted()))
			this.m.Actor.getMount().onActorDied(_onTile);
	}

	local ws_equip = obj.equip;
	obj.equip = function ( _item )
	{
		if (_item == null)
			return false;

		if (::MSU.isNull(this.m.Actor) || !this.getActor().isAbleToEquip(_item))
			return false;

		local ret = ws_equip(_item);

		if (ret)
			this.getActor().onAfterEquip(_item);

		return ret;
	};

	local ws_unequip = obj.unequip;
	obj.unequip = function ( _item )
	{
		if (_item == null || _item == -1)
			return false;

		if (::MSU.isNull(this.m.Actor) || !this.getActor().isAbleToUnequip(_item))
			return false;

		local ret = ws_unequip(_item);

		if (ret)
			this.getActor().onAfterUnequip(_item);

		return ret;
	};
});	