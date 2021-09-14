this.catapult_sling_stone_control <- this.inherit("scripts/skills/skill", {
	m = {
		AdditionalAccuracy = -40,
		AdditionalHitChance = 0,
		SiegeWeapon = null,
	},
	function setWeapon( _w )
	{
		this.m.SiegeWeapon = _w;
	}

	function create()
	{
		this.m.ID = "actives.use_catapult";
		this.m.Name = "Fire Trebuchet";
		this.m.Description = "Hurl a giant stone towards a target with your trebuchet. extremely hard to aim, but stones are everywhere so you never run out of ammunition. Can not be used while engaged in melee.";
		this.m.KilledString = "Stoned";
		this.m.Icon = "skills/active_12.png";
		this.m.IconDisabled = "skills/active_12_sw.png";
		this.m.Overlay = "active_12";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsDoingForwardMove = false;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.75;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 15;
		this.m.MinRange = 4;
		this.m.MaxRange = 18;
		this.m.MaxLevelDifference = 8;
		this.m.IsShieldRelevant = false;
		this.m.IsShieldwallRelevant = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles on even ground, more if shooting downhill"
			}
		]);
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Has [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.AdditionalAccuracy + "%[/color] chance to hit, and [color=" + this.Const.UI.Color.PositiveValue + "]+" + (6 + this.m.AdditionalHitChance) + "%[/color] per tile of distance"
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Has a [color=" + this.Const.UI.Color.NegativeValue + "]100%[/color] chance to daze a target on a hit to the head and always staggers the target"
		});

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onAfterUpdate( _properties )
	{
	}

	function onUse( _user, _targetTile )
	{
		if (this.m.SiegeWeapon == null)
		{
			return false;
		}

		local skill = this.m.SiegeWeapon.getSkills().getSkillByID("actives.catapult_sling_stone");

		if (skill != null)
		{
			skill.use(_targetTile, true);
		}

		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += -40 + this.m.AdditionalAccuracy;
			_properties.HitChanceAdditionalWithEachTile += 6 + this.m.AdditionalHitChance;
			_properties.DamageRegularMin = 70;
			_properties.DamageRegularMax = 150;
			_properties.DamageArmorMult *= 1.2;
		}
	}

});

