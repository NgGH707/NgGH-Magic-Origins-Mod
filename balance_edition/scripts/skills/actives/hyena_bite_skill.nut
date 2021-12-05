this.hyena_bite_skill <- this.inherit("scripts/skills/skill", {
	m = {
		IsRestrained = false,
		IsSpent = false,
		IsFrenzied = false,
	},
	function setRestrained( _f )
	{
		this.m.IsRestrained = _f;
	}

	function create()
	{
		this.m.ID = "actives.hyena_bite";
		this.m.Name = "Hyena Bite";
		this.m.Description = "Ripping off your enemy face with your powerful hyena jaw. Can easily cause bleeding.";
		this.m.KilledString = "Ripped to shreds";
		this.m.Icon = "skills/active_197.png";
		this.m.IconDisabled = "skills/active_197_sw.png";
		this.m.Overlay = "active_197";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/hyena_bite_01.wav",
			"sounds/enemies/dlc6/hyena_bite_02.wav",
			"sounds/enemies/dlc6/hyena_bite_03.wav",
			"sounds/enemies/dlc6/hyena_bite_04.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/enemies/werewolf_claw_hit_01.wav",
			"sounds/enemies/werewolf_claw_hit_02.wav",
			"sounds/enemies/werewolf_claw_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingAndPiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingAndPiercingHead;
		this.m.DirectDamageMult = 0.35;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 6;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
	}

	function isIgnoredAsAOO()
	{
		if (!this.m.IsRestrained)
		{
			return this.m.IsIgnoredAsAOO;
		}

		return !this.getContainer().getActor().isArmedWithRangedWeapon()
	}

	function onAdded()
	{
		this.m.IsFrenzied = this.getContainer().getActor().getFlags().has("frenzy");
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		local actor = this.getContainer().getActor().get();
		local isHigh = actor.getFlags().has("frenzy") || (("isHigh" in actor) && actor.isHigh());
		local isSpecialized = this.getContainer().getActor().getCurrentProperties().IsSpecializedInCleavers;
		local damage = 5;
		
		if (isHigh)
		{
			damage += 5;
		}
		
		if (isSpecialized)
		{
			damage += 5;
		}
		
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Inflicts additional stacking [color=" + this.Const.UI.Color.DamageValue + "]" + damage + "[/color] bleeding damage per turn, for 2 turns"
		});
		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
	}
	
	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInCleavers ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function canDoubleGrip()
	{
		local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		return main != null && off == null && main.isDoubleGrippable();
	}

	function onUse( _user, _targetTile )
	{
		if (this.m.IsRestrained)
		{
			this.m.IsSpent = true;
		}

		local target = _targetTile.getEntity();
		local hp = target.getHitpoints();
		local success = this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return;
		}

		if (success && target.isAlive() && !target.isDying() && !target.getCurrentProperties().IsImmuneToBleeding && hp - target.getHitpoints() >= this.Const.Combat.MinDamageToApplyBleeding)
		{
			_user = _user.get();
			local isHigh = _user.getFlags().has("frenzy") || (("isHigh" in _user) && _user.isHigh());
			local damage = isHigh ? 10 : 5;
			damage = _user.getCurrentProperties().IsSpecializedInCleavers ? damage + 5 : damage;
			local effect = this.new("scripts/skills/effects/bleeding_effect");
			effect.setDamage(damage);

			if (_user.getFaction() == this.Const.Faction.Player)
			{
				effect.setActor(_user);
			}

			target.getSkills().add(effect);
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local items = this.m.Container.getActor().getItems();
			local mhand = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (mhand != null)
			{
				_properties.DamageRegularMin -= mhand.m.RegularDamage;
				_properties.DamageRegularMax -= mhand.m.RegularDamageMax;
				_properties.DamageArmorMult /= mhand.m.ArmorDamageMult;
				_properties.DamageDirectAdd -= mhand.m.DirectDamageAdd;
			}

			_properties.DamageRegularMin += 20;
			_properties.DamageRegularMax += 35;
			_properties.DamageArmorMult *= 1.0;

			if (_properties.IsSpecializedInCleavers && !this.m.IsRestrained)
			{
				_properties.DamageRegularMin += 10;
				_properties.DamageRegularMax += 10;
				_properties.DamageArmorMult += 0.1;
			}

			if (this.m.IsFrenzied && this.m.IsRestrained)
			{
				_properties.DamageTotalMult *= 1.25;
			}

			if (this.canDoubleGrip())
			{
				_properties.DamageTotalMult /= 1.25;
			}
		}
	}

});

