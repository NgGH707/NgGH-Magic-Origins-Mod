this.perk_rabies <- this.inherit("scripts/skills/skill", {
	m = {
		IsRemoved = false,
	},
	function create()
	{
		this.m.ID = "perk.rabies";
		this.m.Name = this.Const.Strings.PerkName.Rabies;
		this.m.Description = this.Const.Strings.PerkDescription.Rabies;
		this.m.Icon = "ui/perks/perk_enrage_wolf.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
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

		local actor = this.getContainer().getActor().get();
		
		if (actor.hasSprite("head_frenzy"))
		{
			local head_frenzy = actor.getSprite("head_frenzy");
			head_frenzy.setBrush(actor.getSprite("head").getBrush().Name + "_frenzy");
			head_frenzy.Visible = true;
			actor.getFlags().add("frenzy_wolf");
			
			this.logInfo("Is setting frenzy bust for " + actor.getName());
		}
		else if ("IsHigh" in actor.m)
		{
			local head = actor.getSprite("head");
			local variant = this.Math.rand(4, 6);
			head.setBrush("bust_hyena_0" + variant + "_head");
			head.Visible = true;
			actor.m.IsHigh = true;
			
			this.logInfo("Is setting frenzy bust for " + actor.getName())
			local b = actor.getBaseProperties();
			b.Initiative += 30;
		}
		
		local name = actor.getName();
		actor.setName("Frenzied " + name);
		actor.setDirty(true);
	}
	
	function onUpdate( _properties )
	{
		_properties.Hitpoints += 20;
		_properties.Bravery += 20;
		_properties.MeleeSkill += 5;
		_properties.DamageTotalMult += 1.25;
	}
	
	function onRemoved()
	{
		if (this.m.IsRemoved)
		{
			return;
		}
		
		local actor = this.getContainer().getActor().get();
		
		if (actor.hasSprite("head_frenzy"))
		{
			local head_frenzy = actor.getSprite("head_frenzy")
			head_frenzy.Visible = false;
			actor.getFlags().remove("frenzy_wolf");
		}
		else if ("IsHigh" in actor.m)
		{
			local head = actor.getSprite("head");
			local variant = this.Math.rand(1, 3);
			head.setBrush("bust_hyena_0" + variant + "_head");
			head.Visible = true;
			actor.m.IsHigh = false;
			
			local b = actor.getBaseProperties();
			b.Initiative -= 30;
		}
		
		actor.setDirty(true);
		this.m.IsRemoved = true;
	}
	
	function removeSelf()
	{
		this.onRemoved();
		this.m.IsGarbage = true;
	}

});

