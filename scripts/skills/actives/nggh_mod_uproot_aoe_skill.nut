this.nggh_mod_uproot_aoe_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "active.uproot_aoe";
		this.m.Name = "Shatter The Earth";
		this.m.Description = "Using hidden roots to create a ground eruption, sending rock shrapnels everywhere.";
		this.m.Icon = "skills/active_220.png";
		this.m.IconDisabled = "skills/active_220_sw.png";
		this.m.Overlay = "active_220";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/skull_bang_01.wav",
			"sounds/enemies/dlc6/skull_bang_02.wav",
			"sounds/enemies/dlc6/skull_bang_03.wav",
			"sounds/enemies/dlc6/skull_bang_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/schrat_uproot_hit_01.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_02.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_03.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_04.wav"
		];
		this.m.SoundOnHit = [];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted + 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsTargetingActor = false;
		this.m.InjuriesOnBody = ::Const.Injury.BluntBody;
		this.m.InjuriesOnHead = ::Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.25;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function onAdded()
	{
		local AI = this.getContainer().getActor().getAIAgent();

		if (AI != null && AI.getID() != ::Const.AI.Agent.ID.Player && AI.findBehavior(::Const.AI.Behavior.ID.Thresh) == null)
		{
			AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_attack_thresh"));
		}
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + ::Const.UI.Color.PositiveValue + "]+10%[/color] chance to hit"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can hit up to 6 targets"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Breaks [color=" + ::Const.UI.Color.PositiveValue + "]Defensive Stance[/color]"
			}
		]);
		return ret;
	}

	function applyEffectToTarget( _user, _target, _targetTile )
	{
		if (_target.isNonCombatant())
		{
			return;
		}

		_target.getSkills().add(::new("scripts/skills/effects/staggered_effect"));

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " has staggered " + ::Const.UI.getColorizedEntityName(_target) + " for one turn");
		}
	}
	
	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		
		::Tactical.getCamera().quake(::createVec(0, -1.0), 6.0, 0.16, 0.35);
		
		for( local i = 0; i < 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = myTile.getNextTile(i);
				local target = nextTile.getEntity();
				
				for( local i = 0; i < ::Const.Tactical.DustParticles.len(); ++i )
				{
					::Tactical.spawnParticleEffect(false, ::Const.Tactical.DustParticles[i].Brushes, nextTile, ::Const.Tactical.DustParticles[i].Delay, ::Const.Tactical.DustParticles[i].Quantity * 0.5, ::Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, ::Const.Tactical.DustParticles[i].SpawnRate, ::Const.Tactical.DustParticles[i].Stages, ::createVec(0, -30));
				}

				if (nextTile.IsOccupiedByActor && target.isAttackable())
				{
					local success = this.attackEntity(_user, target);

					if (nextTile.IsOccupiedByActor && target.isAlive() && !target.isDying())
					{
						local skills = target.getSkills();
						skills.removeByID("effects.shieldwall");
						skills.removeByID("effects.spearwall");
						skills.removeByID("effects.riposte");

						if (success)
						{
							this.applyEffectToTarget(_user, target, nextTile);
							this.applyFatigueDamage(target, 10);
						}
					}
				}
			}
		}

		return true;
	}

	function onTargetSelected( _targetTile )
	{
		if (_targetTile != null)
		{
			local ownTile = this.getContainer().getActor().getTile();

			for( local i = 0; i != 6; ++i )
			{
				if (!ownTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = ownTile.getNextTile(i);

					if (::Math.abs(tile.Level - ownTile.Level) <= 1)
					{
						::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
					}
				}
			}
		}
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInSpears ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin -= 35;
			_properties.DamageRegularMax -= 40;
			_properties.MeleeSkill += 10;
		}
	}

});

