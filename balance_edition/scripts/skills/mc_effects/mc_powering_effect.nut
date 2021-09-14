this.mc_powering_effect <- this.inherit("scripts/skills/skill", {
	m = {
		IsActivated = false,
		IsAlive = true,
		Master = null,
		TurnLefts = 2
	},
	
	function onActivateThat( _f )
	{
		this.m.IsActivated = _f;
	}

	function setMaster( _m )
	{
		if (typeof _m == "instance")
		{
			this.m.Master = _m;
		}
		else
		{
			this.m.Master = this.WeakTableRef(_m);
		}
	}
	
	function getPowerLevel()
	{
		return this.m.TurnLefts;
	}
	
	function setTurnLefts( _value )
	{
		this.m.TurnLefts = _value;
	}
	
	function resetTime()
	{
		this.m.TurnLefts = this.Math.min(5, this.m.TurnLefts + 2);
		this.getContainer().getActor().setMaster(this.m.Master);
		this.getContainer().getActor().updatePowerLevelVisuals(this.getPowerLevel());
	}

	function create()
	{
		this.m.ID = "effects.mc_powering";
		this.m.Name = "Powered";
		this.m.Icon = "skills/status_effect_69.png";
		this.m.IconMini = "status_effect_69_mini";
		this.m.Overlay = "status_effect_69";
		this.m.SoundOnUse = [];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}
	
	function getDescription()
	{
		return "This Earthen Puppet is currently being powered by " + this.Const.UI.getColorizedEntityName(this.m.Master) + " and fully active. Its energy will run out in [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnLefts + "[/color]/[color=" + this.Const.UI.Color.NegativeValue + "]5[/color] more turn(s).";
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
		];
	}

	function onAdded()
	{
		this.getContainer().getActor().m.IsControlledByPlayer = true;
		this.getContainer().getActor().onActive(this.m.Master);
	}
	
	function onTurnEnd()
	{
		if (this.m.Master == null)
		{
			this.removeSelf();
		}
		
		if (--this.m.TurnLefts <= 0)
		{
			this.removeSelf();
		}
		
		this.getContainer().getActor().updatePowerLevelVisuals(this.getPowerLevel());
	}

	function onRemoved()
	{
		if (this.m.IsAlive)
		{
			this.getContainer().getActor().onInactive();
			this.getContainer().getActor().m.IsControlledByPlayer = true;
		}
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints >= this.getContainer().getActor().getHitpoints())
		{
			this.m.IsAlive = false;
			this.onRemoved();
		}
	}
	
	function onUpdate( _properties )
	{
		if (this.m.Master == null)
		{
			this.removeSelf();
			return;
		}
		
		_properties.MeleeDefense += 50;
	}
	
	function onTurnStart()
	{
		if (!this.m.IsActivated)
		{
			return;
		}
		
		local actor = this.getContainer().getActor();
		local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
		local healthAdded = this.Math.min(healthMissing, this.Math.floor(actor.getHitpointsMax() * 0.05));

		if (healthAdded <= 0)
		{
			return;
		}

		actor.setHitpoints(actor.getHitpoints() + healthAdded);
		actor.setDirty(true);

		if (!actor.isHiddenToPlayer())
		{
			this.spawnIcon("status_effect_79", actor.getTile());

			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
			}

			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " repairs itself for " + healthAdded + " points");
		}
	}

});