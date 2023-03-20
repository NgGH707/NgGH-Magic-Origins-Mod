this.nggh_mod_spawn_more_spiders <- ::inherit("scripts/skills/skill", {
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
		this.m.ID = "actives.spawn_more_spider";
		this.m.Name = "Hatch All Eggs";
		this.m.Description = "Forces all Webknecht eggs in the hive to hatch at once.";
		this.m.Icon = "skills/active_spawn_more_spider.png";
		this.m.IconDisabled = "skills/active_spawn_more_spider_sw.png";
		this.m.Overlay = "active_spawn_more_spider";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/giant_spider_idle_04.wav",
			"sounds/enemies/dlc2/giant_spider_idle_05.wav",
			"sounds/enemies/dlc2/giant_spider_idle_06.wav",
			"sounds/enemies/dlc2/giant_spider_idle_07.wav",
			"sounds/enemies/dlc2/giant_spider_idle_08.wav",
			"sounds/enemies/dlc2/giant_spider_idle_09.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted - 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = false;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 50;
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
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Uses all available eggs to spawn spiderlings around you"
			},
		];

		if (::Tactical.isActive() && this.m.EggsPool.countSpiderlingNum() >= ::Const.MaximumSpiderling)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]You can\'t have more than " + ::Const.MaximumSpiderling + " spiders at the same time[/color]"
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

		return this.m.EggsPool.getEggs() >= 2;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (_targetTile.IsEmpty)
		{
			return false;
		}
		
		local count = 0;
		
		for( local i = 0; i < 6; ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else if (_targetTile.getNextTile(i).IsEmpty && ::Math.abs(_targetTile.getNextTile(i).Level - _targetTile.Level) <= 1)
			{
				++count;
			}
		}
		
		return count != 0;
	}

	function onUse( _user, _targetTile )
	{
		local availableTiles = [];
		local num = ::Const.MaximumSpiderling - this.m.EggsPool.countSpiderlingNum();
		
		for( local i = 0; i < 6; ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else if (_targetTile.getNextTile(i).IsEmpty && ::Math.abs(_targetTile.getNextTile(i).Level - _targetTile.Level) <= 1)
			{
				availableTiles.push(_targetTile.getNextTile(i));
			}
		}
		
		if (availableTiles.len() >= 3)
		{
			for( local i = 0; i < 3; i = ++i )
			{
				if (!this.m.EggsPool.hasEggs() || num == 0)
				{
					return false;
				}
				
				local spider = _user.onSpawn(availableTiles[i]);
		
				if (spider == null)
				{
					return false;
				}
				
				this.m.EggsPool.usedOneEgg();
				--num;
			}

			return true;
		}
		
		foreach ( t in availableTiles )
		{
			if (!this.m.EggsPool.hasEggs() || num == 0)
			{
				return false;
			}
			
			local spider = _user.onSpawn(t);
	
			if (spider == null)
			{
				return false;
			}
			
			this.m.EggsPool.usedOneEgg();
			--num;
		}
		
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

