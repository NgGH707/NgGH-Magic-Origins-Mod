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
	    	this.m.LootScript.extend([
	    		[1, ["loot/sabertooth_item"]],
        		[1, ["legend_armor/armor_upgrades/nggh_mod_named_hyena_fur_legend_upgrade"]]
        	]);
	        break;

	    case ::Const.EntityType.Direwolf:
	    	this.m.LootScript.extend([
	    		[1, ["loot/sabertooth_item"]],
        		[1, ["legend_armor/armor_upgrades/nggh_mod_named_direwolf_pelt_legend_upgrade"]]
        	]);
	        break;

	    case ::Const.EntityType.LegendWhiteDirewolf:
	    	this.m.LootScript.extend([
	    		[2, ["loot/sabertooth_item"]],
	    		[1, ["legend_armor/armor_upgrades/nggh_mod_named_white_wolf_pelt_legend_upgrade"]]
        	]);
	        break;

	    case ::Const.EntityType.Lindwurm:
			this.m.LootScript.extend([
				[1, ["tools/acid_flask_item"]],
    			[1, ["legend_armor/armor_upgrades/nggh_mod_named_lindwurm_scales_legend_upgrade", "shields/named/named_lindwurm_shield"]]
       		]);
	        break;

	    case ::Const.EntityType.LegendStollwurm:
	    	this.m.LootScript.extend([
	    		[1, ["tools/acid_flask_item"]],
	    		[1, ["legend_armor/armor_upgrades/nggh_mod_named_stollwurm_scales_legend_upgrade", "shields/named/named_lindwurm_shield"]]
        	]);
	        break;

	    case ::Const.EntityType.Unhold:
	    case ::Const.EntityType.BarbarianUnhold:
	    case ::Const.EntityType.UnholdBog:
	   		this.m.BonusXP += 150;
	        this.m.LootScript.extend([
	        	[2, ["loot/deformed_valuables_item"]],
	        	[1, ["misc/unhold_hide_item"]],
	        	[1, ["accessory/iron_will_potion_item"]]
	        ]);
	        break;

	    case ::Const.EntityType.UnholdFrost:
	   	case ::Const.EntityType.BarbarianUnholdFrost:
	    	this.m.LootScript.extend([
	    		[1, ["loot/deformed_valuables_item"]],
        		[1, ["legend_armor/armor_upgrades/nggh_mod_named_unhold_fur_legend_upgrade"]]
        	]);
	        break;

	    case ::Const.EntityType.LegendRockUnhold:
	   		this.m.BonusXP += 250;
	        this.m.LootScript.extend([
	        	[1, ["loot/deformed_valuables_item"]],
	        	[2, ["misc/legend_rock_unhold_hide_item"]],
	        	[1, ["misc/legend_rock_unhold_bones_item"]]
	        ]);
	        break;

	    case ::Const.EntityType.LegendBear:
	    	this.m.BonusXP += 125;
	        this.m.LootScript.extend([
	        	[1, ["loot/legend_bear_fur_item"]],
	        	[1, ["special/bodily_reward_item", "special/spiritual_reward_item"]],
	        ]);
	        break;

	    case ::Const.EntityType.Spider:
	    	this.m.LootScript.extend([
	    		[1, ["loot/webbed_valuables_item"]],
        		[1, ["legend_armor/armor_upgrades/nggh_mod_named_light_padding_replacement_legend_upgrade"]]
        	]);
	        break;

	    case ::Const.EntityType.LegendRedbackSpider:
	    	this.m.LootScript.extend([
	    		[2, ["loot/webbed_valuables_item"]],
        		[1, ["legend_armor/armor/legend_armor_redback_cloak_upgrade"]]
        	]);
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
	        	[1, ["shields/named/mod_nggh_named_schrat_shield"]]
	        ]);
	        break;

	    case ::Const.EntityType.LegendGreenwoodSchrat:
	    	this.m.BonusXP += 100;
	        this.m.LootScript.extend([
	        	[1, ["misc/heart_of_the_forest_item"]],
	        	[1, ["misc/legend_ancient_green_wood_item"]],
	        	[1, ["shields/named/mod_nggh_named_schrat_shield"]]
	        ]);
	        break;

	    case ::Const.EntityType.Kraken:
	    	this.m.BonusXP += 400;
	        this.m.LootScript.extend([
	        	[2, ["misc/kraken_tentacle_item", "misc/kraken_horn_plate_item"]],
	        	[1, ["legend_armor/armor_upgrades/nggh_mod_named_horn_plate_legend_upgrade"]],
	        	[1, ["shields/special/craftable_kraken_shield"]]
	        ]);
	        break;

	    case ::Const.EntityType.TricksterGod:
	    	this.m.BonusXP += 900;
	    	this.m.LootScript.extend([
	    		[1, ["legend_armor/legendary/legend_ijirok_armor"]],
	    		[1, ["helmets/legendary/ijirok_helmet"]],
	    	]);
	        break;

	    case ::Const.EntityType.Serpent:
	    	this.m.LootScript.extend([
	    		[2, ["loot/rainbow_scale_item"]],
        		[1, ["legend_armor/armor_upgrades/nggh_mod_named_serpent_skin_legend_upgrade"]]
        	]);
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
			this.m.Killer = _attacker;
	}

	function onDeath( _fatalityType )
	{
		this.skill.onDeath( _fatalityType );
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();

		if (typeof this.m.Killer == "instance")
			this.m.Killer = this.m.Killer.get();

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
							item.m.Name = actor.getName() + "\'s Scale";
						else
							item.setName(actor.getName());
					}

					myTile.Items.push(item);
					myTile.IsContainingItems = true;
					item.m.Tile = myTile;
				}
			}
		}

		if (this.m.Killer != null && ::isKindOf(this.m.Killer, "player"))
			this.m.Killer.addXP(this.m.BonusXP);

		this.m.Killer = null;
	}

});

