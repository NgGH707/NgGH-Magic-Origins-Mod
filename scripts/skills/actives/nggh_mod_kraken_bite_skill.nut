this.nggh_mod_kraken_bite_skill <- ::inherit("scripts/skills/skill", {
	m = {
		BleedingSounds = [
			"sounds/combat/rupture_blood_01.wav",
			"sounds/combat/rupture_blood_02.wav",
			"sounds/combat/rupture_blood_03.wav"
		]
	},
	function create()
	{
		this.m.ID = "actives.kraken_bite";
		this.m.Name = "Bite";
		this.m.Description = "A bite that can cover the distance of 2 tiles and can be used from behind the frontline, outside the range of most melee weapons, and can tear bleeding wounds if not stopped by armor.";
		this.m.KilledString = "Mangled";
		this.m.Icon = "skills/active_146.png";
		this.m.IconDisabled = "skills/active_146_sw.png";
		this.m.Overlay = "active_146";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/tentacle_bite_01.wav",
			"sounds/enemies/dlc2/tentacle_bite_02.wav",
			"sounds/enemies/dlc2/tentacle_bite_03.wav",
			"sounds/enemies/dlc2/tentacle_bite_04.wav",
			"sounds/enemies/dlc2/tentacle_bite_05.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = ::Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = ::Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 50;
		this.m.ChanceSmash = 0;
	}

	function addResources()
	{
		this.skill.addResources();

		foreach( r in this.m.BleedingSounds )
		{
			::Tactical.addResource(r);
		}
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		local specialized = this.getContainer().getActor().getCurrentProperties().IsSpecializedInCleavers;
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts additional [color=" + ::Const.UI.Color.DamageValue + "]" + (specialized ? 10 : 5) + "[/color] bleeding damage over time if not stopped by armor"
			}
		]);

		return ret;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		local actor = this.getContainer().getActor();

		if (!actor.m.IsControlledByPlayer)
		{
			return actor.getMode() == ::Const.KrakenTentacleMode.Attacking;
		}
		
		return true;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 70;
		_properties.DamageRegularMax += 110;
		_properties.DamageArmorMult *= 1.0;
	}

	function onAfterUpdate( _properties )
	{
		if (_properties.IsSpecializedInCleavers)
		{
			_properties.DamageRegularMin += 8;
			_properties.DamageRegularMax += 18;
		}
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local hp = target.getHitpoints();
		local success = this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return success;
		}

		if (success && target.isAlive() && !target.isDying())
		{
			if (!target.getCurrentProperties().IsImmuneToBleeding && hp - target.getHitpoints() >= ::Const.Combat.MinDamageToApplyBleeding)
			{
				local effect = ::new("scripts/skills/effects/bleeding_effect");

				if (_user.getFaction() == ::Const.Faction.Player)
				{
					effect.setActor(this.getContainer().getActor());
				}

				if (_user.getCurrentProperties().IsSpecializedInCleavers)
				{
					effect.setDamage(effect.getDamage() + 5);
				}

				target.getSkills().add(effect);
				::Sound.play(::MSU.Array.rand(this.m.BleedingSounds), ::Const.Sound.Volume.Skill, _user.getPos());
			}
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this && _targetEntity != null)
		{
			if (_targetEntity.getCurrentProperties().IsRooted)
			{
				_properties.MeleeSkill += 25;
				_properties.DamageDirectAdd += 0.1;
			}

			if (_targetEntity.getCurrentProperties().IsStunned)
			{
				_properties.DamageTotalMult *= 1.25;
				_properties.DamageDirectAdd += 0.1;
			}

			if (this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) == this.getMaxRange())
			{
				_properties.MeleeSkill -= 5;
			}
		}
	}

});

