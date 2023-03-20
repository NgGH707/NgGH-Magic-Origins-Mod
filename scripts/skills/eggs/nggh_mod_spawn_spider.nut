this.nggh_mod_spawn_spider <- ::inherit("scripts/skills/skill", {
	m = {
		EggsPool = null
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
		this.m.ID = "actives.spawn_spider";
		this.m.Name = "Hatch Egg";
		this.m.Description = "Force a Webknecht hatch out of an egg.";
		this.m.Icon = "skills/active_spawn_spider.png";
		this.m.IconDisabled = "skills/active_spawn_spider_sw.png";
		this.m.Overlay = "active_spawn_spider";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/giant_spider_idle_04.wav",
			"sounds/enemies/dlc2/giant_spider_idle_05.wav",
			"sounds/enemies/dlc2/giant_spider_idle_06.wav",
			"sounds/enemies/dlc2/giant_spider_idle_07.wav",
			"sounds/enemies/dlc2/giant_spider_idle_08.wav",
			"sounds/enemies/dlc2/giant_spider_idle_09.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted - 2;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 18;
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
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Spiderling can act immediately"
			}
		];

		if (this.getContainer().hasSkill("perk.inherit"))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Spiderling will inherit most of Hive\'s perks"
			});
		}

		if (this.getContainer().hasSkill("perk.natural_selection"))
		{
			local actor = this.getContainer().getActor();

			if (actor.m.Count > 0)
			{
				local m = ::Math.floor(::Math.pow(1.038, ::Math.min(9, actor.m.Count)) * 100) - 100;

				ret.push({
					id = 9,
					type = "text",
					icon = "ui/icons/level.png",
					text = "Spiderling will have [color=" + ::Const.UI.Color.PositiveValue + "]" + m + "%[/color] better stats that what it should normally be"
				});
			}
		}

		if (::Tactical.isActive() && this.m.EggsPool.countSpiderlingNum() >= ::Const.MaximumSpiderling)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]You can\'t have more than 6 spiders at the same time[/color]"
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

		if (this.m.EggsPool == null || this.m.EggsPool.isNull())
		{
			return false;
		}

		if (this.m.EggsPool.countSpiderlingNum() >= ::Const.MaximumSpiderling)
		{
			return false;
		}

		return this.m.EggsPool.hasEggs();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		local spider = _user.onSpawn(_targetTile);
		
		if (spider == null)
		{
			return false;
		}
		
		this.makeSpiderAct(spider);
		this.m.EggsPool.usedOneEgg();
		return true;
	}
	
	function makeSpiderAct( _spawn )
	{
		::Tactical.TurnSequenceBar.removeEntity(_spawn);
		_spawn.m.IsActingImmediately = true;
		_spawn.m.IsTurnDone = false;
		::Tactical.TurnSequenceBar.insertEntity(_spawn);
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = this.getContainer().hasSkill("perk.breeding_machine") ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

});

