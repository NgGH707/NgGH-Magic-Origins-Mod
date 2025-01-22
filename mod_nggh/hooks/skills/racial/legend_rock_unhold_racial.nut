::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/legend_rock_unhold_racial", function(q) 
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
		return (!m.IsPlayer || !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue()) ? 10 : 3;
	}

	q.create = @(__original) function()
	{
		__original();
		m.Name = "Rock Unhold Regeneration";
		m.Description = "Unholds have unbelievable regeneration that no other creature can match. It can easily regrow a missing limb within hours. This one has an especially resilient skin like a set of armor.";
		m.Icon = "skills/status_effect_79.png";
		m.IconMini = "status_effect_79_mini";
		//m.RecoverMult = !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 10 : 3;
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
				icon = "ui/icons/armor_body.png",
				text = "Regenerates [color=" + ::Const.UI.Color.PositiveValue + "]" + getRecoverMult() + "%[/color] of max armor per turn"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Regenerates [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.floor(getRecoverMult() * 1.5) + "%[/color] of max health per turn"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/tooltips/negative.png",
				text = "Health regeneration is stopped while being under the effect of [color=" + ::Const.UI.Color.NegativeValue + "]Poisoned[/color]"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Is [color=" + ::Const.UI.Color.PositiveValue + "]resistant[/color] against piercing, cutting or burning damage"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Is [color=" + ::Const.UI.Color.NegativeValue + "]vulnerable[/color] against blunt damage"
			}
		];
	}

	q.onTurnStart = @() function()
	{
		local actor = getContainer().getActor();
		local mult = getRecoverMult() * 0.01;
		local b = actor.getBaseProperties();
		local totalBodyArmor = b.ArmorMax[0];
		local totalHeadArmor = b.ArmorMax[1];
		local currentBodyArmor = b.Armor[0];
		local currentHeadArmor = b.Armor[1];
		local missingBodyArmor = totalBodyArmor - currentBodyArmor;
		local missingHeadArmor = totalHeadArmor - currentHeadArmor;
		local healRateBody = totalBodyArmor * mult;
		local healRateHead = totalHeadArmor * mult;
		local addedBodyArmor = ::Math.abs(::Math.min(missingBodyArmor, healRateBody));
		local addedHeadArmor = ::Math.abs(::Math.min(missingHeadArmor, healRateBody));
		local newBodyArmor = currentBodyArmor + addedBodyArmor;
		local newHeadArmor = currentHeadArmor + addedHeadArmor;

		if (addedBodyArmor <= 0 && addedHeadArmor <= 0)
			return;
		
		foreach (string in m.ApplicablePoison) 
		{
		    if (actor.getSkills().hasSkill("effects." + string))
		    	return;
		}
		
		actor.setArmor(::Const.BodyPart.Body, newBodyArmor);
		actor.setArmor(::Const.BodyPart.Head, newHeadArmor);
		actor.setDirty(true);

		if (!actor.isHiddenToPlayer()) {
			if (m.SoundOnUse.len() != 0)
				::Sound.play(::MSU.Array.rand(m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " regenerated " + addedBodyArmor + " points of body armor");
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " regenerated " + addedHeadArmor + " points of head armor");
			spawnIcon("status_effect_79", actor.getTile());
		}
	}

	q.onUpdate = @(__original) function( _properties )
	{
		if (!m.IsPlayer)
			__original(_properties);
	}
	
});