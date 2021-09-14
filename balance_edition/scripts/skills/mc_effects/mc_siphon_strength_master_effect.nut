this.mc_siphon_strength_master_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2,
		Efficiency = 1.0,
		Stat = 10,
		Slave = null,
		IsActivated = false
	},
	function getStatMod()
	{
		return this.Math.floor(this.m.Stat * this.m.Efficiency);
	}

	function setEfficiency ( _v )
	{
		this.m.Efficiency = _v;
	}

	function activate()
	{
		this.m.IsActivated = true;
	}

	function setSlave( _p )
	{
		if (_p == null)
		{
			this.m.Slave = null;
		}
		else if (typeof _p == "instance")
		{
			this.m.Slave = _p;
		}
		else
		{
			this.m.Slave = this.WeakTableRef(_p);
		}
	}

	function isAlive()
	{
		return this.getContainer() != null && !this.getContainer().isNull() && this.getContainer().getActor() != null && this.getContainer().getActor().isAlive() && this.getContainer().getActor().getHitpoints() > 0;
	}

	function create()
	{
		this.m.ID = "effects.mc_siphon_strength_master";
		this.m.Name = "Benefited by Siphon Strength";
		this.m.Icon = "skills/effect_mc_05.png";
		this.m.IconMini = "effect_mc_05_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsHidden = false;
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 2;
	}

	function onTurnStart()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

	function onUpdate( _properties )
	{
		if (this.m.IsActivated && (this.m.Slave == null || this.m.Slave.isNull() || !this.m.Slave.isAlive()))
		{
			this.removeSelf();
		}
		else
		{
			local mod = this.getStatMod();
			_properties.TargetAttractionMult *= 1.1;
			_properties.MeleeSkill += mod;
			_properties.RangedSkill += mod;
			_properties.MeleeDefense += mod;
			_properties.RangedDefense += mod;
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		if (this.m.Slave != null && !this.m.Slave.isNull() && !this.m.Slave.getContainer().isNull())
		{
			local slave = this.m.Slave;
			this.m.Slave = null;
			slave.setMaster(null);
			slave.removeSelf();
			slave.getContainer().update();
		}
	}

	function onDeath()
	{
		this.onRemoved();
	}

});

