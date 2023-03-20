::mods_hookExactClass("skills/racial/lindwurm_racial", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Acidic Blood";
		this.m.Description = "This beast has one of the most dangerous blood, it can easily dissolve most kinds of armor.";
		this.m.Icon = "skills/status_effect_78.png";
		this.m.IconMini = "status_effect_78_mini";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	};
	obj.getTooltip <- function()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Splashes acidic blood on melee attacker"
			}
		];
	}
});