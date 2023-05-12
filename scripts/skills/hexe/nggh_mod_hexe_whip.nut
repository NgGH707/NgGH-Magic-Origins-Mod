this.nggh_mod_hexe_whip <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.hexe_whip";
		this.m.Name = "Crack the Whip";
		this.m.Description = "Remind your simp of who their mommy is by giving them a good whipping, so that they give their all to you. \'Always listen to your mommy.\'";
		this.m.KilledString = "Whipped to death";
		this.m.Icon = "skills/active_214.png";
		this.m.IconDisabled = "skills/active_214_sw.png";
		this.m.Overlay = "active_214";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/whip_slave_01.wav",
			"sounds/combat/dlc6/whip_slave_02.wav",
			"sounds/combat/dlc6/whip_slave_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 13;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
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
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Inflicts [color=" + ::Const.UI.Color.DamageValue + "]2[/color] - [color=" + ::Const.UI.Color.DamageValue + "]5[/color] damage that ignores armor to the target"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Gives the targeted simp the \'Whipped\' status effect, increasing many of their stats for 2 rounds. The higher the simp level of the targeted simp, the higher the increase."
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Removes [color=" + ::Const.UI.Color.NegativeValue + "]Charmed[/color] effect from the targeted simp"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Resets the morale of the targeted simp to \'Steady\' if currently below"
			},
		];

		if (this.isUpgraded())
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has been upgraded by [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Const.Strings.PerkName.NggH_BDSM_DommyMommy + "[/color] perk"
			})
		}

		return ret;
	}

	function getWhip()
	{
		local main = this.getContainer().getActor().getMainhandItem();

		if (main == null || !main.isWeaponType(::Const.Items.WeaponType.Whip))
		{
			return null;
		}

		return main;
	}

	function isEquippedWithWhip()
	{
		return this.getWhip() != null;
	}

	function isHidden()
	{
		return this.skill.isHidden() || !this.isEquippedWithWhip();
	}

	function isUpgraded()
	{
		return this.getContainer().hasSkill("perk.bdsm_dommy_mommy");
	}

	function onUpdate( _properties )
	{
		local w = this.getWhip();
		this.m.MaxRange = w == null ? 1 : w.getRangeMax();
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInCleavers ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		return _targetTile.getEntity().getSkills().hasSkill("effects.simp");
	}

	function onUse( _user, _targetTile )
	{
		local t = _targetTile.getEntity();
		local upgraded = this.isUpgraded();
		local hitInfo = clone ::Const.Tactical.HitInfo;
		hitInfo.DamageRegular = ::Math.rand(2, 5);
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = ::Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		t.onDamageReceived(_user, this, hitInfo);

		if (upgraded)
		{
			_user.checkMorale(1, 9000);
		}

		if (t.isAlive() && !t.isDying())
		{
			local n = t.getSkills().getSkillByID("effects.simp").getSimpLevel();

			if (upgraded)
			{
				n += 5;
			}

			t.getSkills().removeByID("effects.charmed");
			t.getSkills().removeByID("effects.legend_intensely_charmed");

			if (t.getSkills().hasSkill("effects.whipped"))
			{
				local s = t.getSkills().getSkillByID("effects.whipped");
				s.onRefresh();
				s.setLevel(n);
				t.getSkills().update();
			}
			else
			{
				local s = ::new("scripts/skills/effects/whipped_effect");
				s.getDescription = function()
				{
					return "This character just received a warming reminder of what they need to do for their mommy. It will last for another " + this.m.TurnsLeft + " round(s).";
				};
				s.setLevel(n);
				t.getSkills().add(s);
			}

			if (t.getMoraleState() < ::Const.MoraleState.Steady)
			{
				t.setMoraleState(::Const.MoraleState.Steady);
			}
		}

		return true;
	}

});

