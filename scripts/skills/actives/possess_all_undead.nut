this.possess_all_undead <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.possess_undead";
		this.m.Name = "Possess Undead";
		this.m.Description = "";
		this.m.Icon = "skills/active_99.png";
		this.m.IconDisabled = "skills/active_99.png";
		this.m.Overlay = "active_99";
		this.m.SoundOnHit = [
			"sounds/enemies/necromancer_01.wav",
			"sounds/enemies/necromancer_02.wav",
			"sounds/enemies/necromancer_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local p = this.getContainer().getActor().getCurrentProperties();
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
			}
		];
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.possessing_undead");
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (!target.getFlags().has("undead"))
		{
			return false;
		}

		if (target.getSkills().hasSkill("effects.possessed_undead"))
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " possesses his creations");

			if (this.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * 1.2, _user.getPos());
			}
		}
		
		local minions = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());
		
		if (minions.len() == 1)
		{
			return false;
		}
		
		local possessing = this.new("scripts/skills/effects/true_possessing_undead_effect");
		
		foreach ( m in minions )
		{
			if (m.getID() == _user.getID())
			{
				continue;
			}
			
			local possessed = this.new("scripts/skills/effects/true_possessed_undead_effect");
			m.getSkills().add(possessed);
			m.setActionPoints(m.getCurrentProperties().ActionPoints);
			possessing.addPossessed(m);
		}
		
		_user.getSkills().add(possessing);
		
		return true;
	}

});

