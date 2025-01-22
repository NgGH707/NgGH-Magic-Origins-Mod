::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/unhold_racial", function(q) 
{
	//obj.m.RecoverMult <- 10;
	q.m.IsPlayer <- false;
	q.m.ApplicablePoison <- [
		"spider_poison",
		"legend_redback_spider_poison",
		"legend_RSW_poison_effect",
		"goblin_poison",
		"legend_zombie_poison",
		"legend_rat_poison",
	];

	q.getRecoverMult <- function()
	{
		return (!m.IsPlayer || !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue()) ? 10 : 5;
	}

	q.create = @(__original) function()
	{
		__original();
		m.Name = "Unhold Regeneration";
		m.Description = "Unholds have unbelievable regeneration that no other creature can match. It can easily regrow a missing limb within hours.";
		m.Icon = "skills/status_effect_79.png";
		m.IconMini = "status_effect_79_mini";
		//m.RecoverMult = !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 10 : 5;
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	q.isHidden <- function()
	{
		return getContainer().hasSkill("racial.legend_rock_unhold");
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
				text = "Regenerates [color=" + ::Const.UI.Color.PositiveValue + "]" + getRecoverMult() + "%[/color] of max health per turn"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/tooltips/negative.png",
				text = "Health regeneration is stopped while being under the effect of [color=" + ::Const.UI.Color.NegativeValue + "]Poisoned[/color]"
			},
		];
	}

	q.onTurnStart = @() function()
	{
		local actor = getContainer().getActor();
		local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
		local healthAdded = ::Math.min(healthMissing, ::Math.floor(actor.getHitpointsMax() * getRecoverMult() * 0.01));

		if (healthAdded <= 0)
			return;

		foreach (string in m.ApplicablePoison) 
		{
		    if (actor.getSkills().hasSkill("effects." + string))
		    	return;
		}

		actor.setHitpoints(actor.getHitpoints() + healthAdded);

		if (!actor.isHiddenToPlayer()) {
			if (m.SoundOnUse.len() != 0)
				::Sound.play(::MSU.Array.rand(m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points");
			spawnIcon("status_effect_79", actor.getTile());
		}
	}

	q.onUpdate = @(__original) function( _properties )
	{
		if (!m.IsPlayer)
			__original(_properties);
	}
	
});