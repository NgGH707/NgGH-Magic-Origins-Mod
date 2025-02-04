::Nggh_MagicConcept.HooksMod.hook("scripts/skills/effects/gruesome_feast_effect", function(q) 
{
	q.m.IsPlayer <- false;

	q.create = @(__original) function()
	{
		__original();
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
		m.IsSerialized = true;
	}

	q.onAdded <- function()
	{
		m.IsPlayer = ::MSU.isKindOf(getContainer().getActor(), "player");
	}

	q.getDescription <- function()
	{
		return "This character ate a fine meal of a live prey.";
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

		switch(getContainer().getActor().getSize())
		{
		case 2:
			ret.extend(getMidSizeTooltips());
			break;

		case 3:
			ret.extend(getHugeSizeTooltips());
			break;
		}
		
		return ret;
	}

	q.getMidSizeTooltips <- function()
	{
		return [
			{
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+120[/color] Hitpoints"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+30[/color] Resolve"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+25[/color] Attack Damage"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+10[/color] Melee Skill"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+6[/color] Melee Defense"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-6[/color] Ranged Defense"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-15[/color] Initiative"
			},
		];
	}

	q.getHugeSizeTooltips <- function()
	{
		return [
			{
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+300[/color] Hitpoints"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+60[/color] Resolve"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+50[/color] Attack Damage"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+20[/color] Melee Skill"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+12[/color] Melee Defense"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-12[/color] Ranged Defense"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-25[/color] Initiative"
			},
		];
	}

	q.onUpdate = @() function( _properties )
	{
		local size = getContainer().getActor().getSize();
		local mainhand = getContainer().getActor().getMainhandItem();

		if (size == 2) {
			_properties.Hitpoints += 120;
			_properties.MeleeSkill += 10;
			_properties.MeleeDefense += 6;
			_properties.RangedDefense -= 6;
			_properties.Bravery += 30;
			_properties.Initiative -= 10;
			_properties.DailyFood += 1;

			if (mainhand == null || mainhand.isItemType(::Const.Items.ItemType.TwoHanded) && !mainhand.isItemType(::Const.Items.ItemType.RangedWeapon)) {
				_properties.DamageRegularMin += 20;
				_properties.DamageRegularMax += 25;
			}
			else {
				_properties.DamageRegularMin += 10;
				_properties.DamageRegularMax += 12;
			}
		}
		else if (size == 3) {
			_properties.Hitpoints += 300;
			_properties.MeleeSkill += 20;
			_properties.MeleeDefense += 12;
			_properties.RangedDefense -= 12;
			_properties.Bravery += 60;
			_properties.Initiative -= 25;
			_properties.DailyFood += 3;

			if (mainhand == null || mainhand.isItemType(::Const.Items.ItemType.TwoHanded) && !mainhand.isItemType(::Const.Items.ItemType.RangedWeapon)) {
				_properties.DamageRegularMin += 40;
				_properties.DamageRegularMax += 60;
			}
			else {
				_properties.DamageRegularMin += 20;
				_properties.DamageRegularMax += 30;
			}
			
			if (!m.IsPlayer)
				getContainer().getActor().getAIAgent().getProperties().BehaviorMult[::Const.AI.Behavior.ID.Retreat] = 0.0;
		}

		m.IsHidden = size <= 1;
	}
	
});