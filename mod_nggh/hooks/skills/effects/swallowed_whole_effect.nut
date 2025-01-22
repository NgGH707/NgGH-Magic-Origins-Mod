::Nggh_MagicConcept.HooksMod.hook("scripts/skills/effects/swallowed_whole_effect", function(q) 
{
	q.m.Link <- null;
	q.m.IsSpecialized <- false;

	q.getLink <- function()
	{
		return m.Link;
	}

	q.setLink <- function( _l )
	{
		if (_l == null) m.Link = null;
		else m.Link = ::MSU.asWeakTableRef(_l);
	}

	q.getDescription <- function()
	{
		return "This character has devoured [color=" + ::Const.UI.Color.NegativeValue + "]" + m.Name + "[/color], holding said victim like a hostage in their belly.";
	}

	q.getTooltip <- function()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = getName()
			},
			{
				id = 2,
				type = "description",
				text = getDescription()
			}
		];

		if (m.IsSpecialized)
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

		local e = m.Link.getSwallowedEntity();

		ret.extend([
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Sapping hitpoints and armor from devoured victim every round"
			},
			{
				id = 3,
				type = "text",
				text = "[u][size=14]" + m.Name + "[/size][/u]"
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

	q.onAdded <- function()
	{
		m.IsSpecialized = getContainer().hasSkill("perk.nacho_big_tummy");
	}

	q.onUpdate <- function( _properties )
	{
		if (!m.IsSpecialized) return;

		_properties.BraveryMult *= 1.25;
	}

	q.onBeforeDamageReceived <- function( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _attacker.getID() == getContainer().getActor().getID() || !m.IsSpecialized || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
			return;

		_properties.DamageReceivedRegularMult *= 0.85;
	}
});