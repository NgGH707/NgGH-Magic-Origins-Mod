this.mod_stomp <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "active.stomp";
		this.m.Name = "Stomp";
		this.m.Description = "Using your immense weight to stomp the ground causing a shockwave blast that deals damage and staggers or even dazes nearby enemies. Impossible to dodge.";
		this.m.Icon = "skills/active_220.png";
		this.m.IconDisabled = "skills/active_220_sw.png";
		this.m.Overlay = "active_220";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/skull_bang_01.wav",
			"sounds/enemies/dlc6/skull_bang_02.wav",
			"sounds/enemies/dlc6/skull_bang_03.wav",
			"sounds/enemies/dlc6/skull_bang_04.wav"
		];
		this.m.SoundOnHit = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 2;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsIgnoringRiposte = true;
		this.m.IsAOE = true;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.15;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Deals damage[/color] to anyone near the user"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "May cause [color=" + this.Const.UI.Color.NegativeValue + "]Staggered[/color], [color=" + this.Const.UI.Color.NegativeValue + "]Dazed[/color] or [color=" + this.Const.UI.Color.NegativeValue + "]Distracted[/color] on hit"
			}
		]);
		return ret;
	}
	

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		
		this.Tactical.getCamera().quake(this.createVec(0, -1.0), 6.0, 0.16, 0.35);
		
		for( local i = 0; i < 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = myTile.getNextTile(i);
				local target = nextTile.getEntity();
				
				for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, nextTile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
				}

				if (nextTile.IsOccupiedByActor && target.isAttackable())
				{
					this.attackEntity(_user, target);
				}
					
				if (nextTile.IsOccupiedByActor && target.isAlive() && !target.isDying())
				{
					local skills = target.getSkills();
					skills.removeByID("effects.shieldwall");
					skills.removeByID("effects.spearwall");
					skills.removeByID("effects.riposte");
					
					this.applyEffectToTarget(_user, target, nextTile);
				}
			}
		}

		return true;
	}
	
	function applyEffectToTarget( _user, _target, _targetTile )
	{
		if (_target.isNonCombatant())
		{
			return;
		}
		
		local effect = this.Math.rand(1, 4);
		
		if (effect == 1)
		{
			_target.getSkills().add(this.new("scripts/skills/effects/distracted_effect"));
			
			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has distracted " + this.Const.UI.getColorizedEntityName(_target) + " for one turn");
			}
		}
		else if (effect == 2)
		{
			if (!_target.getCurrentProperties().IsImmuneToStun)
			{
				return;
			}

			_target.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
			
			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has dazed " + this.Const.UI.getColorizedEntityName(_target) + " for 2 turns");
			}
		}
		else
		{
			_target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));
		
			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has staggered " + this.Const.UI.getColorizedEntityName(_target) + " for 2 turns");
			}
		}
	}

	function onTargetSelected( _targetTile )
	{
		local ownTile = this.m.Container.getActor().getTile();

		for( local i = 0; i != 6; i = ++i )
		{
			if (!ownTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = ownTile.getNextTile(i);

				if (this.Math.abs(tile.Level - ownTile.Level) <= 1)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
				}
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 25;
			_properties.DamageRegularMax += 58;
			_properties.DamageArmorMult *= 0.75;
		}
	}

});

