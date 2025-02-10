::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/legend_bog_unhold_racial", function(q) 
{
	//obj.m.RecoverMult <- 15;
	q.m.IsPlayer <- false;

	q.getRecoverMult <- function()
	{
		return (!m.IsPlayer || !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue()) ? 15 : 10;
	}

	q.create = @(__original) function()
	{
		__original();
		m.Name = "Bog Unhold Regeneration";
		m.Description = "Unholds have unbelievable regeneration that no other creature can match. It can easily regrow a missing limb within hours. This unhold has the stink of the swamp.";
		m.Icon = "skills/status_effect_79.png";
		m.IconMini = "status_effect_79_mini";
		//m.RecoverMult = !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 15 : 10;
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	q.onAdded <- function()
	{
		m.IsPlayer = ::MSU.isKindOf(getContainer().getActor(), "player");
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
				text = "Regenerates [color=" + ::Const.UI.Color.PositiveValue + "]" + getRecoverMult() + "%[/color] of max health each turn"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Being inflicted by [color=" + ::Const.UI.Color.NegativeValue + "]Poisoned[/color] effect can no longer stop health regeneration"
			}
		];
	}

	q.onTurnStart = @() function()
	{
		local actor = getContainer().getActor();
		local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
		local healthAdded = ::Math.min(healthMissing, ::Math.floor(actor.getHitpointsMax() * getRecoverMult() * 0.01));

		if (healthAdded <= 0)
			return;

		actor.setHitpoints(actor.getHitpoints() + healthAdded);

		if (!actor.isHiddenToPlayer()) {
			spawnIcon("status_effect_79", actor.getTile());

			if (m.SoundOnUse.len() != 0)
				::Sound.play(::MSU.Array.rand(m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points");
		}
	}

});