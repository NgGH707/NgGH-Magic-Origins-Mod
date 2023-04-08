// set up the magic points preview system 
::mods_hookNewObject("ui/global/data_helper", function(obj)
{
	local ws_addStatsToUIData = obj.addStatsToUIData;
	obj.addStatsToUIData = function( _entity, _target )
	{
		ws_addStatsToUIData(_entity, _target);

		/*
		if (_entity.isAbleToUseMagic())
		{
			_target.MagicPoints <- _entity.getMagicPoints();
			_target.MagicPointsMax <- _entity.getMagicPointsMax();
		}
		*/

		if (_entity.isMounted())
		{
			local mount = _entity.getMount();
			_target.MountHitpoints <- mount.getHitpoints();
			_target.MountHitpointsMax <- mount.getHitpointsMax();
			_target.MountArmorHead <- mount.getArmor(::Const.BodyPart.Head);
			_target.MountArmorHeadMax <- mount.getArmorMax(::Const.BodyPart.Head);
			_target.MountArmorBody <- mount.getArmor(::Const.BodyPart.Body);
			_target.MountArmorBodyMax <- mount.getArmorMax(::Const.BodyPart.Body);
		}
	}

	// to show blocked equipment slots
	local ws_convertPaperdollEquipmentToUIData = obj.convertPaperdollEquipmentToUIData;
	obj.convertPaperdollEquipmentToUIData = function( _items, _target )
	{
		ws_convertPaperdollEquipmentToUIData(_items, _target);
		if (_items == null) return;
		
		local blocked = [];
		local hasTwoHandBlockedSlot = false;
		for (local i = ::Const.ItemSlot.Mainhand; i <= ::Const.ItemSlot.Ammo; ++i)
		{
			if (i == ::Const.ItemSlot.Mainhand && _items.getData()[i][0] != null && _items.getData()[i][0] != -1)
			{
				hasTwoHandBlockedSlot = _items.getData()[i][0].getBlockedSlotType() != null;
				continue;
			}

			if (i == ::Const.ItemSlot.Offhand && hasTwoHandBlockedSlot)
			{
				continue;
			}

			if (_items.getData()[i][0] != -1)
			{
				continue;
			}

			blocked.push(i);
		}

		if (blocked.len() > 0)
		{
			_target.BlockedSlots <- blocked;
		}
	}

	if (::Is_PlanYourPerks_Exist && ("addPlannedPerksToUIData" in obj))
	{
		local ws_addPlannedPerksToUIData = obj.addPlannedPerksToUIData;
		obj.addPlannedPerksToUIData = function( _entity )
		{
			local PlannedPerksDict = {}
			//weird error
			if (_entity.getPlannedPerks().len() == 0) return ws_addPlannedPerksToUIData(_entity)
			foreach(key, value in _entity.getPlannedPerks()){
				PlannedPerksDict[key] <- value
			}
			return PlannedPerksDict
		}
	}
	
});