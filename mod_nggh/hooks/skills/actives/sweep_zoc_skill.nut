::mods_hookExactClass("skills/actives/sweep_zoc_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted - 10;
		this.m.IsHidden = true;
	};
	obj.isUsable <- function()
	{
		return this.m.IsUsable && ::MSU.isNull(this.getContainer().getActor().getMainhandItem()) && this.getContainer().getActor().getCurrentProperties().IsAbleToUseSkills;
	};
});