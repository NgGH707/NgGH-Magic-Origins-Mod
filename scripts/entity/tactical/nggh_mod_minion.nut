this.nggh_mod_minion <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Master = null,
	},
	
	function getMaster()
	{
		return this.m.Master;
	}
	
	function setMaster( _m )
	{
		if (_m == null)
		{
			this.m.Master = null;
		}
		else if (typeof _m == "instance")
		{
			this.m.Master = _m;
		}
		else 
		{
		 	this.m.Master = this.WeakTableRef(_m);   
		}
	}

	function create()
	{
		this.m.IsControlledByPlayer = true;
		this.m.IsSummoned = true;
		this.actor.create();
		this.getFlags().add("can_be_possessed");
		this.getFlags().set("PotionLastUsed", 0.0);
		this.getFlags().set("PotionsUsed", 0);
		this.m.Items.getData()[::Const.ItemSlot.Offhand][0] = -1;
		this.m.Items.getData()[::Const.ItemSlot.Mainhand][0] = -1;
		this.m.Items.getData()[::Const.ItemSlot.Head][0] = -1;
		this.m.Items.getData()[::Const.ItemSlot.Body][0] = -1;
		this.m.Items.getData()[::Const.ItemSlot.Ammo][0] = -1;
	}

	function onInit()
	{
		this.actor.onInit();
		this.m.Skills.add(::new("scripts/skills/effects/battle_standard_effect"));
		this.m.Skills.add(::new("scripts/skills/actives/break_ally_free_skill"));

		if (this.Const.DLC.Unhold)
		{
			this.m.Skills.add(::new("scripts/skills/actives/wake_ally_skill"));
		}
	}
	
	function onActorKilled( _actor, _tile, _skill )
	{
		if (!this.m.IsAlive || this.m.IsDying)
		{
			return;
		}
		
		if (this.getFaction() == ::Const.Faction.Player || this.getFaction() == ::Const.Faction.PlayerAnimals)
		{
			local XPkiller = ::Math.floor(_actor.getXPValue() * ::Const.XP.XPForKillerPct);
			local XPgroup = _actor.getXPValue() * (1.0 - ::Const.XP.XPForKillerPct);
			this.addXP(XPkiller);
			local brothers = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player);
			
			if (this.m.Master != null && !this.m.Master.isNull() && this.m.Master.isAlive() && !this.m.Master.isDying())
			{
				this.getMaster().getCombatStats().Kills += 1;
				this.getMaster().getLifetimeStats().Kills += 1;
			}
			
			if (brothers.len() == 1)
			{
				this.addXP(XPgroup);
			}
			else
			{
				foreach( bro in brothers )
				{
					bro.addXP(::Math.max(1, ::Math.floor(XPgroup / brothers.len())));
				}
			}
		}

		this.m.Skills.onTargetKilled(_actor, _skill);
	}
	
	function addXP( _xp, _scale = true )
	{
		if (this.m.Master != null && !this.m.Master.isNull() && this.m.Master.isAlive() && !this.m.Master.isDying())
		{
			this.getMaster().addXP(_xp);
		}
	}

	function onResurrected( _info )
	{
		this.setFaction(_info.Faction);
		this.getItems().clear();
		
		if (_info.Items != null)
		{
			_info.Items.transferTo(this.getItems());
		}

		if (_info.Name.len() != 0)
		{
			this.m.Name = _info.Name;
		}

		if (_info.Description.len() != 0)
		{
			this.m.Description = _info.Description;
		}

		this.m.Hitpoints = this.getHitpointsMax() * _info.Hitpoints;
		this.m.XP = this.Math.floor(this.m.XP * _info.Hitpoints);
		this.m.BaseProperties.Armor = _info.Armor;
		this.onUpdateInjuryLayer();
	}
	
	function getPercentOnKillOtherActorModifier()
	{
		return 1.0;
	}
	
	function getFlatOnKillOtherActorModifier()
	{
		return 1.0;
	}
	
	function getRosterTooltip()
	{
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			}
		];
		
		return tooltip;
	}

});

