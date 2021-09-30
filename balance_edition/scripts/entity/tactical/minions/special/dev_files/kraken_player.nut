this.kraken_player <- this.inherit("scripts/entity/tactical/player_beast", {
	m = {
		Tentacles = [],
		TentaclesDestroyed = 0,
		IsEnraged = false,
		Script = "scripts/entity/tactical/minions/special/dev_files/kraken_tentacle_player",
	},
	function getStrength() {return 100}
	function getHealthRecoverMult() {return 20.0}
	function getTentacles()
	{
		return this.m.Tentacles;
	}

	function getTentaclesMax()
	{
		return this.Math.max(4, this.Math.min(8, this.Math.ceil(this.getHitpointsPct() * 2.0 * 8)));
	}

	function canSpawnMoreTentacle()
	{
		return this.m.Tentacles.len() < this.getTentaclesMax();
	}

	function isEnraged()
	{
		return this.m.IsEnraged;
	}

	function canBeEnraged()
	{
		return this.getHitpointsPct() <= 0.25;
	}

	function setEnraged( _s )
	{
		if (this.m.IsEnraged == _s)
		{
			return;
		}

		this.playSound(this.Const.Sound.ActorEvent.Other1, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1] * this.m.SoundVolumeOverall);
		this.m.IsEnraged = _s;

		foreach( t in this.m.Tentacles )
		{
			if (!t.isNull() && t.isAlive() && t.getHitpoints() > 0)
			{
				t.setMode(this.m.IsEnraged ? 1 : 0);
			}
		}
	}

	function create()
	{
		this.player_beast.create();
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Kraken.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(-30, -15);
		this.m.DecapitateBloodAmount = 2.0;
		this.m.IsUsingZoneOfControl = false;
		this.m.RenderAnimationDistanceMult = 3.0;
		this.m.hitpointsMax = 5000;
		this.m.braveryMax = 500;
		this.m.fatigueMax = 1000;
		this.m.initiativeMax = 100;
		this.m.meleeSkillMax = 1000;
		this.m.rangeSkillMax = 50;
		this.m.meleeDefenseMax = 100;
		this.m.rangeDefenseMax = 100;
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/dlc2/krake_idle_01.wav",
			"sounds/enemies/dlc2/krake_idle_02.wav",
			"sounds/enemies/dlc2/krake_idle_03.wav",
			"sounds/enemies/dlc2/krake_idle_04.wav",
			"sounds/enemies/dlc2/krake_idle_05.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/krake_hurt_01.wav",
			"sounds/enemies/dlc2/krake_hurt_02.wav",
			"sounds/enemies/dlc2/krake_hurt_03.wav",
			"sounds/enemies/dlc2/krake_hurt_04.wav",
			"sounds/enemies/dlc2/krake_hurt_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/dlc2/krake_idle_01.wav",
			"sounds/enemies/dlc2/krake_idle_02.wav",
			"sounds/enemies/dlc2/krake_idle_03.wav",
			"sounds/enemies/dlc2/krake_idle_04.wav",
			"sounds/enemies/dlc2/krake_idle_05.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/krake_death_01.wav",
			"sounds/enemies/dlc2/krake_death_02.wav",
			"sounds/enemies/dlc2/krake_death_03.wav",
			"sounds/enemies/dlc2/krake_death_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc2/krake_idle_06.wav",
			"sounds/enemies/dlc2/krake_idle_07.wav",
			"sounds/enemies/dlc2/krake_idle_08.wav",
			"sounds/enemies/dlc2/krake_idle_09.wav",
			"sounds/enemies/dlc2/krake_idle_10.wav",
			"sounds/enemies/dlc2/krake_idle_11.wav",
			"sounds/enemies/dlc2/krake_idle_12.wav",
			"sounds/enemies/dlc2/krake_idle_13.wav",
			"sounds/enemies/dlc2/krake_idle_14.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/dlc2/krake_enraging_01.wav",
			"sounds/enemies/dlc2/krake_enraging_02.wav",
			"sounds/enemies/dlc2/krake_enraging_03.wav",
			"sounds/enemies/dlc2/krake_enraging_04.wav"
		];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1] = 1.5;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 1.5;
		this.m.Flags.add("boss");
		this.m.Flags.add("kraken");
		this.m.Items.blockAllSlots();
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (!this.Tactical.State.isScenarioMode())
		{
			this.updateAchievement("BeastOfBeasts", 1, 1);
		}

		this.player_beast.onDeath(_killer, _skill, _tile, _fatalityType);

		if (_tile != null)
		{
			local flip = false;
			local decal;
			this.m.IsCorpseFlipped = flip;
			local body = this.getSprite("body");
			decal = _tile.spawnDetail("bust_kraken_body_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;
			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsHeadAttached = true;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);

			foreach( t in this.m.Tentacles )
			{
				if (t.isNull())
				{
					continue;
				}

				t.setParent(null);

				if (t.isPlacedOnMap())
				{
					t.killSilently();
				}
			}

			this.m.Tentacles = [];
			local loot;
			loot = this.new("scripts/items/misc/kraken_horn_plate_item");
			loot.drop(_tile);
			loot = this.new("scripts/items/misc/kraken_horn_plate_item");
			loot.drop(_tile);
			loot = this.new("scripts/items/misc/kraken_tentacle_item");
			loot.drop(_tile);

			if (!this.Tactical.State.isScenarioMode() && this.World.Assets.getExtraLootChance() > 0)
			{
				loot = this.new("scripts/items/misc/kraken_horn_plate_item");
				loot.drop(_tile);
			}
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function kill( _killer = null, _skill = null, _fatalityType = this.Const.FatalityType.None, _silent = false )
	{
		this.player_beast.kill(_killer, _skill, _fatalityType, _silent);
	}

	function setFaction( _f )
	{
		this.actor.setFaction(_f);

		foreach( t in this.m.Tentacles )
		{
			if (!t.isNull() && t.isAlive())
			{
				t.setFaction(_f);
			}
		}
	}

	function onTentacleDestroyed()
	{
		if (!this.isAlive() || this.isDying())
		{
			return;
		}

		++this.m.TentaclesDestroyed;

		foreach( i, t in this.m.Tentacles )
		{
			if (t.isNull() || t.isDying() || !t.isAlive())
			{
				this.m.Tentacles.remove(i);
				break;
			}
		}

		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = this.Math.max(150, 200);
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = this.Const.BodyPart.Head;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		this.onDamageReceived(this, null, hitInfo);

		if (!this.isAlive() || this.isDying())
		{
			return;
		}

		for( local numTentacles = this.Math.max(4, this.Math.min(8, this.Math.ceil(this.getHitpointsPct() * 2.0 * 8))); this.m.Tentacles.len() < numTentacles;  )
		{
			local mapSize = this.Tactical.getMapSize();
			local myTile = this.getTile();

			for( local attempts = 0; attempts < 500; attempts = ++attempts )
			{
				local x = this.Math.rand(this.Math.max(0, myTile.SquareCoords.X - 8), this.Math.min(mapSize.X - 1, myTile.SquareCoords.X + 8));
				local y = this.Math.rand(this.Math.max(0, myTile.SquareCoords.Y - 8), this.Math.min(mapSize.Y - 1, myTile.SquareCoords.Y + 8));
				local tile = this.Tactical.getTileSquare(x, y);

				if (!tile.IsEmpty)
				{
				}
				else
				{
					local tentacle = this.spawnTentacle(tile);
					tentacle.updateVisibilityForFaction();
					break;
				}
			}
		}
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = this.Const.BodyPart.Head;
		local ret = this.actor.onDamageReceived(_attacker, _skill, _hitInfo);

		if (!this.m.IsEnraged && this.canBeEnraged())
		{
			this.setEnraged(true);
		}

		return ret;
	}

	function onUpdateInjuryLayer()
	{
		local body = this.getSprite("body");
		local p = this.getHitpointsPct();

		if (p > 0.5)
		{
			body.setBrush("bust_kraken_body_01");
		}
		else
		{
			body.setBrush("bust_kraken_body_01_injured");
		}

		this.setDirty(true);
	}

	function onInit()
	{
		this.player_beast.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Kraken);
		b.Vision = 11;
		b.Hitpoints = 4000;
		b.Armor = [1000, 1000];
		b.ArmorMax = [1000, 1000];
		b.FatigueRecoveryRate = 45;
		b.TargetAttractionMult = 0.75;
		b.DailyFood = 20;
		b.IsAffectedByNight = false;
		b.IsMovable = false;
		b.IsAffectedByInjuries = false;
		b.IsRooted = true;
		b.IsImmuneToDisarm = true;
		b.IsAffectedByRain = false;

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		local body = this.addSprite("body");
		body.setBrush("bust_kraken_body_01");

		if (this.Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.2);
		}

		if (this.Math.rand(0, 100) < 90)
		{
			body.varyColor(0.08, 0.08, 0.08);
		}

		this.addDefaultStatusSprites();
		this.setSpriteOffset("arrow", this.createVec(20, 190));
	}

	function onAfterInit()
	{
		this.player_beast.onAfterInit();
		local perks = ["perk_hold_out", "perk_fearsome", "perk_steel_brow", "perk_stalwart", "perk_legend_composure", "perk_legend_poison_immunity"];
		
		foreach ( script in perks )
		{
			local s = this.new("scripts/skills/perks/" + script);
			s.m.IsSerialized = false;
			this.m.Skills.add(s);
		}
		
		this.m.Skills.add(this.new("scripts/skills/actives/mod_kraken_devour_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_kraken_command_drag_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_kraken_spawn_tentacle_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_kraken_enrage_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_kraken_command_squeeze_skill"));
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
	}

	function onCombatStart()
	{
		this.player_beast.onCombatStart();
		this.m.TentaclesDestroyed = 0;
		this.m.Tentacles = [];
		this.setEnraged(false);
		this.spawnTentaclesAtBattleStart();
	}
	
	function onCombatFinished()
	{
		this.player_beast.onCombatFinished();

		foreach( t in this.m.Tentacles )
		{
			if (t.isNull())
			{
				continue;
			}

			t.setParent(null);
		}

		this.m.TentaclesDestroyed = 0;
		this.m.Tentacles = [];
		this.setEnraged(false);
	}

	function giveStats( _tentacle )
	{
		local b = _tentacle.m.BaseProperties;
		local lv = this.m.Level;
		b.ActionPoints += this.Math.rand(1, 10) <= 2 ? 1 : 0;
		b.Hitpoints += 5 * lv;
		b.Bravery += 2 * lv;
		b.Stamina += 2 * lv;
		b.MeleeSkill += this.Math.floor(1.5 * lv);
		b.RangedSkill += 0;
		b.MeleeDefense += lv;
		b.RangedDefense += lv;
		b.Initiative += 3 * lv;
		_tentacle.m.ActionPoints = b.ActionPoints;
		_tentacle.setHitpointsPct(1.0);
		_tentacle.m.Skills.update();
	}

	function givePerk( _tentacle )
	{
		local perks = this.getSkills().query(this.Const.SkillType.Perk, true);
		local exclude = [
			"perk.gifted",
			"perk.ptr_discovered_talent",
		];
		
		foreach ( p in perks )
		{
			if (exclude.find(p.getID()) != null)
			{
				continue;
			}

			local script = this.findPerkInConst(p.getID());

			if (script == null)
			{
				continue;
			}
			
			local perk = this.new(script);
			_tentacle.getSkills().add(perk);
			perk.onCombatStarted();
		}
	}

	function findPerkInConst( _id )
	{
		foreach ( Def in this.Const.Perks.PerkDefObjects )
		{
			if (Def.ID == _id)
			{
				return Def.Script;
			}
		}

		return null;
	}

	function spawnTentaclesAtBattleStart()
	{
		local myTile = this.getTile();

		for( local i = 0; i < 8; i = i )
		{
			local mapSize = this.Tactical.getMapSize();

			for( local attempts = 0; attempts < 500; attempts = attempts )
			{
				local x = this.Math.rand(this.Math.max(0, myTile.SquareCoords.X - 2), this.Math.min(mapSize.X - 1, myTile.SquareCoords.X + 8));
				local y = this.Math.rand(this.Math.max(0, myTile.SquareCoords.Y - 8), this.Math.min(mapSize.Y - 1, myTile.SquareCoords.Y + 8));
				local tile = this.Tactical.getTileSquare(x, y);

				if (!tile.IsEmpty)
				{
				}
				else
				{
					this.spawnTentacle(tile, true);
					break;
				}

				attempts = ++attempts;
			}

			i = ++i;
		}
	}

	function spawnTentacle( _tile , _isInstant = false )
	{
		local tentacle = this.Tactical.spawnEntity(this.m.Script, _tile.Coords);
		tentacle.setParent(this);
		tentacle.setFaction(this.getFaction());
		tentacle.setMode(this.m.IsEnraged ? 1 : 0);
		tentacle.setName(this.getNameOnly() + "\'s Irrlicht");

		if (!_isInstant)
		{
			tentacle.riseFromGround(0.75);
		}

		this.givePerk(tentacle);
		this.giveStats(tentacle);
		this.m.Tentacles.push(this.WeakTableRef(tentacle));
		return tentacle;
	}

	function setScenarioValues( _isElite = false , _dub = false , _dub_two = false , _dub_three = false )
	{
		if (_isElite || this.Math.rand(1, 100) == 100)
		{
			this.getSkills().add(this.new("scripts/skills/racial/champion_racial"));
		}
		
		local type = this.Const.EntityType.Kraken;
		this.m.Skills.add(this.new("scripts/skills/traits/player_character_trait"));
		this.m.Flags.set("IsPlayerCharacter", true);
		local background = this.new("scripts/skills/backgrounds/charmed_beast_background");
		background.setTo(type);
		this.m.Skills.add(background);
		background.onSetUp();
		background.buildDescription();

		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Kraken);
		b.Vision = 11;
		b.Hitpoints = 4000;
		b.Armor = [1000, 1000];
		b.ArmorMax = [1000, 1000];
		b.FatigueRecoveryRate = 45;
		b.TargetAttractionMult = 0.75;
		b.DailyFood = 20;
		b.IsAffectedByNight = false;
		b.IsMovable = false;
		b.IsAffectedByInjuries = false;
		b.IsRooted = true;
		b.IsImmuneToDisarm = true;
		b.IsAffectedByRain = false;
		this.setTitle(this.Const.Strings.KrakenTitlesOnly[this.Math.rand(0, this.Const.Strings.KrakenTitlesOnly.len() - 1)]);
		this.m.Skills.update();
		
		local c = this.m.CurrentProperties;
		this.m.ActionPoints = c.ActionPoints;
		this.m.Hitpoints = c.Hitpoints;
		this.m.Talents = [];
		this.m.Attributes = [];
		this.m.Talents = [];
		this.m.Talents.resize(this.Const.Attributes.COUNT, 0);
		this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
	}

	function onPlacedOnMap()
	{
		this.player_beast.onPlacedOnMap();
		this.getTile().clear();
		this.getTile().IsHidingEntity = false;
		local myTile = this.getTile();

		if (myTile.hasNextTile(this.Const.Direction.N))
		{
			local tile = myTile.getNextTile(this.Const.Direction.N);

			if (tile.IsEmpty)
			{
				this.Tactical.spawnEntity("scripts/entity/tactical/objects/swamp_tree1", tile.Coords);
			}

			if (tile.hasNextTile(this.Const.Direction.N))
			{
				local tile = tile.getNextTile(this.Const.Direction.N);

				if (tile.IsEmpty)
				{
					this.Tactical.spawnEntity("scripts/entity/tactical/objects/swamp_tree1", tile.Coords);
				}
			}
		}
	}
	
	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
		local AttributesLevelUp = [
			{
				Min = 15,
				Max = 20
			},
			{
				Min = 10,
				Max = 10
			},
			{
				Min = 1,
				Max = 1
			},
			{
				Min = 10,
				Max = 20
			},
			{
				Min = 1,
				Max = 1
			},
			{
				Min = 10,
				Max = 10
			},
			{
				Min = 1,
				Max = 1
			},
			{
				Min = 1,
				Max = 1
			}
		];
		
		if (this.m.Attributes.len() == 0)
		{
			this.m.Attributes.resize(this.Const.Attributes.COUNT);

			for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
			{
				this.m.Attributes[i] = [];
			}
		}

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			for( local j = 0; j < _amount; j = ++j )
			{
				if (_minOnly)
				{
					if (i == this.m.Attributes.Hitpoints)
					{
						this.m.Attributes[i].insert(0, 5);
					}
					else 
					{
						this.m.Attributes[i].insert(0, this.Math.rand(1, this.Math.rand(1, 1)));
					}
				}
				else if (_maxOnly)
				{
					this.m.Attributes[i].insert(0, AttributesLevelUp[i].Max);
				}
				else
				{
					this.m.Attributes[i].insert(0, this.Math.rand(AttributesLevelUp[i].Min, AttributesLevelUp[i].Max));
				}
			}
		}
	}
	
	function getExcludeTraits()
	{
		return [
			"trait.eagle_eyes",
			"trait.short_sighted",
			"trait.hesitant",
			"trait.quick",
			"trait.tiny",
			"trait.fainthearted",
			"trait.dastard",
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
			"trait.spartan",
			"trait.athletic",
			"trait.irrational",
			"trait.clubfooted",
			"trait.loyal",
			"trait.disloyal",
			"trait.survivor",
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
			"trait.steady_hands",
			"trait.slack",
			"trait.frail",
			"trait.predictable",
			"trait.pragmatic",
			"trait.light",
			"trait.firm",
			"trait.double_tongued",
		];
	}

});

