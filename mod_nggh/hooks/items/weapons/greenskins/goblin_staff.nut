::Nggh_MagicConcept.HooksMod.hook("scripts/items/weapons/greenskins/goblin_staff", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		setWeaponType(::Const.Items.WeaponType.Staff | ::Const.Items.WeaponType.MagicStaff)
	}

	q.onEquip = function()
	{
		weapon.onEquip();
		local skill = ::new("scripts/skills/actives/legend_staff_bash");
		skill.m.FatigueCost = 10;
		skill.m.MaxRange = 1;
		addSkill(skill);

		skill = ::new("scripts/skills/actives/legend_staff_knock_out");
		skill.m.FatigueCost = 22;
		skill.m.MaxRange = 1;
		addSkill(skill);

		if (::Is_PTR_Exist)
			addSkill(::new("scripts/skills/actives/ptr_staff_sweep_skill"));
	}
	
});