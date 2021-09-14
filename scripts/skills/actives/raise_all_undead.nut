this.raise_all_undead <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.raise_undead";
		this.m.Name = "Raise Undead";
		this.m.Description = "";
		this.m.Icon = "skills/active_26.png";
		this.m.IconDisabled = "skills/active_26_sw.png";
		this.m.Overlay = "active_26";
		this.m.SoundOnUse = [
			"sounds/enemies/necromancer_01.wav",
			"sounds/enemies/necromancer_02.wav",
			"sounds/enemies/necromancer_03.wav"
		];
		this.m.SoundVolume = 1.2;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
	}
	
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (!_targetTile.IsCorpseSpawned)
		{
			return false;
		}

		if (!_targetTile.Properties.get("Corpse").IsResurrectable)
		{
			return false;
		}

		if (!_targetTile.IsEmpty)
		{
			return false;
		}

		return true;
	}

	function spawnUndead( _user, _tile )
	{
		local p = _tile.Properties.get("Corpse");
		p.Faction = _user.getFaction();
		local e = this.Tactical.Entities.onResurrect(p, true);

		if (e != null)
		{
			e.getSprite("socket").setBrush(_user.getSprite("socket").getBrush().Name);
		}

		return e;
	}

	function onUse( _user, _targetTile )
	{
		local corpses = clone this.Tactical.Entities.getCorpses();

		foreach( c in corpses )
		{
			if (!c.IsEmpty)
			{
				continue;
			}

			if (!c.IsCorpseSpawned || !c.Properties.get("Corpse").IsResurrectable)
			{
				continue;
			}

			if (c.IsVisibleForPlayer)
			{
				for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(true, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, c, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
				}
			}

			local e = this.spawnUndead(_user, c);
			local armor = e.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
			local helmet = e.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
			
			if (armor != null && armor.getCondition() < armor.getConditionMax() / 4)
			{
				armor.setCondition(this.Math.rand(armor.getConditionMax() / 4, armor.getConditionMax() / 3));
			}
			
			if (helmet != null && helmet.getCondition() < helmet.getConditionMax() / 4)
			{
				helmet.setCondition(this.Math.rand(helmet.getConditionMax() / 4, helmet.getConditionMax() / 3));
			}
		}
		
		if (_user.isDiscovered() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " uses Raise Undead");
			
			if (this.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * 1.2, _user.getPos());
			}
		}
		
		return true;
	}

});

