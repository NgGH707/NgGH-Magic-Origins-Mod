::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/trickster_god_racial", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Godly Regeneration";
		m.Description = "Such unimaginable scene unfolds before your eyes. Is this regeneration?";
		m.Icon = "skills/status_effect_79.png";
		m.IconMini = "status_effect_79_mini";
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	q.getTooltip <- function()
	{
		return [
			{
				id = 1,
				type = "title",
				text = getName()
			},
			{
				id = 2,
				type = "description",
				text = getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Regenerates [color=" + ::Const.UI.Color.PositiveValue + "]6%[/color] of max health per turn"
			}
		];
	}
	
});