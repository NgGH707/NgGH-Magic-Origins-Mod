this.manning_siege_weapon_skill <- this.inherit("scripts/skills/skill", {
	m = {
		SiegeWeapon = null,
		BorrowedSkills = []
	},

	function create()
	{
		this.m.ID = "actives.manning_siege_weapon";
		this.m.Name = "Manning Siege Weapon";
		this.m.Description = "Operating a siege weapon near you.";
		this.m.KilledString = "";
		this.m.Icon = "skills/active_maning_mortar.png";
		this.m.IconDisabled = "skills/active_maning_mortar_sw.png";
		this.m.Overlay = "active_maning_mortar";
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 4;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsTargetingActor = true;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1,
		this.m.MaxRange = 1,
		this.m.MaxLevelDifference = 2;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Manning a [color=" + this.Const.UI.Color.PositiveValue + "]Siege weapon[/color]"
			}
		]);

		return ret;
	}
	
	function hasSiegeWeaponNearby()
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return false;
		}

		local myTile = this.getContainer().getActor().getTile();
		local weapons = 0;

		for( local i = 0; i < 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = myTile.getNextTile(i);

				if (this.Math.abs(nextTile.Level - myTile.Level) <= 1 && nextTile.IsOccupiedByActor && (nextTile.getEntity().getType() == this.Const.EntityType.GreenskinCatapult || nextTile.getEntity().getType() == this.Const.EntityType.Mortar) && this.getContainer().getActor().isAlliedWith(nextTile.getEntity()))
				{
					weapons += 1;
				}
			}
		}

		return weapons != 0;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}
	
	function isHidden()
	{
		return !this.hasSiegeWeaponNearby() || this.skill.isHidden();
	}
	
	function onAfterUpdate( _properties )
	{
		local IsSpecialized = this.getContainer().hasSkill("background.legend_inventor");
		this.m.FatigueCostMult = IsSpecialized ? 0 : 1.0;
		this.m.ActionPointCost = IsSpecialized ? 0 : 1;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local _target = _targetTile.getEntity();

		if (_target.getFlags().has("siege_weapon"))
		{
			if (this.m.SiegeWeapon == null)
			{
				return true;
			}

			if (this.m.SiegeWeapon != null && _target.getID() != this.m.SiegeWeapon.getID())
			{
				return true;
			}
			
			return false;
		}

		return false;
	}

	function onUse( _user, _targetTile )
	{
		local _targetEntity = _targetTile.getEntity();
		this.getContainer().removeByID("effects.manning_siege_weapon");
		_targetEntity.assignUser(_user, this);

		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " is manning " + this.Const.UI.getColorizedEntityName(_targetEntity));
		}

		return true;
	}

	function clear()
	{
		if (this.m.BorrowedSkills.len() != 0)
		{
			foreach (i, skill in this.m.BorrowedSkills)
			{
			    skill.removeSelf();
			}
		}

		if (this.m.SiegeWeapon != null)
		{
			this.m.SiegeWeapon.m.User = null;
		}

		this.m.SiegeWeapon = null;
	}

	function onCombatStarted()
	{
		this.m.BorrowedSkills = [];
		this.m.SiegeWeapon = null;
	}

	function onCombatFinished()
	{
		this.m.SiegeWeapon = null;
	}

});

