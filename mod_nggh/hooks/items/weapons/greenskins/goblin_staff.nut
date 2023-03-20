::mods_hookExactClass("items/weapons/greenskins/goblin_staff", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.WeaponType = ::Const.Items.WeaponType.Staff | ::Const.Items.WeaponType.MagicStaff;
		this.setupCategories();
	};
	obj.onEquip = function()
	{
		this.weapon.onEquip();
		local skill = ::new("scripts/skills/actives/legend_staff_bash");
		skill.m.FatigueCost = 10;
		skill.m.MaxRange = 1;
		this.addSkill(skill);

		skill = ::new("scripts/skills/actives/legend_staff_knock_out");
		skill.m.FatigueCost = 22;
		skill.m.MaxRange = 1;
		this.addSkill(skill);

		if (::Is_PTR_Exist)
		{
			this.addSkill(::new("scripts/skills/actives/ptr_staff_sweep_skill"));
		}
	};
});