::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/serpent_racial", function(q) 
{
	q.m.IsPlayer <- false;

	q.create = @(__original) function()
	{
		__original();
		m.Name = "Tough Scales";
		m.Description = "Serpents have tough scales that protect them from high heat and can also deflect firearm shots, making them quite resistant to those kinds of attack.";
		m.Icon = "skills/status_effect_113.png";
		m.IconMini = "status_effect_113_mini";
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	q.onAdded <- function()
	{
		m.IsPlayer = ::MSU.isKindOf(getContainer().getActor(), "player");
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
				icon = "ui/icons/initiative.png",
				text = "While engaging in melee, [color=" + ::Const.UI.Color.PositiveValue + "]+15[/color] Initiative to Turn Order"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/sturdiness.png",
				text = "Takes [color=" + ::Const.UI.Color.PositiveValue + "]33%[/color] less burning damage"
			}
		];
	}

	q.onUpdate = @(__original) function( _properties )
	{
		if (!::Tactical.isActive()) 
			return;

		if (!m.IsPlayer) {
			__original(_properties);
			return;
		}

		if (!getContainer().getActor().isEngagedInMelee())
			_properties.InitiativeForTurnOrderAdditional += 15;
	}

});