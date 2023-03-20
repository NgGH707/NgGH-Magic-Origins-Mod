this.nggh_mod_hex_spell <- ::inherit("scripts/skills/skill", {
	m = {
		Cooldown = 0,
		PerkIDsToQuery = [],
		AdditionalTooltips = [],
		HasFixedColor = false,
		LastTarget = null,
		Color = null,
	},
	function create()
	{
		this.m.ID = "spells.hex";
		this.m.Name = "Hex";
		this.m.Description = "Curse a target with a hex that can redirect any bodily harm to the caster to that target.";
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
		this.m.PerkIDsToQuery.extend(::Const.Hex.PerksToQuery);
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 2;
		this.m.IsSerialized = false;
		this.m.Delay = 500;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 12;
		this.m.MinRange = 1;
		this.m.MaxRange = 8;
		this.m.MaxLevelDifference = 4;
		this.m.MaxRangeBonus = 0;
	}

	function onAdded()
	{
		foreach( id in ::Const.Hex.UniquePerksToQuery )
		{
			local perk = this.getContainer().getSkillByID(id);

			if (perk != null && !::isKindOf(perk, "perk_nggh_locked"))
			{
				perk.onUpgradeHex(this);
			}
		}
	}

	function onResetHex()
	{
		this.m.Name = "Hex";
		this.m.Icon = "skills/active_119.png";
		this.m.Overlay = "active_119";
		this.m.AdditionalTooltips = [];
		this.m.PerkIDsToQuery = [];
		this.m.PerkIDsToQuery.extend(::Const.Hex.PerksToQuery);
		this.m.HasFixedColor = false;
		this.m.Color = null;
	}
	
	function getTooltip()
	{
		if (this.getContainer() == null || this.getContainer().getActor() == null)
		{
			return this.skill.getTooltip();
		}

		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 3,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Redirects attacks[/color] to [color=" + ::Const.UI.Color.PositiveValue + "]Hexed Target[/color]"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can be used to remove [color=" + ::Const.UI.Color.NegativeValue + "]Hex[/color] effect from an ally"
			}
		]);

		foreach (i, tooltip in this.m.AdditionalTooltips)
		{
			tooltip.id = 5 + i;
			ret.push(tooltip);
		}
		
		if (this.m.Cooldown != 0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can be used again after " + this.m.Cooldown + " turn(s)[/color]"
			});
		}

		return ret;
	}
	
	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInHex ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;

		if (_properties.IsSpecializedInHex && this.getContainer().hasSkill("effects.hex_master"))
		{
			this.m.ActionPointCost -= 1;
		}
	}

	function isUsable()
	{
		return this.m.Cooldown == 0 && this.skill.isUsable();
	}

	function isViableTarget( _user, _target )
	{
		if (_target.getType() == ::Const.EntityType.Hexe || _target.getType() == ::Const.EntityType.LegendHexeLeader)
		{
			return false;
		}

		if (_target.getCurrentProperties().IsImmuneToDamageReflection)
		{
			return false;
		}
		
		if (_target.getSkills().hasSkill("effects.charmed_captive"))
		{
			return false;
		}

		return true;
	}

	function onTurnStart()
	{
		this.m.Cooldown = ::Math.max(0, this.m.Cooldown - 1);
	}

	function onUse( _user, _targetTile )
	{
		if (!this.isViableTarget(_user, _targetTile.getEntity()))
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " fails to hex " + ::Const.UI.getColorizedEntityName(_targetTile.getEntity()));
			return false;
		}
		
		/*
		if (this.m.LastTarget != null && !this.m.LastTarget.isNull() && (!this.m.LastTarget.isAlive() || this.m.LastTarget.isDying() || !this.m.LastTarget.getSkills().hasSkill("effects.hex_slave")))
		{
			this.m.LastTarget = null;
		}
		*/
		
		::Time.scheduleEvent(::TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), {
			User = _user,
			TargetTile = _targetTile
		});
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local target = _targetTile.getEntity();

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " hex " + ::Const.UI.getColorizedEntityName(target));

			if (this.m.SoundOnHit.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), ::Const.Sound.Volume.Skill * 1.0, _user.getPos());
			}
		}

		::Time.scheduleEvent(::TimeUnit.Virtual, 800, function ( _tag )
		{
			if (this.m.Color == null)
			{
				do
				{
					this.m.Color = ::createColor("#ff0000");
					this.m.Color.varyRGB(0.75, 0.75, 0.75);
				}
				while (this.m.Color.R + this.m.Color.G + this.m.Color.B <= 150);
			}
			
			if (target.isAlliedWith(_user))
			{
				target.getSkills().removeByID("effects.hex_slave");
				this.spawnHexEffect(target);
				return;
			}

			local slave = ::new("scripts/skills/hexe/nggh_mod_hex_slave_effect");
			local master = _user.getSkills().getSkillByID("effects.hex_master");
			local perks = this.queryHexPerks();
			
			if (master != null)
			{
				master.resetTime();
				master.addCount();
			}
			else
			{
				master = ::new("scripts/skills/hexe/nggh_mod_hex_master_effect");
			}

			this.onRemoveLastTarget();
			this.onHex(target, master, slave);

			foreach(perk in perks)
			{
				perk.onHex(target, master, slave);
			}

			this.spawnHexEffect(target);

			foreach(perk in perks)
			{
				perk.onAfterHex(target, master, slave);
			}

			this.onAfterHex(target, master, slave);

			if (!this.m.HasFixedColor)
			{
				this.m.Color = null;
			}

		}.bindenv(this), null);
	}

	function queryHexPerks()
	{
		local ret = [];

		foreach( id in this.m.PerkIDsToQuery )
		{
			//::logInfo("PerkIDsToQuery, check id:" + id);
			local perk = this.getContainer().getSkillByID(id);

			if (perk != null)
			{
				//::logInfo("PerkIDsToQuery, valid id:" + perk.getID());
				ret.push(perk);
			}
		}

		return ret;
	}

	function onRemoveLastTarget()
	{
		/*
		if (this.m.LastTarget != null && !this.m.LastTarget.isNull() && this.m.LastTarget.isAlive() && !this.m.LastTarget.isDying())
		{
			local h = this.m.LastTarget.getSkills().getSkillByID("effects.hex_slave");

			if (h != null)
			{
				h.setMaster(null);
			}
			
			this.m.LastTarget.getSkills().removeByID("effects.hex_slave");
		}

		this.m.LastTarget = null;
		*/

		local h = this.getContainer().getSkillByID("effects.hex_master");

		if (h != null)
		{
			h.removeAllSlaves(false);
		}
	}

	function onHex( _targetEntity, _masterHex, _slaveHex )
	{
		_masterHex.setColor(this.m.Color);
		_masterHex.addSlave(_slaveHex);
	}

	function onAfterHex( _targetEntity, _masterHex, _slaveHex )
	{
		if (_masterHex.getContainer() == null || _masterHex.getContainer().isNull())
		{
			this.getContainer().add(_masterHex);
		}

		_targetEntity.getSkills().add(_slaveHex);
		_masterHex.activate();

		//this.m.LastTarget = ::WeakTableRef(_targetEntity);
	}

	function spawnHexEffect( _targetEntity )
	{
		::Tactical.spawnSpriteEffect("effect_pentagram_02", this.m.Color, _targetEntity.getTile(), !_targetEntity.getSprite("status_hex").isFlippedHorizontally() ? 10 : -5, 88, 3.0, 1.0, 0, 400, 300);
	}
	
	function getHitchance( _targetEntity )
	{
		if (!this.isViableTarget(this.getContainer().getActor(), _targetEntity))
		{
			return 0;
		}

		return 100;
	}
	
	function onCombatStarted()
	{
		this.m.Cooldown = 0;
		this.m.LastTarget = null;
	}

	function onTargetSelected( _targetTile ) {}

});

