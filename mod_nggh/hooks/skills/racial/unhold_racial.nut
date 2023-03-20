::mods_hookExactClass("skills/racial/unhold_racial", function(obj) 
{
	//obj.m.RecoverMult <- 10;
	obj.m.IsPlayer <- false;

	obj.getRecoverMult <- function()
	{
		return (!this.m.IsPlayer || ::Nggh_MagicConcept.IsOPMode) ? 10 : 5;
	}

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Unhold Regeneration";
		this.m.Description = "Unholds have unbelievable regeneration that no other creature can match. It can easily regrow a missing limb within hours.";
		this.m.Icon = "skills/status_effect_79.png";
		this.m.IconMini = "status_effect_79_mini";
		//this.m.RecoverMult = ::Nggh_MagicConcept.IsOPMode ? 10 : 5;
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	};
	obj.isHidden <- function()
	{
		return this.getContainer().hasSkill("racial.legend_rock_unhold");
	};
	obj.onAdded <- function()
	{
		this.m.IsPlayer = this.getContainer().getActor().isPlayerControlled();
	}
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
				text = "Regenerates [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getRecoverMult() + "%[/color] of max health"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/tooltips/negative.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Poisoned[/color] effect stops health regeneration"
			}
		];
	};
	obj.onTurnStart = function()
	{
		local actor = this.getContainer().getActor();
		local mult = this.getRecoverMult() * 0.01;
		local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
		local healthAdded = ::Math.min(healthMissing, ::Math.floor(actor.getHitpointsMax() * mult));

		if (healthAdded <= 0)
		{
			return;
		}

		foreach (string in [
			"spider_poison_effect",
			"legend_redback_spider_poison_effect",
			"legend_RSW_poison_effect",
			"goblin_poison",
			"legend_zombie_poison",
			"legend_rat_poison",
		]) 
		{
		    if (actor.getSkills().hasSkill("effects." + string))
		    {
		    	return;
		    }
		}

		actor.setHitpoints(actor.getHitpoints() + healthAdded);
		actor.setDirty(true);

		if (!actor.isHiddenToPlayer())
		{
			this.spawnIcon("status_effect_79", actor.getTile());

			if (this.m.SoundOnUse.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
			}

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points");
		}
	};

	local ws_onUpdate = obj.onUpdate;
	obj.onUpdate = function( _properties )
	{
		if (this.m.IsPlayer) return;

		ws_onUpdate(_properties);
	};
});