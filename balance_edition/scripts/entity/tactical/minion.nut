this.minion <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Dominate = null,
		Master = null,
		Weight = 0,
		IsGuest = true,
		Talents = [],
		CombatStats = {
			DamageDealtHitpoints = 0,
			DamageDealtArmor = 0,
			DamageReceivedHitpoints = 0,
			DamageReceivedArmor = 0,
			Kills = 0,
			XPGained = 0
		},
		LifetimeStats = {
			Kills = 0,
			Battles = 0,
			BattlesWithoutMe = 0,
			MostPowerfulVanquished = "",
			MostPowerfulVanquishedXP = 0,
			MostPowerfulVanquishedType = 0,
			FavoriteWeapon = "",
			FavoriteWeaponUses = 0,
			CurrentWeaponUses = 0,
			Tags = null
		},
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

	function getCombatStats()
	{
		return this.m.Master != null && !this.m.Master.isNull() ? this.m.Master.getCombatStats() : this.m.CombatStats;
	}

	function getLifetimeStats()
	{
		return this.m.Master != null && !this.m.Master.isNull() ? this.m.Master.getLifetimeStats() : this.m.LifetimeStats;
	}
	
	function getDominate()
	{
		return this.m.Dominate;
	}
	
	function setDominate( _d )
	{
		this.m.Dominate = _d;
	}
	
	function getWeight()
	{
		return this.m.Weight;
	}
	
	function setWeight( _value )
	{
		this.m.Weight = _value;
	}

	function setGuest( _f )
	{
		this.m.IsGuest = true;
	}

	function isGuest()
	{
		return this.m.IsGuest;
	}

	function getPlaceInFormation()
	{
		return 21;
	}

	function getTalents()
	{
		return this.m.Talents;
	}

	function getBackground()
	{
		return null;
	}

	function isPlayerControlled()
	{
		return this.m.IsControlledByPlayer && (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals);
	}

	function getImagePath( _ignoreLayers = [] )
	{
		local result = "tacticalentity(" + this.m.ContentID + "," + this.getID() + ",socket,miniboss,arrow";

		for( local i = 0; i < _ignoreLayers.len(); i = i )
		{
			result = result + ("," + _ignoreLayers[i]);
			i = ++i;
		}

		result = result + ")";
		return result;
	}

	function getOverlayImage()
	{
		if (this.m.Type == 106 || this.m.Type == 107 || this.m.Type == 108 || this.m.Type == 109 || this.m.Type == 110)
		{
			return "zombie_02_orientation";
		}
		else
		{
			return this.Const.EntityIcon[this.m.Type];
		}
	}

	function create()
	{
		this.m.Talents.resize(this.Const.Attributes.COUNT, 0);
		this.m.IsControlledByPlayer = true;
		this.m.IsSummoned = true;
		this.actor.create();
		this.getFlags().add("can_be_possessed");
		this.getFlags().set("PotionLastUsed", 0.0);
		this.getFlags().set("PotionsUsed", 0);
		this.m.LifetimeStats.Tags = this.new("scripts/tools/tag_collection");
		this.m.Items.getData()[this.Const.ItemSlot.Offhand][0] = -1;
		this.m.Items.getData()[this.Const.ItemSlot.Mainhand][0] = -1;
		this.m.Items.getData()[this.Const.ItemSlot.Head][0] = -1;
		this.m.Items.getData()[this.Const.ItemSlot.Body][0] = -1;
		this.m.Items.getData()[this.Const.ItemSlot.Ammo][0] = -1;
	}

	function onInit()
	{
		this.actor.onInit();
		this.m.Skills.add(this.new("scripts/skills/effects/battle_standard_effect"));
		this.m.Skills.add(this.new("scripts/skills/actives/break_ally_free_skill"));

		if (this.Const.DLC.Unhold)
		{
			this.m.Skills.add(this.new("scripts/skills/actives/wake_ally_skill"));
		}
	}
	
	function onActorKilled( _actor, _tile, _skill )
	{
		if (!this.m.IsAlive || this.m.IsDying)
		{
			return;
		}
		
		if (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local XPkiller = this.Math.floor(_actor.getXPValue() * this.Const.XP.XPForKillerPct);
			local XPgroup = _actor.getXPValue() * (1.0 - this.Const.XP.XPForKillerPct);
			this.addXP(XPkiller);
			local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
			
			if (this.m.Master != null && !this.m.Master.isNull() && this.m.Master.isAlive() && !this.m.Master.isDying())
			{
				this.getMaster().getCombatStats().Kills += 1;
				this.getMaster().getLifetimeStats().Kills += 1;
				this.Const.LegendMod.SetFavoriteEnemyKill(this.getMaster(), _actor);
			}
			
			if (brothers.len() == 1)
			{
				this.addXP(XPgroup);
			}
			else
			{
				foreach( bro in brothers )
				{
					bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
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
	
	function afterLoad()
	{
		this.setFaction(this.Const.Faction.PlayerAnimals);
	}

	function onAfterInit()
	{
		this.updateOverlay();
		this.setSpriteOffset("status_rooted_back", this.getSpriteOffset("status_rooted"));
		this.getSprite("status_rooted_back").Scale = this.getSprite("status_rooted").Scale;
		this.setDiscovered(true);
	}

	function onUpdateInjuryLayer()
	{
		if (!this.hasSprite("injury"))
		{
			return;
		}

		local injury = this.getSprite("injury");
		local p = this.getHitpointsPct();

		if (p > 0.5)
		{
			if (injury.Visible)
			{
				injury.Visible = false;

				if (this.hasSprite("injury_skin"))
				{
					this.getSprite("injury_skin").Visible = false;
				}

				if (this.hasSprite("injury_body"))
				{
					this.getSprite("injury_body").Visible = false;
				}

				this.setDirty(true);
			}
		}
		else if (!injury.Visible)
		{
			injury.Visible = true;

			if (this.hasSprite("injury_skin"))
			{
				this.getSprite("injury_skin").Visible = true;
			}

			if (this.hasSprite("injury_body"))
			{
				this.getSprite("injury_body").Visible = true;
			}

			this.setDirty(true);
		}
	}

	function onBeforeCombatResult()
	{
		if (this.Math.rand(1, 100) <= 25)
		{
			this.getItems().dropAll(null, null, false);
		}
		
		this.killSilently();
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

