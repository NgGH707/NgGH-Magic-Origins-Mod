this.throw_rock_mod <- this.inherit("scripts/skills/skill", {
	m = {
		AdditionalAccuracy = 0,
		AdditionalHitChance = 0
	},
	function create()
	{
		this.m.ID = "actives.throw_rock";
		this.m.Name = "Boulder Toss";
		this.m.Description = "Who needs a catapult when you have a giant golem as siege weapon? Good luck on trying to block this \'little\' rock with a shield. Can not be used in melee.";
		this.m.Icon = "skills/active_193.png";
		this.m.IconDisabled = "skills/active_193_sw.png";
		this.m.Overlay = "active_193";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/sand_golem_throw_01.wav",
			"sounds/enemies/dlc6/sand_golem_throw_02.wav",
			"sounds/enemies/dlc6/sand_golem_throw_03.wav",
			"sounds/enemies/dlc6/sand_golem_throw_04.wav",
			"sounds/enemies/dlc6/sand_golem_throw_05.wav",
			"sounds/enemies/dlc6/sand_golem_throw_06.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc6/sand_golem_throw_hit_01.wav",
			"sounds/enemies/dlc6/sand_golem_throw_hit_02.wav",
			"sounds/enemies/dlc6/sand_golem_throw_hit_03.wav",
			"sounds/enemies/dlc6/sand_golem_throw_hit_04.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/enemies/catapult_death_01.wav",
			"sounds/enemies/catapult_death_02.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 4;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsDoingForwardMove = true;
		this.m.IsShieldRelevant = false;
		this.m.IsShieldwallRelevant = false;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.DirectDamageMult = 0.45;
		this.m.MinRange = 2;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 3;
		this.m.ProjectileType = this.Const.ProjectileType.Rock;
		this.m.ProjectileTimeScale = 1.33;
		this.m.IsProjectileRotated = true;
		this.m.ChanceSmash = 50;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles on even ground, more if throwing downhill"
			}
		]);

		if (30 + this.m.AdditionalAccuracy >= 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+" + (25 + this.m.AdditionalAccuracy) + "%[/color] chance to hit, and [color=" + this.Const.UI.Color.NegativeValue + "]" + (-10 + this.m.AdditionalHitChance) + "%[/color] per tile of distance"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + this.Const.UI.Color.NegativeValue + "]" + (25 + this.m.AdditionalAccuracy) + "%[/color] chance to hit, and [color=" + this.Const.UI.Color.NegativeValue + "]" + (-10 + this.m.AdditionalHitChance) + "%[/color] per tile of distance"
			});
		}

		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Has a [color=" + this.Const.UI.Color.NegativeValue + "]100%[/color] chance to daze a target on hit"
		});
		
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Throws a freaking huge [color=" + this.Const.UI.Color.NegativeValue + "]Boulder[/color] at the enemy"
		});

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.getContainer().setBusy(true);
			local tag = {
				Skill = this,
				User = _user,
				TargetTile = _targetTile
			};
			
			local d = _user.getTile().getDirectionTo(_targetTile) + 3;
			d = d > 5 ? d - 6 : d;

			if (_user.getTile().hasNextTile(d))
			{
				this.Tactical.getShaker().shake(_user, _user.getTile().getNextTile(d), 6);
			}
			
			this.Time.scheduleEvent(this.TimeUnit.Virtual, this.m.Delay, this.onPerformAttack, tag);

			if (!_user.isPlayerControlled() && _targetTile.getEntity().isPlayerControlled())
			{
				_user.getTile().addVisibilityForFaction(this.Const.Faction.Player);
			}

			return true;
		}
		else
		{
			return this.attackEntity(_user, _targetTile.getEntity());
		}
	}

	function onPerformAttack( _tag )
	{
		_tag.Skill.getContainer().setBusy(false);
		return _tag.Skill.attackEntity(_tag.User, _tag.TargetTile.getEntity());
	}
	
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			local targetTile = _targetEntity.getTile();
			local user = this.getContainer().getActor();

			_targetEntity.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));

			if (!user.isHiddenToPlayer() && targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " struck a hit that leaves " + this.Const.UI.getColorizedEntityName(_targetEntity) + " dazed");
			}
		}
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += 15 + this.m.AdditionalAccuracy;
			_properties.HitChanceAdditionalWithEachTile += -10 + this.m.AdditionalHitChance;
			_properties.DamageRegularMin += 105;
			_properties.DamageRegularMax += 135;
			_properties.DamageArmorMult *= 0.75;
		}
	}

});

