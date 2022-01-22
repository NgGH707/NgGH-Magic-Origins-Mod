this.hex_spell <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		Cooldown = 0,
		LastTarget = null,
	},
	function create()
	{
		this.mc_magic_skill.create();
		this.m.ID = "spells.hex";
		this.m.Name = "Hex";
		this.m.Description = "Curse a target with a hex that can redirect any attack to the poor cursed vitim";
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
		this.m.Order = this.Const.SkillOrder.UtilityTargeted + 2;
		this.m.IsSerialized = false;
		this.m.Delay = 500;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsIgnoreBlockTarget = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 8;
		this.m.MaxLevelDifference = 4;
		this.m.MaxRangeBonus = 0;
	}

	function getDescription()
	{
		return this.skill.getDescription();
	}
	
	function getTooltip()
	{
		if (this.getContainer() == null || this.getContainer().getActor() == null)
		{
			return this.skill.getTooltip();
		}

		local ret = this.skill.getDefaultUtilityTooltip();
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Curses[/color] a target"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Redirect attacks[/color] to [color=" + this.Const.UI.Color.PositiveValue + "]Cursed Target[/color]"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can be used to remove [color=" + this.Const.UI.Color.PositiveValue + "]Hex[/color]"
			}
		]);
		
		if (this.m.Cooldown != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can be used again after " + this.m.Cooldown + " turns[/color]"
			});
		}

		return ret;
	}
	
	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor().getSkills();
		
		if (actor.hasSkill("perk.fortified_mind"))
		{
			this.m.FatigueCostMult = this.Const.Combat.WeaponSpecFatigueMult;
		}
	}

	function isUsable()
	{
		return this.m.Cooldown == 0 && this.skill.isUsable();
	}

	function isViableTarget( _user, _target )
	{
		if (_target.getCurrentProperties().IsImmuneToDamageReflection)
		{
			return false;
		}
		
		if (_target.getSkills().hasSkill("effects.charmed_captive"))
		{
			return false;
		}
		
		if (_target.getType() == this.Const.EntityType.Hexe)
		{
			return false;
		}

		return true;
	}

	function onTurnStart()
	{
		this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
	}

	function onUse( _user, _targetTile )
	{
		if (!this.isViableTarget(_user, _targetTile.getEntity()))
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " fails to hexe " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()));
			return false;
		}
		
		if (this.m.LastTarget != null)
		{
			if (!this.m.LastTarget.isAlive() || !this.m.LastTarget.getSkills().hasSkill("effects.hex_slave"))
			{
				this.m.LastTarget = null;
			}
		}
		
		local tag = {
			User = _user,
			TargetTile = _targetTile
		};
		
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local target = _targetTile.getEntity();

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " hexes " + this.Const.UI.getColorizedEntityName(target));

			if (this.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, _user.getPos());
			}
		}

		this.Time.scheduleEvent(this.TimeUnit.Virtual, 800, function ( _tag )
		{
			local color;

			do
			{
				color = this.createColor("#ff0000");
				color.varyRGB(0.75, 0.75, 0.75);
			}
			while (color.R + color.G + color.B <= 150);

			this.Tactical.spawnSpriteEffect("effect_pentagram_02", color, _targetTile, !target.getSprite("status_hex").isFlippedHorizontally() ? 10 : -5, 88, 3.0, 1.0, 0, 400, 300);
			
			if (target.isAlliedWith(_user))
			{
				target.getSkills().removeByID("effects.hex_slave");
				target.getSkills().update();
				return;
			}

			local slave = this.new("scripts/skills/spell_hexe/w_hex_slave_effect");
			local master = _user.getSkills().getSkillByID("effects.hex_master");
			
			if (this.m.LastTarget != null && this.m.LastTarget.isAlive())
			{
				if (this.m.LastTarget.getSkills().hasSkill("effects.hex_slave"))
				{
					this.m.LastTarget.getSkills().getSkillByID("effects.hex_slave").setMaster(null);
				}
				
				this.m.LastTarget.getSkills().removeByID("effects.hex_slave");
				this.m.LastTarget.getSkills().update();
			}
			
			this.m.LastTarget = target;
			
			if (master != null)
			{
				master.setSlave(slave);
				master.setColor(color);
				master.resetTime();
				master.addCount();
				master.activate();
				slave.setMaster(master);
				slave.setColor(color);
				target.getSkills().add(slave);
				slave.activate();
			}
			else
			{
				master = this.new("scripts/skills/spell_hexe/w_hex_master_effect");
				master.setSlave(slave);
				master.setColor(color);
				_user.getSkills().add(master);
				master.activate();
				slave.setMaster(master);
				slave.setColor(color);
				target.getSkills().add(slave);
				slave.activate();
			}
			
		}.bindenv(this), null);
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

});

