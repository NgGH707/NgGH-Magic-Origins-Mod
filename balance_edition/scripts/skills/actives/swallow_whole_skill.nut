this.swallow_whole_skill <- this.inherit("scripts/skills/skill", {
	m = {
		SwallowedEntity = null,
		IsArena = false,
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
		this.m.IsUsingHitchance = false;
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not swallow something bigger than you[/color]"
			}
		];
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.m.SwallowedEntity == null;
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
		
		if (target.getSkills().hasSkill("racial.champion") || target.getFlags().has("IsPlayerCharacter"))
		{
			return false;
		}
		
		local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

		if (brothers.len() == 1 && !this.getContainer().getActor().isPlayerControlled())
		{
			return false;
		}
		
		if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			return false;
		}
		
		if (!this.checkCanBeSwallow(target))
		{
			return false;
		}

		return true;
	}

	function onTurnStart()
	{
		if (this.m.SwallowedEntity != null)
		{
			this.m.SwallowedEntity.setHitpoints(this.Math.maxf(5, this.m.SwallowedEntity.getHitpoints() - 10));
		}
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
		
		this.Tactical.getTemporaryRoster().add(target);
		this.Tactical.TurnSequenceBar.removeEntity(target);

		if (!target.hasSprite("dirt"))
		{
			local slime = target.addSprite("dirt");
			slime.setHorizontalFlipping(!target.isAlliedWithPlayer());
			slime.Visible = false;
		}
		
		this.m.SwallowedEntity = target;
		this.m.SwallowedEntity.getFlags().set("Devoured", true);
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
	
	function onCombatStarted()
	{
		local isArena = this.Tactical.State.m.StrategicProperties != null && this.Tactical.State.m.StrategicProperties.IsArenaMode;
		this.m.IsArena = isArena;
	}
	
	function onCombatFinished()
	{
		local actor = this.getContainer().getActor();
		
		if (this.m.SwallowedEntity != null && this.getContainer().getActor().isPlayerControlled())
		{
			this.m.SwallowedEntity.getItems().dropAll(actor.getTile(), actor, false);
			if (!this.m.IsArena && this.m.SwallowedEntity.m.WorldTroop != null && ("Party" in this.m.SwallowedEntity.m.WorldTroop) && this.m.SwallowedEntity.m.WorldTroop.Party != null)
			{
				this.m.SwallowedEntity.m.WorldTroop.Party.removeTroop(this.m.SwallowedEntity.m.WorldTroop);
			}
			this.onSwallow(actor);
			actor.addXP(this.m.SwallowedEntity.getXPValue());
			actor.getSprite("body").setBrush("bust_ghoul_body_03");
			actor.getSprite("head").setBrush("bust_ghoul_03_head_0" + actor.m.Head);
			actor.getSprite("injury").setBrush("bust_ghoul_03_injured");
		}
		
		this.m.SwallowedEntity = null;
		this.m.IsArena = false;
	}
	
	function onSwallow( _user )
	{
		_user.setHitpoints(this.Math.min(_user.getHitpoints() + 100, _user.getHitpointsMax()));

		if (_user.getFlags().has("hunger"))
		{
			local count = this.Math.min(2, _user.getFlags().getAsInt("hunger") + 1);
			_user.getFlags().set("hunger", count);
		}
		else 
		{
		    _user.getFlags().set("hunger", 2);
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
			this.Const.EntityType.SkeletonLich,
			this.Const.EntityType.LegendOrcElite,
			this.Const.EntityType.LegendOrcBehemoth,
			this.Const.EntityType.LegendWhiteDirewolf,
			this.Const.EntityType.LegendStollwurm,
			this.Const.EntityType.LegendRockUnhold,
			this.Const.EntityType.LegendGreenwoodSchrat,
		];
		local type = _entity.getType();
		local ret = invalid.find(type);
		
		if (type == this.Const.EntityType.SandGolem || type == this.Const.EntityType.Ghoul || type == this.Const.EntityType.LegendSkinGhoul)
		{
			local isBig = _entity.getSize() >= 3;
			return !isBig;
		}
		
		if (ret != null)
		{
			return false;
		}
		
		type = _entity.getFlags().has("bewitched") ? _entity.getFlags().get("bewitched") : null;

		if (type != null && invalid.find(type) != null)
		{
			return false;
		}
		
		return true;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInShields ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

});

