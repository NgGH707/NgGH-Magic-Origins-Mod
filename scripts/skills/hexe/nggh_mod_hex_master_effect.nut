this.nggh_mod_hex_master_effect <- ::inherit("scripts/skills/skill", {
	m = {
		Count = 1,
		TurnsLeft = 1,
		LastRoundApplied = 0,
		Color = ::createColor("#ffffff"),
		HexType = ::Const.Hex.Type.Default,
		IsShareThePainActive = false,
		IsActivated = false,
		
		AdditionalTooltips = [],
		Slave = [],
	},
	function activate()
	{
		this.m.IsActivated = true;

		foreach (s in this.m.Slave)
		{
			if (s == null || s.isNull())
			{
				continue;
			}

			s.activate();
		}
	}
	
	function addCount()
	{
		++this.m.Count;
	}

	function addSlave( _s )
	{
		if (_s == null)
		{
			return;
		}

		local slave = typeof _s == "instance" ? _s : ::WeakTableRef(_s);
		slave.setColor(this.m.Color);
		slave.setMaster(this);
		this.m.Slave.push(slave);
	}

	function removeSlave( _s )
	{
		local find;

		foreach (i, s in this.m.Slave)
		{
			if (s == null || s.isNull())
			{
				continue;
			}

			if (s.get() == _s)
			{
				find = i;
				break;
			}
		}

		if (find != null)
		{
			this.m.Slave.remove(find);
		}

		if (!this.checkHex())
		{
			this.removeSelf();
		}
	}

	function removeAllSlaves( _update = true )
	{
		foreach (i, s in this.m.Slave)
		{
			if (s == null || s.isNull())
			{
				continue;
			}

			s.setMaster(null);
			s.getContainer().removeByID(s.getID());
		}

		this.m.Slave = [];

		if (_update)
		{
			this.removeSelf();
		}
	}

	function getSlave()
	{
		return this.m.Slave;
	}

	function setColor( _c )
	{
		this.m.Color = _c;
	}

	function isShareThePainActive()
	{
		return this.m.IsShareThePainActive;
	}

	function isAlive()
	{
		return this.getContainer() != null && !this.getContainer().isNull() && this.getContainer().getActor() != null && this.getContainer().getActor().isAlive() && this.getContainer().getActor().getHitpoints() > 0;
	}

	function create()
	{
		this.m.ID = "effects.hex_master";
		this.m.Name = "Protected by a Hex";
		this.m.Icon = "skills/status_effect_84.png";
		this.m.IconMini = "status_effect_84_mini";
		this.m.SoundOnUse = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsHidden = false;
	}
	
	function onAdded()
	{
		this.m.LastRoundApplied = ::Time.getRound();
	}
	
	function getDescription()
	{
		return "This character is under the protection of a hex. All attacks will be redirected to the cursed victim, regardless of distance. This hex will wear off next turn.";
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
			{
				id = 3,
				type = "text",
				icon = "ui/icons/sturdiness.png",
				text = "Can redirect [color=" + ::Const.UI.Color.PositiveValue + "]" + this.m.Count + "[/color] attack(s)"
			}
		];

		foreach (i, tooltip in this.m.AdditionalTooltips)
		{
			tooltip.id = 4 + i;
			ret.push(tooltip);
		}
		
		return ret;
	}

	function resetTime()
	{
		this.m.TurnsLeft = 1;
	}

	function checkHex()
	{
		if (this.m.Slave.len() == 0)
		{
			return false;
		}	

		local new = [];

		foreach( s in this.m.Slave )
		{
			if (s == null || s.isNull())
			{
				continue;
			}

			new.push(s);
		}

		this.m.Slave = new;
		return this.m.Slave.len() != 0;
	}
	
	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (!this.m.IsActivated || !this.checkHex())
		{
			this.removeSelf();
			return;
		}

		if (_hitInfo != null && (_hitInfo.DamageRegular != 0 || _hitInfo.DamageArmor != 0))
		{
			this.applyDamageToSlave(_hitInfo, null, --this.m.Count == 0);
		}
		
		_properties.DamageReceivedTotalMult = 0.0;
		_properties.FatigueReceivedPerHitMult = 0.0;

		/*
		_properties.IsImmuneToDaze = true;
		_properties.IsImmuneToStun = true;
		_properties.IsImmuneToDisarm = true;
		_properties.IsImmuneToBleeding = true;
		_properties.IsImmuneToPoison = true;
		*/

		if (!this.checkHex() || this.m.Count == 0)
		{
			this.removeSelf();
		}
	}

	function applyDamageToSlave( _hitInfo, _attacker = null , _remove = false , _exclude = null, _isHex = false)
	{
		if (_attacker == null)
		{
			_attacker = this.getContainer().getActor();
		}

		if (_exclude == null)
		{
			_exclude = [];
		}

		foreach( s in this.m.Slave )
		{
			if (s == null || s.isNull())
			{
				continue;
			}

			if (_exclude.find(s.getContainer().getActor().getID()) != null)
			{
				continue;
			}

			if (_isHex)
			{
				s.m.IsHitByHex = true;
			}

			s.applyDamage(_hitInfo, _attacker, _remove);
		}
	}

	function onUpdate( _properties )
	{
		if (this.m.IsActivated && !this.checkHex())
		{
			this.removeSelf();
		}
		else
		{
			_properties.TargetAttractionMult *= 0.75;
			local actor = this.getContainer().getActor();
			actor.getSprite("status_hex").setBrush("bust_hex_sw");
			actor.getSprite("status_hex").Color = this.m.Color;
			actor.getSprite("status_hex").Visible = true;
			actor.setDirty(true);
		}
	}

	function onDeath( _fatalityType )
	{
		this.onRemoved();
	}

	function onCombatFinished()
	{
		this.onRemoved();
		this.skill.onCombatFinished();
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.getSprite("status_hex").Visible = false;
		actor.getSprite("status_hex").Color = ::createColor("#ffffff");
		actor.setDirty(true);

		foreach( s in this.m.Slave )
		{
			if (s != null && !s.isNull() && !s.getContainer().isNull())
			{
				s.setMaster(null);
				s.removeSelf();

				//s.getContainer().update();
			}
		}

		if (this.m.HexType == ::Const.Hex.Type.Suffering)
		{
			this.getContainer().setRedirect(false);
		}

		this.m.Slave = [];
	}

	function onTurnStart()
	{
		if (--this.m.TurnsLeft <= 0 && this.m.LastRoundApplied != ::Time.getRound())
		{
			this.removeSelf();
		}
	}

});

