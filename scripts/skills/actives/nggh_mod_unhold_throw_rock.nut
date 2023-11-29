this.nggh_mod_unhold_throw_rock <- ::inherit("scripts/skills/skill", {
	m = {
		AdditionalAccuracy = 10,
		AdditionalHitChance = -10
	},
	function create()
	{
		this.m.ID = "actives.throw_balls";
		this.m.Name = "Throw Rock";
		this.m.Description = "Hurl a huge rock at a target. Goodluck blocking it with a shield! Can not be used while engaged in melee.";
		this.m.KilledString = "Smashed";
		this.m.Icon = "skills/active_12.png";
		this.m.IconDisabled = "skills/active_12_sw.png";
		this.m.Overlay = "active_12";
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
		this.m.SoundOnHitShield = [
			"sounds/combat/dlc4/sling_shield_hit_01.wav",
			"sounds/combat/dlc4/sling_shield_hit_02.wav",
			"sounds/combat/dlc4/sling_shield_hit_03.wav",
			"sounds/combat/dlc4/sling_shield_hit_04.wav",
			"sounds/combat/dlc4/sling_shield_hit_05.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/combat/dlc4/sling_miss_01.wav",
			"sounds/combat/dlc4/sling_miss_02.wav",
			"sounds/combat/dlc4/sling_miss_03.wav",
			"sounds/combat/dlc4/sling_miss_04.wav",
			"sounds/combat/dlc4/sling_miss_05.wav",
			"sounds/combat/dlc4/sling_miss_06.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsWeaponSkill = true;
		this.m.IsDoingForwardMove = false;
		this.m.IsShieldRelevant = false;
		this.m.InjuriesOnBody = ::Const.Injury.BluntBody;
		this.m.InjuriesOnHead = ::Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.35;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 2;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 4;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 25;

		this.m.ProjectileType = ::Const.ProjectileType.NggH_Rock;
		this.m.ProjectileTimeScale = 1.2;
		this.m.IsProjectileRotated = true;
	}

	function getTooltip()
	{
		local ret = this.getRangedTooltip(this.getDefaultTooltip());

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ignores the bonus to Melee Defense granted by shields"
			}
		]);

		if (!this.getContainer().hasSkill("actives.sweep"))
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Stop user from using any other weapon skill[/color]"
			});
		}

		if (::Tactical.isActive() && this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		if (!::Tactical.isActive())
			return true;

		if (this.getContainer().getActor().isEngagedInMelee())
			return false;

		return this.m.IsUsable && this.getContainer().getActor().getCurrentProperties().IsAbleToUseSkills && !this.isHidden() && !(this.getContainer().getActor().getSkills().hasSkill("trait.oath_of_honor") && (this.m.IsWeaponSkill && this.m.IsRanged || this.m.IsOffensiveToolSkill));
	}

	function getAmmo()
	{
		local item = this.getContainer().getActor().getOffhandItem();

		if (item == null)
			return 0;

		return item.getAmmo();
	}

	function consumeAmmo()
	{
		local item = this.getContainer().getActor().getOffhandItem();

		if (item != null)
			item.consumeAmmo();
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInThrowing ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		if (_user.getFlags().has("nggh_character"))
			_user.m.IsInventoryLocked = false;

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.getContainer().setBusy(true);
			local d = _user.getTile().getDirectionTo(_targetTile) + 3;

			if (d > 5) d -= 6;

			// making a throwing stance
			if (_user.getTile().hasNextTile(d))
				::Tactical.getShaker().shake(_user, _user.getTile().getNextTile(d), 6);

			::Time.scheduleEvent(::TimeUnit.Virtual, this.m.Delay, this.onPerformAttack, {
				Skill = this,
				User = _user,
				TargetTile = _targetTile
			});

			if (!_user.isPlayerControlled() && _targetTile.getEntity().isPlayerControlled())
				_user.getTile().addVisibilityForFaction(::Const.Faction.Player);

			return true;
		}

		local ret = this.attackEntity(_user, _targetTile.getEntity());
		_user.getItems().unequip(_user.getOffhandItem());
		return ret;
	}

	function onPerformAttack( _tag )
	{
		_tag.Skill.getContainer().setBusy(false);
		local ret = _tag.Skill.attackEntity(_tag.User, _tag.TargetTile.getEntity());
		_tag.User.getItems().unequip(_tag.User.getOffhandItem());
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		if (this.getContainer().hasSkill("actives.sweep"))
		{
			// recoup the initiative loss
			_properties.Initiative += 20 * _properties.FatigueToInitiativeRate;
			return;
		}

		// i don't want a non-unhold can throw giant rock while being able to use weapon skills
		_properties.IsAbleToUseWeaponSkills = false;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += this.m.AdditionalAccuracy;
			_properties.HitChanceAdditionalWithEachTile += this.m.AdditionalHitChance;

			if (!this.getContainer().hasSkill("actives.sweep"))
				return;

			if (this.getContainer().getActor().getMainhandItem() != null)
				return;	

			_properties.DamageRegularMin -= 30;
			_properties.DamageRegularMax -= 60;
			_properties.DamageArmorMult /= 0.8;
		}
	}

	/*
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill != this || !_targetEntity.isAlive() || _targetEntity.isDying())
			return;

		_targetEntity.getSkills().add(::new("scripts/skills/effects/staggered_effect"));

		if (!this.getContainer().getActor().isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " has staggered " + ::Const.UI.getColorizedEntityName(_targetEntity) + " for one turn");
	}
	*/

});

