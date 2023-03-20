::mods_hookExactClass("skills/actives/hyena_bite_skill", function ( obj )
{
	obj.m.IsRestrained <- false;
	obj.m.IsSpent <- false;
	obj.m.IsFrenzied <- false;

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Ripping off your enemy face with your powerful hyena jaw. Can easily cause bleeding.";
		this.m.Icon = "skills/active_197.png";
		this.m.IconDisabled = "skills/active_197_sw.png";
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
	obj.onAdded <- function()
	{
		this.m.IsFrenzied = this.getContainer().getActor().getFlags().has("frenzy");
	};
	obj.getTooltip <- function()
	{
		local ret = this.getDefaultTooltip();
		local actor = this.getContainer().getActor().get();
		local isHigh = this.m.IsFrenzied || (("isHigh" in actor) && actor.isHigh());
		local isSpecialized = this.getContainer().getActor().getCurrentProperties().IsSpecializedInCleavers;
		local damage = 5;
		if (isHigh) damage += 5;
		if (isSpecialized) damage += 5;
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Inflicts additional stacking [color=" + ::Const.UI.Color.DamageValue + "]" + damage + "[/color] bleeding damage per turn, for 2 turns"
		});
		return ret;
	};
	obj.canDoubleGrip <- function()
	{
		return this.getContainer().getActor().isDoubleGrippingWeapon();
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInCleavers ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	};
	obj.onUse = function( _user, _targetTile )
	{
		if (this.m.IsRestrained)
		{
			this.m.IsSpent = true;
		}

		local target = _targetTile.getEntity();
		local hp = target.getHitpoints();
		local success = this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return;
		}

		if (success && target.isAlive() && !target.isDying() && !target.getCurrentProperties().IsImmuneToBleeding && hp - target.getHitpoints() >= ::Const.Combat.MinDamageToApplyBleeding)
		{
			_user = _user.get();
			local isHigh = this.m.IsFrenzied || (("isHigh" in _user) && _user.isHigh());
			local damage = isHigh ? 10 : 5;
			damage = _user.getCurrentProperties().IsSpecializedInCleavers ? damage + 5 : damage;
			local effect = ::new("scripts/skills/effects/bleeding_effect");
			effect.setDamage(damage);

			if (_user.getFaction() == ::Const.Faction.Player)
			{
				effect.setActor(_user);
			}

			target.getSkills().add(effect);
		}

		return success;
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

			_properties.DamageRegularMin += 20;
			_properties.DamageRegularMax += 35;
			_properties.DamageArmorMult *= 1.0;

			if (_properties.IsSpecializedInCleavers && !this.m.IsRestrained)
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