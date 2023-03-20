this.perk_nggh_wolf_rabies <- ::inherit("scripts/skills/skill", {
	m = {
		IsRemoved = false,
	},
	function create()
	{
		this.m.ID = "perk.rabies";
		this.m.Name = ::Const.Strings.PerkName.NggHWolfRabies;
		this.m.Description = ::Const.Strings.PerkDescription.NggHWolfRabies;
		this.m.Icon = "ui/perks/perk_enrage_wolf.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.IsNew)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (!actor.getFlags().has("Type"))
		{
			return;
		}
		
		if (actor.hasSprite("head_frenzy"))
		{
			local head_frenzy = actor.getSprite("head_frenzy");
			head_frenzy.setBrush(actor.getSprite("head").getBrush().Name + "_frenzy");
			head_frenzy.Visible = true;
		}
		else if (actor.getFlags().getAsInt("Type") != ::Const.EntityType.Hyena)
		{
			::logError("this actor, " + actor.getName() + ", can not get rabies");
			return;
		}
		else
		{
			local head = actor.getSprite("head");
			head.setBrush("bust_hyena_0" + ::Math.rand(4, 6) + "_head");
			head.Visible = true;

			// bonus stats
			local b = actor.getBaseProperties();
			b.Initiative += 25;
		}
		
		actor.setName("Frenzied " + actor.getNameOnly());
		actor.getFlags().add("frenzy");
		actor.setDirty(true);
		this.m.IsNew = true;
	}
	
	function onUpdate( _properties )
	{
		_properties.Hitpoints += 20;
		_properties.Bravery += 20;
		_properties.MeleeSkill += 5;
		_properties.DamageTotalMult *= 1.25;
	}
	
	function onRemoved()
	{
		if (this.m.IsRemoved)
		{
			return;
		}
		
		local actor = this.getContainer().getActor().get();

		if (!actor.getFlags().has("Type"))
		{
			this.m.IsRemoved = true;
			return;
		}
		
		if (actor.hasSprite("head_frenzy"))
		{
			local head_frenzy = actor.getSprite("head_frenzy")
			head_frenzy.resetBrush();
			head_frenzy.Visible = false;
		}
		else if (actor.getFlags().getAsInt("Type") != ::Const.EntityType.Hyena)
		{
			return;
		}
		else
		{
			local head = actor.getSprite("head");
			head.setBrush("bust_hyena_0" + ::Math.rand(1, 3) + "_head");
			head.Visible = true;
			
			local b = actor.getBaseProperties();
			b.Initiative -= 25;
		}
		
		this.m.IsRemoved = true;
		actor.getFlags().remove("frenzy");
		actor.setDirty(true);
	}
	
	function removeSelf()
	{
		this.onRemoved();
		this.m.IsGarbage = true;
	}

});

