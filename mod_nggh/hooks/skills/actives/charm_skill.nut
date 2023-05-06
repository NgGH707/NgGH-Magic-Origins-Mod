::mods_hookExactClass("skills/actives/charm_skill", function ( obj )
{
	/*local ws_create = obj.create;
	obj.create = function()
	{
		this.m.IsMagicSkill = true;
		this.m.MagicPointsCost = 5;
		ws_create();
	}
	*/
	obj.isViableTarget = function( _user, _target )
	{
		if (_target.isAlliedWith(_user))
		{
			return false;
		}

		if (_target.getMoraleState() == ::Const.MoraleState.Ignore || _target.getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			return false;
		}

		if (_target.getCurrentProperties().MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0)
		{
			return false;
		}

		/*
		if (_target.getCurrentProperties().IsImmuneToMagic)
		{
			return false;
		}
		*/
		
		if (_target.getType() == ::Const.EntityType.Hexe || _target.getType() == ::Const.EntityType.LegendHexeLeader)
		{
			return false;
		}

		if (_target.getFlags().has("Hexe"))
		{
			return false;
		}
		
		if (_target.isNonCombatant())
		{
			return false;
		}

		local simp = _target.getSkills().getSkillByID("effects.simp");

	    if (simp != null && simp.getSimpLevel() == 0 && simp.isMutiny())
		{
			return false;
		}

		local skills = [
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

		return true;
	};
	obj.onDelayedEffect = function( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local target = _targetTile.getEntity();
		local time = ::Tactical.spawnProjectileEffect("effect_heart_01", _user.getTile(), _targetTile, 0.33, 2.0, false, false);
		local self = this;
		::Time.scheduleEvent(::TimeUnit.Virtual, time, function ( _e )
		{
			local bonus = _targetTile.getDistanceTo(_user.getTile()) == 1 ? -5 : 0;

			if (!this.isViableTarget(_user, target) || target.getSkills().hasSkill("background.eunuch") || target.getSkills().hasSkill("trait.player") || target.getSkills().hasSkill("trait.loyal"))
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " can not be charmed");
				}

				return false;
			}

			if (target.getCurrentProperties().IsResistantToAnyStatuses && ::Math.rand(1, 100) <= 50)
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his unnatural physiology");
				}

				return false;
			}

			/*
			if (target.getCurrentProperties().IsResistantToMagic && ::Math.rand(1, 100) <= 50)
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his magic resistance");
				}

				return false;
			}
			*/

			if (target.checkMorale(0, -35 + bonus, ::Const.MoraleCheckType.MentalAttack))
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his resolve");
				}

				return false;
			}

			if (target.checkMorale(0, -35 + bonus, ::Const.MoraleCheckType.MentalAttack))
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his resolve");
				}

				return false;
			}

			this.m.Slaves.push(target.getID());
			local charmed = ::new("scripts/skills/effects/charmed_effect");
			charmed.setMasterFaction(_user.getFaction() == ::Const.Faction.Player ? ::Const.Faction.PlayerAnimals : _user.getFaction());
			charmed.setMaster(self);
			target.getSkills().add(charmed);

			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " is charmed");
			}

			_user.setCharming(true);
		}.bindenv(this), this);
	};
});