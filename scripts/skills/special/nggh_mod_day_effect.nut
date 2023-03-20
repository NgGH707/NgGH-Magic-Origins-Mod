this.nggh_mod_day_effect <- ::inherit("scripts/skills/skill", {
	m = {
		Penalty = {
			Bravery = 0.3,
			MeleeSkill = 0.15,
			RangedSkill = 0.15,
			MeleeDefense = 0.15,
			RangedDefense = 0.15
		}
	},
	function create()
	{
		this.m.ID = "special.day";
		this.m.Name = "Daytime";
		this.m.Description = "You are a creature of the dark, bathing in sunlight won\'t be any good for you.";
		this.m.Icon = "skills/status_effect_daytime.png";
		this.m.IconMini = "status_effect_daytime_mini";
		this.m.Type = ::Const.SkillType.StatusEffect | ::Const.SkillType.Special;
		this.m.IsActive = false;
		this.m.IsSerialized = false;
		this.m.IsHidden = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("perk.daytime"))
		{
			return;
		}

		// recalculate the penalty if this character has resistance
		foreach (k, v in this.m.Penalty)
		{
			this.m.Penalty[k] = v / 3;
		}
	}

	function getTooltip()
	{
		local ret = [
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

		local mult = 100;
		local bravery = ::Math.floor(this.m.Penalty.Bravery * mult);
		local meleeSkill = ::Math.floor(this.m.Penalty.MeleeSkill * mult);
		local rangedSkill = ::Math.floor(this.m.Penalty.RangedSkill * mult);
		local meleeDefense = ::Math.floor(this.m.Penalty.MeleeDefense * mult);
		local rangedDefense = ::Math.floor(this.m.Penalty.RangedDefense * mult);

		ret.extend([
	    	{
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + bravery + "%[/color] Resolve"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + meleeSkill + "%[/color] Melee Skill"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + rangedSkill + "%[/color] Melee Defense"
			}
			{
				id = 12,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + meleeDefense + "%[/color] Ranged Skill"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + rangedDefense + "%[/color] Ranged Defense"
			}
	    ]);

		return ret;
	}

	function onUpdate( _properties )
	{
		if (this.isHidden())
		{
			return;
		}

		_properties.BraveryMult *= 1 - this.m.Penalty.Bravery;
		_properties.MeleeSkillMult *= 1 - this.m.Penalty.MeleeSkill;
		_properties.RangedSkillMult *= 1 - this.m.Penalty.RangedSkill;
		_properties.MeleeDefenseMult *= 1 - this.m.Penalty.MeleeDefense;
		_properties.RangedDefenseMult *= 1 - this.m.Penalty.RangedDefense;
	}

	function isHidden()
	{
		local actor = this.getContainer().getActor();

		if (actor.isPlacedOnMap())
		{
			local myTile = actor.getTile();

			if (myTile.Properties.Effect != null && myTile.Properties.Effect.Type == "shadows")
			{
				return true;
			}

			return false;
		}

		return false;
	}

});

