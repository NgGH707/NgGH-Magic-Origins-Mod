::mods_hookExactClass("skills/racial/legend_bog_unhold_racial", function(obj) 
{
	//obj.m.RecoverMult <- 15;
	obj.m.IsPlayer <- false;

	obj.getRecoverMult <- function()
	{
		return (!this.m.IsPlayer || ::Nggh_MagicConcept.IsOPMode) ? 15 : 10;
	}

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Bog Unhold Regeneration";
		this.m.Description = "Unholds have unbelievable regeneration that no other creature can match. It can easily regrow a missing limb within hours. This unhold has the stink of the swamp.";
		this.m.Icon = "skills/status_effect_79.png";
		this.m.IconMini = "status_effect_79_mini";
		//this.m.RecoverMult = ::Nggh_MagicConcept.IsOPMode ? 15 : 10;
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
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
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Poisoned[/color] effect can no longer interupting health regeneration"
			}
		];
	};
	obj.onTurnStart = function()
	{
		local actor = this.getContainer().getActor();
		local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
		local healthAdded = ::Math.min(healthMissing, ::Math.floor(actor.getHitpointsMax() * this.getRecoverMult() * 0.01));

		if (healthAdded <= 0)
		{
			return;
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
});