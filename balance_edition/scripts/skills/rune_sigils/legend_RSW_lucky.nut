this.legend_RSW_lucky <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.legend_RSW_lucky";
		this.m.Name = "Rune Sigil: Lucky";
		this.m.Description = "Rune Sigil: Lucky";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (this.getItem() == null || _targetEntity.getXPValue() <= 0)
		{
			return;
		}

		local actor = this.getContainer().getActor();
		local chance = this.Math.floor(_targetEntity.getXPValue() / this.Const.MC_Combat.LuckyRuneChanceModifier);
		local rolled = this.Math.rand(1, 100);
		
		if (rolled > chance)
		{
			this.Tactical.EventLog.logEx("Hope you get lucky next time " + " (Chance: " + chance + ", Rolled: " + rolled + ")");
		}
		else
		{
			local r = this.Math.rand(1, 100);
			local drops_table = [
				[
					40,
					"supplies/money_item"
				],
				[
					10,
					"supplies/legend_pie_item"
				],
				[
					10,
					"misc/poison_gland_item"
				],
				[
					10,
					"trade/cloth_rolls_item"
				],
				[
					5,
					"misc/ghoul_teeth_item"
				],
				[
					5,
					"tools/throwing_net"
				],
				[
					5,
					"loot/goblin_rank_insignia_item"
				],
				[
					5,
					"loot/bead_necklace_item"
				],
				[
					5,
					"trade/quality_wood_item"
				],
				[
					5,
					"trade/peat_bricks_item"
				],
			];

			if (r == 1)
			{
				drops_table = [
			    	[
						1,
						"special/trade_jug_01_item"
					],
					[
						1,
						"special/fountain_of_youth_item"
					],
					[
						1,
						"special/fountain_of_youth_item"
					],
					[
						1,
						"misc/kraken_horn_plate_item"
					],
					[
						1,
						"misc/legend_ancient_scroll_item"
					],
				];

				local total = [];
				total.extend(clone this.Const.Items.NamedWeapons);
				total.extend(clone this.Const.Items.NamedUndeadWeapons);
				total.extend(clone this.Const.Items.NamedGoblinWeapons);
				total.extend(clone this.Const.Items.NamedOrcWeapons);
				total.extend(clone this.Const.Items.NamedOrcShields);
				total.extend(clone this.Const.Items.NamedUndeadShields);
				total.extend(clone this.Const.Items.NamedBanditShields);
				total.extend(clone this.Const.Items.NamedShields);

				if (this.LegendsMod.Configs().LegendArmorsEnabled())
				{
				    total.extend(clone this.Const.Items.LegendNamedArmorLayers);
				    total.extend(clone this.Const.Items.LegendNamedHelmetLayers);
				}
				else 
				{
				    total.extend(clone this.Const.Items.NamedArmors);
				    total.extend(clone this.Const.Items.NamedHelmets);
				}

				foreach ( script in total ) 
				{
				    drops_table.push([
				    	1,
				    	script
				    ]);
				}
			}
			else if (r <= 6) 
			{
			    drops_table = [
			    	[
			    		5,
			    		"misc/legend_stollwurm_scales_item"
			    	],
			    	[
			    		10,
			    		"misc/legend_demon_hound_bones_item"
			    	],
			    	[
			    		10,
			    		"misc/legend_ancient_green_wood_item"
			    	],
			    	[
			    		10,
			    		"misc/legend_banshee_essence_item"
			    	],
			   		[
						10,
						"misc/legend_demon_third_eye_item"
					],
					[
						10,
						"misc/legend_demon_third_eye_item"
					],
					[
						10,
						"misc/legend_redback_poison_gland_item"
					],
					[
						10,
						"misc/legend_rock_unhold_hide_item"
					],
					[
						10,
						"misc/legend_skin_ghoul_skin_item"
					],
					[
						10,
						"misc/legend_white_wolf_pelt_item"
					],
					[
						10,
						"misc/legend_witch_leader_hair_item"
					],
					[
						5,
						"misc/potion_of_oblivion_item"
					],
					[
						10,
						"misc/legend_scroll_item"
					],
				];
			}
			else if (r <= 16) 
			{
			    drops_table = [
					[
						20,
						"loot/looted_valuables_item"
					],
					[
						15,
						"misc/heart_of_the_forest_item"
					],
					[
						15,
						"misc/happy_powder_item"
					],
					[
						15,
						"misc/miracle_drug_item"
					],
					[
						10,
						"misc/snake_oil_item"
					],
					[
						10,
						"misc/potion_of_knowledge_item"
					],
					[
						5,
						"accessory/legend_warbear_item"
					],
					[
						10,
						"accessory/legend_cat_item"
					],
					[
						10,
						"special/bodily_reward_item"
					],
					[
						5,
						"special/spiritual_reward_item"
					]
				];
			}
			else if (r <= 40) 
			{
			   drops_table = [
					[
						20,
						"trade/copper_ingots_item"
					],
					[
						15,
						"trade/amber_shards_item"
					],
					[
						10,
						"tools/smoke_bomb_item"
					],
					[
						10,
						"accessory/night_vision_elixir_item"
					],
					[
						10,
						"accessory/iron_will_potion_item"
					],
					[
						5,
						"tools/fire_bomb_item"
					],
					[
						5,
						"tools/acid_flask_item"
					],
					[
						5,
						"tools/daze_bomb_item"
					],
					[
						10,
						"accessory/antidote_item"
					],
					[
						10,
						"tools/holy_water_item"
					],
				];
			}
			
			local tile = _targetEntity.getTile();
			local item = this.Const.World.Common.pickItem(drops_table, "scripts/items/");
			local name = item.getName();

			if (item.getID() == "supplies.money")
			{
				item.setAmount(this.Math.rand(10, 20) * 10);
				name =  item.getAmount() + " crowns";
			}

			for( local i = 0; i < this.Const.Tactical.DazeParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DazeParticles[i].Brushes, tile, this.Const.Tactical.DazeParticles[i].Delay, this.Const.Tactical.DazeParticles[i].Quantity, this.Const.Tactical.DazeParticles[i].LifeTimeQuantity, this.Const.Tactical.DazeParticles[i].SpawnRate, this.Const.Tactical.DazeParticles[i].Stages);
			}

			//item.drop(tile);
			tile.Items.push(this);
			tile.IsContainingItems = true;
			item.m.Tile = _tile;
			this.Tactical.EventLog.logEx("[color=" + this.Const.UI.Color.NegativeValue + "]Wow!!![/color] you get [color=#0b0084]" + name + "[/color] as bonus loot due to " + this.Const.UI.getColorizedEntityName(actor) + "\'s Lucky rune");
		}
	}

});

