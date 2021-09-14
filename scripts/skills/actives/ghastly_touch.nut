this.ghastly_touch <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.ghastly_touch";
		this.m.Name = "Ghastly Touch";
		this.m.Description = "A touch of something doesn\'t belong to the living world. Slowly and surely draining away any piece of life.";
		this.m.KilledString = "Frightened to death";
		this.m.Icon = "skills/active_42.png";
		this.m.IconDisabled = "skills/active_42_sw.png";
		this.m.Overlay = "active_42";
		this.m.SoundOnUse = [
			"sounds/enemies/ghastly_touch_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Completely ignores armor"
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 15;
		_properties.DamageRegularMax += 25;
		_properties.IsIgnoringArmorOnAttack = true;
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

