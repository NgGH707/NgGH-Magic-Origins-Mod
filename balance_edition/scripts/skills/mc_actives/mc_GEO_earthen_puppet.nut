this.mc_GEO_earthen_puppet <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		IsUsed = false,
		Puppet = null,
		Script = "scripts/entity/tactical/minions/special/sand_puppet"
	},
	
	function create()
	{
		this.mc_magic_skill.create();
		this.m.ID = "actives.mc_earthen_puppet";
		this.m.Name = "Create Earthen Puppet";
		this.m.Description = "Sculpting an earthen golem with the most potent soil, sand, stone and magical energy. The golem is just a lifeless puppet that can be served like a siege weapon and it requires constant recharge to operate. Can only create one golem per battle. The higher your resolve the stronger your puppet would be.";
		this.m.Icon = "skills/active_mc_07.png";
		this.m.IconDisabled = "skills/active_mc_07_sw.png";
		this.m.Overlay = "active_mc_07";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/sand_golem_assemble_01.wav",
			"sounds/enemies/dlc6/sand_golem_assemble_02.wav",
			"sounds/enemies/dlc6/sand_golem_assemble_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury + 1;
		this.m.Delay = 1000;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsTargetingActor = false;
		this.m.ActionPointCost = 9;
		this.m.FatigueCost = 45;
		this.m.MaxRangeBonus = 1;
		this.m.IsRanged = true;
		this.m.IsUtility = true;
		this.m.IsIgnoreBlockTarget = true;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
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
				id = 4,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles"
			}
		];
		
		if (this.m.IsUsed)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Charge your [color=" + this.Const.UI.Color.PositiveValue + "]Earthen Puppet[/color] with [color=" + this.Const.UI.Color.NegativeValue + "]2[/color] turns worth of magical energy"
			});
		}
		
		return ret;
	}
	
	function onUpdate( _properties )
	{
		if (!this.m.IsUsed)
		{
			this.m.Name = "Create Earthen Puppet";
			this.m.Description = "Sculpting an earthen golem with the most potent soil, sand, stone and magical energy. The golem is just a lifeless puppet that requiring constant recharge to be active. Can only create one golem per battle.";
			this.m.Icon = "skills/active_mc_07.png";
			this.m.IconDisabled = "skills/active_mc_07_sw.png";
			this.m.Overlay = "active_mc_07";
			this.m.IsTargetingActor = false;
		}
		else
		{
			this.m.Name = "Recharge Puppet";
			this.m.Description = "Recharge an Earthen Puppet and slightly restore its armor, allowing it to wreck havoc in the battle field.";
			this.m.Icon = "skills/active_mc_08.png";
			this.m.IconDisabled = "skills/active_mc_08_sw.png";
			this.m.Overlay = "active_mc_08";
			this.m.IsTargetingActor = true;
		}
	}
	
	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = this.m.IsUsed ? 1.0 : 0.5;
		this.m.MaxRange = this.m.IsUsed ? 8 : 2;
	}
	
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.m.IsUsed)
		{
			return !_targetTile.IsOccupiedByActor && this.skill.onVerifyTarget(_originTile, _targetTile);
		}
		else
		{
			if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			{
				return false;
			}

			local target = _targetTile.getEntity();
			
			if (!_targetTile.IsOccupiedByActor || _targetTile.IsEmpty)
			{
				return false;
			}
			
			if (!target.getFlags().has("puppet"))
			{
				return false;
			}

			local skill = target.getSkills().getSkillByID("effects.mc_powering")
			
			if (skill != null && skill.getPowerLevel() >= 5)
			{
				return false;
			}
			
			return true;
		}
	}

	function onUse( _user, _targetTile )
	{	
		this.getContainer().setBusy(true);
		this.spawnIcon(this.m.Overlay, _targetTile);
		
		if (!this.m.IsUsed)
		{
			this.m.IsUsed = true;
			this.onSpawnPuppet(_user, _targetTile);
		}
		else
		{
			this.Tactical.CameraDirector.addMoveToTileEvent(100, _targetTile);
			this.Tactical.CameraDirector.addDelay(0.2);
			this.onPowering(_user, _targetTile.getEntity());
			this.restoreArmor(_targetTile.getEntity());
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.m.Name);
			this.getContainer().setBusy(false);
		}
		
		this.m.IsEnhanced = false;
		return true;
	}
	
	function onSpawnPuppet( _user, _targetTile )
	{
		this.Tactical.CameraDirector.addMoveToTileEvent(this.m.Delay, _targetTile);
		this.Tactical.CameraDirector.addDelay(0.2);
		local spawn = this.Tactical.spawnEntity(this.m.Script, _targetTile.Coords.X, _targetTile.Coords.Y);
		spawn.setFaction(2);
		spawn.setNewStats(this.getBonusDamageFromResolve(_user.getCurrentProperties()), false);
		spawn.grow();
		this.onPowering(_user, spawn, true);
		this.m.Puppet = spawn;
		this.getContainer().setBusy(false);
	}
	
	function onPowering( _user, _puppet , _isFree = false)
	{
		local effect = this.new("scripts/skills/mc_effects/mc_powering_effect");
		effect.setMaster(_user);
		local hasEffect = _puppet.getSkills().getSkillByID("effects.mc_powering");
		
		if (_isFree)
		{
			effect.setTurnLefts(1);
		}
		
		if (hasEffect != null)
		{
			hasEffect.setMaster(_user);
			hasEffect.resetTime();
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_puppet) + " is charged with magical energy");
		}
		else
		{
			_puppet.getSkills().add(effect);
			this.actitvateGolem(_puppet);
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_puppet) + " is active now");
		}
	}
	
	function actitvateGolem( _golem )
	{
		local effect = _golem.getSkills().getSkillByID("effects.mc_powering");
		
		if (effect != null)
		{
			this.Tactical.TurnSequenceBar.removeEntity(_golem);
			_golem.m.IsActingImmediately = true;
			_golem.m.IsTurnDone = false;
			_golem.m.IsWaitActionSpent = false;
			this.Tactical.TurnSequenceBar.insertEntity(_golem);
		}
	}
	
	function restoreArmor( _entity )
	{
		_entity.setHitpoints(this.Math.min(_entity.getHitpointsMax(), _entity.getHitpoints() + 20));
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_entity) + " seems to be in a better state");
	}
	
	function onCombatStarted()
	{
		if (this.m.IsUsed)
		{
			this.m.IsUsed = false;
		}
		
		this.m.Puppet = null;
	}
	
	function onCombatFinished()
	{
		if (this.m.IsUsed)
		{
			this.m.IsUsed = false;
		}
		
		this.m.Puppet = null;
	}
	
});