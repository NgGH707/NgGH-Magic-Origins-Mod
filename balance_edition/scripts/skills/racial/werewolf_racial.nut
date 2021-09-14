this.werewolf_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.werewolf";
		this.m.Name = "Blind Rage";
		this.m.Description = "Gain additional damage scaling with loss health";
		this.m.Icon = "skills/status_effect_wolf_rider.png";
		this.m.IconMini = "status_effect_wolf_rider_mini";
		this.m.Type = this.Const.SkillType.Racial;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}
	
	function getTooltip()
	{
		local healthMax = this.getContainer().getActor().getHitpointsMax();
		local healthMissing = 1 - this.getContainer().getActor().getHitpointsPct();
		local additionalDamage = this.Math.floor(healthMax * healthMissing * 0.25);

		if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
		{
			additionalDamage = this.Math.floor(additionalDamage * 2);
		}
		
		return [
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
			{
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + additionalDamage + "[/color] Attack Damage"
			}
		];
	}
	
	function onAdded()
	{
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			return;
		}
		
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.getContainer().update();
	}

	function onUpdate( _properties )
	{
		local healthMax = this.getContainer().getActor().getHitpointsMax();
		local healthMissing = 1 - this.getContainer().getActor().getHitpointsPct();
		local additionalDamage = this.Math.floor(healthMax * healthMissing * 0.25);

		if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
		{
			additionalDamage = this.Math.floor(additionalDamage * 2);
		}

		if (additionalDamage > 0)
		{
			_properties.DamageRegularMin += additionalDamage;
			_properties.DamageRegularMax += additionalDamage;
		}
	}

});

