::mods_hookExactClass("skills/perks/perk_ptr_versatile_weapon", function ( obj )
{
	obj.m.IsForceEnabled <- false;
	obj.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	};
	obj.onUpdate <- function( _properties )
	{
		if (!this.m.IsForceEnabled)
		{
			local weapon = this.getContainer().getActor().getMainhandItem();

			if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Sword))
			{
				return;
			}
		}

		_properties.MeleeDamageMult += this.m.Bonus;
		_properties.DamageDirectAdd += this.m.Bonus;
		_properties.DamageArmorMult += this.m.Bonus;
	}
});