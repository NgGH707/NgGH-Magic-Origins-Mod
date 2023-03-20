::mods_hookExactClass("skills/actives/legend_grow_greenwood_shield_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Grow Greenwood Shield";
		this.m.Description = "Regrow your bark, producing a protective shield";
		this.m.Icon = "skills/active_121.png";
		this.m.IconDisabled = "skills/active_121_sw.png";
		this.m.Overlay = "active_121";
		this.m.Order = ::Const.SkillOrder.NonTargeted + 1;
	};
	obj.onAdded <- function()
	{
		if (!::Nggh_MagicConcept.IsOPMode && this.getContainer().getActor().isPlayerControlled())
		{
			this.m.FatigueCost = 50;
		}
	}
	obj.getTooltip <- function()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		local isSpecialized = this.getContainer().getActor().getCurrentProperties().IsSpecializedInHammers;

		ret.push({
			id = 4,
			type = "text",
			icon = "/ui/icons/melee_defense.png",
			text = "Grants a [color=" + ::Const.UI.Color.PositiveValue + "]+40[/color] Melee and Ranged Defense shield, with [color=" + ::Const.UI.Color.PositiveValue + "]64[/color] durability"
		});

		if (isSpecialized)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Gains [color=" + ::Const.UI.Color.PositiveValue + "]Shieldwall[/color] effect for free when growing a new shield"
			});
		}

		return ret;
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInHammers ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	};
	obj.onUse = function( _user, _targetTile )
	{
		local actor = this.getContainer().getActor();
		local isSpecialized = this.getContainer().hasSkill("perk.grow_shield");

		::Time.scheduleEvent(::TimeUnit.Virtual, 250, function ( _idk )
		{
			actor.getItems().equip(::new("scripts/items/shields/beasts/legend_greenwood_schrat_shield"));
			actor.getSprite("shield_icon").Alpha = 0;
			actor.getSprite("shield_icon").fadeIn(1500);

			if (isSpecialized)
			{
				actor.getSkills().add(::new("scripts/skills/effects/shieldwall_effect"));
			}
		}, null);
	};
});