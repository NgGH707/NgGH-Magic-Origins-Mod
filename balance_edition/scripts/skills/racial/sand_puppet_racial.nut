this.sand_puppet_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.skeleton";
		this.m.Name = "Resistant to Ranged Attacks";
		this.m.Description = "Ranged, Slashing and Piercing attacks are not very effective against this character.";
		this.m.Icon = "ui/perks/perk_32.png";
		this.m.IconMini = "perk_32_mini";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function getTooltip()
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
			}
		];
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_skill == null)
		{
			return;
		}

		local ranged = [
			"actives.aimed_shot",
			"actives.quick_shot",
			"actives.legend_cascade",
			"actives.legend_siphon_skill",
			"actives.shoot_bolt",
			"actives.shoot_stake",
			"actives.sling_stone",
			"actives.legend_piercing_shot",
			"actives.fire_handgonne",
			"actives.throw_javelin",
			"actives.legend_magic_missile",
			"actives.ignite_firelance"
		];

		if (ranged.find(_skill.getID()) != null)
		{
			_properties.DamageReceivedRegularMult *= 0.33;
		}
		else if (_skill.hasDamageType(this.Const.Damage.DamageType.Piercing))
		{
		    _properties.DamageReceivedRegularMult *= 0.67;
		}
	}

});

