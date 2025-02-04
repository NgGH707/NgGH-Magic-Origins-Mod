::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/legend_werewolf_racial", function(q) 
{
	q.m.ConversionRate <- 0.25;

	q.create = @(__original) function()
	{
		__original();
		m.Description = "Gain additional damage based on your loss health.";
		m.Icon = "skills/status_effect_wolf_rider.png";
		m.IconMini = "status_effect_wolf_rider_mini";
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	q.getTooltip <- function()
	{
		return [
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
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + getBonus(getContainer().getActor()) + "[/color] Attack Damage"
			}
		];
	}

	q.onUpdate = @() function( _properties )
	{
		local damage = getBonus(getContainer().getActor());

		if (additionalDamage > 0) {
			_properties.DamageRegularMin += additionalDamage;
			_properties.DamageRegularMax += additionalDamage;
		}
	}

	q.getBonus <- function( _actor )
	{
		local healthPct = _actor.getHitpointsPct();

		if (healthPct >= 1.0) return 0;

		local additionalDamage = ::Math.floor(_actor.getHitpointsMax() * (1.0 - healthPct) * m.ConversionRate);

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			additionalDamage = ::Math.floor(additionalDamage * 1.5);

		return ::Math.min(100, additionalDamage);
	}

});