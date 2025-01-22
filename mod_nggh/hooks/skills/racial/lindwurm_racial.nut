::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/lindwurm_racial", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Acidic Blood";
		m.Description = "This beast has one of the most dangerous blood, it can easily dissolve most kinds of armor.";
		m.Icon = "skills/status_effect_78.png";
		m.IconMini = "status_effect_78_mini";
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First;
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
				icon = "ui/icons/special.png",
				text = "Splashes acidic blood on melee attacker"
			}
		];
	}
	
});