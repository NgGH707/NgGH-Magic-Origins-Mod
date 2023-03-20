::mods_hookExactClass("skills/racial/champion_racial", function(obj) 
{
	//obj.m.Mult <- 1.0;
	obj.m.GainHP <- false;
	obj.m.IsPlayer <- false;

	obj.getMult <- function()
	{
		return !this.m.IsPlayer || ::Nggh_MagicConcept.IsOPMode ? 1.0 : 0.67;
	}

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "The toughest among the strongest. Who dares to challenge those like them?";
		//this.m.Mult = ::Nggh_MagicConcept.IsOPMode ? 1.0 : 0.67;
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	};
	obj.onAdded <- function()
	{
		local actor = this.getContainer().getActor();
		this.m.IsPlayer = actor.isPlayerControlled();

		if (actor.hasSprite("miniboss"))
		{
			actor.getSprite("miniboss").setBrush("bust_miniboss");
			actor.setDirty(true);
		}

		if (this.m.IsPlayer)
		{
			actor.m.IsMiniboss = true;
			
			if (::isKindOf(actor.get(), "spider_player") && actor.getSize() < 1.0)
			{
				this.getContainer().getActor().setSize(1.0);
			}
		}
		else 
		{
			this.getContainer().add(::new("scripts/skills/special/nggh_mod_champion_loot"));    
		}
	};
	obj.onRemoved <- function()
	{
		local actor = this.getContainer().getActor();
		actor.getSprite("miniboss").Visible = false;
		actor.setDirty(true);
	};
	obj.getTooltip <- function()
	{
		local mult = this.getMult();
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
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor((this.m.GainHP ? 1.35 : 1) * 35 * mult) + "%[/color] Hitpoints"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(15 * mult) + "%[/color] Attack Damage"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(15 * mult) + "%[/color] Initiative"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(15 * mult) + "%[/color] Melee Skill"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor((this.m.GainHP ? 1 : 1.25) * 25 * mult) + "%[/color] Ranged Skill"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor((this.m.GainHP ? 1 : 1.25) * 25 * mult) + "%[/color] Melee Defense"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(15 * mult) + "%[/color] Ranged Defense"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(50 * mult) + "%[/color] Resolve"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(50 * mult) + "%[/color] Max Fatigue"
			}
		];
	};
	obj.onUpdate = function( _properties )
	{
		local mult = this.getMult();
		_properties.DamageTotalMult *= 1.0 + (0.15 * mult);
		_properties.BraveryMult *= 1.0 + (0.5 * mult);
		_properties.StaminaMult *= 1.0 + (0.5 * mult);
		_properties.MeleeSkillMult *= 1.0 + (0.15 * mult);
		_properties.RangedSkillMult *= 1.0 + (0.15 * mult);
		_properties.InitiativeMult *= 1.0 + (0.15 * mult);
		_properties.MeleeDefenseMult *= 1.0 + (0.25 * mult);
		_properties.RangedDefenseMult *= 1.0 + (0.25 * mult);
		_properties.HitpointsMult *= 1.0 + (0.35 * mult);

		this.m.GainHP = this.getContainer().getActor().getBaseProperties().MeleeDefense >= 20 || this.getContainer().getActor().getBaseProperties().RangedDefense >= 20 || this.getContainer().getActor().getBaseProperties().MeleeDefense >= 15 && this.getContainer().getActor().getBaseProperties().RangedDefense >= 15;

		if (this.m.GainHP)
		{
			_properties.HitpointsMult *= 1.0 + (0.35 * mult);
			return;
		}
		
		_properties.MeleeDefenseMult *= 1.0 + (0.25 * mult);
		_properties.RangedDefenseMult *= 1.0 + (0.25 * mult);
	};
	obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == null) return;
		
		if (_skill.getID() != "actives.spider_bite" && _skill.getID() != "actives.legend_redback_spider_bite") return;

		_properties.DamageTotalMult *= 1.15; // a buff for champion spider
	};
});