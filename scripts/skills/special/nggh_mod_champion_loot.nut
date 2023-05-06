this.nggh_mod_champion_loot <- ::inherit("scripts/skills/skill", {
	m = {
		BonusXP = 100,
		Killer = null
		LootScript = null,
		ChampionType = null,	
	},
	function create()
	{
		this.m.ID = "special.champion_loot";
		this.m.Icon = "skills/passive_07.png";
		this.m.IconMini = "passive_07_mini";
		this.m.Type = ::Const.SkillType.Special;
		this.m.IsHidden = true;
		this.m.IsActive = false;
		this.m.IsSerialized = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local excluded = [
			::Const.EntityType.LegendOrcBehemoth,
			::Const.EntityType.LegendOrcElite,
			::Const.EntityType.OrcBerserker,
			::Const.EntityType.OrcWarlord,
			::Const.EntityType.OrcWarrior,
			::Const.EntityType.Hexe,
			::Const.EntityType.LegendHexeLeader
		];

		if (actor.getFlags().has("human") || (actor.getFlags().has("undead") && !actor.getFlags().has("ghoul")) || actor.getFlags().has("goblin") || excluded.find(actor.getType()) != null)
		{
			this.removeSelf();
			return;
		}
		
	    this.m.ChampionType = actor.getType();
	    this.pickLoot();
	}

	function pickLoot()
	{
		this.m.LootScript = [];

		switch (this.m.ChampionType) 
		{
	    case ::Const.EntityType.Ghoul:
	        this.m.LootScript.extend([
	        	[2, ["loot/growth_pearls_item"]],
	        	[1, ["accessory/named/nggh_mod_named_ghoul_trophy_item"]]
	        ]);
	        break;

	    case ::Const.EntityType.LegendSkinGhoul:
	    	if (this.getContainer().getActor().getSize() == 3)
	    	{
		    	this.m.LootScript.extend([
	    			[1, ["accessory/legend_skin_ghoul_blood_flask_item"]],
	    			[1, ["accessory/named/nggh_mod_named_ghoul_trophy_item"]],
	        		[1, ["misc/legend_ancient_scroll_item"]]
	       		]);
	    	}
	    	else
	    	{
	    		this.m.LootScript.extend([
	    			[2, ["loot/growth_pearls_item"]],
	    			[1, ["accessory/named/nggh_mod_named_ghoul_trophy_item"]],
	        		[1, ["misc/legend_ancient_scroll_item"]]
	       		]);
	    	}
	        break;

	    case ::Const.EntityType.Hyena:
	    	if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		    {
		    	this.m.LootScript.extend([
		    		[1, ["loot/sabertooth_item"]],
	        		[1, ["legend_armor/armor_upgrades/nggh_mod_named_hyena_fur_legend_upgrade"]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[1, ["loot/sabertooth_item"]],
	        		[1, ["armor_upgrades/named/nggh_mod_named_hyena_fur_upgrade"]]
	        	]);
		    }
	        break;

	    case ::Const.EntityType.Direwolf:
	        if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		    {
		    	this.m.LootScript.extend([
		    		[1, ["loot/sabertooth_item"]],
	        		[1, ["legend_armor/armor_upgrades/nggh_mod_named_direwolf_pelt_legend_upgrade"]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[1, ["loot/sabertooth_item"]],
	        		[1, ["armor_upgrades/named/nggh_mod_named_direwolf_pelt_upgrade"]]
	        	]);
		    }
	        break;

	    case ::Const.EntityType.LegendWhiteDirewolf:
	        if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/sabertooth_item"]],
		    		[1, ["legend_armor/armor_upgrades/nggh_mod_named_white_wolf_pelt_legend_upgrade"]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/sabertooth_item"]],
	        		[1, ["armor_upgrades/named/nggh_mod_named_white_wolf_pelt_upgrade"]]
	        	]);
		    }
	        break;

	    case ::Const.EntityType.Lindwurm:
	        if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
			{
				this.m.LootScript.extend([
					[1, ["tools/acid_flask_item"]],
	    			[1, ["legend_armor/armor_upgrades/nggh_mod_named_lindwurm_scales_legend_upgrade", "shields/named/named_lindwurm_shield"/*, "legend_armor/legendary/legend_lindwurm_armor"*/]]
	       		]);
			}
			else
			{
				this.m.LootScript.extend([
					[1, ["tools/acid_flask_item"]],
	    			[1, ["armor_upgrades/named/nggh_mod_named_lindwurm_scales_upgrade", "shields/named/named_lindwurm_shield"/*, "armor/named/lindwurm_armor"*/]]
	       		]);
			}
	        break;

	    case ::Const.EntityType.LegendStollwurm:
	        if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		    {
		    	this.m.LootScript.extend([
		    		[1, ["tools/acid_flask_item"]],
		    		[1, ["legend_armor/armor_upgrades/nggh_mod_named_stollwurm_scales_legend_upgrade", "shields/named/named_lindwurm_shield"]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[1, ["tools/acid_flask_item"]],
	        		[1, ["armor_upgrades/named/nggh_mod_named_stollwurm_scales_upgrade", "shields/named/named_lindwurm_shield"]]
	        	]);
		    }
	        break;

	    case ::Const.EntityType.Unhold:
	    case ::Const.EntityType.BarbarianUnhold:
	    case ::Const.EntityType.UnholdBog:
	   		this.m.BonusXP += 100;
	        this.m.LootScript.extend([
	        	[2, ["loot/deformed_valuables_item"]],
	        	[1, ["misc/unhold_hide_item"]],
	        	[1, ["accessory/iron_will_potion_item"]]
	        ]);
	        break;

	    case ::Const.EntityType.UnholdFrost:
	   	case ::Const.EntityType.BarbarianUnholdFrost:
	        if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		    {
		    	this.m.LootScript.extend([
		    		[1, ["loot/deformed_valuables_item"]],
	        		[1, ["legend_armor/armor_upgrades/nggh_mod_named_unhold_fur_legend_upgrade"]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[1, ["loot/deformed_valuables_item"]],
	        		[1, ["armor_upgrades/named/nggh_mod_named_unhold_fur_upgrade"]]
	        	]);
		    }
	        break;

	    case ::Const.EntityType.LegendRockUnhold:
	   		this.m.BonusXP += 150;
	        this.m.LootScript.extend([
	        	[1, ["loot/deformed_valuables_item"]],
	        	[2, ["misc/legend_rock_unhold_hide_item"]],
	        	[1, ["misc/legend_rock_unhold_bones_item"]]
	        ]);
	        break;

	    case ::Const.EntityType.LegendBear:
	    	this.m.BonusXP += 75;
	        this.m.LootScript.extend([
	        	[1, ["loot/legend_bear_fur_item"]],
	        	[1, ["special/bodily_reward_item", "special/spiritual_reward_item"]],
	        ]);
	        break;

	    case ::Const.EntityType.Spider:
	        if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		    {
		    	this.m.LootScript.extend([
		    		[1, ["loot/webbed_valuables_item"]],
	        		[1, ["legend_armor/armor_upgrades/nggh_mod_named_light_padding_replacement_legend_upgrade"]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[1, ["loot/webbed_valuables_item"]],
	        		[1, ["armor_upgrades/named/nggh_mod_named_light_padding_replacement_upgrade"]]
	        	]);
		    }
	        break;

	    case ::Const.EntityType.LegendRedbackSpider:
	        if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/webbed_valuables_item"]],
	        		[1, ["legend_armor/armor/legend_armor_redback_cloak_upgrade"]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/webbed_valuables_item"]],
	        		[1, ["armor_upgrades/named/nggh_mod_named_redback_cloak_upgrade"]]
	        	]);
		    }
	        break;

	    case ::Const.EntityType.Alp:
	    	this.m.BonusXP += 25;
	        this.m.LootScript.extend([
	        	[1, ["loot/soul_splinter_item", "misc/petrified_scream_item"]],
	        	[1, ["accessory/named/nggh_mod_named_alp_trophy_item"]]
	        ]);
	        break;

	    case ::Const.EntityType.LegendDemonAlp:
	    	this.m.BonusXP += 100;
	        this.m.LootScript.extend([
	        	[1, ["misc/legend_demon_third_eye_item", "misc/legend_demon_alp_skin_item"]],
	        	[1, ["accessory/legend_demonalp_trophy_item", "special/fountain_of_youth_item"]]
	        ]);
	        break;

	    case ::Const.EntityType.Schrat:
	    	this.m.BonusXP += 50;
	        this.m.LootScript.extend([
	        	[1, ["misc/heart_of_the_forest_item"]],
	        	[1, ["loot/ancient_amber_item"]],
	        	[1, ["shields/special/craftable_schrat_shield"]]
	        ]);
	        break;

	    case ::Const.EntityType.LegendGreenwoodSchrat:
	    	this.m.BonusXP += 100;
	        this.m.LootScript.extend([
	        	[1, ["misc/heart_of_the_forest_item"]],
	        	[1, ["misc/legend_ancient_green_wood_item"]],
	        	[1, ["shields/special/legend_craftable_greenwood_schrat_shield"]]
	        ]);
	        break;

	    case ::Const.EntityType.Kraken:
	    	this.m.BonusXP += 400;
	        this.m.LootScript.extend([
	        	[2, ["misc/kraken_tentacle_item", "misc/kraken_horn_plate_item"]],
	        	[1, ["shields/special/craftable_kraken_shield"]]
	        ]);
	        if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		    {
		    	this.m.LootScript.push(
		    		[1, ["legend_armor/armor_upgrades/nggh_mod_named_horn_plate_legend_upgrade"]]
		    	);
		    }
		    else
		    {
		    	this.m.LootScript.push(
		    		[1, ["armor_upgrades/named/nggh_mod_named_horn_plate_upgrade"]]
		    	);
		    }
	        break;

	    case ::Const.EntityType.TricksterGod:
	    	this.m.BonusXP += 900;
	        if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
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

	    case ::Const.EntityType.Serpent:
	        if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/rainbow_scale_item"]],
	        		[1, ["legend_armor/armor_upgrades/nggh_mod_named_serpent_skin_legend_upgrade"]]
	        	]);
		    }
		    else
		    {
		    	this.m.LootScript.extend([
		    		[2, ["loot/rainbow_scale_item"]],
	        		[1, ["armor_upgrades/named/nggh_mod_named_serpent_skin_upgrade"]]
	        	]);
		    }
	        break;

	     default:
	     	this.m.BonusXP *= 2;
	     	this.m.LootScript.extend([
	    		[2, ["misc/legend_ancient_scroll_item", "misc/potion_of_oblivion_item", "misc/potion_of_knowledge_item", "misc/potion_of_knowledge_item"]]
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

	function onDeath( _fatalityType )
	{
		this.skill.onDeath( _fatalityType );
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();

		if (typeof this.m.Killer == "instance")
		{
			this.m.Killer = this.m.Killer.get();
		}

		if (this.m.Killer == null || this.m.Killer.getFaction() == ::Const.Faction.Player || this.m.Killer.getFaction() == ::Const.Faction.PlayerAnimals)
		{
			foreach ( entry in this.m.LootScript )
			{
				for (local i = 0; i < entry[0]; ++i)
				{
					local r = ::MSU.Array.rand(entry[1]);
					local item = ::new("scripts/items/" + r);

					if (item.isItemType(::Const.Items.ItemType.Named))
					{
						if (item.isItemType(::Const.Items.ItemType.Shield))
						{
							item.m.Name = actor.getName() + "\'s Scale";
						}
						else
						{
							item.setName(actor.getName());
						}
					}

					myTile.Items.push(item);
					myTile.IsContainingItems = true;
					item.m.Tile = myTile;
				}
			}
		}

		if (this.m.Killer != null && ::isKindOf(this.m.Killer, "player"))
		{
			this.addXP(this.m.Killer, this.m.BonusXP);
		}

		this.m.Killer = null;
	}

	function addXP( _actor, _xp )
	{
		_actor.addXP(_xp);
		return;

		local isScenarioMode = !(("State" in ::World) && ::World.State != null);

		if (_actor.m.Level >= ::Const.LevelXP.len() || _actor.isGuest() || !isScenarioMode && ::World.Assets.getOrigin().getID() == "scenario.manhunters" && _actor.m.Level >= 7 && _actor.getBackground().getID() == "background.slave")
		{
			return;
		}

		_xp = _xp * ::World.Assets.m.XPMult;

		if (::World.Retinue.hasFollower("follower.drill_sergeant"))
		{
			_xp = _xp * ::Math.maxf(1.0, 1.2 - 0.02 * (_actor.m.Level - 1));
		}

		if (_actor.m.XP + _xp * _actor.m.CurrentProperties.XPGainMult >= ::Const.LevelXP[::Const.LevelXP.len() - 1])
		{
			_actor.m.CombatStats.XPGained += ::Const.LevelXP[::Const.LevelXP.len() - 1] - _actor.m.XP;
			_actor.m.XP = ::Const.LevelXP[::Const.LevelXP.len() - 1];
			return;
		}
		else if (!isScenarioMode && ::World.Assets.getOrigin().getID() == "scenario.manhunters" && _actor.m.XP + _xp * _actor.m.CurrentProperties.XPGainMult >= ::Const.LevelXP[6] && _actor.getBackground().getID() == "background.slave")
		{
			_actor.m.CombatStats.XPGained += ::Const.LevelXP[6] - _actor.m.XP;
			_actor.m.XP = ::Const.LevelXP[6];
			return;
		}

		_actor.m.XP += ::Math.floor(_xp * _actor.m.CurrentProperties.XPGainMult);
		_actor.m.CombatStats.XPGained += ::Math.floor(_xp * _actor.m.CurrentProperties.XPGainMult);
	}

});

