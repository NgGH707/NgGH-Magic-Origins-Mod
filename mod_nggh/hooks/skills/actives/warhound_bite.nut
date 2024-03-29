::mods_hookExactClass("skills/actives/warhound_bite", function ( obj )
{
	obj.m.IsRestrained <- false;
	obj.m.IsSpent <- false;

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Warhound Bite";
		this.m.Description = "Ripping off your enemy face with your powerful hound jaw. Do poorly against armor.";
		this.m.Icon = "skills/active_164.png";
		this.m.IconDisabled = "skills/active_164_sw.png";
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted + 5;
	};
	obj.setRestrained <- function( _f )
	{
		this.m.IsRestrained = _f;
	};
	obj.isIgnoredAsAOO <- function()
	{
		if (!this.m.IsRestrained)
			return this.m.IsIgnoredAsAOO;

		return !this.getContainer().getActor().isArmedWithRangedWeapon();
	};
	obj.isUsable <- function()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
	};
	obj.onTurnStart <- function()
	{
		this.m.IsSpent = false;
	};

	local ws_onUse = obj.onUse;
	obj.onUse = function( _user, _targetTile )
	{
		if (this.m.IsRestrained) this.m.IsSpent = true;
		return ws_onUse(_user, _targetTile);
	};
	obj.canDoubleGrip <- function()
	{
		return this.getContainer().getActor().isDoubleGrippingWeapon();
	};
	obj.getTooltip <- function()
	{
		return this.getDefaultTooltip();
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInSwords ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	};
	obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local items = this.getContainer().getActor().getItems();
			local mhand = items.getItemAtSlot(::Const.ItemSlot.Mainhand);

			if (mhand != null)
			{
				_properties.DamageRegularMin -= mhand.m.RegularDamage;
				_properties.DamageRegularMax -= mhand.m.RegularDamageMax;
				_properties.DamageArmorMult /= mhand.m.ArmorDamageMult;
				_properties.DamageDirectAdd -= mhand.m.DirectDamageAdd;
			}

			_properties.DamageRegularMin += 25;
			_properties.DamageRegularMax += 40;
			_properties.DamageArmorMult *= 0.4;
			
			if (this.canDoubleGrip())
				_properties.DamageTotalMult /= 1.25;
		}
	};
	obj.onUpdate = function( _properties ) {};
});