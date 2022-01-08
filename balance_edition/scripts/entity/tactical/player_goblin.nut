this.player_goblin <- this.inherit("scripts/entity/tactical/player", {
	m = {
		Mount = null,
		ExcludedMount = [],
		IsWearingGoblinArmor = false,
		IsWearingGoblinHelmet = false,
		IsWearingSmallShield = false,
	},
	function getExcludedMount()
	{
		return this.m.ExcludedMount;
	}
	
	function isMounted()
	{
		return this.m.Mount.isMounted();
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		if (this.isMounted() && this.Math.rand(1, 100) <= this.Const.ChanceToHitMount)
		{
			return this.m.Mount.onDamageReceived(_attacker, _skill, _hitInfo);
		}

		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function onUpdateInjuryLayer()
	{
		this.actor.onUpdateInjuryLayer();

		if (this.isMounted())
		{
			this.m.Mount.updateInjuryLayer();
		}
	}
	
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		local offset = this.createVec(0, 0);
		_appearance.Quiver = "bust_goblin_quiver";
		this.actor.onAppearanceChanged(_appearance, _setDirty);
		this.m.Mount.updateAppearance();
		
		if (this.isMounted())
		{
		    offset = this.createVec(this.Const.GoblinRiderMounts[this.m.Mount.getMountType()].Sprite[0][0], this.Const.GoblinRiderMounts[this.m.Mount.getMountType()].Sprite[0][1]);
		}
		
		this.setSpriteOffset("background", offset);
		this.setSpriteOffset("quiver", offset);
		this.setSpriteOffset("body", offset);
		this.setSpriteOffset("shaft", offset);
		this.setSpriteOffset("head", offset);
		this.setSpriteOffset("injury", offset);
		this.setSpriteOffset("accessory", offset);
		this.setSpriteOffset("accessory_special", offset);
		this.setSpriteOffset("body_blood", offset);
		
		foreach( h in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(h))
			{
				continue;
			}
			
			this.setSpriteOffset(h, offset);
			this.getSprite(h).Scale = 0.85;

			if (h == "helmet")
			{
				this.getSprite(h).Scale = !this.m.IsWearingGoblinHelmet ? 0.85 : 1.0;
			}
		}
		
		local armors = ["armor", "armor_layer_chain", "armor_layer_plate", "armor_layer_tabbard", "armor_layer_cloak", "armor_upgrade_back", "armor_upgrade_front"];
		
		foreach( a in armors )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, offset);
			this.getSprite(a).Scale = 0.85;

			if (a == "armor")
			{
				this.getSprite(a).Scale = !this.m.IsWearingGoblinArmor ? 0.85 : 1.0;
			}
		}

		this.setSpriteOffset("shield_icon", offset);
		this.getSprite("shield_icon").Scale = this.m.IsWearingSmallShield ? 0.85 : 1.0;
		this.setSpriteOffset("arms_icon", offset);
		this.getSprite("status_rooted").Scale = 0.47;
		this.setSpriteOffset("status_rooted", this.createVec(0, 0));
		
		this.setAlwaysApplySpriteOffset(true);
		this.setDirty(true);
		this.onFactionChanged();
	}

	function resetRenderEffects()
	{
		this.actor.resetRenderEffects();

		if (this.isMounted())
		{
		    local offset = this.createVec(this.Const.GoblinRiderMounts[this.m.Mount.getMountType()].Sprite[0][0], this.Const.GoblinRiderMounts[this.m.Mount.getMountType()].Sprite[0][1]);
			this.setSpriteOffset("shield_icon", offset);
			this.setSpriteOffset("arms_icon", offset);
		}
	}

	function create()
	{
		this.m.IsControlledByPlayer = true;
		this.m.IsGeneratingKillName = false;
		this.m.Type = this.Const.EntityType.Player;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.BloodSplatterOffset = this.createVec(-10, 15);
		this.m.DecapitateSplatterOffset = this.createVec(20, -20);
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/goblin_idle_03.wav",
			"sounds/enemies/goblin_idle_04.wav",
			"sounds/enemies/goblin_idle_05.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/goblin_hurt_00.wav",
			"sounds/enemies/goblin_hurt_01.wav",
			"sounds/enemies/goblin_hurt_02.wav",
			"sounds/enemies/goblin_hurt_03.wav",
			"sounds/enemies/goblin_hurt_04.wav",
			"sounds/enemies/goblin_hurt_05.wav",
			"sounds/enemies/goblin_hurt_06.wav",
			"sounds/enemies/goblin_hurt_07.wav",
			"sounds/enemies/goblin_hurt_08.wav",
			"sounds/enemies/goblin_hurt_09.wav",
			"sounds/enemies/goblin_hurt_10.wav",
			"sounds/enemies/goblin_hurt_11.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/goblin_idle_00.wav",
			"sounds/enemies/goblin_idle_01.wav",
			"sounds/enemies/goblin_idle_02.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/goblin_flee_00.wav",
			"sounds/enemies/goblin_flee_01.wav",
			"sounds/enemies/goblin_flee_02.wav",
			"sounds/enemies/goblin_flee_03.wav",
			"sounds/enemies/goblin_flee_04.wav",
			"sounds/enemies/goblin_flee_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/goblin_death_00.wav",
			"sounds/enemies/goblin_death_01.wav",
			"sounds/enemies/goblin_death_02.wav",
			"sounds/enemies/goblin_death_03.wav",
			"sounds/enemies/goblin_death_04.wav",
			"sounds/enemies/goblin_death_05.wav",
			"sounds/enemies/goblin_death_06.wav",
			"sounds/enemies/goblin_death_07.wav",
			"sounds/enemies/goblin_death_08.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/goblin_idle_06.wav",
			"sounds/enemies/goblin_idle_07.wav",
			"sounds/enemies/goblin_idle_08.wav",
			"sounds/enemies/goblin_idle_09.wav",
			"sounds/enemies/goblin_idle_10.wav",
			"sounds/enemies/goblin_idle_11.wav",
			"sounds/enemies/goblin_idle_12.wav",
			"sounds/enemies/goblin_idle_13.wav",
			"sounds/enemies/goblin_idle_14.wav"
		];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 0.9;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Flee] = 1.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 0.5;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 1.15;
		this.m.SoundPitch = this.Math.rand(95, 110) * 0.01;
		this.m.AIAgent = this.new("scripts/ai/tactical/player_agent");
		this.m.AIAgent.setActor(this);
		this.m.Flags.add("can_mount");
		this.m.Flags.add("goblin");
		this.m.Flags.set("PotionLastUsed", 0.0);
		this.m.Flags.set("PotionsUsed", 0);
		this.m.Items = this.new("scripts/items/nggh707_item_container");
		this.m.Items.setActor(this);
		this.m.Mount = this.new("scripts/mods/mount_manager");
		this.m.Mount.setActor(this);
		this.m.Formations = this.new("scripts/entity/tactical/formations_container");
		this.m.LifetimeStats.Tags = this.new("scripts/tools/tag_collection");
		this.m.ExcludedMount.push("accessory.spider");
		this.m.ExcludedMount.push("accessory.tempo_spider");
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
		
		local b = this.m.BaseProperties;
		b.IsFleetfooted = true;
		b.DamageDirectMult = 1.25;
		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.Items.getAppearance().Body = "bust_goblin_01_body";

		local arrow = this.addSprite("arrow");
		arrow.setBrush("bust_arrow");
		arrow.Visible = false;
		this.setSpriteColorization("arrow", false);
		local rooted = this.addSprite("status_rooted_back");
		rooted.Visible = false;
		rooted.Scale = 0.55;
		
		this.addSprite("background");
		this.addSprite("socket").setBrush("bust_base_player");
		this.addSprite("miniboss");

		//mount sprites
		this.addSprite("mount_extra1"); //spider legs_back
		this.addSprite("mount_extra2"); //spider body

		local quiver = this.addSprite("quiver");
		quiver.Visible = false;
		
		local body = this.addSprite("body");
		body.setBrush("bust_goblin_01_body");
		local injury_body = this.addSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_goblin_01_body_injured");
		this.addSprite("armor");
		this.addSprite("armor_layer_chain");
		this.addSprite("armor_layer_plate");
		this.addSprite("armor_layer_tabbard");
		this.addSprite("surcoat");
		this.addSprite("armor_layer_cloak");
		this.addSprite("armor_upgrade_back");
		this.addSprite("shaft");
		
		local accessory = this.addSprite("accessory");
		accessory.Scale = 0.85;
		local accessoryS = this.addSprite("accessory_special");
		accessoryS.Scale = 0.85;
		
		this.addSprite("head");
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_goblin_01_head_injured");
		
		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		this.addSprite("armor_upgrade_front");

		local v = 0;
		local v2 = 0;
		this.setAlwaysApplySpriteOffset(true);

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, this.createVec(v2, v));
		}
		
		local body_blood = this.addSprite("body_blood");
		body_blood.Visible = false;
		local shield_icon = this.addSprite("shield_icon");
		shield_icon.Visible = false;
		
		//mount sprites
		this.addSprite("mount");
		this.addSprite("mount_armor");
		this.addSprite("mount_head");
		this.addSprite("mount_extra");
		this.addSprite("mount_injury");
		this.addSprite("mount_restrain");
		
		this.addSprite("dirt");
		local hex = this.addSprite("status_hex");
		hex.Visible = false;
		local sweat = this.addSprite("status_sweat");
		local stunned = this.addSprite("status_stunned");
		stunned.setBrush(this.Const.Combat.StunnedBrush);
		stunned.Visible = false;
		local arms_icon = this.addSprite("arms_icon");
		arms_icon.Visible = false;
		local rooted = this.addSprite("status_rooted");
		rooted.Visible = false;
		rooted.Scale = this.getSprite("status_rooted_back").Scale;

		if (this.m.MoraleState != this.Const.MoraleState.Ignore)
		{
			local morale = this.addSprite("morale");
			morale.Visible = false;
		}
		
		if (this.Const.DLC.Unhold)
		{
			this.m.Skills.add(this.new("scripts/skills/actives/wake_ally_skill"));
		}
		
		local rider = this.new("scripts/skills/special/goblin_rider");
		rider.setManager(this.m.Mount);
		this.m.Mount.setRiderSkill(rider);
		this.m.Skills.add(rider);

		this.m.Skills.add(this.new("scripts/skills/special/sluggish"));
		this.m.Skills.add(this.new("scripts/skills/special/weapon_breaking_warning"));
		this.m.Skills.add(this.new("scripts/skills/special/bag_fatigue"));
		this.m.Skills.add(this.new("scripts/skills/special/no_ammo_warning"));
		this.m.Skills.add(this.new("scripts/skills/special/stats_collector"));
		this.m.Skills.add(this.new("scripts/skills/special/mood_check"));
		this.m.Skills.add(this.new("scripts/skills/special/double_grip"));
		this.m.Skills.add(this.new("scripts/skills/effects/captain_effect"));
		this.m.Skills.add(this.new("scripts/skills/effects/battle_standard_effect"));
		this.m.Skills.add(this.new("scripts/skills/effects/realm_of_nightmares_effect"));
		this.m.Skills.add(this.new("scripts/skills/effects/legend_demon_hound_aura_effect"));
		this.m.Skills.add(this.new("scripts/skills/actives/break_ally_free_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/hand_to_hand"));
		this.m.Skills.add(this.new("scripts/skills/effects/legend_veteran_levels_effect"));
		
		this.setPreventOcclusion(true);
		this.setBlockSight(false);
		this.setVisibleInFogOfWar(false);
	}
	
	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
		this.getSprite("background").setHorizontalFlipping(flip);
		this.getSprite("quiver").setHorizontalFlipping(!flip);
		this.getSprite("body").setHorizontalFlipping(!flip);
		this.getSprite("injury_body").setHorizontalFlipping(!flip);
		this.getSprite("shaft").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(!flip);
		this.getSprite("injury").setHorizontalFlipping(!flip);
		this.getSprite("body_blood").setHorizontalFlipping(flip);
		this.getSprite("accessory").setHorizontalFlipping(flip);
		this.getSprite("accessory_special").setHorizontalFlipping(flip);

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.getSprite(a).setHorizontalFlipping(flip);
		}

		if (this.m.IsWearingGoblinHelmet)
		{
			this.getSprite("helmet").setHorizontalFlipping(!flip);
			this.getSprite("helmet_damage").setHorizontalFlipping(!flip);
		}
		
		local flip = !this.isAlliedWithPlayer();
		
		this.getSprite("armor_layer_chain").setHorizontalFlipping(flip);
		this.getSprite("armor_layer_plate").setHorizontalFlipping(flip);
		this.getSprite("armor_layer_tabbard").setHorizontalFlipping(flip);
		this.getSprite("armor_layer_cloak").setHorizontalFlipping(flip);
		this.getSprite("armor_upgrade_back").setHorizontalFlipping(flip);
		this.getSprite("armor_upgrade_front").setHorizontalFlipping(flip);

		if (this.m.IsWearingGoblinArmor)
		{
			flip = !flip;
		}
		
		this.getSprite("armor").setHorizontalFlipping(flip);
	}
	
	function onAfterInit()
	{
		this.getSprite("status_rooted").Scale = 0.47;
		this.setSpriteOffset("status_rooted", this.createVec(0, -5));
		this.updateOverlay();
		this.setSpriteOffset("status_rooted_back", this.getSpriteOffset("status_rooted"));
		this.getSprite("status_rooted_back").Scale = this.getSprite("status_rooted").Scale;
		this.setFaction(this.Const.Faction.Player);
		this.setDiscovered(true);
		
		local perks = ["perk_pathfinder", "perk_quick_hands"];
		
		foreach ( script in perks )
		{
			local s = this.new("scripts/skills/perks/" + script);
			s.m.IsSerialized = false;
			this.m.Skills.add(s);
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

	function isReallyKilled( _fatalityType )
	{
		this.m.CurrentProperties.SurvivesAsUndead = false;
		return this.player.isReallyKilled(_fatalityType);
	}

	function getTooltip( _targetedWithSkill = null )
	{
		if (!this.isPlacedOnMap() || !this.isAlive() || this.isDying())
		{
			return [];
		}

		local turnsToGo = this.Tactical.TurnSequenceBar.getTurnsUntilActive(this.getID());
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName(),
				icon = "ui/tooltips/height_" + this.getTile().Level + ".png"
			}
		];

		if (!this.isPlayerControlled() && _targetedWithSkill != null && this.isKindOf(_targetedWithSkill, "skill"))
		{
			local tile = this.getTile();

			if (tile.IsVisibleForEntity && _targetedWithSkill.isUsableOn(this.getTile()))
			{
				tooltip.push({
					id = 3,
					type = "headerText",
					icon = "ui/icons/hitchance.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + _targetedWithSkill.getHitchance(this) + "%[/color] chance to hit",
					children = _targetedWithSkill.getHitFactors(tile)
				});
			}
		}

		tooltip.extend([
			{
				id = 2,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = this.Tactical.TurnSequenceBar.getActiveEntity() == this ? "Acting right now!" : this.m.IsTurnDone || turnsToGo == null ? "Turn done" : "Acts in " + turnsToGo + (turnsToGo > 1 ? " turns" : " turn")
			},
			{
				id = 3,
				type = "progressbar",
				icon = "ui/icons/armor_head.png",
				value = this.getArmor(this.Const.BodyPart.Head),
				valueMax = this.getArmorMax(this.Const.BodyPart.Head),
				text = "" + this.getArmor(this.Const.BodyPart.Head) + " / " + this.getArmorMax(this.Const.BodyPart.Head) + "",
				style = "armor-head-slim"
			},
			{
				id = 4,
				type = "progressbar",
				icon = "ui/icons/armor_body.png",
				value = this.getArmor(this.Const.BodyPart.Body),
				valueMax = this.getArmorMax(this.Const.BodyPart.Body),
				text = "" + this.getArmor(this.Const.BodyPart.Body) + " / " + this.getArmorMax(this.Const.BodyPart.Body) + "",
				style = "armor-body-slim"
			},
			{
				id = 5,
				type = "progressbar",
				icon = "ui/icons/health.png",
				value = this.getHitpoints(),
				valueMax = this.getHitpointsMax(),
				text = "" + this.getHitpoints() + " / " + this.getHitpointsMax() + "",
				style = "hitpoints-slim"
			},
			{
				id = 6,
				type = "progressbar",
				icon = "ui/icons/morale.png",
				value = this.getMoraleState(),
				valueMax = this.Const.MoraleState.COUNT - 1,
				text = this.Const.MoraleStateName[this.getMoraleState()],
				style = "morale-slim"
			},
			{
				id = 7,
				type = "progressbar",
				icon = "ui/icons/fatigue.png",
				value = this.getFatigue(),
				valueMax = this.getFatigueMax(),
				text = "" + this.getFatigue() + " / " + this.getFatigueMax() + "",
				style = "fatigue-slim"
			}
		]);

		if (this.isMounted())
		{
			tooltip.push({
				id = 3,
				type = "text",
				text = "[u][size=14]Mount[/size][/u]"
			});
			tooltip.extend(this.m.Mount.getMountTooltip());
		}

		local result = [];
		local statusEffects = this.getSkills().query(this.Const.SkillType.StatusEffect | this.Const.SkillType.TemporaryInjury, false, true);

		foreach( i, statusEffect in statusEffects )
		{
			tooltip.push({
				id = 100 + i,
				type = "text",
				icon = statusEffect.getIcon(),
				text = statusEffect.getName()
			});
		}

		return tooltip;
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
				local decal = stub.addSprite("body");
				decal.setBrush("bust_goblin_body_dead");
				decal.Color = sprite_head.Color;
				decal.Saturation = sprite_head.Saturation;

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
		
		local flip = this.Math.rand(1, 100) < 50;

		if (_tile != null)
		{
			this.m.IsCorpseFlipped = flip;
			local decal;
			local skin = this.getSprite("body");
			decal = _tile.spawnDetail("bust_goblin_body_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = skin.Color;
			decal.Saturation = skin.Saturation;
			decal.setBrightness(0.9);
			decal.Scale = 0.95;
			_tile.spawnDetail(this.getItems().getAppearance().CorpseArmor, this.Const.Tactical.DetailFlag.Corpse, flip);

			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				if (!this.getItems().getAppearance().HideCorpseHead)
				{
					decal = _tile.spawnDetail(this.getSprite("head").getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
					decal.Color = skin.Color;
					decal.Saturation = skin.Saturation;
					decal.setBrightness(0.9);
					decal.Scale = 0.95;
				}

				if (this.getItems().getAppearance().HelmetCorpse != "")
				{
					decal = _tile.spawnDetail(this.getItems().getAppearance().HelmetCorpse, this.Const.Tactical.DetailFlag.Corpse, flip);
					decal.setBrightness(0.9);
					decal.Scale = 0.95;
				}
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [
					this.getSprite("head").getBrush().Name + "_dead",
					this.getItems().getAppearance().HelmetCorpse
				];
				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-50, 30), 180.0, this.getSprite("head").getBrush().Name + "_dead_bloodpool");
				decap[0].Color = skin.Color;
				decap[0].Saturation = skin.Saturation;
				decap[0].setBrightness(0.9);
				decap[0].Scale = 0.95;

				if (decap.len() >= 2)
				{
					decap[1].setBrightness(0.9);
				}
			}

			if (_fatalityType == this.Const.FatalityType.Disemboweled)
			{
				local decal = _tile.spawnDetail("bust_goblin_body_dead_guts", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail(this.getItems().getAppearance().CorpseArmor + "_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail(this.getItems().getAppearance().CorpseArmor + "_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}

			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getNameOnly();
			corpse.Tile = _tile;
			corpse.IsResurrectable = false;
			corpse.IsConsumable = true;
			corpse.Items = this.getItems();
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		this.getItems().dropAll(_tile, _killer, flip);
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);

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
	
	function updateInjuryVisuals( _setDirty = true )
	{
		this.setDirty(_setDirty);
	}
	
	function playSound( _type, _volume, _pitch = 1.0 )
	{
		this.actor.playSound(_type, _volume, _pitch);
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 1.0;
	}
	
	function onAfterDeath( _tile )
	{
		if (this.Tactical.Entities.getHostilesNum() == 0)
		{
			return;
		}
		
		this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived].len() - 1)], this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1], _tile.Pos, 1.0);
	}
	
	function setScenarioValues( _isElite = false, _isRanged = false, _isShaman = false, _isOverseer = false )
	{
		local body = this.getSprite("body");
		body.setBrush("bust_goblin_01_body");
		body.varySaturation(0.1);
		body.varyColor(0.07, 0.07, 0.09);
		local variant = 0;
		local b = this.m.BaseProperties;
		local type = this.Const.EntityType.GoblinFighter;
		local isWolfRider = false;

		if (!_isRanged && !_isShaman && !_isOverseer)
		{
			_isRanged = this.Math.rand(1, 3) == 2;
		}
		
		switch (true) 
		{
	    case _isShaman:
	        this.setActorIntoShaman(_isElite);
			variant = 3;
			type = this.Const.EntityType.GoblinShaman;
	        break;

	    case _isOverseer:
	        this.setActorIntoOverseer(_isElite);
			variant = 2;
			type = this.Const.EntityType.GoblinLeader;
	        break;

	    case _isRanged:
	        this.setActorIntoRanged(_isElite);
			variant = 1;
			type = this.Const.EntityType.GoblinAmbusher;
	        break;
	
	    default:
	    	this.setActorIntoFighter(_isElite);
			if (this.Math.rand(1, 100) <= 25)
			{
				b.setValues(this.Const.Tactical.Actor.GoblinWolfrider);
				type = this.Const.EntityType.GoblinWolfrider;
				isWolfRider = true;
				this.getSkills().add(this.new("scripts/skills/perks/perk_wolf_rider"));
				this.getItems().unequip(this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory));
				this.getItems().equip(this.new("scripts/items/accessory/wolf_item"));
			}
		}
		
		local background = this.new("scripts/skills/backgrounds/charmed_goblin_background");
		background.setTo(type);
		background.m.IsWolfrider = isWolfRider;
		this.m.Skills.add(background);
		background.onSetUp();
		background.buildDescription();
		
		local c = this.m.CurrentProperties;
		this.m.ActionPoints = c.ActionPoints;
		this.m.Hitpoints = c.Hitpoints;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.Talents = [];
		this.m.Attributes = [];
		this.fillModsTalentValues(9 , true);
		this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		this.m.Skills.update();
	}
	
	function setActorIntoShaman( _isElite = false )
	{
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.GoblinShaman);
		b.Vision = 8;
		b.TargetAttractionMult = 2.0;
		b.IsAffectedByNight = false;
		
		local head = this.getSprite("head");
		head.setBrush("bust_goblin_02_head_01");
		head.Saturation = this.getSprite("body").Saturation;
		head.Color = this.getSprite("body").Color;
		this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_staff"));

		if (!this.LegendsMod.Configs().LegendArmorsEnabled())
		{
			this.m.Items.equip(this.new("scripts/items/armor/greenskins/goblin_shaman_armor"));
			this.m.Items.equip(this.new("scripts/items/helmets/greenskins/goblin_shaman_helmet"));
		}
		else 
		{
		    this.m.Items.equip(this.new("scripts/items/armor/layer_greenskins/goblin_shaman_base_armor"));
			this.m.Items.equip(this.new("scripts/items/helmets/layer_greenskins/goblin_shaman_base_helmet"));
		}
		
		if (_isElite)
		{
			this.makeMiniboss(3);
		}
	}
	
	function setActorIntoOverseer( _isElite = false )
	{
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.GoblinLeader);
		b.DamageDirectMult = 1.1;
		b.TargetAttractionMult = 1.5;
		
		local head = this.getSprite("head");
		head.setBrush("bust_goblin_03_head_01");
		head.Saturation = this.getSprite("body").Saturation;
		head.Color = this.getSprite("body").Color;
		
		this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_crossbow"));
		this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_falchion"));
		
		if (_isElite)
		{
			this.makeMiniboss(2);
		}
		
		if (!this.LegendsMod.Configs().LegendArmorsEnabled())
		{
			this.m.Items.equip(this.new("scripts/items/armor/greenskins/goblin_leader_armor"));
			this.m.Items.equip(this.new("scripts/items/helmets/greenskins/goblin_leader_helmet"));
		}
		else 
		{
		    this.m.Items.equip(this.new("scripts/items/armor/layer_greenskins/goblin_leader_base_armor"));
			this.m.Items.equip(this.new("scripts/items/helmets/layer_greenskins/goblin_leader_base_helmet"));
		}
	}
	
	function setActorIntoRanged( _isElite = false )
	{
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.GoblinAmbusher);
		b.DamageDirectMult = 1.25;
		b.TargetAttractionMult = 1.1;
		
		local head = this.getSprite("head");
		head.setBrush("bust_goblin_01_head_0" + this.Math.rand(1, 3));
		head.Saturation = this.getSprite("body").Saturation;
		head.Color = this.getSprite("body").Color;
		
		this.assignRangedEquipment();
		
		if (_isElite)
		{
			this.makeMiniboss(1);
		}
	}
	
	function setActorIntoFighter( _isElite = false )
	{
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.GoblinFighter);
		b.DamageDirectMult = 1.25;
		
		local head = this.getSprite("head");
		head.setBrush("bust_goblin_01_head_0" + this.Math.rand(1, 3));
		head.Saturation = this.getSprite("body").Saturation;
		head.Color = this.getSprite("body").Color;
		
		this.assignMeleeEquipment();
		
		if (_isElite)
		{
			this.makeMiniboss(0);
		}
	}
	
	function assignRangedEquipment()
	{
		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
		{
			local r = this.Math.rand(1, 2);

			if (r == 1)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_heavy_bow"));
			}
			else
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_bow"));
			}
		}

		this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_notched_blade"));

		if (!this.LegendsMod.Configs().LegendArmorsEnabled())
		{
			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
			{
				this.m.Items.equip(this.new("scripts/items/armor/greenskins/goblin_skirmisher_armor"));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/greenskins/goblin_skirmisher_helmet"));
			}
		}
		else 
		{
		    if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
			{
				this.m.Items.equip(this.new("scripts/items/armor/layer_greenskins/goblin_skirmisher_base_armor"));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/layer_greenskins/goblin_skirmisher_base_helmet"));
			}
		}

		if (this.Math.rand(1, 100) <= 10)
		{
			this.m.Items.addToBag(this.new("scripts/items/accessory/poison_item"));
		}
	}
	
	function assignMeleeEquipment()
	{
		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
		{
			local weapons = [
				"weapons/greenskins/goblin_falchion",
				"weapons/greenskins/goblin_spear",
			];

			if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Offhand))
			{
				weapons.extend([
					"weapons/greenskins/goblin_pike"
				]);
			}

			this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}
		
		this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_notched_blade"));

		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getID() != "weapon.goblin_spear" && this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getID() != "weapon.named_goblin_spear")
		{
			this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_spiked_balls"));
		}

		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				this.m.Items.equip(this.new("scripts/items/tools/throwing_net"));
			}
			else
			{
				local shields = [
					"shields/greenskins/goblin_light_shield",
					"shields/greenskins/goblin_heavy_shield"
				];
				this.m.Items.equip(this.new("scripts/items/" + shields[this.Math.rand(0, shields.len() - 1)]));
			}
		}

		if (!this.LegendsMod.Configs().LegendArmorsEnabled())
		{
			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
			{
				local armor = [
					"armor/greenskins/goblin_medium_armor",
					"armor/greenskins/goblin_heavy_armor"
				];
				this.m.Items.equip(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					local h = this.new("scripts/items/helmets/greenskins/goblin_light_helmet");
					h.m.Variant = 1;
					h.updateVariant();
					this.m.Items.equip(h);
				}
				else
				{
					this.m.Items.equip(this.new("scripts/items/helmets/greenskins/goblin_heavy_helmet"));
				}
			}
		}
		else 
		{
			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
			{
				local armor = [
					"armor/layer_greenskins/goblin_medium_base_armor",
					"armor/layer_greenskins/goblin_heavy_base_armor"
				];
				this.m.Items.equip(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					local h = this.new("scripts/items/helmets/layer_greenskins/goblin_light_base_helmet");
					h.m.Variant = 1;
					h.updateVariant();
					this.m.Items.equip(h);
				}
				else
				{
					this.m.Items.equip(this.new("scripts/items/helmets/layer_greenskins/goblin_heavy_base_helmet"));
				}
			}    
		}
	}

	function makeMiniboss( _type = 0 )
	{
		this.m.Skills.add(this.new("scripts/skills/racial/champion_racial"));
		this.m.IsMiniboss = true;
		
		if (_type == 0)
		{
			local weapons = [
				"weapons/named/named_goblin_falchion",
				"weapons/named/named_goblin_spear"
			];
			this.m.Items.unequip(this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
			this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_dodge"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_relentless"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
			return true;
		}
		
		if (_type == 1)
		{
			local weapons = [
				"weapons/named/named_goblin_heavy_bow"
			];
			this.m.Items.unequip(this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
			this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_overwhelm"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_dodge"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_relentless"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
			return true;
		}
		
		if (_type == 2)
		{
			local weapons = [
				"weapons/named/named_goblin_falchion"
			];
			
			foreach ( i in this.m.Items.getAllItems() )
			{
				if (i.isInBag())
				{
					this.m.Items.removeFromBag(i);
				}
				else
				{
					this.m.Items.unequip(i);
				}
			}
			
			this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
			this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_crossbow"));
			this.m.Items.equip(this.new("scripts/items/accessory/wolf_item"));
			this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_overwhelm"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_dodge"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_relentless"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
			return true;
		}
		
		if (_type == 3)
		{
			this.m.Skills.add(this.new("scripts/skills/perks/perk_dodge"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
			return true;
		}
	}
	
	function fillModsTalentValues( _stars = 0 , _force = false )
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
		
		this.fillModsTalentValues(stars, _force);
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
		if (_item.isItemType(this.Const.Items.ItemType.Helmet))
		{
			local goblin_helmets = [
				"armor.head.goblin_heavy_helmet",
				"armor.head.goblin_leader_helmet",
				"armor.head.goblin_light_helmet",
				"armor.head.goblin_shaman_helmet",
				"armor.head.goblin_skirmisher_helmet",
			];
			this.m.IsWearingGoblinHelmet = goblin_helmets.find(_item.getID()) != null;
		}

		if (_item.isItemType(this.Const.Items.ItemType.Armor))
		{
			local goblin_armors = [
				"armor.body.goblin_heavy_armor",
				"armor.body.goblin_leader_armor",
				"armor.body.goblin_light_armor",
				"armor.body.goblin_medium_armor",
				"armor.body.goblin_shaman_armor",
				"armor.body.goblin_skirmisher_armor",
			];

			this.m.IsWearingGoblinArmor = goblin_armors.find(_item.getID()) != null;
		}

		if (_item.isItemType(this.Const.Items.ItemType.Shield))
		{
			local small_shields = [
				"shield.goblin_heavy_shield",
				"shield.goblin_light_shield",
				"shield.buckler",
				"shield.auxiliary_shield",
			];

			this.m.IsWearingSmallShield = small_shields.find(_item.getID()) != null;
		}

		if (_item.getSlotType() == this.Const.ItemSlot.Accessory && this.getSkills().hasSkill("perk.wolf_rider"))
		{
			this.m.Mount.onAccessoryEquip(_item);
		}
	}

	function onActorUnequip( _item )
	{
		if (_item.getSlotType() == this.Const.ItemSlot.Accessory)
		{
			this.m.Mount.onAccessoryUnequip();
		}

		if (_item.isItemType(this.Const.Items.ItemType.Helmet))
		{
			this.m.IsWearingGoblinHelmet = false;
		}

		if (_item.isItemType(this.Const.Items.ItemType.Armor))
		{
			this.m.IsWearingGoblinArmor = false;
		}
	}

	function onActorAfterEquip( _item )
	{
		if (!_item.isItemType(this.Const.Items.ItemType.Shield) && !_item.isItemType(this.Const.Items.ItemType.MeleeWeapon) || _item.m.SkillPtrs.len() == 0)
		{
			return;
		}

		local mod = _item.getStaminaModifier();
		local penalty = mod <= -14 ? 1 + this.Math.maxf(0, this.Math.abs(14 + mod) / 7) : 0;

		foreach( _skill in _item.m.SkillPtrs )
		{
			if (_skill.isType(this.Const.SkillType.Active))
			{
				_skill.setFatigueCost(this.Math.max(0, _skill.getFatigueCostRaw() + 5 * penalty));
			}
		}
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
	        ret = [
	        	"bust_goblin_01_body",
	        ];
	        break;

	    case "head":
	        ret = [
	        	"bust_goblin_01_head_01",
	        	"bust_goblin_01_head_02",
	        	"bust_goblin_01_head_03",
	        	"bust_goblin_02_head_01",
	        	"bust_goblin_03_head_01",
	        ];
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
		this.m.Skills.update();

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

