this.champion_racial <- this.inherit("scripts/skills/skill", {
	m = {
		GainHP = false,
		IsPlayer = false,
	},
	function create()
	{
		this.m.ID = "racial.champion";
		this.m.Name = "Champion";
		this.m.Description = "The toughest among the strongest. Who dares to challenge those like them?";
		this.m.Icon = "skills/status_effect_108.png";
		this.m.IconMini = "status_effect_108_mini";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onRemoved()
	{
		this.getContainer().getActor().getSprite("miniboss").Visible = false;
	}
	
	function onAdded()
	{
		if (this.getContainer().getActor().hasSprite("miniboss"))
		{
			this.getContainer().getActor().getSprite("miniboss").setBrush("bust_miniboss");
		}

		if (!this.getContainer().getActor().isPlayerControlled())
		{
			return;
		}
		
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.getContainer().getActor().m.IsMiniboss = true;
		this.getContainer().update();
		
		if (this.isKindOf(this.getContainer().getActor().get(), "spider_player") && this.getContainer().getActor().getSize() < 1.0)
		{
			this.getContainer().getActor().setSize(0.95);
		}
	}
	
	function getTooltip()
	{
		local mult = this.m.IsPlayer ? 0.75 : 1.0;
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
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor((this.m.GainHP ? 1.35 : 1) * 35 * mult) + "%[/color] Hitpoints"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(15 * mult) + "%[/color] Attack Damage"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(15 * mult) + "%[/color] Initiative"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(15 * mult) + "%[/color] Melee Skill"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor((this.m.GainHP ? 1 : 1.25) * 25 * mult) + "%[/color] Ranged Skill"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor((this.m.GainHP ? 1 : 1.25) * 25 * mult) + "%[/color] Melee Defense"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(15 * mult) + "%[/color] Ranged Defense"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(50 * mult) + "%[/color] Resolve"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(50 * mult) + "%[/color] Max Fatigue"
			}
		];
	}

	function onUpdate( _properties )
	{
		local mult = this.m.IsPlayer ? 0.75 : 1.0;
		_properties.DamageTotalMult *= 1 + (0.15 * mult);
		_properties.BraveryMult *= 1 + (0.5 * mult);
		_properties.StaminaMult *= 1 + (0.5 * mult);
		_properties.MeleeSkillMult *= 1 + (0.15 * mult);
		_properties.RangedSkillMult *= 1 + (0.15 * mult);
		_properties.InitiativeMult *= 1 + (0.15 * mult);
	
		_properties.MeleeDefenseMult *= 1 + (0.25 * mult);
		_properties.RangedDefenseMult *= 1 + (0.25 * mult);
		_properties.HitpointsMult *= 1 + (0.35 * mult);

		if (this.getContainer().getActor().getBaseProperties().MeleeDefense >= 20 || this.getContainer().getActor().getBaseProperties().RangedDefense >= 20 || this.getContainer().getActor().getBaseProperties().MeleeDefense >= 15 && this.getContainer().getActor().getBaseProperties().RangedDefense >= 15)
		{
			_properties.MeleeDefenseMult *= 1 + (0.25 * mult);
			_properties.RangedDefenseMult *= 1 + (0.25 * mult);
			this.m.GainHP = false;
		}
		else
		{
			_properties.HitpointsMult *= 1 + (0.35 * mult);
			this.m.GainHP = true;
		}
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null)
		{
			return;
		}
		
		if (_skill.getID() == "actives.spider_bite" || _skill.getID() == "actives.legend_redback_spider_bite")
		{
			_properties.DamageTotalMult *= 1.2;
		}
	}

});

