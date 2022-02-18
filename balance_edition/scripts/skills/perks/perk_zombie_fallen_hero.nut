this.perk_zombie_fallen_hero <- this.inherit("scripts/skills/skill", {
	m = {
		IsRightActor = false
	},
	function create()
	{
		this.m.ID = "perk.zombie_fallen_hero";
		this.m.Name = this.Const.Strings.PerkName.ZombieFallenHero;
		this.m.Description = this.Const.Strings.PerkDescription.ZombieFallenHero;
		this.m.Icon = "ui/perks/perk_zombie_fallen_hero.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints += 1;
		_properties.Hitpoints += 10;
		_properties.MeleeSkill += 5;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();

		if (this.isKindOf(actor.get(), "undead_player"))
		{
			this.m.IsRightActor = true;
			actor.m.IsResurrectingOnFatality = true;
		}
	}

	function onRemoved()
	{
		if (this.m.IsRightActor)
		{
			this.getContainer().getActor().m.IsResurrectingOnFatality = false;
		}
	}

});

