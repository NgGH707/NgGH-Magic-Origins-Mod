this.summon_enemy <- this.inherit("scripts/skills/skill", {
	m = {},
	
	function create()
	{
		this.m.ID = "actives.summon_enemy";
		this.m.Name = "Dev - Summon Skill";
		this.m.Description = ".";
		this.m.Icon = "skills/active_83.png";
		this.m.IconDisabled = "skills/active_83_sw.png";
		this.m.Overlay = "active_83";
		this.m.SoundOnUse = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.NonTargeted + 5;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
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
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		local actor = this.getContainer().getActor();
		return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
	}
	
	function onUpdate( _properties )
	{
		_properties.Bravery += 10000;
		_properties.IsSkillUseFree = true;
		_properties.FatigueEffectMult = 0;
	}

	function onUse( _user, _targetTile )
	{
		local s = [
			"engineer",
		];
		local script = s[this.Math.rand(0, s.len() - 1)];
		local entity = this.Tactical.spawnEntity("scripts/entity/tactical/humans/" + script, _targetTile.Coords.X, _targetTile.Coords.Y);
		entity.setFaction(this.Const.Faction.Enemy);
		entity.assignRandomEquipment();
		
		return true;
	}

});

