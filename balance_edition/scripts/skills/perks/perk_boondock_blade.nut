this.perk_boondock_blade <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.boondock_blade";
		this.m.Name = this.Const.Strings.PerkName.BoondockBlade;
		this.m.Description = this.Const.Strings.PerkDescription.BoondockBlade;
		this.m.Icon = "skills/status_effect_08.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return;
		}
		
		if (this.getContainer().getActor().getTile().IsHidingEntity || this.getContainer().getActor().isHidden())
		{
			_properties.MeleeDefense += 10;
			_properties.RangedDefense += 10;
			_properties.MeleeSkill += 10;
			_properties.RangedSkill += 10;
		}
	}

});

