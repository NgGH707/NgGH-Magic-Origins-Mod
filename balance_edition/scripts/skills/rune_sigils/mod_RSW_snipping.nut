this.mod_RSW_snipping <- this.inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false
	},
	function create()
	{
		this.m.ID = "special.mod_RSW_snipping";
		this.m.Name = "Rune Sigil: Snipping";
		this.m.Description = "Rune Sigil: Snipping";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null)
		{
			return;
		}

		if (_skill == null || !_skill.m.IsWeaponSkill || !skill.m.IsRanged || _targetEntity == null)
		{
			return;
		}

		local actor = this.getContainer().getActor();
		local dis = _targetEntity.getTile().getDistanceTo(actor.getTile());

		switch (true) 
		{
	    case dis >= 7:
	        _properties.HitChanceAdditionalWithEachTile += 6;
	        break;

	    case dis >= 5:
	        _properties.HitChanceAdditionalWithEachTile += 4;
	        break;

	    case dis >= 3:
	        _properties.HitChanceAdditionalWithEachTile += 2;
	        break;

	    default:
	        _properties.HitChanceAdditionalWithEachTile -= 5;
		}
	}

});

