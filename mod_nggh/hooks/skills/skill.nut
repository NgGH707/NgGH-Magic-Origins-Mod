/* set up the base in skill
::mods_hookBaseClass("skills/skill", function(obj)
{
	obj = obj[obj.SuperName];
	obj.m.IsRequireStaff <- false;
	obj.m.IsMagicSkill <- false;
	obj.m.MagicPointsCost <- 0;

	local ws_isUsable = obj.isUsable;
	obj.isUsable = function()
	{
		if (this.isMagicSkill())
		{
			if (!this.getContainer().getActor().getCurrentProperties().IsAbleToUseMagicSkills) return false;

			if (this.isRequireStaff() && !this.isActorArmedWithStaff()) return false;
		}

		return ws_isUsable();
	}

	local ws_onVerifyTarget = obj.onVerifyTarget;
	obj.onVerifyTarget = function( _originTile, _targetTile )
	{
		if (!ws_onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (this.isMagicSkill() && this.m.IsTargetingActor && _targetTile.getEntity().getCurrentProperties().IsImmuneToMagic)
		{
			return false;
		}

		return true;
	}

	local ws_isAffordable = obj.isAffordable;
	obj.isAffordable = function()
	{
		if (this.isMagicSkill() && this.getContainer().getActor().isAbleToUseMagic() && !this.isAffordableBasedOnMP())
		{
			return false;
		}

		return ws_isAffordable();
	}

	local ws_isAffordablePreview = obj.isAffordablePreview;
	obj.isAffordablePreview = function()
	{
		if (this.isMagicSkill() && this.getContainer().getActor().isAbleToUseMagic() && this.getMagicPointsCost() > this.getContainer().getActor().getPreviewMagicPoints())
		{
			return false;
		}

		return ws_isAffordablePreview();
	}

	local ws_getCostString = obj.getCostString;
	obj.getCostString = function()
	{
		if (this.isMagicSkill() && this.getContainer().getActor().isAbleToUseMagic())
		{
			return "[i]Costs " + (this.isAffordableBasedOnAPPreview() ? "[b][color=" + ::Const.UI.Color.PositiveValue + "]" + this.getActionPointCost() : "[b][color=" + ::Const.UI.Color.NegativeValue + "]" + this.getActionPointCost()) + " AP[/color][/b] and " + (this.isAffordableBasedOnMP() ? "[b][color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMagicPointsCost() : "[b][color=" + ::Const.UI.Color.NegativeValue + "]" + this.getMagicPointsCost()) + " MP[/color][/b] to use[/i]\n";
		}

		return ws_getCostString();
	}

	local ws_getFatigueCost = obj.getFatigueCost;
	obj.getFatigueCost = function()
	{
		if (this.isMagicSkill() && this.getContainer().getActor().isAbleToUseMagic())
		{
			return ::Const.Nggh_Magic.DefaultFatigueCost;
		}

		return ws_getFatigueCost();
	}

	obj.isMagicSkill <- function()
	{
		return this.m.IsMagicSkill;
	}

	obj.isRequireStaff <- function()
	{
		return this.m.IsRequireStaff;
	}

	obj.getMagicPointsCost <- function()
	{
		return this.m.MagicPointsCost;
	}

	obj.isAffordableBasedOnMP <- function()
	{
		return this.getMagicPointsCost() <= this.getContainer().getActor().getMagicPoints();
	}

	obj.isAffordableBasedOnMPPreview <- function()
	{
		if (this.getContainer().getActor().getPreviewSkillID() == this.getID())
		{
			return this.isMagicSkill();
		}
		
		return this.getMagicPointsCost() <= this.getContainer().getActor().getPreviewMagicPoints()
	}

	obj.isActorArmedWithStaff <- function()
	{
		local mainhand = this.getContainer().getActor().getMainhandItem();
		return mainhand != null && mainhand.isWeaponType(::Const.Items.WeaponType.Staff | ::Const.Items.WeaponType.MagicStaff);
	}

	obj.factoringMagicalElements <- function( _targetEntity, _properties )
	{
		local c = _targetEntity.getCurrentProperties();

		if (c.IsImmuneToMagic)
		{
			_properties.DamageTotalMult *= 0.0;
			return;
		}

		if (c.IsResistantToMagic)
		{
			_properties.DamageTotalMult *= 0.5;
		}

		local mDef = _targetEntity.getMagicDefense();
		_properties.DamageRegularMin -= ::Math.floor(mDef * ::Const.Nggh_Magic.MinimumMagicDefenseModifier);
		_properties.DamageRegularMax -= ::Math.floor(mDef * ::Const.Nggh_Magic.MaximumMagicDefenseModifier);
		_properties.DamageTotalMult *= _properties.MagicalPower;
	}

	obj.removeBonusesFromWeapon <- function( _properties )
	{
		local actor = this.getContainer().getActor();
		local main = actor.getMainhandItem();
		local off = actor.getOffhandItem();

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
	}

	local ws_use = obj.use;
	obj.use = function( _targetTile, _forFree = false )
	{
		local ret = ws_use(_targetTile, _forFree);
		local user = this.getContainer().getActor();
		
		if (!_forFree && this.isMagicSkill())
		{
			user.setMagicPoints(user.getMagicPoints() - this.getMagicPointsCost());
		}

		return ret;
	}
});
*/