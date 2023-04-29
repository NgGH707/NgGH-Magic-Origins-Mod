this.nggh_mod_hex_slave_effect <- ::inherit("scripts/skills/skill", {
	m = {
		Master = null,
		IsActivated = false,
		AdditionalTooltips = [],
		Color = ::createColor("#ffffff"),
		HexType = ::Const.Hex.Type.Default,
		IsHitByHex = false,

		IsSpent = false,
	},
	function activate()
	{
		this.m.IsActivated = true;
	}

	function setMaster( _p )
	{
		if (_p == null)
		{
			this.m.Master = null;
		}
		else if (typeof _p == "instance")
		{
			this.m.Master = _p;
		}
		else
		{
			this.m.Master = ::WeakTableRef(_p);
		}
	}

	function setColor( _c )
	{
		this.m.Color = _c;
	}

	function isShareThePainActive()
	{
		return this.m.Master != null && !this.m.Master.isNull() && this.m.Master.isShareThePainActive();
	}

	function isAlive()
	{
		return this.getContainer() != null && !this.getContainer().isNull() && this.getContainer().getActor() != null && this.getContainer().getActor().isAlive() && this.getContainer().getActor().getHitpoints() > 0;
	}

	function create()
	{
		this.m.ID = "effects.hex_slave";
		this.m.Name = "Hex";
		this.m.KilledString = "Died from a hex";
		this.m.Icon = "skills/status_effect_84.png";
		this.m.IconMini = "status_effect_84_mini";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_hex_damage_01.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_02.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_03.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_04.wav"
		];
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "This character has been cursed to feel the pain and receive all the wounds on behalf of someone. Be careful, as it could kill him. The effect will persist for another [color=" + ::Const.UI.Color.NegativeValue + "]1[/color] turn(s).";
	}

	function getTooltip()
	{
		local ret = [
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
		];

		foreach (i, tooltip in this.m.AdditionalTooltips)
		{
			tooltip.id = 3 + i;
			ret.push(tooltip);
		}
		
		return ret;
	}

	function applyDamage( _hitInfo, _attacker , _remove = false )
	{	
		if (this.m.SoundOnUse.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.25, this.getContainer().getActor().getPos());
		}

		local hitInfo = clone _hitInfo;
		this.getContainer().getActor().onDamageReceived(_attacker, this, hitInfo);
		
		if (_remove)
		{
			this.removeSelf();
		}
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (this.m.IsHitByHex)
		{
			this.m.IsHitByHex = false;
			return;
		}

		if (_damageHitpoints <= 0) return;

		if (!this.isShareThePainActive() || this.m.IsSpent) return;

		local hitInfo = clone ::Const.Tactical.HitInfo;
		hitInfo.DamageRegular = _damageHitpoints;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = ::Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;

		this.m.Master.applyDamageToSlave(hitInfo, null, false, [this.getContainer().getActor().getID()], true);
		this.m.IsHitByHex = false;
		this.m.IsSpent = true;
		
		if (!this.m.Master.checkHex())
		{
			this.m.Master.removeSelf();
		}
	}

	function onNewRound()
	{
		this.m.IsSpent = false;
	}

	function onDeath( _fatalityType )
	{
		this.onRemoved();
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		if (actor.hasSprite("status_hex"))
		{
			actor.getSprite("status_hex").Visible = false;
			actor.getSprite("status_hex").Color = this.createColor("#ffffff");
		}

		actor.setDirty(true);

		if (this.m.Master != null && !this.m.Master.isNull() && !this.m.Master.getContainer().isNull())
		{
			this.m.Master.removeSlave(this);
			this.m.Master = null;
			//master.getContainer().update();
		}
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();

		if (this.m.IsActivated && (this.m.Master == null || this.m.Master.isNull() || !this.m.Master.isAlive()))
		{
			this.removeSelf();
		}
		else if (actor.hasSprite("status_hex"))
		{
			local hex = actor.getSprite("status_hex");

			if (!hex.Visible)
			{
				hex.setBrush("bust_hex_sw");
				hex.Color = this.m.Color;
				hex.Alpha = 0;
				hex.Visible = true;
				hex.fadeIn(700);
				actor.setDirty(true);
			}

			switch(this.m.HexType)
			{
			case ::Const.Hex.Type.Default:
			case ::Const.Hex.Type.Suffering:
				return;

			case ::Const.Hex.Type.Weakening:
				_properties.DamageTotalMult *= 0.60;
				_properties.StaminaMult *= 0.67;
				_properties.FatigueRecoveryRate -= 5;
				break;

			case ::Const.Hex.Type.Vulnerability:
				_properties.DamageReceivedTotalMult *= 1.15;
				_properties.InitiativeMult *= 0.75;
				break;

			case ::Const.Hex.Type.Misfortune:
				_properties.TotalAttackToHitMult *= 0.88;
				_properties.TotalDefenseToHitMult *= 0.9;
			}
		}
	}

});

