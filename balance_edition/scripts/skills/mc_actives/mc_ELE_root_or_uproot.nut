this.mc_ELE_root_or_uproot <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		IsVines = false,
	},
	function create()
	{
		this.mc_magic_skill.create();
		this.m.ID = "actives.mc_root_or_uproot";
		this.m.Name = "Root";
		this.m.Description = "";
		this.m.Icon = "skills/active_70.png";
		this.m.IconDisabled = "skills/active_70_sw.png";
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/schrat_uproot_01.wav",
			"sounds/enemies/dlc2/schrat_uproot_02.wav",
			"sounds/enemies/dlc2/schrat_uproot_03.wav",
			"sounds/enemies/dlc2/schrat_uproot_04.wav",
			"sounds/enemies/dlc2/schrat_uproot_05.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/schrat_uproot_hit_01.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_02.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_03.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury + 2;
		this.m.Delay = 0;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsTargetingActor = false;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = true;
		this.m.IsDoingForwardMove = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsRanged = true;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 35;
		this.m.ChanceSmash = 15;
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().getSkillByID("special.mc_focus"))
		{
			this.m.Name = "Root";
			this.m.Description = "Conjure up the force of nature to bind your foes. Affect targets in a straight line. Accuracy based on ranged skill.";
			this.m.Icon = "skills/active_70.png";
			this.m.IconDisabled = "skills/active_70_sw.png";
			this.m.Overlay = "active_70";
			this.m.IsVines = true;
		}
		else
		{
			this.m.Name = "Uproot";
			this.m.Description = "Crushing, piercing enemies with the force of nature. Attack in a straight line. Accuracy based on ranged skill. Damage based on resolve, deal reduced damage if you don\'t have a magic staff.";
			this.m.Icon = "skills/active_122.png";
			this.m.IconDisabled = "skills/active_122_sw.png";
			this.m.Overlay = "active_122";
			this.m.IsVines = false;
		}
	}
	
	function getTooltip()
	{
		local ret = this.m.IsVines ? this.skill.getDefaultUtilityTooltip() : this.skill.getDefaultTooltip();
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Can hit up to 3 targets"
		});

		if (this.m.IsVines)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Trapped targets in Vines, also affect allies"
			});
		}
		else 
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Is enhanced by [color=" + this.Const.UI.Color.PositiveValue + "]Concentrate[/color] effect"
			});    
		}

		return ret;
	}

	function isViableTargetToRoot( _user, _target )
	{
		if (_target.getCurrentProperties().IsRooted)
		{
			return false;
		}

		if (_target.getCurrentProperties().IsImmuneToRoot)
		{
			return false;
		}

		return true;
	}
	
	function spawnRoot( _user, _targetTile )
	{
		if (!_targetTile.IsOccupiedByActor)
		{
			return;
		}

		local target = _targetTile.getEntity();
		local toHit = this.getHitchance(target);
		local rolled = this.Math.rand(1, 100);
		target.raiseRootsFromGround("bust_roots", "bust_roots_back");
		this.Tactical.EventLog.log_newline();

		if (!this.isViableTargetToRoot(_user, target))
		{
			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(target) + " can\'t be rooted in vines");
			}
			return;
		}

		if (rolled > toHit)
		{
			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " fails to root " + this.Const.UI.getColorizedEntityName(target) + " in vines (Chance: " + toHit + ", Rolled: " + rolled + ")");
			}
			return;
		}

		if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " roots " + this.Const.UI.getColorizedEntityName(target) + " in vines (Chance: " + toHit + ", Rolled: " + rolled + ")");
		}

		target.getSkills().add(this.new("scripts/skills/effects/rooted_effect"));
		local breakFree = this.new("scripts/skills/actives/break_free_skill");
		breakFree.setDecal("roots_destroyed");
		breakFree.m.Icon = "skills/active_75.png";
		breakFree.m.IconDisabled = "skills/active_75_sw.png";
		breakFree.m.Overlay = "active_75";
		breakFree.m.SoundOnUse = this.m.SoundOnHitHitpoints;
		target.getSkills().add(breakFree);

		local sounds = [
			"sounds/combat/break_free_roots_00.wav",
			"sounds/combat/break_free_roots_01.wav",
			"sounds/combat/break_free_roots_02.wav",
			"sounds/combat/break_free_roots_03.wav"
		];

		if (sounds.len() != 0)
		{
			this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Skill, target.getPos());
		}
	}
	
	function spawnUprootAttack( _user, _targetTile )
	{
		this.Tactical.spawnAttackEffect("uproot", _targetTile, 0, -50, 100, 300, 100, this.createVec(0, 90), 200, this.createVec(0, -90), true);

		for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _targetTile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
		}

		if (_targetTile.IsOccupiedByActor && _targetTile.getEntity().isAttackable())
		{
			if (_targetTile.getEntity().m.IsShakingOnHit)
			{
				this.Tactical.getShaker().shake(_targetTile.getEntity(), _targetTile, 7);
				_user.playSound(this.Const.Sound.ActorEvent.Move, 2.0);
			}

			this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, function ( _tag )
			{
				this.attackEntity(_user, _targetTile.getEntity());
			}.bindenv(this), null);
		}
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local self = this;
		local func = this.m.IsEnhanced ? "spawnUprootAttack" : "spawnRoot";
		local dir = myTile.getDirectionTo(_targetTile);
		self[func](_user, _targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, function ( _tag )
			{
				self[func](_user, forwardTile);
			}.bindenv(this), null);


			if (forwardTile.hasNextTile(dir))
			{
				local furtherForwardTile = forwardTile.getNextTile(dir);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 400, function ( _tag )
				{
					self[func](_user, furtherForwardTile);
				}.bindenv(this), null);
			}
		}

		this.m.IsEnhanced = false;
		return true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill != this)
		{
			return;
		}

		if (!_targetEntity.isAlive() || _targetEntity.isDying())
		{
			return;
		}

		if (_targetEntity.isNonCombatant())
		{
			return;
		}

		_targetEntity.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " is staggered for one turn");
	}
	
	function onTargetSelected( _targetTile )
	{
		local ownTile = this.m.Container.getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		
		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);
				
			if (forwardTile.IsOccupiedByActor || forwardTile.IsEmpty)
			{
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, forwardTile, forwardTile.Pos.X, forwardTile.Pos.Y);
			}
			
			if (forwardTile.hasNextTile(dir))
			{
				local followupTile = forwardTile.getNextTile(dir);
				
				if (followupTile.IsOccupiedByActor || followupTile.IsEmpty)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, followupTile, followupTile.Pos.X, followupTile.Pos.Y);
				}
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 53;
			_properties.DamageRegularMax += 86;
			_properties.DamageArmorMult *= 0.75;
			_properties.DamageTotalMult *= this.getBonusDamageFromResolve(_properties);
			this.removeBonusesFromWeapon(_properties);
		}
	}

	function isViableTargetToFreeze( _user, _target )
	{
		local excluded = [
			this.Const.EntityType.TricksterGod,
			this.Const.EntityType.Ghost,
			this.Const.EntityType.LegendWhiteDirewolf,
			this.Const.EntityType.LegendBanshee,
			this.Const.EntityType.LegendDemonHound,
			this.Const.EntityType.SkeletonPhylactery,
			this.Const.EntityType.SkeletonLich,
			this.Const.EntityType.SkeletonLichMirrorImage,
			this.Const.EntityType.SkeletonBoss,
			this.Const.EntityType.SkeletonPriest,
			this.Const.EntityType.ZombieBoss,
			this.Const.EntityType.AlpShadow,
		];

		if (excluded.find(_target.getType()) != null)
		{
			return false;
		}

		return true;
	}
	
});

