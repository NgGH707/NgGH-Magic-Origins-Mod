this.mc_curse_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2,
		Damage = 0,
		LastRoundApplied = 0,
		Actor = null
	},
	function getDamage()
	{
		return this.m.Damage;
	}

	function setDamage( _d )
	{
		if (this.m.Damage != 0)
		{
			_d = this.Math.max(1, this.Math.floor(_d * 0.5));
			this.addDamage(_d);
		}
		else 
		{
		    this.m.Damage = _d;
		}
	}

	function addDamage( _d )
	{
		this.m.Damage = this.Math.min(105, this.m.Damage + _d);
	}

	function setActor( _a )
	{
		this.m.Actor = typeof _a == "instance" ? _a.get() : _a;
	}

	function create()
	{
		this.m.ID = "effects.mc_curse";
		this.m.Name = "Cursed";
		this.m.KilledString = "Cursed to death";
		this.m.Icon = "skills/status_effect_84.png";
		this.m.IconMini = "status_effect_84_mini";
		this.m.Overlay = "status_effect_84";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_hex_damage_01.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_02.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_03.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_04.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DamageOverTime;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function getName()
	{
		return this.m.Name + " (" + this.getDamage() + " damage)";
	}

	function getDescription()
	{
		return "This character is cursed and lose [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Damage + "[/color] hitpoints each turn for [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] more turn(s).";
	}

	function getAttacker()
	{
		if (this.m.Actor == null)
		{
			return this.getContainer().getActor();
		}

		if (this.m.Actor != this.getContainer().getActor())
		{
			if (typeof this.m.Actor == "instance")
			{
				this.m.Actor = this.m.Actor.get();
			}

			if (!this.m.Actor.isAlive())
			{
				return this.getContainer().getActor();
			}

			if (this.m.Actor.isPlacedOnMap())
			{
				return this.getContainer().getActor();
			}

			if (this.m.Actor.getFlags().get("Devoured") == true)
			{
				return this.getContainer().getActor();
			}
		}

		return this.m.Actor;
	}

	function onRefresh()
	{
		this.m.TurnsLeft = this.Math.min(5, this.m.TurnsLeft + 1);
	}

	function applyDamage( _ignoreCount = false )
	{
		if (this.m.LastRoundApplied != this.Time.getRound() || _ignoreCount)
		{
			this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
			local hitInfo = clone this.Const.Tactical.HitInfo;
			local damage = this.Math.rand(this.Math.floor(this.m.Damage * 0.67), this.m.Damage);
			local mult = _ignoreCount ? 0.67 : 1.0;
			hitInfo.DamageRegular = damage * mult;
			hitInfo.DamageArmor = damage * mult;
			hitInfo.DamageDirect = this.Math.rand(10, 40) * 0.01;
			hitInfo.BodyPart = this.Math.rand(0, 1);
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			this.getContainer().getActor().onDamageReceived(this.getAttacker(), this, hitInfo);

			if (!_ignoreCount)
			{
				this.m.LastRoundApplied = this.Time.getRound();

				if (--this.m.TurnsLeft <= 0)
				{
					this.removeSelf();
				}
			}
		}
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 0.9;
	}

	function onTurnEnd()
	{
		this.applyDamage();
	}

	function onWaitTurn()
	{
		this.applyDamage();
	}

});

