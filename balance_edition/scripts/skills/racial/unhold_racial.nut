this.unhold_racial <- this.inherit("scripts/skills/skill", {
	m = {
		RecoverMult = 15
	},
	function create()
	{
		this.m.ID = "racial.unhold";
		this.m.Name = "Unhold Regeneration";
		this.m.Description = "Unholds have unbelievable regeneration that no other creature can match. It can easily regrow a missing limb within hours.";
		this.m.Icon = "skills/status_effect_79.png";
		this.m.IconMini = "status_effect_79_mini";
		this.m.SoundOnUse = [
			"sounds/enemies/unhold_regenerate_01.wav",
			"sounds/enemies/unhold_regenerate_02.wav",
			"sounds/enemies/unhold_regenerate_03.wav"
		];
		this.m.Type = this.Const.SkillType.Racial;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}
	
	function isHidden()
	{
		return this.getContainer().hasSkill("racial.legend_rock_unhold");
	}
	
	function getTooltip()
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
				text = "Regenerates [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.RecoverMult + "%[/color] of max health"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/tooltips/negative.png",
				text = "Getting [color=" + this.Const.UI.Color.NegativeValue + "]Poisoned[/color] interupting health regeneration"
			}
		];
	}
	
	function onAdded()
	{
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			return;
		}
		
		this.m.RecoverMult = 7;
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.getContainer().update();
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		local mult = this.m.RecoverMult * 0.01;
		local HP = actor.isPlayerControlled() ? actor.getHitpoints() : actor.getHitpointsMax();
		local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
		local healthAdded = this.Math.min(healthMissing, this.Math.floor(HP * mult));

		if (healthAdded <= 0)
		{
			return;
		}
		
		if (!actor.getSkills().hasSkill("effects.spider_poison_effect") && !actor.getSkills().hasSkill("effects.legend_redback_spider_poison_effect") && !actor.getSkills().hasSkill("effects.legend_RSW_poison_effect"))
		{
			actor.setHitpoints(actor.getHitpoints() + healthAdded);
			actor.setDirty(true);

			if (!actor.isHiddenToPlayer())
			{
				this.spawnIcon("status_effect_79", actor.getTile());

				if (this.m.SoundOnUse.len() != 0)
				{
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
				}

				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points");
			}
		}
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor().get();

		if (this.Tactical.isActive() && this.getContainer().getActor().isPlacedOnMap() && this.Time.getRound() <= 2 && (this.isKindOf(actor, "unhold_armored") || this.isKindOf(actor, "unhold_frost_armored")))
		{
			_properties.InitiativeForTurnOrderAdditional += 40;
		}
	}

});

