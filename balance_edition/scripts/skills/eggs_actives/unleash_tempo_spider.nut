this.unleash_tempo_spider <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.unleash_tempo_spider";
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
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.NonTargeted + 5;
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
		return this.m.IsHidden || !this.getContainer().getActor().getFlags().has("has_tempo_spider");
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		local spider = _user.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

		if (spider == null || spider.getID() != "accessory.tempo_spider")
		{
			return false;
		}

		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " dismounts from " + this.Const.UI.getColorizedEntityName(spider.getEntity()));
		spider.onPlace(_targetTile);
		spider.isDone();
		return true;
	}

});

