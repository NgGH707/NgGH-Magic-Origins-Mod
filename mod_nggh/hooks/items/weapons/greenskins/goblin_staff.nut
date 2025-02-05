::Nggh_MagicConcept.HooksMod.hook("scripts/items/weapons/greenskins/goblin_staff", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		setWeaponType(::Const.Items.WeaponType.Mace | ::Const.Items.WeaponType.Staff | ::Const.Items.WeaponType.MagicStaff)
	}
	
});