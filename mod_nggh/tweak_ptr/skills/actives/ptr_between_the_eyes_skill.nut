::mods_hookExactClass("skills/actives/ptr_between_the_eyes_skill", function ( obj )
{
	obj.isHidden <- function()
	{
		if (this.getContainer().getActor().getFlags().has("human"))
		{
			return !this.getContainer().getActor().isArmedWithMeleeWeapon();
		}

		return this.m.IsHidden;
	};
});