this.nggh_mod_add_egg <- ::inherit("scripts/skills/skill", {
	m = {
		EggsPool = null,
		Cooldown = 0,
	},
	
	function setEggsPool( _p )
	{
		if (_p == null)
		{
			this.m.EggsPool = null;
		}
		else if (typeof _p == "instance")
		{
			this.m.EggsPool = _p;
		}
		else
		{
			this.m.EggsPool = ::WeakTableRef(_p);
		}
	}
	
	function create()
	{
		this.m.ID = "actives.add_egg";
		this.m.Name = "More Egg";
		this.m.Description = "Spawns more eggs.";
		this.m.Icon = "skills/active_more_egg.png";
		this.m.IconDisabled = "skills/active_more_egg_sw.png";
		this.m.Overlay = "active_more_egg";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/giant_spider_egg_spawn_01.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_02.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_03.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_04.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 18;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
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
			}
		];

		if (this.m.Cooldown != 0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can be used again after " + this.m.Cooldown + " turn(s)[/color]"
			});
		}

		return ret;
	}
	
	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		return this.m.Cooldown == 0 && this.m.EggsPool != null && !this.m.EggsPool.isNull() && this.m.EggsPool.getEggs() < 3;
	}

	function onUse( _user, _targetTile )
	{
		if (this.m.EggsPool == null || this.m.EggsPool.isNull())
		{
			return false;
		}
		
		this.m.EggsPool.addEggs(1);
		this.m.Cooldown = 2;
		return true;
	}

	function onUpdate( _properties )
	{
		if (this.m.Cooldown != 0)
		{
			_properties.FatigueRecoveryRateMult *= 0.75;
		}
	}

	function onTurnStart()
	{
		this.m.Cooldown = ::Math.max(0, this.m.Cooldown - 1);
	}

});

