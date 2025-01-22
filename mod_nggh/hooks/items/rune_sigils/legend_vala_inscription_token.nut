::Nggh_MagicConcept.HooksMod.hook("scripts/items/rune_sigils/legend_vala_inscription_token", function(q) 
{
	q.onUse = @(__original) function( _actor, _item = null )
	{
		if (__original(_actor, _item))
			return true;

		local target;

		if (m.RuneVariant == 101 || m.RuneVariant == 104 || m.RuneVariant == 105) {
			target = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);

			if (target == null || target.getID() == "weapon.nggh_ancient_lich_book")
				return false;
		}
		else if (m.RuneVariant == 100 || m.RuneVariant == 107) {
			target = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Head);

			if (target == null)
				return false;
		}
		else if (m.RuneVariant == 102 || m.RuneVariant == 103) {
			target = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Body);

			if (target == null)
				return false;
		}
		else if (m.RuneVariant == 106) {
			target = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);

			if (target == null || target.getID().find("shield") == null)
				return false;
		}
		else {
			return false;
		}

		::Sound.play("sounds/combat/legend_vala_inscribe.wav");
		local alreadyRuned = target.isRuned();
		target.setRuneVariant(m.RuneVariant);
		target.setRuneBonus1(m.RuneBonus1);
		target.setRuneBonus2(m.RuneBonus2);

		if (!alreadyRuned)
			target.updateRuneSigil();

		_actor.getItems().unequip(target);
		_actor.getItems().equip(target);
		return true;
	}
	
});