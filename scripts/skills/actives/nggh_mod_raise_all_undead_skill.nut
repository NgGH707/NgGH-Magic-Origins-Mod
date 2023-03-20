this.nggh_mod_raise_all_undead_skill <- ::inherit("scripts/skills/skill", {
	m = {
		IsSpent = false,
	},
	function create()
	{
		this.m.ID = "actives.raise_all_undead";
		this.m.Name = "The Black Book";
		this.m.Description = "Witness the true power that can overcome death. The Book allows you to raise all the dead on the map back to life and fight for you.";
		this.m.Icon = "skills/active_213.png";
		this.m.IconDisabled = "skills/active_213_sw.png";
		this.m.Overlay = "active_black_book";
		this.m.SoundOnUse = [
			"sounds/enemies/necromancer_01.wav",
			"sounds/enemies/necromancer_02.wav",
			"sounds/enemies/necromancer_03.wav"
		];
		this.m.SoundVolume = 1.35;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.NonTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();

		if (this.m.IsSpent)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can only be used once per battle[/color] "
			});

			return ret;
		}

		if (::Tactical.isActive())
		{
			local count = this.getNumAvailableCorpsesOnTheMap();

			if (count > 0)
			{
				ret.push({
					id = 8,
					type = "text",
					icon = "ui/icons/kills.png",
					text = "There is [color=" + ::Const.UI.Color.PositiveValue + "]" + count + "[/color] corpse(s) can be resurrected"
				});
			}
			else
			{
				ret.push({
					id = 8,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]There is no suitable corpse on the map[/color] "
				});
			}
		}

		return ret;
	}

	function getNumAvailableCorpsesOnTheMap()
	{
		local count = 0;

		foreach ( c in ::Tactical.Entities.getCorpses() )
		{
			if (!this.isViableTile(c))
			{
				continue;
			}

			++count;
		}

		return count;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function isViableTile( _tile )
	{
		if (!_tile.IsEmpty)
		{
			return false;
		}
		
		if (!::MSU.Tile.canResurrectOnTile(_tile))
		{
			return false;
		}

		return true;
	}

	function spawnUndead( _user, _tile )
	{
		local p = _tile.Properties.get("Corpse");
		local f = _user.getFaction();

		if ("IsPlayer" in p)
		{
			p.Faction = f;
		}
		else
		{
			p.Faction = f == ::Const.Faction.Player ? ::Const.Faction.PlayerAnimals : f;
		}
		
		local e = ::Tactical.Entities.onResurrect(p, true);

		if (e != null)
		{
			e.getSprite("socket").setBrush(_user.getSprite("socket").getBrush().Name);
		}

		return e;
	}

	function onUse( _user, _targetTile )
	{
		local corpses = clone ::Tactical.Entities.getCorpses();

		foreach( c in corpses )
		{
			if (!this.isViableTile(c))
			{
				continue;
			}

			if (c.IsVisibleForPlayer)
			{
				for( local i = 0; i < ::Const.Tactical.RaiseUndeadParticles.len(); ++i )
				{
					::Tactical.spawnParticleEffect(true, ::Const.Tactical.RaiseUndeadParticles[i].Brushes, c, ::Const.Tactical.RaiseUndeadParticles[i].Delay, ::Const.Tactical.RaiseUndeadParticles[i].Quantity, ::Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, ::Const.Tactical.RaiseUndeadParticles[i].SpawnRate, ::Const.Tactical.RaiseUndeadParticles[i].Stages);
				}
			}

			local e = this.spawnUndead(_user, c);

			if (e != null)
			{
				if (e.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand) == null)
				{
					local item;

					if (e.getItems().getItemAtSlot(::Const.ItemSlot.Offhand) == null)
					{
						item = ::new("scripts/items/weapons/ancient/rhomphaia");
					}
					else
					{
						item = ::new("scripts/items/weapons/ancient/khopesh");
					}

					e.getItems().equip(item);
					item.setCondition(::Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
				}

				if (!c.IsVisibleForPlayer)
				{
					c.addVisibilityForFaction(::Const.Faction.Player);
				}
			}
		}

		::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " has mastered death!");
		this.m.IsSpent = true;
		return true;
	}

	function onCombatStarted()
	{
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.m.IsSpent = false;
	}

});

