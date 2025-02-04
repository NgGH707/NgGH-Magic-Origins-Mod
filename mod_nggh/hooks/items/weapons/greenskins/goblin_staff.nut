::Nggh_MagicConcept.HooksMod.hook("scripts/items/weapons/greenskins/goblin_staff", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		setWeaponType(::Const.Items.WeaponType.Staff | ::Const.Items.WeaponType.MagicStaff)
	}

	q.onEquip = @() function()
	{
		weapon.onEquip();
		local skill = ::new("scripts/skills/actives/bash");
		skill.m.IsStaffBash = true;
		skill.m.FatigueCost = 10;
		skill.m.MaxRange = 1;
		addSkill(skill);

		skill = ::new("scripts/skills/actives/knock_out");
		skill.m.IsStaffKnockOut = true;
		skill.m.FatigueCost = 22;
		skill.m.MaxRange = 1;
		addSkill(skill);
	}
	
});