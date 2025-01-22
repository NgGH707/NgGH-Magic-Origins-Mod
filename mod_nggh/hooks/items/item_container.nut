::Nggh_MagicConcept.HooksMod.hook("scripts/items/item_container", function ( q )
{
	q.m.IsCosplaying <- false;

	q.setCosplaying <- function( _f )
	{
		m.IsCosplaying = _f;
	}

	q.onDamageReceived = @(__original) function( _damage, _fatalityType, _slotType, _attacker )
	{
		if (m.IsCosplaying)
			_damage = 1; // make cosmetic item to lose next to no durability

		__original(_damage, _fatalityType, _slotType, _attacker);
	}

	q.onActorDied = @(__original) function( _onTile )
	{
		__original(_onTile);

		if (!::MSU.isNull(m.Actor) && m.Actor.isMounted()))
			m.Actor.getMount().onActorDied(_onTile);
	}

	q.equip = @(__original) function ( _item )
	{
		if (_item == null)
			return false;

		if (::MSU.isNull(getActor()) || !getActor().isAbleToEquip(_item))
			return false;

		local ret = __original(_item);

		if (ret)
			getActor().onAfterEquip(_item);

		return ret;
	}

	q.unequip = @(__original) function ( _item )
	{
		if (_item == null || _item == -1)
			return false;

		if (::MSU.isNull(getActor()) || !getActor().isAbleToUnequip(_item))
			return false;

		local ret = __original(_item);

		if (ret)
			getActor().onAfterUnequip(_item);

		return ret;
	}
	
});	