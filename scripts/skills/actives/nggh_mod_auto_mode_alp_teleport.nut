this.nggh_mod_auto_mode_alp_teleport <- ::inherit("scripts/skills/nggh_mod_toggle_mode_skill", {
	m = {},
	function create()
	{
		this.nggh_mod_toggle_mode_skill.create();
		this.m.ID = "actives.auto_mode_alp_teleport";
		this.m.Name = "Auto-Teleportation";
		this.m.FlagName = "auto_teleport";
		this.m.Description = "the ability to teleport when you or an allied alp gets hit.";
		this.m.Icon = "skills/active_auto_teleport_on.png";
		this.m.IconDisabled = "skills/active_auto_teleport_off.png";
	}
	

});

