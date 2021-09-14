this.day_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.day";
		this.m.Name = "Daytime";
		this.m.Description = "You are a creature of the dark, bathing in sunlight won\'t be any good for you.";
		this.m.Icon = "skills/status_effect_daytime.png";
		this.m.IconMini = "status_effect_daytime_mini";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.Special;
		this.m.IsActive = false;
		this.m.IsSerialized = false;
		this.m.IsHidden = true;
	}

	function getTooltip()
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
			}
		];

		if (this.getContainer().hasSkill("perk.daytime"))
		{
			ret.extend([
		    	{
					id = 11,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Resolve"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] Melee Skill"
				},
				{
					id = 13,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] Melee Defense"
				}
				{
					id = 12,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] Ranged Skill"
				},
				{
					id = 13,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] Ranged Defense"
				}
		    ]);
		}
		else 
		{
		    ret.extend([
		    	{
					id = 11,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] Resolve"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Melee Skill"
				},
				{
					id = 13,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Melee Defense"
				}
				{
					id = 12,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Ranged Skill"
				},
				{
					id = 13,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Ranged Defense"
				}
		    ]);
		}
		
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		if (this.m.IsHidden)
		{
			return;
		}

		if (!this.getContainer().hasSkill("perk.daytime"))
		{
			_properties.BraveryMult *= 0.75;
			_properties.MeleeSkillMult *= 0.9;
			_properties.RangedSkillMult *= 0.9;
			_properties.MeleeDefenseMult *= 0.9;
			_properties.RangedDefenseMult *= 0.9;
		}
		else 
		{
		    _properties.BraveryMult *= 0.9;
			_properties.MeleeSkillMult *= 0.95;
			_properties.RangedSkillMult *= 0.95;
			_properties.MeleeDefenseMult *= 0.95;
			_properties.RangedDefenseMult *= 0.95;
		}
	}

	function onCombatStarted()
	{
		this.m.IsHidden = !this.World.getTime().IsDaytime;
	}

	function onCombatFinished()
	{
		this.m.IsHidden = true;
	}

});

