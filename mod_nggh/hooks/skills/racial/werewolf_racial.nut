::mods_hookExactClass("skills/racial/werewolf_racial", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Gain additional damage scaling with loss health";
		this.m.Icon = "skills/status_effect_wolf_rider.png";
		this.m.IconMini = "status_effect_wolf_rider_mini";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	};
	obj.getTooltip <- function()
	{
		local healthMax = this.getContainer().getActor().getHitpointsMax();
		local healthMissing = 1 - this.getContainer().getActor().getHitpointsPct();
		local additionalDamage = ::Math.floor(healthMax * healthMissing * 0.25);

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			additionalDamage = ::Math.floor(additionalDamage * 1.5);
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
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + additionalDamage + "[/color] Attack Damage"
			}
		];
	};
	obj.onUpdate = function( _properties )
	{
		local healthMax = this.getContainer().getActor().getHitpointsMax();
		local healthMissing = 1 - this.getContainer().getActor().getHitpointsPct();
		local additionalDamage = ::Math.floor(healthMax * healthMissing * 0.25);

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			additionalDamage = ::Math.floor(additionalDamage * 1.5);
		}

		if (additionalDamage > 0)
		{
			_properties.DamageRegularMin += additionalDamage;
			_properties.DamageRegularMax += additionalDamage;
		}
	}
});