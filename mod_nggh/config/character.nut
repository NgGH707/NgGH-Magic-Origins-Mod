
::Const.CharacterProperties.IsStealthy <- false;
::Const.CharacterProperties.IsSpecializedInHex <- false;
::Const.CharacterProperties.IsSpecializedInWhips <- false;
::Const.CharacterProperties.IsSpecializedInMagic <- false;
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
local ws_onSerialize = ::Const.CharacterProperties.onSerialize;
::Const.CharacterProperties.onSerialize = function( _out )
{
	ws_onSerialize(_out);

	_out.writeU8(this.Vision);
	_out.writeI16(this.ArmorMax[0]);
	_out.writeI16(this.Armor[0]);
	_out.writeI16(this.ArmorMax[1]);
	_out.writeI16(this.Armor[1]);
	_out.writeI16(this.FatigueRecoveryRate);
	_out.writeF32(this.MoraleEffectMult);
	_out.writeF32(this.FatigueEffectMult);
	_out.writeU8(this.DamageRegularMin);
	_out.writeU8(this.DamageRegularMax);
	_out.writeF32(this.DamageRegularMult);
	_out.writeF32(this.DamageArmorMult);
	_out.writeF32(this.DamageTotalMult);
	_out.writeF32(this.DamageDirectAdd);
	_out.writeF32(this.DamageDirectMult);
}
local ws_onDeserialize = ::Const.CharacterProperties.onDeserialize;
::Const.CharacterProperties.onDeserialize = function( _in )
{
	ws_onDeserialize(_in);

	this.Vision = _in.readU8();
	this.ArmorMax[0] = _in.readI16();
	this.Armor[0] = _in.readI16();
	this.ArmorMax[1] = _in.readI16();
	this.Armor[1] = _in.readI16();
	this.FatigueRecoveryRate = _in.readI16();
	this.MoraleEffectMult = _in.readF32();
	this.FatigueEffectMult = _in.readF32();
	this.DamageRegularMin = _in.readU8();
	this.DamageRegularMax = _in.readU8();
	this.DamageRegularMult = _in.readF32();
	this.DamageArmorMult = _in.readF32();
	this.DamageTotalMult = _in.readF32();
	this.DamageDirectAdd = _in.readF32();
	this.DamageDirectMult = _in.readF32();
}


