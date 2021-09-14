this.perk_mastery_all <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.mastery_all";
		this.m.Name = "All Weapons Mastery";
		this.m.Description = "OP";
		this.m.Icon = "ui/perks/perk_10.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onUpdate( _properties )
	{
		_properties.Vision += 1;
		_properties.IsSpecializedInBows = true;
		_properties.IsSpecializedInCrossbows = true;
		_properties.IsSpecializedInShields = true;
		_properties.IsSpecializedInAxes = true;
		_properties.IsSpecializedInCleavers = true;
		_properties.IsSpecializedInDaggers = true;
		_properties.IsSpecializedInFlails = true;
		_properties.IsSpecializedInPolearms = true;
		_properties.IsSpecializedInHammers = true;
		_properties.IsSpecializedInMaces = true;
		_properties.IsSpecializedInSpears = true;
		_properties.IsSpecializedInSwords = true;
		_properties.IsSpecializedInThrowing = true;
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}

		if (_skill.isRanged() && (_skill.getID() == "actives.throw_axe" || _skill.getID() == "actives.throw_balls" || _skill.getID() == "actives.throw_javelin" || _skill.getID() == "actives.throw_spear"))
		{
			local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());

			if (d <= 2)
			{
				_properties.DamageTotalMult *= 1.4;
			}
			else if (d <= 3)
			{
				_properties.DamageTotalMult *= 1.2;
			}
		}
		else if (_skill.isRanged() && (_skill.getID() == "actives.sling_stone"))
		{
			local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());

			if (d <= 2)
			{
				_properties.DamageTotalMult *= 1.4;
			}
			else if (d <= 3)
			{
				_properties.DamageTotalMult *= 1.3;
			}
			else if (d <= 4)
			{
				_properties.DamageTotalMult *= 1.2;
			}
			else if (d <= 5)
			{
				_properties.DamageTotalMult *= 1.1;
			}
			else if (d <= 6)
			{
				_properties.DamageDirectAdd += 0.15;
			}
			else if (d <= 7)
			{
				_properties.DamageDirectAdd += 0.1;
			}
		}
	}

});

