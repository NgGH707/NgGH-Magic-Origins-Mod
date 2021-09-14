this.getroottable().HexenHooks.hookCharacterProperties <- function ()
{
	local gt = this.getroottable();
	gt.Const.CharacterProperties.IsHasMagicTraining <- false;
	gt.Const.CharacterProperties.IsSpecializedInMC_Magic <- false;
	gt.Const.CharacterProperties.getDamRedMod <- function( _isRanged = false )
	{
		local a = "DamageReceivedMeleeMult";

		if (_isRanged)
		{
			a = "DamageReceivedRangedMult";
		}

		local ret = 1.0;
		local mod = [
			"DamageReceivedRegularMult",
			"DamageReceivedDirectMult",
			"DamageReceivedTotalMult",
		];
		mod.push(a);

		foreach (i, string in mod ) 
		{
			if (this.rawin(string))
			{
		 		ret *= this.getMult(this.rawget(string));
		 	}
		}
		
		return ret;
	};
	gt.Const.CharacterProperties.getMult <- function( _mult )
	{
		return _mult >= 0 ? _mult : 1.0 / _mult;
	};
	gt.Const.HexenOrigin.CharacterProperties <- clone this.Const.CharacterProperties;
	gt.Const.HexenOrigin.CharacterProperties.setValues = function( _t )
	{
		this.ActionPoints = _t.ActionPoints;
		this.Hitpoints = _t.Hitpoints;
		this.Bravery = _t.Bravery;
		this.Stamina = _t.Stamina;
		this.MeleeSkill = _t.MeleeSkill;
		this.RangedSkill = _t.RangedSkill;
		this.MeleeDefense = _t.MeleeDefense;
		this.RangedDefense = _t.RangedDefense;
		this.Initiative = _t.Initiative;
		this.Armor[0] = _t.Armor[0];
		this.Armor[1] = _t.Armor[1];
		this.ArmorMax = clone _t.Armor;

		if (_t.rawin("ArmorMax"))
		{
			this.ArmorMax = clone _t.ArmorMax;
		}

		if (_t.rawin("FatigueRecoveryRate"))
		{
			this.FatigueRecoveryRate = _t.FatigueRecoveryRate;
		}

		if (_t.rawin("MoraleEffectMult"))
		{
			this.MoraleEffectMult = _t.MoraleEffectMult;
		}

		if (_t.rawin("FatigueEffectMult"))
		{
			this.FatigueEffectMult = _t.FatigueEffectMult;
		}

		if (_t.rawin("Vision"))
		{
			this.Vision = _t.Vision;
		}

		if (_t.rawin("DamageRegularMin"))
		{
			this.DamageRegularMin = _t.DamageRegularMin;
		}

		if (_t.rawin("DamageRegularMax"))
		{
			this.DamageRegularMax = _t.DamageRegularMax;
		}

		if (_t.rawin("DamageRegularMult"))
		{
			this.DamageRegularMult = _t.DamageRegularMult;
		}

		if (_t.rawin("DamageArmorMult"))
		{
			this.DamageArmorMult = _t.DamageArmorMult;
		}

		if (_t.rawin("DamageTotalMult"))
		{
			this.DamageTotalMult = _t.DamageTotalMult;
		}

		if (_t.rawin("MeleeDamageMult"))
		{
			this.MeleeDamageMult = _t.MeleeDamageMult;
		}

		if (_t.rawin("RangedDamageMult"))
		{
			this.RangedDamageMult = _t.RangedDamageMult;
		}

		if (_t.rawin("DamageDirectAdd"))
		{
			this.DamageDirectAdd = _t.DamageDirectAdd;
		}

		if (_t.rawin("DamageDirectMult"))
		{
			this.DamageDirectMult = _t.DamageDirectMult;
		}

		if (_t.rawin("IsAffectedByNight"))
		{
			this.IsAffectedByNight = _t.IsAffectedByNight;
		}

		if (_t.rawin("IsAffectedByRain"))
		{
			this.IsAffectedByRain = _t.IsAffectedByRain;
		}

		if (_t.rawin("IsAffectedByInjuries"))
		{
			this.IsAffectedByInjuries = _t.IsAffectedByInjuries;
		}

		if (_t.rawin("IsAffectedByFreshInjuries"))
		{
			this.IsAffectedByFreshInjuries = _t.IsAffectedByFreshInjuries;
		}

		if (_t.rawin("IsAffectedByFleeingAllies"))
		{
			this.IsAffectedByFleeingAllies = _t.IsAffectedByFleeingAllies;
		}

		if (_t.rawin("IsAffectedByDyingAllies"))
		{
			this.IsAffectedByDyingAllies = _t.IsAffectedByDyingAllies;
		}

		if (_t.rawin("IsAffectedByLosingHitpoints"))
		{
			this.IsAffectedByLosingHitpoints = _t.IsAffectedByLosingHitpoints;
		}

		if (_t.rawin("IsImmuneToOverwhelm"))
		{
			this.IsImmuneToOverwhelm = _t.IsImmuneToOverwhelm;
		}

		if (_t.rawin("IsImmuneToZoneOfControl"))
		{
			this.IsImmuneToZoneOfControl = _t.IsImmuneToZoneOfControl;
		}

		if (_t.rawin("IsImmuneToStun"))
		{
			this.IsImmuneToStun = _t.IsImmuneToStun;
		}

		if (_t.rawin("IsImmuneToRoot"))
		{
			this.IsImmuneToRoot = _t.IsImmuneToRoot;
		}

		if (_t.rawin("IsImmuneToKnockBackAndGrab"))
		{
			this.IsImmuneToKnockBackAndGrab = _t.IsImmuneToKnockBackAndGrab;
		}

		if (_t.rawin("IsImmuneToRotation"))
		{
			this.IsImmuneToRotation = _t.IsImmuneToRotation;
		}

		if (_t.rawin("IsImmuneToDisarm"))
		{
			this.IsImmuneToDisarm = _t.IsImmuneToDisarm;
		}

		if (_t.rawin("IsImmuneToSurrounding"))
		{
			this.IsImmuneToSurrounding = _t.IsImmuneToSurrounding;
		}

		if (_t.rawin("IsImmuneToBleeding"))
		{
			this.IsImmuneToBleeding = _t.IsImmuneToBleeding;
		}

		if (_t.rawin("IsImmuneToPoison"))
		{
			this.IsImmuneToPoison = _t.IsImmuneToPoison;
		}

		if (_t.rawin("IsImmuneToDamageReflection"))
		{
			this.IsImmuneToDamageReflection = _t.IsImmuneToDamageReflection;
		}

		if (_t.rawin("IsImmuneToFire"))
		{
			this.IsImmuneToFire = _t.IsImmuneToFire;
		}

		if (_t.rawin("IsIgnoringArmorOnAttack"))
		{
			this.IsIgnoringArmorOnAttack = _t.IsIgnoringArmorOnAttack;
		}
	};
	gt.Const.HexenOrigin.CharacterProperties.onSerialize = function( _out )
	{
		_out.writeU8(this.ActionPoints);
		_out.writeI16(this.Hitpoints);
		_out.writeI16(this.Bravery);
		_out.writeI16(this.Stamina);
		_out.writeI16(this.MeleeSkill);
		_out.writeI16(this.RangedSkill);
		_out.writeI16(this.MeleeDefense);
		_out.writeI16(this.RangedDefense);
		_out.writeI16(this.Initiative);
		_out.writeI16(this.ArmorMax[0]);
		_out.writeI16(this.Armor[0]);
		_out.writeI16(this.ArmorMax[1]);
		_out.writeI16(this.Armor[1]);
		_out.writeI16(this.FatigueRecoveryRate);
		_out.writeI16(this.DailyWage);
		_out.writeF32(this.DailyFood);
		_out.writeF32(this.MoraleEffectMult);
		_out.writeF32(this.FatigueEffectMult);
		_out.writeU8(this.Vision);
		_out.writeU8(this.DamageRegularMin);
		_out.writeU8(this.DamageRegularMax);
		_out.writeF32(this.DamageRegularMult);
		_out.writeF32(this.DamageArmorMult);
		_out.writeF32(this.DamageTotalMult);
		_out.writeF32(this.DamageDirectAdd);
		_out.writeF32(this.DamageDirectMult);
		_out.writeBool(this.IsAffectedByNight);
		_out.writeBool(this.IsImmuneToOverwhelm);
		_out.writeBool(this.IsImmuneToZoneOfControl);
		_out.writeBool(this.IsImmuneToStun);
		_out.writeBool(this.IsImmuneToRoot);
		_out.writeBool(this.IsImmuneToKnockBackAndGrab);
		_out.writeBool(this.IsImmuneToRotation);
		_out.writeBool(this.IsImmuneToDisarm);
		_out.writeBool(this.IsImmuneToSurrounding);
		_out.writeBool(this.IsImmuneToBleeding);
		_out.writeBool(this.IsImmuneToPoison);
		_out.writeBool(this.IsImmuneToDamageReflection);
		_out.writeBool(this.IsImmuneToFire);
		_out.writeBool(this.IsIgnoringArmorOnAttack);
	}
	gt.Const.HexenOrigin.CharacterProperties.onDeserialize = function( _in )
	{
		this.ActionPoints = _in.readU8();
		this.Hitpoints = _in.readI16();
		this.Bravery = _in.readI16();
		this.Stamina = _in.readI16();
		this.MeleeSkill = _in.readI16();
		this.RangedSkill = _in.readI16();
		this.MeleeDefense = _in.readI16();
		this.RangedDefense = _in.readI16();
		this.Initiative = _in.readI16();
		this.ArmorMax[0] = _in.readI16();
		this.Armor[0] = _in.readI16();
		this.ArmorMax[1] = _in.readI16();
		this.Armor[1] = _in.readI16();
		this.FatigueRecoveryRate = _in.readI16();
		this.DailyWage = _in.readI16();
		this.DailyFood = _in.readF32();
		this.MoraleEffectMult = _in.readF32();
		this.FatigueEffectMult = _in.readF32();
		this.Vision = _in.readU8();
		this.DamageRegularMin = _in.readU8();
		this.DamageRegularMax = _in.readU8();
		this.DamageRegularMult = _in.readF32();
		this.DamageArmorMult = _in.readF32();
		this.DamageTotalMult = _in.readF32();
		this.DamageDirectAdd = _in.readF32();
		this.DamageDirectMult = _in.readF32();
		this.IsAffectedByNight = _in.readBool();
		this.IsImmuneToOverwhelm = _in.readBool();
		this.IsImmuneToZoneOfControl = _in.readBool();
		this.IsImmuneToStun = _in.readBool();
		this.IsImmuneToRoot = _in.readBool();
		this.IsImmuneToKnockBackAndGrab = _in.readBool();
		this.IsImmuneToRotation = _in.readBool();
		this.IsImmuneToDisarm = _in.readBool();
		this.IsImmuneToSurrounding = _in.readBool();
		this.IsImmuneToBleeding = _in.readBool();
		this.IsImmuneToPoison = _in.readBool();
		this.IsImmuneToDamageReflection = _in.readBool();
		this.IsImmuneToFire = _in.readBool();
		this.IsIgnoringArmorOnAttack = _in.readBool();
	}

	delete this.HexenHooks.hookCharacterProperties;
}