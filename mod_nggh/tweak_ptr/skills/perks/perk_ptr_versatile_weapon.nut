::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_ptr_versatile_weapon", function ( q )
{
	q.m.IsForceEnabled <- false;
	q.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	}
	q.onUpdate = @() function( _properties )
	{
		if (!this.m.IsForceEnabled) {
			local weapon = this.getContainer().getActor().getMainhandItem();

			if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Sword))
				return;
		}

		_properties.MeleeDamageMult += this.m.Bonus;
		_properties.DamageDirectAdd += this.m.Bonus;
		_properties.DamageArmorMult += this.m.Bonus;
	}
});