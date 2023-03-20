::mods_hookExactClass("skills/racial/skeleton_racial", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Resistant against Ranged Attacks";
		this.m.Description = "Piercing or Ranged attacks are not very effective against this character.";
		this.m.Icon = "ui/perks/perk_32.png";
		this.m.IconMini = "perk_32_mini";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	};
	obj.getTooltip <- function()
	{
		local ret = [
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
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Resistant[/color] against Piercing, Burning or Ranged Damage"
			}
		];

		if ("Assets" in ::World && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/sturdiness.png",
				text = "Takes [color=" + ::Const.UI.Color.PositiveValue + "]25%[/color] less damage to Hitpoints"
			});
		}

		return ret;
	};
});