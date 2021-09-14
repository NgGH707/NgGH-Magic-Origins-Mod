this.swallow_whole_summon_skill <- this.inherit("scripts/skills/skill", {
	m = {
		SwallowedEntity = null
	},
	function getSwallowedEntity()
	{
		return this.m.SwallowedEntity;
	}

	function create()
	{
		this.m.ID = "actives.swallow_whole";
		this.m.Name = "Swallow Whole";
		this.m.Description = "Chuckle your foe into your belly. Yum! tasty right?";
		this.m.Icon = "skills/active_103.png";
		this.m.IconDisabled = "skills/active_103_sw.png";
		this.m.Overlay = "active_103";
		this.m.SoundOnHit = [
			"sounds/enemies/swallow_whole_01.wav",
			"sounds/enemies/swallow_whole_02.wav",
			"sounds/enemies/swallow_whole_03.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/enemies/swallow_whole_miss_01.wav",
			"sounds/enemies/swallow_whole_miss_02.wav",
			"sounds/enemies/swallow_whole_miss_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 9;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}
	
	function getTooltip()
	{
		local p = this.getContainer().getActor().getCurrentProperties();
		return [
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
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can be used to [color=" + this.Const.UI.Color.PositiveValue + "]Swallow[/color] an unlucky target"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not swallow something too big[/color]"
			},
		];
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.m.SwallowedEntity == null && this.getContainer().getActor().getSize() == 3;
	}
	
	function isHidden()
	{
		return this.getContainer().getActor().getSize() != 3 || this.skill.isHidden();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();
		
		if (this.getContainer().getActor().isAlliedWith(target))
		{
			return false;
		}
		
		if (target.getSkills().hasSkill("racial.champion"))
		{
			return false;
		}
		
		if (!this.checkCanBeSwallow(target))
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || this.knockToTile.IsVisibleForPlayer))
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " devours " + this.Const.UI.getColorizedEntityName(target));
		}

		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");

		if (target.getMoraleState() != this.Const.MoraleState.Ignore)
		{
			target.setMoraleState(this.Const.MoraleState.Breaking);
		}

		this.m.SwallowedEntity = target;
		this.m.SwallowedEntity.getFlags().set("Devoured", true);
		this.m.SwallowedEntity.setHitpoints(this.Math.max(5, this.m.SwallowedEntity.getHitpoints() - this.Math.rand(10, 20)));
		target.removeFromMap();
		_user.getSprite("body").setBrush("bust_ghoul_body_04");
		_user.getSprite("injury").setBrush("bust_ghoul_04_injured");
		_user.getSprite("head").setBrush("bust_ghoul_04_head_0" + _user.m.Head);
		_user.m.Sound[this.Const.Sound.ActorEvent.Death] = _user.m.Sound[this.Const.Sound.ActorEvent.Other2];
		local effect = this.new("scripts/skills/effects/swallowed_whole_effect");
		effect.setName(target.getName());
		_user.getSkills().add(effect);

		if (this.m.SoundOnHit.len() != 0)
		{
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
		}

		return true;
	}
	
	function onCombatFinished()
	{
		if (this.m.SwallowedEntity != null)
		{
			this.m.SwallowedEntity = null;
		}
	}
	
	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints >= this.getContainer().getActor().getHitpoints())
		{
			if (this.m.SwallowedEntity != null)
			{
				this.m.SwallowedEntity.getItems().dropAll(null, null, false);
				this.m.SwallowedEntity = null;
			}
		}
	}
	
	function checkCanBeSwallow( _entity )
	{
		local invalid = [
			this.Const.EntityType.Mortar,
			this.Const.EntityType.Unhold,
			this.Const.EntityType.UnholdFrost,
			this.Const.EntityType.UnholdBog,
			this.Const.EntityType.BarbarianUnhold,
			this.Const.EntityType.BarbarianUnholdFrost,
			this.Const.EntityType.GoblinWolfrider,
			this.Const.EntityType.OrcWarlord,
			this.Const.EntityType.ZombieBetrayer,
			this.Const.EntityType.Ghost,
			this.Const.EntityType.SkeletonPhylactery,
			this.Const.EntityType.SkeletonLichMirrorImage,
			this.Const.EntityType.Schrat,
			this.Const.EntityType.Lindwurm,
			this.Const.EntityType.Kraken,
			this.Const.EntityType.KrakenTentacle,
			this.Const.EntityType.TricksterGod,
			this.Const.EntityType.ZombieBoss,
			this.Const.EntityType.SkeletonBoss,
			this.Const.EntityType.SkeletonLich
		];
		local type = _entity.getType();
		local ret = invalid.find(type);
		
		if (type == this.Const.EntityType.SandGolem || type == this.Const.EntityType.Ghoul)
		{
			return _entity.getSize() != 3;
		}
		
		if (ret != null)
		{
			return false;
		}
		else
		{
			return true;
		}
	}

});

