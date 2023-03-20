::mods_hookExactClass("skills/racial/legend_rock_unhold_racial", function(obj) 
{
	//obj.m.RecoverMult <- 10;
	obj.m.IsPlayer <- false;

	obj.getRecoverMult <- function()
	{
		return (!this.m.IsPlayer || ::Nggh_MagicConcept.IsOPMode) ? 10 : 3;
	}

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Rock Unhold Regeneration";
		this.m.Description = "Unholds have unbelievable regeneration that no other creature can match. It can easily regrow a missing limb within hours. This one has an especially resilient skin like a set of armor.";
		this.m.Icon = "skills/status_effect_79.png";
		this.m.IconMini = "status_effect_79_mini";
		//this.m.RecoverMult = ::Nggh_MagicConcept.IsOPMode ? 10 : 3;
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
				icon = "ui/icons/armor_body.png",
				text = "Regenerates [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getRecoverMult() + "%[/color] of max armor"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Regenerates [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.floor(this.getRecoverMult() * 1.5) + "%[/color] of max health"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/tooltips/negative.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Poisoned[/color] effect stops health regeneration"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Resistant[/color] against Piercing, Cutting or Burning Damage"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Vulnerable[/color] against Blunt Damage"
			}
		];
	};
	obj.onTurnStart = function()
	{
		local actor = this.getContainer().getActor();
		local mult = this.getRecoverMult() * 0.01;
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
		
		actor.setArmor(::Const.BodyPart.Body, newBodyArmor);
		actor.setArmor(::Const.BodyPart.Head, newHeadArmor);
		actor.setDirty(true);

		if (!actor.isHiddenToPlayer())
		{
			this.spawnIcon("status_effect_79", actor.getTile());

			if (this.m.SoundOnUse.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
			}

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " regenerated " + addedBodyArmor + " points of body armor");
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " regenerated " + addedHeadArmor + " points of head armor");
		}
	};

	local ws_onUpdate = obj.onUpdate;
	obj.onUpdate = function( _properties )
	{
		if (this.m.IsPlayer) return;

		ws_onUpdate(_properties);
	};
	
});