this.mc_DIA_curse <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		ChanceBonus = -25,
		AdditionalAccuracy = 0,
		AdditionalHitChance = -5
	},
	function create()
	{
		this.mc_magic_skill.create();
		this.m.ID = "actives.mc_curse";
		this.m.Name = "Curse";
		this.m.Description = "Put a sinister curse on a target. The curse will slowly kill that target, the more curse you put on the more damage per turn that target receives. Accuracy based on ranged skill. Damage based on resolve, deal reduced damage if you don\'t have a magic staff. Can not be used while engaged in melee.";
		this.m.Icon = "skills/active_119.png";
		this.m.IconDisabled = "skills/active_119_sw.png";
		this.m.Overlay = "active_119";
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/hexe_hex_01.wav",
			"sounds/enemies/dlc2/hexe_hex_02.wav",
			"sounds/enemies/dlc2/hexe_hex_03.wav",
			"sounds/enemies/dlc2/hexe_hex_04.wav",
			"sounds/enemies/dlc2/hexe_hex_05.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/enemies/dlc2/hexe_hex_damage_01.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_02.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_03.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury + 1;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.DirectDamageMult = 0.3;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.IsIgnoreBlockTarget = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultRangedTooltip();

		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Curse can stack the damage up to [color=" + this.Const.UI.Color.PositiveValue + "]105[/color] damage per turn"
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
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 150, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local target = _targetTile.getEntity();
		local self = _tag.Skill;
		local d = self.getDamage(target);

		local toHit = this.getHitchance(target);
		local rolled = this.Math.rand(1, 100);
		local success = rolled <= toHit;
		local container = this.getContainer();
		container.setBusy(true);

		if (success)
		{
			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " curses " + this.Const.UI.getColorizedEntityName(target) + " (Chance: " + toHit + ", Rolled: " + rolled + ")");
			}

			if (this.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, _user.getPos());
			}
		}
		else
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " fails to curse " + this.Const.UI.getColorizedEntityName(target) + " (Chance: " + toHit + ", Rolled: " + rolled + ")");

			if (this.m.SoundOnMiss.len() != 0)
			{
				this.Sound.play(this.m.SoundOnMiss[this.Math.rand(0, this.m.SoundOnMiss.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, _user.getPos());
			}
		}

		this.Time.scheduleEvent(this.TimeUnit.Virtual, 250, function ( _tag )
		{
			local color;
			do
			{
				color = this.createColor("#ff0000");
				color.varyRGB(0.75, 0.75, 0.75);
			}
			while (color.R + color.G + color.B <= 150);
			this.Tactical.spawnSpriteEffect("effect_pentagram_02", color, _targetTile, !target.getSprite("status_hex").isFlippedHorizontally() ? 10 : -5, 88, 3.0, 1.0, 0, 400, 300);

			if (success)
			{
				target.getSkills().add(this.new("scripts/skills/mc_effects/mc_curse_effect"));
				local curse = target.getSkills().getSkillByID("effects.mc_curse");

				if (curse != null)
				{
					curse.setDamage(d);
					curse.setActor(_user);
					curse.applyDamage(true);
				}
			}

			container.setBusy(false);
		}.bindenv(this), null);
	}

	function getDamage( _targetEntity )
	{
		local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
		local damage = this.Math.rand(properties.DamageRegularMin, properties.DamageRegularMax) * properties.DamageRegularMult * properties.DamageTotalMult;
		return damage; 
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 25;
			_properties.DamageRegularMax += 25;
			_properties.DamageTotalMult *= this.getBonusDamageFromResolve(_properties);
			this.removeBonusesFromWeapon(_properties);
			_properties.DamageArmorMult = 1.0;
			_properties.RangedSkill += this.m.AdditionalAccuracy;
			_properties.HitChanceAdditionalWithEachTile += this.m.AdditionalHitChance;
			_properties.RangedAttackBlockedChanceMult = 0.0;
		}
	}

});

