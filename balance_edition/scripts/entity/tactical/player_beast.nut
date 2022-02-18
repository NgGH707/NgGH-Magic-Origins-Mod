this.player_beast <- this.inherit("scripts/entity/tactical/player", {
	m = {
		hitpointsMax = 900,
		braveryMax = 200,
		fatigueMax = 400,
		initiativeMax = 250,
		meleeSkillMax = 150,
		rangeSkillMax = 150,
		meleeDefenseMax = 125,
		rangeDefenseMax = 125,
		SignaturePerks = [],
	},
	function getSignaturePerks()
	{
		return this.m.SignaturePerks;
	}
	
	function getType( _trueType = false )
	{
		return _trueType ? this.getFlags().getAsInt("bewitched") : this.m.Type;
	}

	function getTryoutCost()
	{
		return 0;
	}

	function getDailyCost()
	{
		return 0;
	}
	
	function getStrength()
	{
		return 1.15;
	}
	
	function onUpdateInjuryLayer()
	{
		this.actor.onUpdateInjuryLayer();
	}
	
	function getHealthRecoverMult()
	{
		return 1.0;
	}
	
	function getDaysWounded()
	{
		if (this.getHitpoints() < this.getHitpointsMax())
		{
			return this.Math.ceil((this.getHitpointsMax() - this.getHitpoints()) / (this.Const.World.Assets.HitpointsPerHour * this.getHealthRecoverMult() * (("State" in this.World) && this.World.State != null ? this.World.Assets.m.HitpointsPerHourMult : 1.0)) / 24.0);
		}
		else
		{
			return 0;
		}
	}

	function onTurnStart()
	{
		this.player.onTurnStart();
		this.playIdleSound();
	}

	function onTurnResumed()
	{
		this.player.onTurnResumed();
		this.playIdleSound();
	}
	
	function restoreArmor()
	{
		local b = this.getBaseProperties();
		local c = this.getCurrentProperties();
		
		for ( local i = 0; i < 2; i = i + 1 )
		{
			local add = this.Math.min(5, b.ArmorMax[i] - b.Armor[i]);
			
			if (add == 0)
			{
				continue;
			}
			
			b.Armor[i] += add;
			c.Armor[i] += add;
		}
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
		local time = this.getDaysWithCompany();
		local text;

		if (!this.isGuest())
		{
			if (this.m.Background != null && this.m.Background.getID() == "background.companion")
			{
				text = "With the company from the very beginning.";
			}
			else if (time > 1)
			{
				text = "With the company for " + time + " days.";
			}
			else
			{
				text = "Has just joined the company.";
			}

			if (this.m.LifetimeStats.Battles != 0)
			{
				if (this.m.LifetimeStats.Battles == 1)
				{
					text = text + (" Took part in " + this.m.LifetimeStats.Battles + " battle");
				}
				else
				{
					text = text + (" Took part in " + this.m.LifetimeStats.Battles + " battles");
				}

				if (this.m.LifetimeStats.Kills == 1)
				{
					text = text + (" and has " + this.m.LifetimeStats.Kills + " kill.");
				}
				else if (this.m.LifetimeStats.Kills > 1)
				{
					text = text + (" and has " + this.m.LifetimeStats.Kills + " kills.");
				}
				else
				{
					text = text + ".";
				}

				if (this.m.LifetimeStats.MostPowerfulVanquished != "")
				{
					text = text + (" The most powerful opponent he vanquished was " + this.m.LifetimeStats.MostPowerfulVanquished + ".");
				}
			}

			tooltip.push({
				id = 2,
				type = "description",
				text = text
			});
			tooltip.push({
				id = 5,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "Level " + this.m.Level
			});

			if (this.getDailyCost() != 0)
			{
				tooltip.push({
					id = 3,
					type = "text",
					icon = "ui/icons/asset_daily_money.png",
					text = "Paid [img]gfx/ui/tooltips/money.png[/img]" + this.getDailyCost() + " daily"
				});
			}

			tooltip.push({
				id = 4,
				type = "text",
				icon = this.Const.MoodStateIcon[this.getMoodState()],
				text = this.Const.MoodStateName[this.getMoodState()]
			});

			if (!this.isInReserves())
			{
				tooltip.push({
					id = 6,
					type = "hint",
					icon = "ui/icons/stat_screen_dmg_dealt.png",
					text = "In the fighting line"
				});
			}
			else
			{
				tooltip.push({
					id = 6,
					type = "hint",
					icon = "ui/icons/camp.png",
					text = "In reserve"
				});
			}

			tooltip.push({
				id = 7,
				type = "hint",
				text = this.getBackground().getBackgroundDescription(false)
			});
		}

		local injuries = this.getSkills().query(this.Const.SkillType.Injury | this.Const.SkillType.SemiInjury);

		foreach( injury in injuries )
		{
			if (injury.isType(this.Const.SkillType.TemporaryInjury))
			{
				local ht = injury.getHealingTime();

				if (ht.Min != ht.Max)
				{
					tooltip.push({
						id = 90,
						type = "text",
						icon = injury.getIcon(),
						text = injury.getName() + " (" + ht.Min + "-" + ht.Max + " days)"
					});
				}
				else if (ht.Min > 1)
				{
					tooltip.push({
						id = 90,
						type = "text",
						icon = injury.getIcon(),
						text = injury.getName() + " (" + ht.Min + " days)"
					});
				}
				else
				{
					tooltip.push({
						id = 90,
						type = "text",
						icon = injury.getIcon(),
						text = injury.getName() + " (" + ht.Min + " day)"
					});
				}
			}
			else
			{
				tooltip.push({
					id = 90,
					type = "text",
					icon = injury.getIcon(),
					text = injury.getName()
				});
			}
		}

		if (this.getHitpoints() < this.getHitpointsMax())
		{
			local ht = this.getDaysWounded();

			if (ht > 1)
			{
				tooltip.push({
					id = 133,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Light Wounds (" + ht + " days)"
				});
			}
			else
			{
				tooltip.push({
					id = 133,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Light Wounds (" + ht + " day)"
				});
			}
		}

		return tooltip;
	}
	
	function create()
	{
		this.actor.create();
		this.m.IsControlledByPlayer = true;
		this.m.IsGeneratingKillName = false;
		this.m.Type = this.Const.EntityType.Player;
		this.getFlags().set("PotionLastUsed", 0.0);
		this.getFlags().set("PotionsUsed", 0);
		this.m.Items = this.new("scripts/items/nggh707_item_container");
		this.m.Items.setActor(this);
		this.m.AIAgent = this.new("scripts/ai/tactical/player_agent");
		this.m.AIAgent.setActor(this);
		this.m.Formations = this.new("scripts/entity/tactical/formations_container");
		this.m.LifetimeStats.Tags = this.new("scripts/tools/tag_collection");
	}

	function onInit()
	{
		this.entity.onInit();

		if (!this.isInitialized())
		{
			this.createOverlay();
			this.m.BaseProperties = this.Const.HexenOrigin.CharacterProperties.getClone();
			this.m.CurrentProperties = this.Const.HexenOrigin.CharacterProperties.getClone();
			this.m.IsAttackable = true;

			if (this.m.MoraleState != this.Const.MoraleState.Ignore)
			{
				this.m.Skills.add(this.new("scripts/skills/special/morale_check"));
			}

			this.m.Items.setUnlockedBagSlots(2);
		}

		local arrow = this.addSprite("arrow");
		arrow.setBrush("bust_arrow");
		arrow.Visible = false;
		this.setSpriteColorization("arrow", false);
		local rooted = this.addSprite("status_rooted_back");
		rooted.Visible = false;
		rooted.Scale = 0.55;
		
		this.addSprite("socket").setBrush("bust_base_player");
		
		if (this.Const.DLC.Unhold)
		{
			this.m.Skills.add(this.new("scripts/skills/actives/wake_ally_skill"));
		}
		
		this.m.Skills.add(this.new("scripts/skills/actives/break_ally_free_skill"));
		this.m.Skills.add(this.new("scripts/skills/effects/captain_effect"));
		this.m.Skills.add(this.new("scripts/skills/special/stats_collector"));
		this.m.Skills.add(this.new("scripts/skills/special/mood_check"));
		this.m.Skills.add(this.new("scripts/skills/special/cosmetic"));
		this.m.Skills.add(this.new("scripts/skills/effects/battle_standard_effect"));
		this.m.Skills.add(this.new("scripts/skills/effects/realm_of_nightmares_effect"));
		this.m.Skills.add(this.new("scripts/skills/effects/legend_demon_hound_aura_effect"));
		this.m.Skills.add(this.new("scripts/skills/actives/break_ally_free_skill"));
		this.m.Skills.add(this.new("scripts/skills/effects/legend_veteran_levels_effect"));
		
		this.setName("");
		this.setPreventOcclusion(true);
		this.setBlockSight(false);
		this.setVisibleInFogOfWar(false);
	}

	function onAfterInit()
	{
		this.setFaction(this.Const.Faction.Player);
		this.setDiscovered(true);
		this.updateOverlay();
		this.setSpriteOffset("status_rooted_back", this.getSpriteOffset("status_rooted"));
		this.getSprite("status_rooted_back").Scale = this.getSprite("status_rooted").Scale;
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		local helmet = this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head);

		if (helmet != null && this.isKindOf(helmet, "legend_helmet"))
		{
			_appearance.HelmetDamage = "";
			_appearance.Helmet = "";
		}
		
		this.actor.onAppearanceChanged(_appearance, _setDirty);
	}
	
	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
	}

	function onCombatStart()
	{
		this.m.MaxEnemiesThisTurn = 1;
		this.m.CombatStats.DamageReceivedHitpoints = 0;
		this.m.CombatStats.DamageReceivedArmor = 0;
		this.m.CombatStats.DamageDealtHitpoints = 0;
		this.m.CombatStats.DamageDealtArmor = 0;
		this.m.CombatStats.Kills = 0;
		this.m.CombatStats.XPGained = 0;
		this.m.Skills.onCombatStarted();
		this.m.Skills.update();
		this.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
	}

	function onBeforeCombatResult()
	{
		this.onCombatFinished();
		this.m.LifetimeStats.Battles += 1;
		this.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
		this.getAIAgent().setUseHeat(false);
	}

	function onCombatFinished()
	{
		this.actor.resetRenderEffects();
		this.m.IsAlive = true;
		this.m.IsDying = false;
		this.m.IsAbleToDie = true;
		this.m.Hitpoints = this.Math.max(1, this.m.Hitpoints);
		this.m.MaxEnemiesThisTurn = 1;

		if (this.m.MoraleState != this.Const.MoraleState.Ignore && !this.m.Flags.has("egg"))
		{
			this.setMoraleState(this.Const.MoraleState.Steady);
		}

		this.resetBloodied(false);
		this.getFlags().set("Devoured", false);
		this.getFlags().set("Charmed", false);
		this.getFlags().set("Sleeping", false);
		this.getFlags().set("Nightmare", false);
		this.m.Fatigue = 0;
		this.m.ActionPoints = 0;
		this.m.Items.onCombatFinished();
		this.m.Skills.onCombatFinished();

		if (this.m.IsAlive)
		{
			this.updateLevel();
			this.updateInjuryVisuals(false);

			if (this.hasSprite("dirt"))
			{
				this.getSprite("dirt").resetBrush();
			}
			
			this.setDirty(true);
		}
	}

	function isReallyKilled( _fatalityType )
	{
		this.m.CurrentProperties.SurvivesAsUndead = false;
		return this.player.isReallyKilled(_fatalityType);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (!this.Tactical.State.isScenarioMode() && _fatalityType != this.Const.FatalityType.Unconscious)
		{
			if (this.getLevel() >= 11 && this.World.Assets.isIronman())
			{
				this.updateAchievement("ToughFarewell", 1, 1);
			}
			else
			{
				this.updateAchievement("BloodyToll", 1, 1);
			}

			if (_killer != null && this.isKindOf(_killer, "player") && _killer.getSkills().hasSkill("effects.charmed"))
			{
				this.updateAchievement("NothingPersonal", 1, 1);
			}
		}

		local flip = this.Math.rand(0, 100) < 50;
		this.m.IsCorpseFlipped = flip;
		local isResurrectable = false;
		local appearance = this.getItems().getAppearance();
		local sprite_body = this.getSprite("body");
		
		if (!this.hasSprite("head"))
		{
			this.addSprite("head");
		}
		local sprite_head = this.getSprite("head");
		
		if (!this.hasSprite("accessory"))
		{
			this.addSprite("accessory");
		}
		local sprite_accessory = this.getSprite("accessory");

		if (!this.isGuest())
		{
			local stub = this.Tactical.getCasualtyRoster().create("scripts/entity/tactical/player_corpse_stub");
			stub.setCommander(this.isCommander());
			stub.setOriginalID(this.getID());
			stub.setName(this.getNameOnly());
			stub.setTitle(this.getTitle());
			stub.setCombatStats(this.m.CombatStats);
			stub.setLifetimeStats(this.m.LifetimeStats);
			stub.m.DaysWithCompany = this.getDaysWithCompany();
			stub.m.Level = this.getLevel();
			stub.m.DailyCost = this.getDailyCost();
			stub.addSprite("blood_1").setBrush(this.Const.BloodPoolDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodPoolDecals[this.Const.BloodType.Red].len() - 1)]);
			stub.addSprite("blood_2").setBrush(this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)]);
			stub.setSpriteOffset("blood_1", this.createVec(0, -15));
			stub.setSpriteOffset("blood_2", this.createVec(0, -30));

			if (_fatalityType == this.Const.FatalityType.Devoured)
			{
				for( local i = 0; i != this.Const.CorpsePart.len(); i = ++i )
				{
					stub.addSprite("stuff_" + i).setBrush(this.Const.CorpsePart[i]);
				}
			}
			else
			{
				local decal;
				
				if (!("IsHigh" in this.m))
				{
					local decal = stub.addSprite("body");
					decal.setBrush(sprite_body.getBrush().Name + "_dead");
					decal.Color = sprite_head.Color;
					decal.Saturation = sprite_head.Saturation;
				}
				else
				{
					local decal = stub.addSprite("body");
					decal.setBrush("bust_hyena_01_body_dead");
					decal.Color = sprite_head.Color;
					decal.Saturation = sprite_head.Saturation;
				}

				if (appearance.CorpseArmor != "")
				{
					decal = stub.addSprite("armor");
					decal.setBrush(appearance.CorpseArmor);
				}

				if (appearance.CorpseArmorUpgradeBack != "")
				{
					decal = stub.addSprite("upgrade_back");
					decal.setBrush(appearance.CorpseArmorUpgradeBack);
				}

				if (sprite_accessory.HasBrush)
				{
					decal = stub.addSprite("accessory");
					decal.setBrush(sprite_accessory.getBrush().Name + "_dead");
				}

				if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
				{
					if (appearance.CorpseArmor != "")
					{
						stub.addSprite("arrows").setBrush(appearance.CorpseArmor + "_arrows");
					}
					else
					{
						stub.addSprite("arrows").setBrush(appearance.Corpse + "_arrows");
					}
				}
				else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
				{
					if (appearance.CorpseArmor != "")
					{
						stub.addSprite("arrows").setBrush(appearance.CorpseArmor + "_javelin");
					}
					else
					{
						stub.addSprite("arrows").setBrush(appearance.Corpse + "_javelin");
					}
				}

				if (_fatalityType != this.Const.FatalityType.Decapitated)
				{
					if (sprite_head.HasBrush)
					{
						if (!appearance.HideCorpseHead)
						{
							decal = stub.addSprite("head");
							decal.setBrush(sprite_head.getBrush().Name + "_dead");
							decal.Color = sprite_head.Color;
							decal.Saturation = sprite_head.Saturation;
						}
					}
					
					if (appearance.HelmetCorpse != "")
					{
						decal = stub.addSprite("helmet");
						decal.setBrush(this.getItems().getAppearance().HelmetCorpse);
					}
				}

				if (appearance.CorpseArmorUpgradeFront != "")
				{
					decal = stub.addSprite("upgrade_front");
					decal.setBrush(appearance.CorpseArmorUpgradeFront);
				}
			}
		}

		if (!this.m.IsGuest && !this.Tactical.State.isScenarioMode())
		{
			this.World.Assets.addScore(-5 * this.getLevel());
		}

		if (!this.m.IsGuest && !this.Tactical.State.isScenarioMode() && _fatalityType != this.Const.FatalityType.Unconscious && (_skill != null && _killer != null || _fatalityType == this.Const.FatalityType.Devoured))
		{
			local killedBy;

			if (_fatalityType == this.Const.FatalityType.Devoured)
			{
				killedBy = "Devoured by a Nachzehrer";
			}
			else if (_fatalityType == this.Const.FatalityType.Suicide)
			{
				killedBy = "Committed Suicide";
			}
			else if (_skill.isType(this.Const.SkillType.StatusEffect))
			{
				killedBy = _skill.getKilledString();
			}
			else if (_killer.getID() == this.getID())
			{
				killedBy = "Killed in battle";
			}
			else
			{
				if (_fatalityType == this.Const.FatalityType.Decapitated)
				{
					killedBy = "Beheaded";
				}
				else if (_fatalityType == this.Const.FatalityType.Disemboweled)
				{
					if (this.Math.rand(1, 2) == 1)
					{
						killedBy = "Disemboweled";
					}
					else
					{
						killedBy = "Gutted";
					}
				}
				else
				{
					killedBy = _skill.getKilledString();
				}

				killedBy = killedBy + (" by " + _killer.getKilledName());
			}

			this.World.Statistics.addFallen(this, killedBy);
		}
	}
	
	function assignRandomEquipment()
	{
	}
	
	function setScenarioValues()
	{
		if (!this.getSkills().hasSkill("trait.intensive_training_trait"))
		{
			this.m.Skills.add(inTraining);
		}
	}
	
	function setStartValuesEx( _backgrounds, _addTraits = true, _gender = -1, _addEquipment = true )
	{
	}
	
	function fillBeastTalentValues( _stars = 0 , _force = false )
	{
		local helper = this.getroottable().TalentFiller;
		
		if (this.getBackground() != null && ("Custom" in this.getBackground().m.Info))
		{
			helper.fillModdedTalentValues(this , this.getBackground().m.Info.Custom.Talents , _stars , _force);
		}
	}

	function fillTalentValues( _num = null , _force = false )
	{
		local stars = 0;
		
		if (_num == null)
		{
			stars = this.Math.rand(1, 9);
		}
		else
		{
			_num = this.Math.max(1, this.Math.min(_num, 3));
			stars = this.Math.rand(_num, _num * 3);
		}
		
		this.fillBeastTalentValues(stars, _force);
	}

	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
	}

	function getAttributeLevelUpValues()
	{
		local b = this.getBaseProperties();

		if (this.m.Attributes[0].len() == 0)
		{
			for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
			{
				this.m.Attributes[i].push(1);
			}
		}

		local ret = {
			hitpoints = b.Hitpoints,
			hitpointsMax = this.m.hitpointsMax,
			hitpointsIncrease = this.m.Attributes[this.Const.Attributes.Hitpoints][0],
			bravery = b.Bravery,
			braveryMax = this.m.braveryMax,
			braveryIncrease = this.m.Attributes[this.Const.Attributes.Bravery][0],
			fatigue = b.Stamina,
			fatigueMax = this.m.fatigueMax,
			fatigueIncrease = this.m.Attributes[this.Const.Attributes.Fatigue][0],
			initiative = b.Initiative,
			initiativeMax = this.m.initiativeMax,
			initiativeIncrease = this.m.Attributes[this.Const.Attributes.Initiative][0],
			meleeSkill = b.MeleeSkill,
			meleeSkillMax = this.m.meleeSkillMax,
			meleeSkillIncrease = this.m.Attributes[this.Const.Attributes.MeleeSkill][0],
			rangeSkill = b.RangedSkill,
			rangeSkillMax = this.m.rangeSkillMax,
			rangeSkillIncrease = this.m.Attributes[this.Const.Attributes.RangedSkill][0],
			meleeDefense = b.MeleeDefense,
			meleeDefenseMax = this.m.meleeDefenseMax,
			meleeDefenseIncrease = this.m.Attributes[this.Const.Attributes.MeleeDefense][0],
			rangeDefense = b.RangedDefense,
			rangeDefenseMax = this.m.rangeDefenseMax,
			rangeDefenseIncrease = this.m.Attributes[this.Const.Attributes.RangedDefense][0]
		};
		return ret;
	}

	function setAttributeLevelUpValues( _v )
	{
		local b = this.getBaseProperties();
		b.Hitpoints += _v.hitpointsIncrease;
		this.m.Hitpoints += _v.hitpointsIncrease;
		b.Stamina += _v.maxFatigueIncrease;
		b.Bravery += _v.braveryIncrease;
		b.MeleeSkill += _v.meleeSkillIncrease;
		b.RangedSkill += _v.rangeSkillIncrease;
		b.MeleeDefense += _v.meleeDefenseIncrease;
		b.RangedDefense += _v.rangeDefenseIncrease;
		b.Initiative += _v.initiativeIncrease;
		this.m.LevelUps = this.Math.max(0, this.m.LevelUps - 1);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			this.m.Attributes[i].remove(0);
		}

		this.getSkills().update();
		this.setDirty(true);

		if (b.MeleeSkill >= 90)
		{
			this.updateAchievement("Swordmaster", 1, 1);
		}

		if (b.RangedSkill >= 90)
		{
			this.updateAchievement("Deadeye", 1, 1);
		}
	}
	
	function TherianthropeInfection( _killer )
	{
	}
	
	function TherianthropeInfectionRandom()
	{
	}
	
	function updateInjuryVisuals( _setDirty = true )
	{
		this.setDirty(_setDirty);
	}
	
	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}
	
	function getRiderID()
	{
		return "";
	}
	
	function setRider()
	{
	}
	
	function getExcludeTraits()
	{
		return [
			"trait.eagle_eyes",
			"trait.short_sighted",
			"trait.tough",
			"trait.strong",
			"trait.hesitant",
			"trait.quick",
			"trait.tiny",
			"trait.cocky",
			"trait.clumsy",
			"trait.fearless",
			"trait.fat",
			"trait.dumb",
			"trait.bright",
			"trait.drunkard",
			"trait.fainthearted",
			"trait.bleeder",
			"trait.ailing",
			"trait.determined",
			"trait.dastard",
			"trait.deathwish",
			"trait.fragile",
			"trait.insecure",
			"trait.optimist",
			"trait.pessimist",
			"trait.superstitious",
			"trait.brave",
			"trait.dexterous",
			"trait.sure_footing",
			"trait.asthmatic",
			"trait.iron_lungs",
			"trait.craven",
			"trait.greedy",
			"trait.gluttonous",
			"trait.spartan",
			"trait.athletic",
			"trait.brute",
			"trait.irrational",
			"trait.clubfooted",
			"trait.loyal",
			"trait.disloyal",
			"trait.bloodthirsty",
			"trait.iron_jaw",
			"trait.survivor",
			"trait.impatient",
			"trait.swift",
			"trait.night_blind",
			"trait.night_owl",
			"trait.paranoid",
			"trait.hate_greenskins",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.fear_beasts",
			"trait.fear_undead",
			"trait.fear_greenskins",
			"trait.teamplayer",
			"trait.weasel",
			"trait.huge",
			"trait.lucky",
			"trait.steady_hands",
			"trait.slack",
			"trait.frail",
			"trait.natural",
			"trait.unpredictable",
			"trait.predictable",
			"trait.pragmatic",
			"trait.light",
			"trait.heavy",
			"trait.firm",
			"trait.ambitious",
			"trait.aggressive",
			"trait.gift_of_people",
			"trait.double_tongued",
			"trait.seductive",
		];
	}

	function canEquipThis( _item )
	{
		return true;
	}

	function canUnequipThis( _item )
	{
		return true;
	}

	function onActorEquip( _item )
	{
	}

	function onActorUnequip( _item )
	{
	}

	function onActorAfterEquip( _item )
	{
	}

	function onActorAfterUnequip( _item )
	{
	}

	function getBarberSpriteChange()
	{
		return [
			"body",
			"head",
		];
	}

	function getPossibleSprites( _type )
	{
		local ret = [];

		switch (_type) 
		{
	    case "body":
	        ret = [];
	        break;

	    case "head":
	        ret = [];
	        break;    
		}

		return ret;
	}

	function onSerialize( _out )
	{
		this.actor.onSerialize(_out);
		_out.writeU8(this.m.Level);
		_out.writeU8(this.m.PerkPoints);
		_out.writeU8(this.m.PerkPointsSpent);
		_out.writeU8(this.m.LevelUps);
		_out.writeF32(this.m.Mood);
		_out.writeU8(this.m.MoodChanges.len());

		for( local i = 0; i != this.m.MoodChanges.len(); i = i )
		{
			_out.writeBool(this.m.MoodChanges[i].Positive);
			_out.writeString(this.m.MoodChanges[i].Text);
			_out.writeF32(this.m.MoodChanges[i].Time);
			i = ++i;
		}

		_out.writeF32(this.m.HireTime);
		_out.writeF32(this.m.LastDrinkTime);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = i )
		{
			_out.writeU8(this.m.Talents[i]);
			i = ++i;
		}

		for( local i = 0; i != this.Const.Attributes.COUNT; i = i )
		{
			_out.writeU8(this.m.Attributes[i].len());

			foreach( a in this.m.Attributes[i] )
			{
				_out.writeU8(a);
			}

			i = ++i;
		}

		_out.writeU8(this.m.PlaceInFormation);
		_out.writeU32(this.m.LifetimeStats.Kills);
		_out.writeU32(this.m.LifetimeStats.Battles);
		_out.writeU32(this.m.LifetimeStats.BattlesWithoutMe);
		_out.writeU16(this.m.LifetimeStats.MostPowerfulVanquishedType);
		_out.writeString(this.m.LifetimeStats.MostPowerfulVanquished);
		_out.writeU16(this.m.LifetimeStats.MostPowerfulVanquishedXP);
		_out.writeString(this.m.LifetimeStats.FavoriteWeapon);
		_out.writeU32(this.m.LifetimeStats.FavoriteWeaponUses);
		_out.writeU32(this.m.LifetimeStats.CurrentWeaponUses);
		this.m.LifetimeStats.Tags.onSerialize(_out);
		_out.writeBool(this.m.IsTryoutDone);
		this.m.Formations.onSerialize(_out);
		_out.writeU8(this.m.VeteranPerks);
		_out.writeBool(this.m.IsCommander);
		_out.writeString(this.m.CampAssignment);
		_out.writeF32(this.m.LastCampTime);
		_out.writeBool(this.m.InReserves);
		_out.writeU8(this.m.CompanyID);
	}

	function onDeserialize( _in )
	{
		this.actor.onDeserialize(_in);

		this.m.Level = _in.readU8();
		this.m.PerkPoints = _in.readU8();
		this.m.PerkPointsSpent = _in.readU8();
		this.m.LevelUps = _in.readU8();
		this.m.Mood = _in.readF32();
		local numMoodChanges = _in.readU8();
		this.m.MoodChanges.resize(numMoodChanges, 0);

		for( local i = 0; i != numMoodChanges; i = i )
		{
			local moodChange = {};
			moodChange.Positive <- _in.readBool();
			moodChange.Text <- _in.readString();
			moodChange.Time <- _in.readF32();
			this.m.MoodChanges[i] = moodChange;
			i = ++i;
		}

		this.m.HireTime = _in.readF32();
		this.m.LastDrinkTime = _in.readF32();
		this.m.Talents.resize(this.Const.Attributes.COUNT, 0);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = i )
		{
			this.m.Talents[i] = _in.readU8();
			i = ++i;
		}

		this.m.Attributes.resize(this.Const.Attributes.COUNT);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = i )
		{
			this.m.Attributes[i] = [];
			local n = _in.readU8();
			this.m.Attributes[i].resize(n);

			for( local j = 0; j != n; j = j )
			{
				this.m.Attributes[i][j] = _in.readU8();
				j = ++j;
			}

			i = ++i;
		}

		local ret = this.m.Skills.query(this.Const.SkillType.Background);

		if (ret.len() != 0)
		{
			this.m.Background = ret[0];
			this.m.Background.adjustHiringCostBasedOnEquipment();
			this.m.Background.buildDescription(true);
		}

		this.m.PlaceInFormation = _in.readU8();
		this.m.LifetimeStats.Kills = _in.readU32();
		this.m.LifetimeStats.Battles = _in.readU32();
		this.m.LifetimeStats.BattlesWithoutMe = _in.readU32();

		if (_in.getMetaData().getVersion() >= 37)
		{
			this.m.LifetimeStats.MostPowerfulVanquishedType = _in.readU16();
		}

		this.m.LifetimeStats.MostPowerfulVanquished = _in.readString();
		this.m.LifetimeStats.MostPowerfulVanquishedXP = _in.readU16();
		this.m.LifetimeStats.FavoriteWeapon = _in.readString();
		this.m.LifetimeStats.FavoriteWeaponUses = _in.readU32();
		this.m.LifetimeStats.CurrentWeaponUses = _in.readU32();

		if (_in.getMetaData().getVersion() >= 57)
		{
			this.m.LifetimeStats.Tags.onDeserialize(_in);
		}

		this.m.IsTryoutDone = _in.readBool();

		if (_in.getMetaData().getVersion() >= 46)
		{
			this.m.Formations.onDeserialize(_in);
		}

		if (_in.getMetaData().getVersion() >= 47)
		{
			this.m.VeteranPerks = _in.readU8();

			if (this.m.VeteranPerks == 0)
			{
				this.m.VeteranPerks = 5;
			}
		}

		if (_in.getMetaData().getVersion() >= 48)
		{
			this.m.IsCommander = _in.readBool();
		}

		if (_in.getMetaData().getVersion() >= 52)
		{
			this.m.CampAssignment = _in.readString();
			this.m.LastCampTime = _in.readF32();
		}

		if (_in.getMetaData().getVersion() >= 54)
		{
			this.m.InReserves = _in.readBool();
		}

		this.m.CompanyID = _in.readU8();
		this.m.Skills.update();
	}

});

