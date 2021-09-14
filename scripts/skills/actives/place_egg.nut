this.place_egg <- this.inherit("scripts/skills/skill", {
	m = {
		Item = null,
	},
	function setItem( _i )
	{
		this.m.Item = this.WeakTableRef(_i);
	}

	function create()
	{
		this.m.ID = "actives.place_egg";
		this.m.Name = "Drop Eggs";
		this.m.Description = "Drop your spider eggs friend to a nearby tile. Needs a free tile adjacent.";
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
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getName()
	{
		if (this.m.Item != null)
		{
			return "Drop " + this.Const.UI.getColorizedEntityName(this.m.Item.getEntity());
		}

		return this.m.Name;
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
			{
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "Immediately [color=" + this.Const.UI.Color.NegativeValue + "]end your turn[/color] on used"
			},
		];
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " drops " + this.Const.UI.getColorizedEntityName(this.m.Item.getEntity()) + " down");
		this.m.Item.onPlace(_targetTile);
		this.m.Item.onDone();
		this.Tactical.TurnSequenceBar.onNextTurnButtonPressed();
		return true;
	}

});

