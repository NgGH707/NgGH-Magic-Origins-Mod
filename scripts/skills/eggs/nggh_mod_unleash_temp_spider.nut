this.nggh_mod_unleash_temp_spider <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.unleash_temp_spider";
		this.m.Name = "Dismount";
		this.m.Description = "Get down from your mount.";
		this.m.Icon = "skills/active_place_egg.png";
		this.m.IconDisabled = "skills/active_place_egg_sw.png";
		this.m.Overlay = "active_place_egg";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/giant_spider_egg_spawn_01.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_02.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_03.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_04.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.NonTargeted + 5;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
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
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
		];
		return ret;
	}

	function isHidden()
	{
		return this.m.IsHidden || !this.getContainer().getActor().getFlags().has("has_temp_spider");
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		local spider = _user.getItems().getItemAtSlot(::Const.ItemSlot.Accessory);

		if (spider == null || spider.getID() != "accessory.temp_spider")
		{
			return false;
		}

		::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " dismounts from " + ::Const.UI.getColorizedEntityName(spider.getEntity()));
		spider.onPlace(_targetTile);
		spider.onDone();
		return true;
	}

});

