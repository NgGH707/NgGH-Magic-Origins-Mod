this.mod_kraken_bite_skill <- this.inherit("scripts/skills/skill", {
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
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
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
			this.Tactical.addResource(r);
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
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts additional [color=" + this.Const.UI.Color.DamageValue + "]" + (specialized ? 10 : 5) + "[/color] bleeding damage over time if not stopped by armor"
			}
		]);

		return ret;
	}

	function isHidden()
	{
		return this.getContainer().getActor().getMode() != 1;
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
			_properties.DamageRegularMin += 5;
			_properties.DamageRegularMax += 12;
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
			if (!target.getCurrentProperties().IsImmuneToBleeding && hp - target.getHitpoints() >= this.Const.Combat.MinDamageToApplyBleeding)
			{
				local effect = this.new("scripts/skills/effects/bleeding_effect");

				if (_user.getFaction() == this.Const.Faction.Player)
				{
					effect.setActor(this.getContainer().getActor());
				}

				if (_user.getCurrentProperties().IsSpecializedInCleavers)
				{
					effect.setDamage(effect.getDamage() + 5);
				}

				target.getSkills().add(effect);
				this.Sound.play(this.m.BleedingSounds[this.Math.rand(0, this.m.BleedingSounds.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
			}
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			if (_targetEntity != null && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) == this.m.MaxRange)
			{
				_properties.MeleeSkill -= 10;
			}
		}
	}

});

