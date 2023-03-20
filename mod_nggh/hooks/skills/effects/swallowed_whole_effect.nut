::mods_hookExactClass("skills/effects/swallowed_whole_effect", function(obj) 
{
	obj.m.Link <- null;
	obj.m.IsSpecialized <- false;

	obj.getLink <- function()
	{
		return this.m.Link;
	};
	obj.setLink <- function( _l )
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
		 	this.m.Link = ::WeakTableRef(_l);
		}
	};
	obj.getDescription <- function()
	{
		return "This character has devoured [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.Name + "[/color], holding said victim like a hostage in its belly.";
	};
	obj.getTooltip <- function()
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

		if (this.m.IsSpecialized)
		{
			ret.extend([
				{
					id = 4,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + ::Const.UI.Color.PositiveValue + "]+25%[/color] Resolve"
				},
				{
					id = 4,
					type = "text",
					icon = "ui/icons/sturdiness.png",
					text = "[color=" + ::Const.UI.Color.PositiveValue + "]-15%[/color] Damage Taken"
				}
			]);
		}

		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Sapping hitpoints and armor from devoured victim every round"
		});

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
				value = e.getArmor(::Const.BodyPart.Head),
				valueMax = e.getArmorMax(::Const.BodyPart.Head),
				text = "" + e.getArmor(::Const.BodyPart.Head) + " / " + e.getArmorMax(::Const.BodyPart.Head) + "",
				style = "armor-head-slim"
			},
			{
				id = 5,
				type = "progressbar",
				icon = "ui/icons/armor_body.png",
				value = e.getArmor(::Const.BodyPart.Body),
				valueMax = e.getArmorMax(::Const.BodyPart.Body),
				text = "" + e.getArmor(::Const.BodyPart.Body) + " / " + e.getArmorMax(::Const.BodyPart.Body) + "",
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
	obj.onAdded <- function()
	{
		this.m.IsSpecialized = this.getContainer().hasSkill("perk.nacho_big_tummy");
	};
	obj.onUpdate <- function( _properties )
	{
		if (!this.m.IsSpecialized) return;

		_properties.BraveryMult *= 1.25;
	};
	obj.onBeforeDamageReceived <- function( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || !this.m.IsSpecialized || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
		{
			return;
		}

		_properties.DamageReceivedRegularMult *= 0.85;
	}
});