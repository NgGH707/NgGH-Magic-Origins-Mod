this.true_necromancer <- this.inherit("scripts/entity/tactical/human", {
	m = {	
		LastAttackerID = null,
		LastRound = 0,
		Counter = 0,
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.Necromancer;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = 250000;
		this.human.create();
		this.m.Name = "NgGH the True Necromancer";
		this.m.Faces = ["bust_head_necro_01"];
		this.m.Hairs = [21];
		this.m.HairColors = ["grey"];
		this.m.Beards = ["14"];
		this.m.BeardChance = 100;
		this.m.ConfidentMoraleBrush = "icon_confident_undead";
		this.m.SoundPitch = 0.9;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/nggh707_agent");
		this.m.AIAgent.setActor(this);
		this.m.Flags.add("isNgGH707");
		this.m.Flags.add("isNecromancerBoss");
		this.m.Flags.add("undead");
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.human.onDeath(_killer, _skill, _tile, _fatalityType);
		local allEntities = this.Tactical.Entities.getAllInstancesAsArray();

		foreach ( e in allEntities) 
		{
			if (!e.isAlliedWith(this))
			{
				e.getSkills().add(this.new("scripts/skills/effects/mummy_curse_effect"));
				e.getSkills().add(this.new("scripts/skills/effects/mummy_curse_effect"));
			}
		}

		local myTile = this.getTile();
		local mapSize = this.Tactical.getMapSize();
		local attempts = 0;
		local n = 0;
		this.Sound.play("sounds/enemies/zombie_rise_01.wav", this.Const.Sound.Volume.Skill * 2.0, myTile.Pos);

		while (attempts++ < 250)
		{
			local x = this.Math.rand(this.Math.max(0, myTile.SquareCoords.X - 5), this.Math.min(mapSize.X - 1, myTile.SquareCoords.X + 5));
			local y = this.Math.rand(this.Math.max(0, myTile.SquareCoords.Y - 5), this.Math.min(mapSize.Y - 1, myTile.SquareCoords.Y + 5));

			if (!this.Tactical.isValidTileSquare(x, y))
			{
				continue;
			}

			local tile = this.Tactical.getTileSquare(x, y);

			if (!tile.IsEmpty || tile.ID == myTile.ID)
			{
				continue;
			}

			local script = n == 4 ? "scripts/entity/tactical/enemies/zombie_swordsaint" : "scripts/entity/tactical/enemies/zombie_betrayer";
			local e = this.Tactical.spawnEntity(script, tile.Coords);
			e.setFaction(this.getFaction());
			e.riseFromGround(0.75);
			e.assignRandomEquipment();
			++n;

			if (n >= 6)
			{
				break;
			}
		}
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Necromancer);
		b.ActionPoints = 9;
		b.Hitpoints = 100;
		b.Bravery = 989;
		b.Stamina = 250;
		b.MeleeSkill = 100;
		b.RangedSkill = 999;
		b.MeleeDefense = 25;
		b.RangedDefense = 25;
		b.Initiative = 100;
		b.InitiativeForTurnOrderAdditional = -999;
		b.DamageMinimum = 25;
		b.MoraleEffectMult = 0.0;
		b.Vision = 99;
		b.Threat = 50;
		b.FatigueReceivedPerHitMult = 0.0;
		b.ThresholdToReceiveInjuryMult = 1000.0;
		b.DamageReceivedRangedMult = 0.85;
		b.TargetAttractionMult = 3.0;
		b.FatalityChanceMult = 10000.0;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToOverwhelm = true;
		b.IsImmuneToZoneOfControl = true;
		b.IsImmuneToSurrounding = true;
		b.IsImmuneToFire = true;
		b.IsAffectedByRain = false;
		b.IsAffectedByNight = false;
		b.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] = 10000.0;
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_undead");
		this.getSprite("head").Color = this.createColor("#ffffff");
		this.getSprite("head").Saturation = 1.0;
		this.getSprite("body").Saturation = 0.6;
		this.m.Skills.removeByID("actives.hand_to_hand");
		
		local touch = this.new("scripts/skills/actives/ghastly_touch");
		touch.m.ActionPointCost = 3;
		this.m.Skills.add(touch);
		//this.m.Skills.add(this.new("scripts/skills/actives/raise_all_undead"));
		//this.m.Skills.add(this.new("scripts/skills/actives/possess_all_undead"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/traits/fearless_trait"));
		this.m.Skills.add(this.new("scripts/skills/traits/iron_jaw_trait"));
		this.makeMiniboss();
	}
	
	function onTurnStart()
	{
		if (!this.isAlive())
		{
			return;
		}
		
		this.Tactical.spawnSpriteEffect("necro_quote_" + this.Math.rand(1, 6), this.createColor("#ffffff"), this.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 160, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
		this.actor.onTurnStart();
	}
	
	function onTurnResumed()
	{
		this.Tactical.spawnSpriteEffect("necro_quote_" + this.Math.rand(1, 6), this.createColor("#ffffff"), this.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 160, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
		this.actor.onTurnResumed();
	}

	/*function onMissed( _attacker, _skill, _dontShake = false )
	{
		this.actor.onMissed(_attacker, _skill, _dontShake);

		if (_attacker != null)
		{
			if (this.Time.getRound() == this.m.LastRound && this.m.LastAttackerID == _attacker.getID())
			{
				++this.m.Counter;
			}
			else
			{
				this.m.Counter = 0;
			}

			this.m.LastAttackerID = _attacker.getID();
			this.m.LastRound = this.Time.getRound();

			if (this.m.Counter > 6)
			{
				_attacker.killSilently();
			}
		}
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		local ret = this.actor.onDamageReceived(_attacker, _skill, _hitInfo);

		if (_attacker != null)
		{
			if (this.Time.getRound() == this.m.LastRound && this.m.LastAttackerID == _attacker.getID())
			{
				++this.m.Counter;
			}
			else
			{
				this.m.Counter = 0;
			}

			this.m.LastAttackerID = _attacker.getID();
			this.m.LastRound = this.Time.getRound();

			if (this.m.Counter > 6)
			{
				_attacker.killSilently();
			}
		}

		return ret;
	}*/
	
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (!this.Tactical.State.isScenarioMode() && _killer != null && _killer.isPlayerControlled())
		{
			this.updateAchievement("ManInBlack", 1, 1);
		}
		
		this.Tactical.EventLog.log("[color=" + this.Const.UI.Color.DamageValue + "]IMPOSSIBLE!!![/color]");

		if (_killer != null)
		{
			_killer.kill(null, null, this.Const.FatalityType.Decapitated);
		}

		this.human.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function assignRandomEquipment()
	{
		local skull = this.new("scripts/items/weapons/nggh707_skull_of_the_dead");
		skull.m.IsDroppedAsLoot = false;
		this.m.Items.equip(skull);
		
		local helmet = this.new("scripts/items/helmets/nggh707_headgear");
		helmet.m.IsDroppedAsLoot = false;
		this.m.Items.equip(helmet);
		
		local armor = this.new("scripts/items/armor/named/named_noble_mail_armor");
		armor.m.IsDroppedAsLoot = false;
		armor.m.StaminaModifier = -15;
		this.m.Items.equip(armor);
	}

	function makeMiniboss()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		this.getSprite("miniboss").setBrush("bust_miniboss"); 
		this.m.Skills.update();
		return true;
	}
	
	function activateCheatPunish()
	{
		local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
		local poorVictim = brothers[this.Math.rand(0, brothers.len() - 1)];
		
		if (poorVictim != null)
		{
			this.Tactical.CameraDirector.addMoveToTileEvent(0, poorVictim.getTile());
			this.Tactical.CameraDirector.addDelay(1.5);
			poorVictim.kill(this, null, this.Const.FatalityType.Decapitated);
		}

		return true;
	}
	
	function killSilently()
	{
		this.activateCheatPunish();
	}
	
	function kill( _killer = null, _skill = null, _fatalityType = this.Const.FatalityType.None, _silent = false )
	{
		if (_killer == null && _skill == null && _fatalityType == this.Const.FatalityType.None && !_silent)
		{
			this.m.Hitpoints = this.m.Hitpoints == 0 ? 1 : this.m.Hitpoints;
			this.Tactical.EventLog.log("[color=" + this.Const.UI.Color.DamageValue + "]Cheater!!! DIE.....[/color]");
			this.Tactical.spawnSpriteEffect("status_effect_111", this.createColor("#ffffff"), this.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
			return this.activateCheatPunish();
		}
		
		if (_killer == null || _skill == null)
		{
			this.m.Hitpoints = this.m.Hitpoints == 0 ? 1 : this.m.Hitpoints;
			this.Tactical.EventLog.log("Such pitiful lucky hits can\'t kill " + this.Const.UI.getColorizedEntityName(this));
			this.Tactical.spawnSpriteEffect("status_effect_111", this.createColor("#ffffff"), this.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
			return;
		}
		
		this.actor.kill(_killer, _skill, _fatalityType, _silent);
	}

});

