::mods_hookExactClass("skills/racial/trickster_god_racial", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Godly Regeneration";
		this.m.Description = "Such unimaginable scene unfolds before your eyes. Is this regeneration?";
		this.m.Icon = "skills/status_effect_79.png";
		this.m.IconMini = "status_effect_79_mini";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
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
				icon = "ui/icons/days_wounded.png",
				text = "Regenerates [color=" + ::Const.UI.Color.PositiveValue + "]6%[/color] of max health"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has an attack that can [color=" + ::Const.UI.Color.PositiveValue + "]Ignore[/color] knock back immunity"
			}
		];
	};
});