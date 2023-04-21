this.nggh_mod_kraken_player <- inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {
		Tentacles = [],
		TentaclesDestroyed = 0,
		IsEnraged = true,
		Script = "scripts/entity/tactical/player_beast/nggh_mod_kraken_tentacle_player",

		Mode = null,
	},
	function getStrengthMult() 
	{
		return 15.5;
	}

	function getTentacles()
	{
		return this.m.Tentacles;
	}

	function getTentaclesMax()
	{
		return ::Math.max(4, ::Math.min(8, ::Math.ceil(this.getHitpointsPct() * 2.0 * 8)));
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
		return this.getHitpointsPct() <= 0.5;
	}

	function setEnraged( _s )
	{
		if (this.m.IsEnraged == _s)
		{
			return;
		}

		this.playSound(::Const.Sound.ActorEvent.Other1, ::Const.Sound.Volume.Actor * ::m.SoundVolume[::Const.Sound.ActorEvent.Other1] * this.m.SoundVolumeOverall);
		this.m.IsEnraged = _s;

		foreach( t in this.m.Tentacles )
		{
			if (!t.isNull() && t.isAlive() && t.getHitpoints() > 0)
			{
				t.setMode(this.m.IsEnraged ? 1 : 0);
			}
		}
	}

	function setMode( _m )
	{
		if (_m == null)
		{
			this.m.Mode = null;
		}
		else if (typeof _m == "instance")
		{
			this.m.Mode = _m;
		}
		else 
		{
			this.m.Mode = ::WeakTableRef(_m);			    
		}
	}

	function getMode()
	{
		return this.m.Mode;
	}

	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.BloodType = ::Const.BloodType.Red;
		this.m.BloodSplatterOffset = ::createVec(0, 0);
		this.m.DecapitateSplatterOffset = ::createVec(-30, -15);
		this.m.RenderAnimationDistanceMult = 3.0;
		this.m.DecapitateBloodAmount = 2.0;
		this.m.IsUsingZoneOfControl = false;
		this.m.SignaturePerks = ["HoldOut", "SteelBrow", "Fearsome", "Stalwart", "LegendComposure", "LegendPoisonImmunity"];
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.Kraken;
		this.m.AttributesLevelUp = ::Const.Nggh_AttributesLevelUp.Kraken;
		this.m.BonusHealthRecoverMult = 74.0;
		this.m.AttributesMax = {
			Hitpoints = 5000,
			Bravery = 500,
			Fatigue = 1000,
			Initiative = 100,
			MeleeSkill = 1000,
			RangedSkill = 50,
			MeleeDefense = 100,
			RangedDefense = 100,
		};
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/dlc2/krake_idle_01.wav",
			"sounds/enemies/dlc2/krake_idle_02.wav",
			"sounds/enemies/dlc2/krake_idle_03.wav",
			"sounds/enemies/dlc2/krake_idle_04.wav",
			"sounds/enemies/dlc2/krake_idle_05.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/krake_hurt_01.wav",
			"sounds/enemies/dlc2/krake_hurt_02.wav",
			"sounds/enemies/dlc2/krake_hurt_03.wav",
			"sounds/enemies/dlc2/krake_hurt_04.wav",
			"sounds/enemies/dlc2/krake_hurt_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/dlc2/krake_idle_01.wav",
			"sounds/enemies/dlc2/krake_idle_02.wav",
			"sounds/enemies/dlc2/krake_idle_03.wav",
			"sounds/enemies/dlc2/krake_idle_04.wav",
			"sounds/enemies/dlc2/krake_idle_05.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/krake_death_01.wav",
			"sounds/enemies/dlc2/krake_death_02.wav",
			"sounds/enemies/dlc2/krake_death_03.wav",
			"sounds/enemies/dlc2/krake_death_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
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
		this.m.Sound[::Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/dlc2/krake_enraging_01.wav",
			"sounds/enemies/dlc2/krake_enraging_02.wav",
			"sounds/enemies/dlc2/krake_enraging_03.wav",
			"sounds/enemies/dlc2/krake_enraging_04.wav"
		];
		this.m.SoundVolume[::Const.Sound.ActorEvent.Other1] = 1.5;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Death] = 1.5;
		this.m.Flags.add("regen_armor");
		this.m.Flags.add("kraken");
		this.m.Flags.add("boss");

		// can't equip most things
		local items = this.getItems(); 
		items.getData()[::Const.ItemSlot.Offhand][0] = -1;
		items.getData()[::Const.ItemSlot.Mainhand][0] = -1;
		items.getData()[::Const.ItemSlot.Head][0] = -1;
		items.getData()[::Const.ItemSlot.Body][0] = -1;
		items.getData()[::Const.ItemSlot.Ammo][0] = -1;
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (!::Tactical.State.isScenarioMode())
		{
			::updateAchievement("BeastOfBeasts", 1, 1);
		}

		this.nggh_mod_player_beast.onDeath(_killer, _skill, _tile, _fatalityType);
		local flip = this.m.IsCorpseFlipped;

		if (_tile != null)
		{
			local body = this.getSprite("body");
			local decal = _tile.spawnDetail("bust_kraken_body_01_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsResurrectable = false;
			corpse.IsConsumable = _fatalityType != ::Const.FatalityType.Unconscious;
			corpse.IsHeadAttached = _fatalityType != ::Const.FatalityType.Decapitated;
			corpse.Items = _fatalityType != ::Const.FatalityType.Unconscious ? this.getItems() : null;
			corpse.Armor = this.m.BaseProperties.Armor;
			corpse.Tile = _tile;
			corpse.Value = 10.0;
			corpse.IsPlayer = true;
			_tile.Properties.set("Corpse", corpse);
			::Tactical.Entities.addCorpse(_tile);

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

			if (_fatalityType == ::Const.FatalityType.Unconscious)
			{
				return;
			}

			::new("scripts/items/misc/kraken_horn_plate_item").drop(_tile);
			::new("scripts/items/misc/kraken_horn_plate_item").drop(_tile);
			::new("scripts/items/misc/kraken_tentacle_item").drop(_tile);

			if (!::Tactical.State.isScenarioMode() && ::World.Assets.getExtraLootChance() > 0)
			{
				::new("scripts/items/misc/kraken_horn_plate_item").drop(_tile);
			}
		}
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

		local hitInfo = clone ::Const.Tactical.HitInfo;
		hitInfo.DamageRegular = ::Math.max(50, 145 - (this.m.TentaclesDestroyed - 1) * 5);
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = ::Const.BodyPart.Head;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		this.onDamageReceived(this, null, hitInfo);

		if (!this.isAlive() || this.isDying())
		{
			return;
		}

		for( local numTentacles = ::Math.max(4, ::Math.min(8, ::Math.ceil(this.getHitpointsPct() * 2.0 * 8))); this.m.Tentacles.len() < numTentacles;  )
		{
			local mapSize = ::Tactical.getMapSize();
			local myTile = this.getTile();

			for( local attempts = 0; attempts < 500; attempts = ++attempts )
			{
				local x = ::Math.rand(::Math.max(0, myTile.SquareCoords.X - 8), ::Math.min(mapSize.X - 1, myTile.SquareCoords.X + 8));
				local y = ::Math.rand(::Math.max(0, myTile.SquareCoords.Y - 8), ::Math.min(mapSize.Y - 1, myTile.SquareCoords.Y + 8));
				local tile = ::Tactical.getTileSquare(x, y);

				if (!tile.IsEmpty)
				{
				}
				else
				{
					local tentacle = this.spawnTentacle(tile);

					if (tentacle != null)
					{
						tentacle.updateVisibilityForFaction();
					}
		
					break;
				}
			}
		}
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = ::Const.BodyPart.Head;
		local ret = this.nggh_mod_player_beast.onDamageReceived(_attacker, _skill, _hitInfo);

		if (!this.m.IsEnraged && this.canBeEnraged())
		{
			this.setEnraged(true);
		}

		return ret;
	}

	function onUpdateInjuryLayer()
	{
		local body = this.getSprite("body");

		if (this.getHitpointsPct() > 0.5)
		{
			body.setBrush("bust_kraken_body_01");
		}
		else
		{
			body.setBrush("bust_kraken_body_01_injured");
		}

		this.setDirty(true);
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		_appearance.Accessory = "";
		this.nggh_mod_player_beast.onAppearanceChanged(_appearance, _setDirty);
	}

	function onInit()
	{
		this.nggh_mod_player_beast.onInit();
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.Kraken);
		b.DamageReceivedRegularMult = 1.25;
		b.MovementFatigueCostMult = 2.0;
		b.TargetAttractionMult = 0.75;
		b.MovementAPCostMult = 1.67;
		b.FatigueRecoveryRate = 50;
		b.DailyFood = 20;
		b.Vision = 11;
		
		b.IsAffectedByRain = false;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToDaze = true;
		b.IsMovable = false;
		//b.IsRooted = true;

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		
		local body = this.getSprite("body");
		body.setBrush("bust_kraken_body_01");

		if (::Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.2);
		}

		if (::Math.rand(0, 100) < 90)
		{
			body.varyColor(0.08, 0.08, 0.08);
		}
		
		this.addDefaultStatusSprites();
		this.setSpriteOffset("arrow", ::createVec(20, 190));
	}

	function onAfterInit()
	{
		this.nggh_mod_player_beast.onAfterInit();
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_kraken_devour_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_kraken_command_release_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_kraken_spawn_tentacle_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_kraken_command_squeeze_skill"));

		// autopilot 
		local mode = ::new("scripts/skills/actives/nggh_mod_kraken_autopilot_mode");
		this.setMode(mode);
		this.m.Skills.add(mode);

		// switch mode (single)
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_kraken_change_tentacle_mode_single"));

		// switch mode (all)
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_kraken_change_tentacle_mode_all"));

		// preferred mode
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_kraken_preferred_tentacle_mode"));

		//this.m.Skills.add(this.new("scripts/skills/actives/mod_kraken_enrage_skill"));
	}

	function onAfterFactionChanged()
	{
		this.getSprite("body").setHorizontalFlipping(this.isAlliedWithPlayer());
	}

	function onCombatStart()
	{
		this.m.Tentacles = [];
		this.m.TentaclesDestroyed = 0;
		this.nggh_mod_player_beast.onCombatStart();
		this.spawnTentaclesAtBattleStart();
	}
	
	function onCombatFinished()
	{
		this.nggh_mod_player_beast.onCombatFinished();

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
	}

	function giveStats( _tentacle )
	{
		local b = _tentacle.m.BaseProperties;
		local lv = this.m.Level;
		b.ActionPoints += ::Math.rand(1, 10) <= 2 ? 1 : 0;
		b.Hitpoints += 5 * lv;
		b.Bravery += 2 * lv;
		b.Stamina += 2 * lv;
		b.MeleeSkill += ::Math.floor(1.5 * lv);
		b.RangedSkill += 0;
		b.MeleeDefense += lv;
		b.RangedDefense += lv;
		b.Initiative += 3 * lv;

		_tentacle.m.ActionPoints = b.ActionPoints;
		_tentacle.m.Skills.update();
		_tentacle.setHitpointsPct(1.0);
	}

	function givePerks( _tentacle )
	{
		foreach ( p in this.getSkills().query(::Const.SkillType.Perk, true) )
		{
			if (!p.isSerialized())
			{
				continue;
			}

			if (::Const.NoCopyPerks.find(p.getID()) != null)
			{
				continue;
			}

			/* a bit reduntant 
			if (this.getSkills().hasSkill(p.getID()))
			{
				continue;
			}
			*/

			local script = ::Nggh_MagicConcept.findPerkScriptByID(p.getID());

			if (script == null)
			{
				continue;
			}
			
			local perk = ::new(script);
			_tentacle.getSkills().add(perk);
			perk.onCombatStarted();
		}
	}

	function spawnTentaclesAtBattleStart()
	{
		local myTile = this.getTile();

		for( local i = 0; i < 8; ++i )
		{
			local mapSize = this.Tactical.getMapSize();

			for( local attempts = 0; attempts < 500; )
			{
				local x = ::Math.rand(::Math.max(0, myTile.SquareCoords.X - 2), ::Math.min(mapSize.X - 1, myTile.SquareCoords.X + 8));
				local y = ::Math.rand(::Math.max(0, myTile.SquareCoords.Y - 8), ::Math.min(mapSize.Y - 1, myTile.SquareCoords.Y + 8));
				local tile = ::Tactical.getTileSquare(x, y);

				if (!tile.IsEmpty)
				{
					++attempts;
					continue;
				}
				
				this.spawnTentacle(tile, true);
				break;
			}
		}
	}

	function spawnTentacle( _tile , _isInstant = false )
	{
		local tentacle = ::Tactical.spawnEntity(this.m.Script, _tile.Coords);
		tentacle.setParent(this);
		tentacle.setFaction(this.getFaction());
		tentacle.setMode(this.getTentacleBattleMode());
		tentacle.setName(this.getNameOnly() + "\'s Irrlicht");
		tentacle.getFlags().set("Source", this.getID());

		if (!_isInstant)
		{
			tentacle.riseFromGround(0.75);
		}

		this.getMode().onChangeAI(tentacle);
		this.givePerks(tentacle);
		this.giveStats(tentacle);

		this.m.Tentacles.push(::WeakTableRef(tentacle));
		return tentacle;
	}

	function getTentacleBattleMode()
	{
		if (this.getFlags().get("tentacle_autopilot"))
		{
			return this.getFlags().getAsInt("tentacle_mode");
		}

		return ::Const.KrakenTentacleMode.Attacking;
	}

	function setStartValuesEx( _isElite = false , _parameter_1 = null , _parameter_2 = null , _parameter_3 = null )
	{
		local type = ::Const.EntityType.Kraken;
		this.addDefaultBackground(type);

		this.getSkills().add(::new("scripts/skills/traits/player_character_trait"));
		this.setTitle(::MSU.Array.rand(::Const.Strings.KrakenTitlesOnly));
		this.getFlags().set("IsPlayerCharacter", true);

		this.setScenarioValues(type, _isElite);
	}

	function onRoundStart()
	{
		/*
		local myTile = this.getTile();

		if (myTile.hasNextTile(::Const.Direction.N))
		{
			local tile = myTile.getNextTile(::Const.Direction.N);

			if (tile.IsEmpty)
			{
				::Tactical.spawnEntity("scripts/entity/tactical/objects/swamp_tree1", tile.Coords);
			}

			if (tile.hasNextTile(::Const.Direction.N))
			{
				local tile = tile.getNextTile(::Const.Direction.N);

				if (tile.IsEmpty)
				{
					::Tactical.spawnEntity("scripts/entity/tactical/objects/swamp_tree1", tile.Coords);
				}
			}
		}
		*/

		this.nggh_mod_player_beast.onRoundStart();

		if (::Time.getRound() == 1 && this.isAlive())
		{
			this.playSound(::Const.Sound.ActorEvent.Other1, ::Const.Sound.Volume.Actor * this.m.SoundVolume[::Const.Sound.ActorEvent.Other1] * this.m.SoundVolumeOverall);
		}
	}

	function onRetreating()
	{
		if (!this.isPlacedOnMap())
		{
			return;
		}

		this.getMode().switchMode(true);
	}

	function canEnterBarber()
	{
		return false;
	}

});

