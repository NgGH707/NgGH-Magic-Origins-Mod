this.nggh_mod_kraken_command_release_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.kraken_command_release";
		this.m.Name = "Release Prey";
		this.m.Description = "Release an ensnared prey.";
		this.m.Icon = "skills/active_151.png";
		this.m.IconDisabled = "skills/active_151_sw.png";
		this.m.Overlay = "active_151";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/krake_choke_01.wav",
			"sounds/enemies/dlc2/krake_choke_02.wav",
			"sounds/enemies/dlc2/krake_choke_03.wav",
			"sounds/enemies/dlc2/krake_choke_04.wav",
			"sounds/enemies/dlc2/krake_choke_05.wav"
		];
		this.m.SoundVolume = 0.75;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsRangeLimitsEnforced = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		//this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 3;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		return this.getDefaultUtilityTooltip();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local skill = _targetTile.getEntity().getSkills().getSkillByID("actives.kraken_move_ensnared");

		if (skill == null)
		{
			return false;
		}

		if (skill.m.ParentID == null || this.getContainer().getActor().getID() != skill.m.ParentID)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local breakFree = target.getSkills().getSkillByID("actives.break_free");
		local ensnare = target.getSkills().getSkillByID("actives.kraken_ensnare");

		if (breakFree != null)
		{
			if (ensnare != null)
			{
				ensnare.m.OnRemoveCallbackData.LoseHitpoints = false;
			}

			if (breakFree.m.SoundOnUse.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(breakFree.m.SoundOnUse), ::Const.Sound.Volume.Skill * breakFree.m.SoundVolume, _user.getPos());
			}

			breakFree.setSkillBonus(2000);
			breakFree.onUse(target, _targetTile);
		}

		return true;
	}

	//function onTargetSelected( _targetTile ) {}
	function getHitFactors( _targetTile ) {return []}

});

