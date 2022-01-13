this.mod_nacho_vomiting_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 0
	},
	function setCooldown()
	{
		this.m.Cooldown = 1;
	}

	function create()
	{
		this.m.ID = "actives.nacho_vomiting";
		this.m.Name = "Throw Up";
		this.m.Description = "Time to look back what i ate this morning. Uwwwww Owhwhwhwh!";
		this.m.Icon = "skills/active_nacho_vomit.png";
		this.m.IconDisabled = "skills/active_nacho_vomit_sw.png";
		this.m.Overlay = "active_nacho_vomit";
		this.m.SoundOnHit = [
			"sounds/enemies/swallow_whole_01.wav",
			"sounds/enemies/swallow_whole_02.wav",
			"sounds/enemies/swallow_whole_03.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/enemies/swallow_whole_miss_01.wav",
			"sounds/enemies/swallow_whole_miss_02.wav",
			"sounds/enemies/swallow_whole_miss_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = false;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}
	
	function getTooltip()
	{
		return [
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
		];

		if (!this.getContainer().hasSkill("effects.swallowed_whole"))
		{
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Don\'t have anything inside your belly[/color]"
				}
			]);
		}

		if (this.m.Cooldown != 0)
		{
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used in " + this.m.Cooldown + " turn(s)[/color]"
				}
			]);
		}
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.m.Cooldown == 0 && this.getContainer().hasSkill("effects.swallowed_whole");
	}
	
	function isHidden()
	{
		return this.getContainer().getActor().getSize() != 3 || this.skill.isHidden();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		this.getContainer().removeByID("effects.swallowed_whole");

		if (this.m.SoundOnHit.len() != 0)
		{
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
		}

		local e = _user.onAfterDeath(_targetTile);

		if (e == null)
		{
			return false;
		}

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " throws up " + this.Const.UI.getColorizedEntityName(e) + " out of its stomache");
		}

		local skill = this.getSkills().getSkillByID("actives.swallow_whole");

		if (skill == null)
		{
			skill = this.getSkills().getSkillByID("actives.legend_skin_ghoul_swallow_whole");
			
			if (skill == null)
			{
				return true;
			}
		}

		skill.setCooldown();
		return true;
	}

	function onTurnStart()
	{
		this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
	}
	
	function onCombatFinished()
	{
		this.m.Cooldown = 0;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInShields ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

});

