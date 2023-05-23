::mods_hookExactClass("skills/effects/gruesome_feast_effect", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.m.IsSerialized = true;
	}
	obj.getDescription <- function()
	{
		return "This character ate a fine meal and it helps this character grows up so fast.";
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

		switch(this.getContainer().getActor().getSize())
		{
		case 2:
			ret.extend(this.getMidSizeTooltips());
			break;

		case 3:
			ret.extend(this.getHugeSizeTooltips());
			break;
		}
		
		return ret;
	};
	obj.getMidSizeTooltips <- function()
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
	};
	obj.getHugeSizeTooltips <- function()
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
	};
	obj.onUpdate = function( _properties )
	{
		local size = this.getContainer().getActor().getSize();
		local isPlayer = this.getContainer().getActor().isPlayerControlled();
		local mainhand = this.getContainer().getActor().getMainhandItem();
		this.m.IsHidden = size <= 1;

		if (size == 2)
		{
			_properties.Hitpoints += 120;
			_properties.MeleeSkill += 10;
			_properties.MeleeDefense += 6;
			_properties.RangedDefense -= 6;
			_properties.Bravery += 30;
			_properties.Initiative -= 10;
			_properties.DailyFood += 1;

			if (mainhand == null || mainhand.isItemType(::Const.Items.ItemType.TwoHanded) && !mainhand.isItemType(::Const.Items.ItemType.RangedWeapon))
			{
				_properties.DamageRegularMin += 20;
				_properties.DamageRegularMax += 25;
			}
			else
			{
				_properties.DamageRegularMin += 10;
				_properties.DamageRegularMax += 12;
			}
		}
		else if (size == 3)
		{
			_properties.Hitpoints += 300;
			_properties.MeleeSkill += 20;
			_properties.MeleeDefense += 12;
			_properties.RangedDefense -= 12;
			_properties.Bravery += 60;
			_properties.Initiative -= 25;
			_properties.DailyFood += 3;

			if (mainhand == null || mainhand.isItemType(::Const.Items.ItemType.TwoHanded) && !mainhand.isItemType(::Const.Items.ItemType.RangedWeapon))
			{
				_properties.DamageRegularMin += 40;
				_properties.DamageRegularMax += 60;
			}
			else
			{
				_properties.DamageRegularMin += 20;
				_properties.DamageRegularMax += 30;
			}
			
			if (!isPlayer)
			{
				this.getContainer().getActor().getAIAgent().getProperties().BehaviorMult[::Const.AI.Behavior.ID.Retreat] = 0.0;
			}
		}
	}
	
});