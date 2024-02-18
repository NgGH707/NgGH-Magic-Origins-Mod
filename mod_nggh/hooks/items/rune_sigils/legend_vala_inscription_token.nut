::mods_hookExactClass("items/rune_sigils/legend_vala_inscription_token", function(obj) 
{
	local onUse = obj.onUse;
	obj.onUse <- function( _actor, _item = null )
	{
		if (onUse(_actor, _item))
			return true;

		local target;

		if (this.m.RuneVariant == 101 || this.m.RuneVariant == 104 || this.m.RuneVariant == 105)
		{
			target = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);

			if (target == null || target.getID() == "weapon.nggh_ancient_lich_book")
				return false;
		}
		else if (this.m.RuneVariant == 100 || this.m.RuneVariant == 107)
		{
			target = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Head);

			if (target == null)
				return false;
		}
		else if (this.m.RuneVariant == 102 || this.m.RuneVariant == 103)
		{
			target = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Body);

			if (target == null)
				return false;
		}
		else if (this.m.RuneVariant == 106)
		{
			target = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);

			if (target == null || target.getID().find("shield") == null)
				return false;
		}
		else
		{
			return false;
		}

		::Sound.play("sounds/combat/legend_vala_inscribe.wav");
		local alreadyRuned = target.isRuned();
		target.setRuneVariant(this.m.RuneVariant);
		target.setRuneBonus1(this.m.RuneBonus1);
		target.setRuneBonus2(this.m.RuneBonus2);

		if (!alreadyRuned)
			target.updateRuneSigil();

		_actor.getItems().unequip(target);
		_actor.getItems().equip(target);
		return true;
	}
});