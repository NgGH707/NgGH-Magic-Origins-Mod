::mods_hookExactClass("skills/actives/werewolf_bite", function ( obj )
{
	obj.m.IsRestrained <- false;
	obj.m.IsSpent <- false;
	obj.m.IsFrenzied <- false;

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Tear an enemy assunder with your teeth";
		this.m.Icon = "skills/active_71.png";
		this.m.IconDisabled = "skills/active_71_bw.png";
	};
	obj.setRestrained <- function( _f )
	{
		this.m.IsRestrained = _f;
	};
	obj.isIgnoredAsAOO <- function()
	{
		if (!this.m.IsRestrained)
		{
			return this.m.IsIgnoredAsAOO;
		}

		return !this.getContainer().getActor().isArmedWithRangedWeapon();
	};
	obj.onAdded <- function()
	{
		this.m.IsFrenzied = this.getContainer().getActor().getFlags().has("frenzy");
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

			_properties.DamageRegularMin += 30;
			_properties.DamageRegularMax += 50;
			_properties.DamageArmorMult *= 0.7;

			if (_properties.IsSpecializedInSwords && !this.m.IsRestrained)
			{
				_properties.DamageRegularMin += 10;
				_properties.DamageRegularMax += 10;
				_properties.DamageArmorMult += 0.1;
			}

			if (this.m.IsFrenzied && this.m.IsRestrained)
			{
				_properties.DamageTotalMult *= 1.25;
			}

			if (this.canDoubleGrip())
			{
				_properties.DamageTotalMult /= 1.25;
			}
		}
	};
	obj.onUpdate = function( _properties ) {};
});