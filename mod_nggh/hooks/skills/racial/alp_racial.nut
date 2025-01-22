::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/alp_racial", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Partly Exist In Dreams";
		m.Description = "Has strong resistance against ranged or piercing attacks due to part of its real body only existing in a dream. It has the habbit to haunt and stalk its prey.";
		m.Icon = "skills/status_effect_102.png";
		m.IconMini = "status_effect_102_mini";
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
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

		if (::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue()) {
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]-15%[/color] Melee Damage"
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]-15%[/color] Ranged Damage"
				}
			]);
		}

		ret.extend([
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Is [color=" + ::Const.UI.Color.PositiveValue + "]resistant[/color] against piercing or ranged damage"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Is [color=" + ::Const.UI.Color.NegativeValue + "]vulnerable[/color] against fire damage"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Causes allied \'Alps\' to teleport after taking damage"
			}
		]);

		return ret;
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player"))
			getContainer().getActor().getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/ai_alp_teleport"));
	}

	q.onUpdate <- function( _properties )
	{
		if (!::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue()) return; // nerf alp player as these doesn't do anything to npc alp

		_properties.MeleeDamageMult *= ::Const.AlpWeaponDamageMod;
		_properties.RangedDamageMult *= ::Const.AlpWeaponDamageMod;
	}

	q.teleport = @() function( _tag )
	{
		foreach( a in ::Tactical.Entities.getInstancesOfFaction(getContainer().getActor().getFaction()) )
		{
			local b = a.getAIAgent().getBehavior(::Const.AI.Behavior.ID.AlpTeleport);

			if (b == null)
				continue;

			local skill = a.getSkills().getSkillByID("actives.alp_teleport");

			if (skill == null || !a.isAlive() || a.getHitpoints() <= 0)
				continue;

			if (!a.getFlags().get("auto_teleport"))
				continue;

			b.onEvaluate(a);
			b.onExecute(a);
		}
	}

});