this.siege_golem_racial <- this.inherit("scripts/skills/skill", {
	m = {
		IsAlive = true,
		Master = null,
		TurnLefts = 2
	},
	
	function IsAlive()
	{
		return this.m.IsAlive;
	}

	function setMaster( _m , _isForce = false )
	{
		if (typeof _m == "instance")
		{
			this.m.Master = _m;
		}
		else
		{
			this.m.Master = this.WeakTableRef(_m);
		}
		
		if (_isForce)
		{
			this.getContainer().getActor().setMaster(_m);
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

	function create()
	{
		this.m.ID = "racial.siege_golem";
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
		return "This Siege Golem is fully active. Its energy will run out in [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnLefts + "[/color] more turn(s). Then it will deactivate and charging itself for [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] turn then becomes active again.";
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
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]The color of Puppet\'s eyes telling about its power level[/color]"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Useless without powering[/color]"
			}
		];
	}

	function onAdded()
	{
	}
	
	function onActivateGolem()
	{
		local actor = this.getContainer().getActor();
		actor.setMaster(this.m.Master);
		this.m.IsAlive = true;
		this.setTurnLefts(2);
		actor.onActive();
	}
	
	function onDeactivateGolem()
	{
		this.m.IsAlive = false;
		this.m.TurnLefts = 2;
		this.getContainer().getActor().onInactive();
	}
	
	function onNewRound()
	{
		if (!this.IsAlive())
		{
			if (--this.m.TurnLefts <= 0);
			{
				this.onActivateGolem();
			}
		}
		
		this.getContainer().getActor().updatePowerLevelVisuals(this.getPowerLevel());
	}
	
	function onTurnEnd()
	{
		if (this.IsAlive())
		{
			if (--this.m.TurnLefts <= 0)
			{
				this.onDeactivateGolem();
			}
		}
		
		this.getContainer().getActor().updatePowerLevelVisuals(this.getPowerLevel());
	}
	
	function onUpdate( _properties )
	{
		_properties.MeleeDefense += 50;
	}

});