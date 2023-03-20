this.nggh_mod_blind_effect <- ::inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2,
	},
	function create()
	{
		this.m.ID = "effects.blind";
		this.m.Name = "Blinded by Acid";
		this.m.Icon = "skills/status_effect_117.png";
		this.m.IconMini = "status_effect_117_mini";
		this.m.Overlay = "status_effect_117";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 2;
	}

	function onAdded()
	{
		// instantly panic
		::Tactical.TurnSequenceBar.pushEntityBack(this.getContainer().getActor().getID());
		this.getContainer().getActor().checkMorale(-1, -1000);
	}

	function getDescription()
	{
		return "This character face has been splashed by the acidic blood of Lindwurm, thus, become temporarily blinded and fall into a complete panic mode. Pain and darkness, the perfect recipe for a disaster. Will wear off in [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] turn(s).";
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
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 25) + "%[/color] Melee Skill"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 45) + "%[/color] Ranged Skill"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 25) + "%[/color] Melee Defense"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 45) + "%[/color] Ranged Defense"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 15) + "%[/color] Initiative"
			}
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 25) + "%[/color] Resolve"
			}
			{
				id = 10,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 45) + "%[/color] Vision"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.VisionMult *= 1.0 - (this.m.TurnsLeft * 0.45);
		_properties.BraveryMult *= 1.0 - (this.m.TurnsLeft * 0.25);
		_properties.InitiativeMult *= 1.0 - (this.m.TurnsLeft * 0.15);
		_properties.MeleeSkillMult *= 1.0 - (this.m.TurnsLeft * 0.25);
		_properties.MeleeDefenseMult *= 1.0 - (this.m.TurnsLeft * 0.25);
		_properties.RangedSkillMult *= 1.0 - (this.m.TurnsLeft * 0.45);
		_properties.RangedDefenseMult *= 1.0 - (this.m.TurnsLeft * 0.45);
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

