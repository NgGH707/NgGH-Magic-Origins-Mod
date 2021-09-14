this.grow_shield_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.grow_shield";
		this.m.Name = "Grow Shield";
		this.m.Description = "Using your own hand to grow a shield out of it.";
		this.m.Icon = "skills/active_121.png";
		this.m.IconDisabled = "skills/active_121_sw.png";
		this.m.Overlay = "active_121";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/schrat_regrowth_01.wav",
			"sounds/enemies/dlc2/schrat_regrowth_02.wav",
			"sounds/enemies/dlc2/schrat_regrowth_03.wav",
			"sounds/enemies/dlc2/schrat_regrowth_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.IsSerialized = false;
		this.m.Order = this.Const.SkillOrder.NonTargeted + 1;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 50;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}
	
	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		local isSpecialized = this.getContainer().getActor().getCurrentProperties().IsSpecializedInHammers;

		if (isSpecialized)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Gains [color=" + this.Const.UI.Color.PositiveValue + "]Shieldwall[/color] effect for free"
			});
		}

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInHammers ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function isUsable()
	{
		return !this.getContainer().getActor().isArmedWithShield() && this.skill.isUsable();
	}

	function onUse( _user, _targetTile )
	{
		local actor = this.getContainer().getActor();
		local isSpecialized = this.getContainer().hasSkill("perk.grow_shield");
		
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 250, function ( _idk )
		{
			actor.getItems().equip(this.new("scripts/items/shields/beasts/schrat_shield"));
			actor.getSprite("shield_icon").Alpha = 0;
			actor.getSprite("shield_icon").fadeIn(1500);

			if (isSpecialized)
			{
				actor.getSkills().add(this.new("scripts/skills/effects/shieldwall_effect"));
			}
		}, null);
	}

});

