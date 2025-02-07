
::Const.CharacterProperties.IsStealthy <- false;
::Const.CharacterProperties.IsWeakenByPoison <- false;
::Const.CharacterProperties.IsSpecializedInHex <- false;
::Const.CharacterProperties.IsSpecializedInWhips <- false;
::Const.CharacterProperties.IsSpecializedInMagic <- false;
::Const.CharacterProperties.IsSpecializedInMountedCharge <- false;
/* new character properties
::Const.CharacterProperties.IsHasMagicTraining <- false;
::Const.CharacterProperties.MagicalPower <- 1.0;
::Const.CharacterProperties.MagicPointsEfficiency <- 1.0;
::Const.CharacterProperties.IsAbleToUseMagicSkills <- true;
::Const.CharacterProperties.IsAbleToGainMagicPoints <- true;
::Const.CharacterProperties.IsImmuneToMagic <- false;
::Const.CharacterProperties.IsResistantToMagic <- false;
::Const.CharacterProperties.getMagicDefense <- function()
{
	local magicDef = this.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack];
	local magicDefMult = this.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack];

	if (magicDef >= 0)
	{
		return this.Math.floor(magicDef * (magicDefMult >= 0 ? magicDefMult : 1.0 / magicDefMult));
	}
	else
	{
		return this.Math.floor(magicDef * (magicDefMult < 0 ? magicDefMult : 1.0 / magicDefMult));
	}
};*/


// add new functions
::Const.CharacterProperties.getMult <- function( _mult )
{
	return _mult >= 0 ? _mult : 1.0 / _mult;
};
::Const.CharacterProperties.getDamRedMod <- function( _isRanged = false )
{
	local ret = 1.0;
	local mod = [
		"DamageReceivedRegularMult",
		"DamageReceivedTotalMult",
	];
	mod.push(_isRanged ? "DamageReceivedRangedMult" : "DamageReceivedMeleeMult");

	foreach (i, string in mod ) 
	{
		if (this.rawin(string))
		{
	 		ret *= this.getMult(this.rawget(string));
	 	}
	}
	return ret;
};

// hooks
local ws_setValues = ::Const.CharacterProperties.setValues;
::Const.CharacterProperties.setValues = function( _t )
{
	ws_setValues(_t);

	if (_t.rawin("ArmorMax"))
	{
		this.ArmorMax = clone _t.ArmorMax;
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
};


::Nggh_MagicConcept.onSerializeProperties <- function( _actor, _out )
{
	local b = _actor.getBaseProperties();
	_out.writeU8(b.Vision);
	_out.writeI16(b.ArmorMax[0]);
	_out.writeI16(b.Armor[0]);
	_out.writeI16(b.ArmorMax[1]);
	_out.writeI16(b.Armor[1]);
	_out.writeI16(b.FatigueRecoveryRate);
	_out.writeF32(b.MoraleEffectMult);
	_out.writeF32(b.FatigueEffectMult);
	_out.writeU8(b.DamageRegularMin);
	_out.writeU8(b.DamageRegularMax);
	_out.writeF32(b.DamageRegularMult);
	_out.writeF32(b.DamageArmorMult);
	_out.writeF32(b.DamageTotalMult);
	_out.writeF32(b.DamageDirectAdd);
	_out.writeF32(b.DamageDirectMult);
};

::Nggh_MagicConcept.onDeserializeProperties <- function( _properties, _in )
{
	_properties.clear();
	_properties.Vision <- _in.readU8();
	_properties.ArmorMax <- [0, 0];
	_properties.Armor <- [0, 0];
	_properties.ArmorMax[0] = _in.readI16();
	_properties.Armor[0] = _in.readI16();
	_properties.ArmorMax[1] = _in.readI16();
	_properties.Armor[1] = _in.readI16();
	_properties.FatigueRecoveryRate <- _in.readI16();
	_properties.MoraleEffectMult <- _in.readF32();
	_properties.FatigueEffectMult <- _in.readF32();
	_properties.DamageRegularMin <- _in.readU8();
	_properties.DamageRegularMax <- _in.readU8();
	_properties.DamageRegularMult <- _in.readF32();
	_properties.DamageArmorMult <- _in.readF32();
	_properties.DamageTotalMult <- _in.readF32();
	_properties.DamageDirectAdd <- _in.readF32();
	_properties.DamageDirectMult <- _in.readF32();
};

::Nggh_MagicConcept.applyBaseProperties <- function( _actor, _properties )
{
	local b = _actor.getBaseProperties();
	foreach (k, value in _properties)
	{
		b[k] = value;
	}
};