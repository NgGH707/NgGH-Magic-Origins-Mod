this.swallowed_whole_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Name = "",
		Link = null,
	},
	function getLink()
	{
		return this.m.Link;
	}
	
	function setLink( _l )
	{
		if (_l == null)
		{
			this.m.Link = null;
		}
		else if (typeof _l == "instance")
		{
			this.m.Link = _l;
		}
		else 
		{
		 	this.m.Link = this.WeakTableRef(_l);
		}
	}

	function setName( _n )
	{
		this.m.Name = _n;
	}

	function getName()
	{
		return "Devoured " + this.m.Name;
	}

	function create()
	{
		this.m.ID = "effects.swallowed_whole";
		this.m.Name = "Devour";
		this.m.Icon = "skills/status_effect_72.png";
		this.m.IconMini = "status_effect_72_mini";
		this.m.Overlay = "status_effect_72";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}
	
	function getDescription()
	{
		return "This character has devoured [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Name + "[/color], holding said victim like a hostage in its belly.";
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

		if (this.getContainer().hasSkill("perk.nacho_big_tummy"))
		{
			ret.extend([
				{
					id = 4,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] Resolve"
				},
				{
					id = 4,
					type = "text",
					icon = "ui/icons/sturdiness.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]-15%[/color] Damage Taken"
				}
			]);
		}

		local e = this.m.Link.getSwallowedEntity();

		ret.extend([
			{
				id = 3,
				type = "text",
				text = "[u][size=14]" + this.m.Name + "[/size][/u]"
			},
			{
				id = 4,
				type = "progressbar",
				icon = "ui/icons/armor_head.png",
				value = e.getArmor(this.Const.BodyPart.Head),
				valueMax = e.getArmorMax(this.Const.BodyPart.Head),
				text = "" + e.getArmor(this.Const.BodyPart.Head) + " / " + e.getArmorMax(this.Const.BodyPart.Head) + "",
				style = "armor-head-slim"
			},
			{
				id = 5,
				type = "progressbar",
				icon = "ui/icons/armor_body.png",
				value = e.getArmor(this.Const.BodyPart.Body),
				valueMax = e.getArmorMax(this.Const.BodyPart.Body),
				text = "" + e.getArmor(this.Const.BodyPart.Body) + " / " + e.getArmorMax(this.Const.BodyPart.Body) + "",
				style = "armor-body-slim"
			},
			{
				id = 6,
				type = "progressbar",
				icon = "ui/icons/health.png",
				value = e.getHitpoints(),
				valueMax = e.getHitpointsMax(),
				text = "" + e.getHitpoints() + " / " + e.getHitpointsMax() + "",
				style = "hitpoints-slim"
			}
		]);

		return ret;
	}

	function onUpdate( _properties )
	{
		local skill = this.getContainer().getSkillByID("perk.nacho_big_tummy");

		if (skill == null)
		{
			return;
		}

		_properties.DamageReceivedRegularMult *= 0.85;
		_properties.BraveryMult *= 1.25;
	}

});

