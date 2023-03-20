this.load_mortar <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.load_mortar_player";
		this.m.Name = "Load Mortar";
		this.m.Description = "Ready another shot to be fired. Can not be used while engaged in melee.";
		this.m.Icon = "skills/active_212.png";
		this.m.IconDisabled = "skills/active_212_sw.png";
		this.m.Overlay = "active_212";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/reload_gonne_01.wav",
			"sounds/combat/dlc6/reload_gonne_02.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 6;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1,
		this.m.MaxRange = 1,
		this.m.MaxLevelDifference = 2;
	}
	
	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
		
		local ammo = this.getAmmo();

		if (ammo > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "Has enough supples for [color=" + this.Const.UI.Color.PositiveValue + "]" + ammo + "[/color] shots"
			});
		}
		else
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Out of ammo supplies[/color]"
			});
		}

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local _target = _targetTile.getEntity();

		if (_target.getType() == this.Const.EntityType.Mortar && _target.getFlags().has("siege_weapon") && !_target.getFlags().get("isLoaded"))
		{
			return true;
		}

		return false;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		local myTile = this.getContainer().getActor().getTile();

		if (myTile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			return false;
		}

		return this.getAmmo() > 0;
	}
	
	function onAfterUpdate( _properties )
	{
		local IsSpecialized = this.getContainer().hasSkill("background.legend_inventor");
		this.m.FatigueCostMult = IsSpecialized ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		this.m.ActionPointCost = IsSpecialized ? 4 : 6;
	}

	function onUse( _user, _targetTile )
	{
		local siege_weapon = _targetTile.getEntity();
		this.consumeAmmo();	
		siege_weapon.getFlags().set("isLoaded", true);
		siege_weapon.getSprite("body").setBrush("mortar_01");
		this.spawnIcon(this.m.Overlay, _targetTile);
		
		return true;
	}
	
	function consumeAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);

		if (item != null)
		{
			item.consumeAmmo();
		}
	}
	
	function getAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);

		if (item == null)
		{
			return 0;
		}

		if (this.isKindOf(item, "bomb_bag"))
		{
			return item.getAmmo();
		}

		return 0;
	}

});

