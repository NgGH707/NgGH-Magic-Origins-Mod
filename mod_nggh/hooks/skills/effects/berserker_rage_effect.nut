::Nggh_MagicConcept.HooksMod.hook("scripts/skills/effects/berserker_rage_effect", function(q) 
{
	q.onAdded <- function()
	{
		if (getContainer().getActor().isPlayerControlled())
			m.RageStacks = 1;
	}

	q.isHidden <- function()
	{
		return m.RageStacks == 0;
	}

	q.getTooltip <- function()
	{
		local i = ::Math.max(30, (1.0 - 0.01 * m.RageStacks) * 100);
		return = [
			{
				id = 1,
				type = "title",
				text = getName()
			},
			{
				id = 2,
				type = "description",
				text = getDescription()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/mood_01.png",
				text = "Has [color=" + ::Const.UI.Color.NegativeValue + "]" + m.RageStacks + "[/color] stack(s) of rage"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + m.RageStacks + "[/color] Attack Damage"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + m.RageStacks + "[/color] Resolve"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + m.RageStacks + "[/color] Initiative"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Takes [color=" + ::Const.UI.Color.PositiveValue + "]" + (100 - i) + "%[/color] less damage to Hitpoints"
			}
		];
	}

	q.onUpdate = @(__original) function( _properties )
	{
		local value = _properties.DamageReceivedTotalMult;

		__original(_properties);

		// nerf the damage reduction to only affect hitpoints damage
		_properties.DamageReceivedTotalMult = value;
		_properties.DamageReceivedRegularMult *= ::Math.maxf(0.3, 1.0 - 0.02 * m.RageStacks);
	}

	q.onCombatStarted <- function()
	{
		m.RageStacks = 0;
		getContainer().getActor().updateRageVisuals(m.RageStacks);
	}

	q.onCombatFinished <- function()
	{
		m.RageStacks = 1;
		getContainer().getActor().updateRageVisuals(m.RageStacks);
	}
});