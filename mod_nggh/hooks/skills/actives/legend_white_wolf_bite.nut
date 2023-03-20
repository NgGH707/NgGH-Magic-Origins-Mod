::mods_hookExactClass("skills/actives/legend_white_wolf_bite", function ( obj )
{
	obj.m.IsRestrained <- false;
	obj.m.IsSpent <- false;

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Ripping off your enemy face with your powerful white wolf jaw.";
		this.m.Icon = "skills/active_71.png";
		this.m.IconDisabled = "skills/active_71_sw.png";
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
	obj.isUsable <- function()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
	};
	obj.onTurnStart <- function()
	{
		this.m.IsSpent = false;
	};
	obj.isHidden <- function()
	{
		return this.getContainer().hasSkill("actives.werewolf_bite");
	};
	obj.canDoubleGrip <- function()
	{
		return this.getContainer().getActor().isDoubleGrippingWeapon();
	};
	obj.onAdded <- function()
	{
		this.m.ActionPointCost = this.getContainer().getActor().isPlayerControlled() ? 4 : 6;
		this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 10 : 20;
	};
	obj.getTooltip <- function()
	{
		return this.getDefaultTooltip();
	};

	local ws_onUpdate = obj.onUpdate;
	obj.onUpdate = function( _properties )
	{
		if (!this.m.IsRestrained)
		{
			ws_onUpdate(_properties);
		}
	};

	local ws_onUse = obj.onUse;
	obj.onUse = function( _user, _targetTile )
	{
		if (this.m.IsRestrained) this.m.IsSpent = true;
		return ws_onUse(_user, _targetTile);
	};
	obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == this && this.m.IsRestrained)
		{
			_properties.DamageRegularMin += 45;
			_properties.DamageRegularMax += 75;
			_properties.DamageArmorMult += 0.8;

			local items = this.getContainer().getActor().getItems();
			local mhand = items.getItemAtSlot(::Const.ItemSlot.Mainhand);

			if (mhand != null)
			{
				_properties.DamageRegularMin -= mhand.m.RegularDamage;
				_properties.DamageRegularMax -= mhand.m.RegularDamageMax;
				_properties.DamageArmorMult /= mhand.m.ArmorDamageMult;
				_properties.DamageDirectAdd -= mhand.m.DirectDamageAdd;
			}
			
			if (this.canDoubleGrip())
			{
				_properties.DamageTotalMult /= 1.25;
			}
		}
	};
});