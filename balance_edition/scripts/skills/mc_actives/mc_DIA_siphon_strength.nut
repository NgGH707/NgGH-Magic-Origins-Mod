this.mc_DIA_siphon_strength <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		ChanceBonus = 0
	},
	function create()
	{
		this.mc_magic_skill.create();
		this.m.ID = "actives.mc_siphon_strength";
		this.m.Name = "Siphon Strength";
		this.m.Description = "Weaken your target while strengthening yourself with target\'s lost strength. Success chance based on ranged skill.";
		this.m.Icon = "skills/active_mc_05.png";
		this.m.IconDisabled = "skills/active_mc_05_sw.png";
		this.m.Overlay = "active_mc_05";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_charm_chimes_01.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_02.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_03.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_04.wav",
		];
		this.m.IsUsingActorPitch = true;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury + 1;
		this.m.IsActive = true;
		this.m.IsSerialized = false;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsUtility = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 13;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.IsIgnoreBlockTarget = true;
	}
	
	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles on even ground, more if casting downhill"
		});
		
		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.mc_siphon_strength_master");
	}

	function onUse( _user, _targetTile )
	{	
		local target = _targetTile.getEntity();
		this.Tactical.spawnSpriteEffect("bust_nightmare", this.createColor("#ffffff"), _targetTile, 0, 40, 1.0, 0.25, 0, 400, 300);
		local skill = _user.getCurrentProperties().getRangedSkill();
		local toHit = this.Math.min(95, skill + this.m.ChanceBonus);
		local rolled = this.Math.rand(1, 100);
		this.Tactical.EventLog.log_newline();

		if (rolled <= toHit)
		{
			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " curses " + this.Const.UI.getColorizedEntityName(target) + " (Chance: " + toHit + ", Rolled: " + rolled + ")");
			}

			local slave = this.new("scripts/skills/mc_effects/mc_siphon_strength_slave_effect");
			local master = this.new("scripts/skills/mc_effects/mc_siphon_strength_master_effect");
			local efficiency = this.getBonusDamageFromResolve(_user.getCurrentProperties());

			if (this.m.IsEnhanced)
			{
				efficiency *= 1.25;
			}

			slave.setMaster(master);
			target.getSkills().add(slave);

			master.setSlave(slave);
			master.setEfficiency(efficiency);
			_user.getSkills().add(master);

			slave.activate();
			master.activate();
		}
		else
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " fails to curse " + this.Const.UI.getColorizedEntityName(target) + " (Chance: " + toHit + ", Rolled: " + rolled + ")");
			this.m.IsEnhanced = false;
			return false;
		}

		this.m.IsEnhanced = false;
		return true;
	}

	function getHitchance( _targetEntity )
	{
		local skill = this.getContainer().getActor().getCurrentProperties().getRangedSkill();
		local toHit = this.Math.min(95, skill + this.m.ChanceBonus);
		return toHit;
	}

	function getHitFactors( _targetTile )
	{
		return [];
	}

});

