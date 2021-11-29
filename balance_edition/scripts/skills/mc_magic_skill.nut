this.mc_magic_skill <- this.inherit("scripts/skills/skill", {
	m = {
		IsUtility = false,
		IsEnhanced = false,
		IsConsumeConcentrate = true,
		IsShotStraight = false,
		IsIgnoreBlockTarget = false,
		IsOnlyInCalculation = false,
	},
	function create()
	{
		this.m.MaxRangeBonus = 2;
		this.m.MaxLevelDifference = 4;
	}

	/*function getDescription()
	{
		ret = this.skill.getDescription();

		if (this.m.IsUtility)
		{
			ret += " Effect based on resolve, lose effectiveness if you don\'t have a magic staff.";
		}

		if (this.m.IsAttack)
		{
			if (this.m.IsRanged)
			{
				ret += " Accuracy based on ranged skill.";
			}
			else 
			{
			    ret += " Accuracy based on melee skill.";
			}

			ret += " Damage based on resolve, deal reduced damage if you don\'t have a magic staff.";
		}

		return ret;
	}*/

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInMC_Magic ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function hasStaff()
	{
		local actor = this.getContainer().getActor();
		local staff = actor.getMainhandItem();

		if (staff == null || !staff.isWeaponType(this.Const.Items.WeaponType.MagicStaff))
		{
			return false;
		}

		return true;
	}

	function getMagicPower( _properties )
	{
		local ret = _properties.getBravery() + _properties.MoraleCheckBravery[this.Const.MoraleCheckType.MentalAttack];
		if (_properties.IsHasMagicTraining) ret = this.Math.floor(ret * 1.1);
		return  ret;
	}

	function getBonusDamageFromResolve( _properties , _ignoreStaff = false )
	{
		local resolve = this.getMagicPower(_properties);
		local fraction = resolve / 60.0;
		local bonus = this.Math.floor(fraction * 100) * 0.01;
		local mult = 1.0;

		if (!_ignoreStaff)
		{
			local actor = this.getContainer().getActor();
			local staff = actor.getMainhandItem();

			if (staff == null || !staff.isWeaponType(this.Const.Items.WeaponType.MagicStaff))
			{
				mult = _properties.IsSpecializedInMC_Magic ? this.Const.MC_Combat.NoStaffWithMasteryDamageMult : this.Const.MC_Combat.NoStaffDamageMult;
			}
		}

		if (bonus > 1)
		{
			return this.Math.pow(bonus, 0.5) * mult;
		}

		return 1.0 * mult;
	}

	function removeBonusesFromWeapon( _properties )
	{
		local actor = this.getContainer().getActor();
		local main = actor.getMainhandItem();
		local off = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

		if (main != null)
		{
			_properties.DamageRegularMin -= main.m.RegularDamage;
			_properties.DamageRegularMax -= main.m.RegularDamageMax;
			_properties.DamageArmorMult /= main.m.ArmorDamageMult;
			_properties.DamageDirectAdd -= main.m.DirectDamageAdd;

			if (off == null && main.isDoubleGrippable())
			{
				_properties.MeleeDamageMult /= 1.25;
			}
		}

		/*if (this.m.IsOnlyInCalculation && this.m.IsRanged && this.m.IsIgnoreBlockTarget && this.m.IsShowingProjectile)
		{
			_properties.RangedSkill += 15;
			_properties.DamageTotalMult /= 0.75;
		}*/

		if (this.m.IsIgnoreBlockTarget)
		{
			_properties.RangedAttackBlockedChanceMult = 0.0;
		}
	}

	function use( _targetTile, _forFree = false )
	{
		local ret = this.skill.use(_targetTile, _forFree);
		//if (this.m.IsConsumeConcentrate) this.getContainer().removeByID("special.mc_focus");
		return ret;
	}

	function onBeforeUse( _user, _targetTile )
	{
		return;

		if (this.getContainer().hasSkill("special.mc_focus"))
		{
			this.m.IsEnhanced = true;
		}
	}
	
	/*function attackEntity( _user, _targetEntity, _allowDiversion = true )
	{	
		this.m.IsOnlyInCalculation = true;

		if (this.m.IsIgnoreBlockTarget)
		{
			_allowDiversion = false;
		}

		if (this.m.IsRanged && this.m.IsShotStraight && userTile.getDistanceTo(_targetEntity.getTile()) > 1)
		{
			local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(_user.getTile(), _targetEntity.getTile(), _user.getFaction());

			if (blockedTiles.len() != 0)
			{
				_allowDiversion = false;
				_targetEntity = blockedTiles[this.Math.rand(0, blockedTiles.len() - 1)].getEntity();
			}
		}

		local ret = this.skill.attackEntity(_user, _targetEntity, _allowDiversion);
		this.m.IsOnlyInCalculation = false;
		return ret;
	}*/

	function getCursorForTile( _tile )
	{
		if (this.m.IsUtility)
		{
			return this.Const.UI.Cursor.Give;
		}

		return this.Const.UI.Cursor.Attack;
	}
	
	function onTargetSelected( _targetTile )
	{
		if (!this.m.IsIgnoreBlockTarget)
		{
			this.skill.onTargetSelected(_targetTile);
		}
	}
	
});

