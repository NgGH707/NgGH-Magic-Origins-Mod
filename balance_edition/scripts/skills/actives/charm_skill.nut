this.charm_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Slaves = []
	},
	function removeSlave( _entityID )
	{
		local i = this.m.Slaves.find(_entityID);

		if (i != null)
		{
			this.m.Slaves.remove(i);
		}

		if (this.m.Slaves.len() == 0 && this.isAlive())
		{
			this.getContainer().getActor().setCharming(false);
		}
	}

	function isAlive()
	{
		return this.getContainer() != null && !this.getContainer().isNull() && this.getContainer().getActor() != null && this.getContainer().getActor().isAlive() && this.getContainer().getActor().getHitpoints() > 0;
	}

	function create()
	{
		this.m.ID = "actives.charm";
		this.m.Name = "Charm";
		this.m.Description = "";
		this.m.Icon = "skills/active_120.png";
		this.m.IconDisabled = "skills/active_120.png";
		this.m.Overlay = "active_120";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_charm_kiss_01.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_02.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_03.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/hexe_charm_chimes_01.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_02.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_03.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 8;
		this.m.MaxLevelDifference = 4;
	}

	function isViableTarget( _user, _target )
	{
		if (_target.isAlliedWith(_user))
		{
			return false;
		}

		if (_target.getMoraleState() == this.Const.MoraleState.Ignore || _target.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return false;
		}

		if (_target.getCurrentProperties().MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0)
		{
			return false;
		}
		
		if (_target.getType() == this.Const.EntityType.Hexe || _target.getType() == this.Const.EntityType.LegendHexeLeader)
		{
			return false;
		}
		
		if (_target.isNonCombatant())
		{
			return false;
		}

		local skills = [
			"effects.fake_charmed_broken",
			"effects.charmed",
			"effects.charmed_captive",
			"effects.legend_intensely_charmed",
		];

		foreach ( id in skills ) 
		{
		    if (_target.getSkills().hasSkill(id))
		    {
		    	return false;
		    }
		}
		
		if (_target.getFlags().has("Hexe"))
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
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
		local time = this.Tactical.spawnProjectileEffect("effect_heart_01", _user.getTile(), _targetTile, 0.33, 2.0, false, false);
		local self = this;
		this.Time.scheduleEvent(this.TimeUnit.Virtual, time, function ( _e )
		{
			local bonus = _targetTile.getDistanceTo(_user.getTile()) == 1 ? -5 : 0;

			if (target.getSkills().hasSkill("background.eunuch") || target.getSkills().hasSkill("trait.player") || target.getSkills().hasSkill("trait.loyal"))
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " can not be charmed");
				}

				return false;
			}

			if (target.checkMorale(0, -35 + bonus, this.Const.MoraleCheckType.MentalAttack))
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his resolve");
				}

				return false;
			}

			if (target.checkMorale(0, -35 + bonus, this.Const.MoraleCheckType.MentalAttack))
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his resolve");
				}

				return false;
			}

			this.m.Slaves.push(target.getID());
			local charmed = this.new("scripts/skills/effects/charmed_effect");
			charmed.setMasterFaction(_user.getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : _user.getFaction());
			charmed.setMaster(self);
			target.getSkills().add(charmed);

			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " is charmed");
			}

			_user.setCharming(true);
		}.bindenv(this), this);
	}

	function onDeath()
	{
		foreach( id in this.m.Slaves )
		{
			local e = this.Tactical.getEntityByID(id);

			if (e != null)
			{
				e.getSkills().removeByID("effects.charmed");
			}
		}

		this.m.Slaves = [];
	}

	function onUpdate( _properties )
	{
		if (this.m.Slaves.len() == 0)
		{
			this.getContainer().getActor().setCharming(false);
		}
	}

});

