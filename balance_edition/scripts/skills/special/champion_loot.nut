this.champion_loot <- this.inherit("scripts/skills/skill", {
	m = {
		ChampionType = null,
		LootScript = null,
		Killer = null
	},
	function create()
	{
		this.m.ID = "special.champion_loot";
		this.m.Icon = "skills/passive_07.png";
		this.m.IconMini = "passive_07_mini";
		this.m.Type = this.Const.SkillType.Special;
		this.m.IsHidden = true;
		this.m.IsActive = false;
		this.m.IsSerialized = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local excluded = [
			this.Const.EntityType.LegendOrcBehemoth,
			this.Const.EntityType.LegendOrcElite,
			this.Const.EntityType.OrcBerserker,
			this.Const.EntityType.OrcWarlord,
			this.Const.EntityType.OrcWarrior,
			this.Const.EntityType.Hexe,
			this.Const.EntityType.LegendHexeLeader
		];

		if (actor.getFlags().has("human") || (actor.getFlags().has("undead") && !actor.getFlags().has("ghoul")) || actor.getFlags().has("goblin") || excluded.find(actor.getType()) != null)
		{
			this.removeSelf();
		}
		else 
		{
		    this.m.ChampionType = actor.getType();
		    this.pickLoot();
		}
	}

	function pickLoot()
	{
		this.m.LootScript = [];

		switch (this.m.ChampionType) 
		{
	    case this.Const.EntityType.Ghoul:
	        this.m.LootScript.extend([
	        	[2, ["loot/growth_pearls_item"]],
	        	[1, ["accessory/ghoul_trophy_item", "misc/legend_scroll_item"]]
	        ]);
	        break;

	    case this.Const.EntityType.LegendSkinGhoul:
	    	if (this.getContainer().getActor().getSize() == 3)
	    	{
	    		/*if (this.LegendsMod.Configs().LegendArmorsEnabled())
		    	{
		    		this.m.LootScript.extend([
		    			[1, ["legend_helmets/vanity/legend_helmet_nach_helm"]]
		       		]);
		    	}
		    	else
		    	{
		    		this.m.LootScript.extend([
		    			[1, ["helmets/legendary/legend_skin_helmet"]]
		       		]);
		    	}*/

		    	this.m.LootScript.extend([
	    			[1, ["accessory/legend_skin_ghoul_blood_flask_item"]],
	    			[2, ["misc/legend_skin_ghoul_skin_item"]],
	        		[1, ["misc/legend_scroll_item"]]
	       		]);
	    	}
	    	else
	    	{
	    		this.m.LootScript.extend([
	    			[2, ["loot/growth_pearls_item"]],
	    			[1, ["misc/legend_skin_ghoul_skin_item"]],
	        		[1, ["misc/legend_scroll_item"]]
	       		]);
	    	}
	        break;

	    case this.Const.EntityType.Hyena:
	    	if (this.LegendsMod.Configs().LegendArmorsEnabled())
		    {
		    	this.m.LootScript.extend([
		    		[1, ["loot/sabertooth_item"]],
	        		[1, ["legend_armor/armor_upgrades/mod_named_hyena_fur_upgrade"]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[1, ["loot/sabertooth_item"]],
	        		[1, ["armor_upgrades/named/named_hyena_fur_upgrade"]]
	        	]);
		    }
	        break;

	    case this.Const.EntityType.Direwolf:
	        if (this.LegendsMod.Configs().LegendArmorsEnabled())
		    {
		    	this.m.LootScript.extend([
		    		[1, ["loot/sabertooth_item"]],
	        		[1, ["legend_armor/armor_upgrades/mod_named_direwolf_pelt_upgrade"]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[1, ["loot/sabertooth_item"]],
	        		[1, ["armor_upgrades/named/named_direwolf_pelt_upgrade"]]
	        	]);
		    }
	        break;

	    case this.Const.EntityType.LegendWhiteDirewolf:
	        if (this.LegendsMod.Configs().LegendArmorsEnabled())
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/sabertooth_item"]],
		    		[1, ["legend_armor/armor_upgrades/mod_named_armor_white_wolf_pelt_upgrade"/*, "legend_helmets/vanity/legend_helmet_white_wolf_helm"*/]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/sabertooth_item"]],
	        		[1, ["armor_upgrades/named/legend_named_white_wolf_pelt_upgrade"/*,"helmets/legendary/legend_white_wolf_helmet"*/]]
	        	]);
		    }
	        break;

	    case this.Const.EntityType.Lindwurm:
	        if (this.LegendsMod.Configs().LegendArmorsEnabled())
			{
				this.m.LootScript.extend([
					[1, ["tools/acid_flask_item"]],
	    			[1, ["legend_armor/armor_upgrades/mod_named_lindwurm_scales_upgrade", "named_lindwurm_shield"/*, "legend_armor/legendary/legend_lindwurm_armor"*/]]
	       		]);
			}
			else
			{
				this.m.LootScript.extend([
					[1, ["tools/acid_flask_item"]],
	    			[1, ["armor_upgrades/named/named_lindwurm_scales_upgrade", "named_lindwurm_shield"/*, "armor/named/lindwurm_armor"*/]]
	       		]);
			}
	        break;

	    case this.Const.EntityType.LegendStollwurm:
	        if (this.LegendsMod.Configs().LegendArmorsEnabled())
		    {
		    	this.m.LootScript.extend([
		    		[1, ["tools/acid_flask_item"]],
		    		[1, ["legend_armor/armor_upgrades/mod_named_armor_stollwurm_scales_upgrade", "named_lindwurm_shield"/*, "legend_helmets/vanity/legend_helmet_lindwurm_helm"*/]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[1, ["tools/acid_flask_item"]],
	        		[1, ["armor_upgrades/named/legend_named_stollwurm_scales_upgrade", "named_lindwurm_shield"/*, "helmets/legendary/legend_stollwurm_helmet"*/]]
	        	]);
		    }
	        break;

	    case this.Const.EntityType.Unhold:
	    case this.Const.EntityType.BarbarianUnhold:
	    case this.Const.EntityType.UnholdBog:
	        this.m.LootScript.extend([
	        	[2, ["loot/deformed_valuables_item"]],
	        	[2, ["misc/unhold_hide_item"]],
	        	[1, ["accessory/iron_will_potion_item"]]
	        ]);
	        break;

	    case this.Const.EntityType.UnholdFrost:
	   	case this.Const.EntityType.BarbarianUnholdFrost:
	        if (this.LegendsMod.Configs().LegendArmorsEnabled())
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/deformed_valuables_item"]],
	        		[1, ["legend_armor/armor_upgrades/mod_named_unhold_fur_upgrade"]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/deformed_valuables_item"]],
	        		[1, ["armor_upgrades/named/named_unhold_fur_upgrade"]]
	        	]);
		    }
	        break;

	    case this.Const.EntityType.LegendRockUnhold:
	        this.m.LootScript.extend([
	        	[1, ["loot/deformed_valuables_item"]],
	        	[2, ["misc/legend_rock_unhold_hide_item"]],
	        	[1, ["misc/legend_rock_unhold_bones_item"]]
	        ]);
	        break;

	    case this.Const.EntityType.LegendBear:
	        this.m.LootScript.extend([
	        	[1, ["loot/legend_bear_fur_item"]],
	        	[1, ["special/bodily_reward_item", "special/spiritual_reward_item"]],
	        ]);
	        break;

	    case this.Const.EntityType.Spider:
	        this.m.LootScript.extend([
	        	[1, ["loot/webbed_valuables_item"]],
	        	[1, ["misc/miracle_drug_item"]],
	        	[1, ["misc/legend_redback_poison_gland_item"]]
	        ]);
	        break;

	    case this.Const.EntityType.LegendRedbackSpider:
	        if (this.LegendsMod.Configs().LegendArmorsEnabled())
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/webbed_valuables_item"]],
	        		[1, [/*"legend_helmets/vanity/legend_helmet_redback_helm",*/ "legend_armor/armor/legend_armor_redback_cloak_upgrade"]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/webbed_valuables_item"]],
	        		[1, [/*"helmets/legendary/legend_redback_helmet",*/ "armor_upgrades/named/legend_named_redback_cloak_upgrade"]]
	        	]);
		    }
	        break;

	    case this.Const.EntityType.Alp:
	        this.m.LootScript.extend([
	        	[1, ["loot/soul_splinter_item", "misc/petrified_scream_item"]],
	        	[1, ["special/fountain_of_youth_item"]]
	        ]);
	        break;

	    case this.Const.EntityType.LegendDemonAlp:
	        this.m.LootScript.extend([
	        	[1, ["misc/legend_demon_third_eye_item", "misc/legend_demon_alp_skin_item"]],
	        	[1, ["accessory/legend_demonalp_trophy_item", "special/fountain_of_youth_item"]]
	        ]);
	        break;

	    case this.Const.EntityType.Schrat:
	        this.m.LootScript.extend([
	        	[1, ["misc/heart_of_the_forest_item"]],
	        	[1, ["loot/ancient_amber_item"]],
	        	[1, ["shields/special/craftable_schrat_shield"]]
	        ]);
	        break;

	    case this.Const.EntityType.LegendGreenwoodSchrat:
	        this.m.LootScript.extend([
	        	[1, ["misc/heart_of_the_forest_item"]],
	        	[1, ["misc/legend_ancient_green_wood_item"]],
	        	[1, ["shields/special/legend_craftable_greenwood_schrat_shield"]]
	        ]);
	        break;

	    case this.Const.EntityType.Kraken:
	        this.m.LootScript.extend([
	        	[2, ["misc/kraken_tentacle_item"]],
	        	[1, ["misc/kraken_horn_plate_item"]],
	        	[1, ["shields/special/craftable_kraken_shield"]]
	        ]);
	        break;

	    case this.Const.EntityType.TricksterGod:
	        if (this.LegendsMod.Configs().LegendArmorsEnabled())
		    {
		    	this.m.LootScript.extend([
		    		[1, ["legend_armor/legendary/legend_ijirok_armor"]],
		    		[1, ["helmets/legendary/ijirok_helmet"]],
		    	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[1, ["armor/legendary/ijirok_armor"]],
		    		[1, ["helmets/legendary/ijirok_helmet"]],
		    	]);
		    }
	        break;

	    case this.Const.EntityType.Serpent:
	        if (this.LegendsMod.Configs().LegendArmorsEnabled())
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/rainbow_scale_item"]],
	        		[1, ["legend_armor/armor_upgrades/mod_named_serpent_skin_upgrade"]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/rainbow_scale_item"]],
	        		[1, ["armor_upgrades/named/named_serpent_skin_upgrade"]]
	        	]);
		    }
	        break;

	     default:
	     	this.m.LootScript.extend([
	    		[2, ["misc/legend_scroll_item", "misc/potion_of_oblivion_item", "misc/potion_of_knowledge_item"]]
        	]);
		}
	}

	function onDamageReceived(_attacker, _damageHitpoints, _damageArmor)
	{
		if (_damageHitpoints >= this.getContainer().getActor().getHitpoints())
		{
			this.m.Killer = _attacker;
		}
	}

	function onDeath()
	{
		this.skill.onDeath();
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();

		if (this.m.Killer == null || this.m.Killer.getFaction() == this.Const.Faction.Player)
		{
			foreach ( entry in this.m.LootScript )
			{
				for (local i = 0; i < entry[0]; ++i)
				{
					local r = this.MSU.Array.getRandom(entry[1]);
					local item = this.new("scripts/items/" + r);

					if (item.isNamed())
					{
						item.setName(actor.getName());
					}

					myTile.Items.push(item);
					myTile.IsContainingItems = true;
					item.m.Tile = myTile;
				}
			}
		}

		if (this.m.Killer != null && this.isKindOf(this.m.Killer, "player"))
		{
			this.addXP(this.m.Killer, 100);
		}

		/*if (this.Tactical.State.m.StrategicProperties != null && !this.Tactical.State.m.StrategicProperties.IsArenaMode && this.m.LootScript != null && this.m.LootScript.len() > 0)
		{
			if (!("Loot" in this.Tactical.State.m.StrategicProperties))
			{
				this.Tactical.State.m.StrategicProperties.Loot <- [];
			}
			
			local script = "scripts/items/" + this.m.LootScript[this.Math.rand(0, this.m.LootScript.len() - 1)];
			this.Tactical.State.m.StrategicProperties.Loot.push(script);
		}*/

		this.m.Killer = null;
	}

	function addXP( _actor, _xp )
	{
		local isScenarioMode = !(("State" in this.World) && this.World.State != null);

		if (_actor.m.Level >= this.Const.LevelXP.len() || _actor.isGuest() || !isScenarioMode && this.World.Assets.getOrigin().getID() == "scenario.manhunters" && _actor.m.Level >= 7 && _actor.getBackground().getID() == "background.slave")
		{
			return;
		}

		_xp = _xp * this.World.Assets.m.XPMult;

		if (this.World.Retinue.hasFollower("follower.drill_sergeant"))
		{
			_xp = _xp * this.Math.maxf(1.0, 1.2 - 0.02 * (this.m.Level - 1));
		}

		if (_actor.m.XP + _xp * _actor.m.CurrentProperties.XPGainMult >= this.Const.LevelXP[this.Const.LevelXP.len() - 1])
		{
			_actor.m.CombatStats.XPGained += this.Const.LevelXP[this.Const.LevelXP.len() - 1] - _actor.m.XP;
			_actor.m.XP = this.Const.LevelXP[this.Const.LevelXP.len() - 1];
			return;
		}
		else if (!isScenarioMode && this.World.Assets.getOrigin().getID() == "scenario.manhunters" && _actor.m.XP + _xp * _actor.m.CurrentProperties.XPGainMult >= this.Const.LevelXP[6] && _actor.getBackground().getID() == "background.slave")
		{
			_actor.m.CombatStats.XPGained += this.Const.LevelXP[6] - _actor.m.XP;
			_actor.m.XP = this.Const.LevelXP[6];
			return;
		}

		_actor.m.XP += this.Math.floor(_xp * _actor.m.CurrentProperties.XPGainMult);
		_actor.m.CombatStats.XPGained += this.Math.floor(_xp * _actor.m.CurrentProperties.XPGainMult);
	}

});

