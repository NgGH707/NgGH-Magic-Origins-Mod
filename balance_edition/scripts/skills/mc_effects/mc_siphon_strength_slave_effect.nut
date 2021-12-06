this.mc_siphon_strength_slave_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Master = null,
		IsActivated = false
	},
	function activate()
	{
		this.m.IsActivated = true;
	}

	function setMaster( _p )
	{
		if (_p == null)
		{
			this.m.Master = null;
		}
		else if (typeof _p == "instance")
		{
			this.m.Master = _p;
		}
		else
		{
			this.m.Master = this.WeakTableRef(_p);
		}
	}

	function isAlive()
	{
		return this.getContainer() != null && !this.getContainer().isNull() && this.getContainer().getActor() != null && this.getContainer().getActor().isAlive() && this.getContainer().getActor().getHitpoints() > 0;
	}

	function create()
	{
		this.m.ID = "effects.mc_siphon_strength_slave";
		this.m.Name = "Curse of Weaken";
		this.m.KilledString = "Died from a hex";
		this.m.Icon = "skills/effect_mc_05.png";
		this.m.IconMini = "effect_mc_05_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "This character has been cursed to feel the same pain and receive the same wounds as another character. Be careful, as it could kill him. The effect will persist for another [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] turn(s).";
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
			},
		];

		local mod = this.getStatMod();

		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + mod + "[/color] Melee Skill"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + mod + "%[/color] Ranged Skill"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + mod + "%[/color] Melee Defense"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + mod + "%[/color] Ranged Defense"
			}
		]);

		return ret;
	}

	function applyStatMod()
	{
		return this.m.Master.getStatMod();
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		if (actor.hasSprite("status_hex"))
		{
			actor.getSprite("status_hex").Visible = false;
		}

		actor.setDirty(true);

		if (this.m.Master != null && !this.m.Master.isNull() && !this.m.Master.getContainer().isNull())
		{
			local master = this.m.Master;
			this.m.Master = null;
			master.setSlave(null);
			master.removeSelf();
			master.getContainer().update();
		}
	}

	function onDeath()
	{
		this.onRemoved();
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();

		if (this.m.IsActivated && (this.m.Master == null || this.m.Master.isNull() || !this.m.Master.isAlive()))
		{
			this.removeSelf();
		}
		else
		{
			local mod = this.applyStatMod();
			_properties.MeleeSkill -= mod;
			_properties.RangedSkill -= mod;
			_properties.MeleeDefense -= mod;
			_properties.RangedDefense -= mod;

			if (actor.hasSprite("status_hex"))
			{
				local hex = actor.getSprite("status_hex");
				local fadeIn = !hex.Visible;

				if (fadeIn)
				{
					hex.setBrush("bust_nightmare");
					hex.Alpha = 0;
					hex.Visible = true;
					hex.fadeIn(700);
					actor.setDirty(true);
				}
			}
		}
	}

});

