::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/ptr_between_the_eyes_skill", function ( q ) {
	q.isHidden <- function() {
		if (this.getContainer().getActor().getFlags().has("human"))
			return !this.getContainer().getActor().isArmedWithMeleeWeapon();

		return this.m.IsHidden;
	};
});