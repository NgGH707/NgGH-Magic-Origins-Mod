this.nggh_mod_lindwurm_player <- ::inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {
		Tail = null,
	},
	// OwO! i luv scalie boi, especially when they have a long thick tail, a bit squishy is even better, don't judge me :3
	function isStollwurm()
	{
		return this.getFlags().get("Type") == ::Const.EntityType.LegendStollwurm;
	}
	
	function getStrengthMult()
	{
		return this.isStollwurm() ? 9.0 : 3.0;
	}

	function getHitpointsPerVeteranLevel()
	{
		return ::Math.rand(1, 3);
	}
	
	function getImageOffsetY()
	{
		return this.isStollwurm() ? 0 : 20;
	}

	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.BloodType = ::Const.BloodType.Green;
		this.m.BloodSplatterOffset = ::createVec(0, 0);
		this.m.DecapitateSplatterOffset = ::createVec(-30, -15);
		this.m.DecapitateBloodAmount = 2.0;
		this.m.SignaturePerks = ["Fearsome"];
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.Lindwurm;
		this.m.AttributesLevelUp = ::Const.Nggh_AttributesLevelUp.Lindwurm;
		this.m.BonusHealthRecoverMult = 4.0;
		this.m.AttributesMax = {
			Hitpoints = 3000,
			Bravery = 400,
			Fatigue = 700,
			Initiative = 200,
			MeleeSkill = 150,
			RangedSkill = 50,
			MeleeDefense = 100,
			RangedDefense = 100,
		};
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/lindwurm_fleeing_01.wav",
			"sounds/enemies/lindwurm_fleeing_02.wav",
			"sounds/enemies/lindwurm_fleeing_03.wav",
			"sounds/enemies/lindwurm_fleeing_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/lindwurm_hurt_01.wav",
			"sounds/enemies/lindwurm_hurt_02.wav",
			"sounds/enemies/lindwurm_hurt_03.wav",
			"sounds/enemies/lindwurm_hurt_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/lindwurm_idle_01.wav",
			"sounds/enemies/lindwurm_idle_02.wav",
			"sounds/enemies/lindwurm_idle_03.wav",
			"sounds/enemies/lindwurm_idle_04.wav",
			"sounds/enemies/lindwurm_idle_05.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/lindwurm_flee_01.wav",
			"sounds/enemies/lindwurm_flee_02.wav",
			"sounds/enemies/lindwurm_flee_03.wav",
			"sounds/enemies/lindwurm_flee_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/lindwurm_death_01.wav",
			"sounds/enemies/lindwurm_death_02.wav",
			"sounds/enemies/lindwurm_death_03.wav",
			"sounds/enemies/lindwurm_death_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/lindwurm_idle_06.wav",
			"sounds/enemies/lindwurm_idle_07.wav",
			"sounds/enemies/lindwurm_idle_08.wav",
			"sounds/enemies/lindwurm_idle_09.wav",
			"sounds/enemies/lindwurm_idle_10.wav",
			"sounds/enemies/lindwurm_idle_11.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Move] = this.m.Sound[::Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] = 1.5;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Death] = 1.5;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Flee] = 1.5;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Move] = 1.5;
		this.m.SoundPitch = ::Math.rand(95, 105) * 0.01;
		this.m.Flags.add("body_immune_to_acid");
		this.m.Flags.add("head_immune_to_acid");
		this.m.Flags.add("regen_armor");
		this.m.Flags.add("lindwurm");

		// can't equip most things
		local items = this.getItems(); 
		items.getData()[::Const.ItemSlot.Offhand][0] = -1;
		items.getData()[::Const.ItemSlot.Mainhand][0] = -1;
		items.getData()[::Const.ItemSlot.Body][0] = -1;
		items.getData()[::Const.ItemSlot.Ammo][0] = -1;
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == ::Const.Sound.ActorEvent.Move && ::Math.rand(1, 100) <= 50)
		{
			return;
		}

		this.nggh_mod_player_beast.playSound(_type, _volume, _pitch);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.nggh_mod_player_beast.onDeath(_killer, _skill, _tile, _fatalityType);
		local flip = this.m.IsCorpseFlipped;
		
		if (_tile != null)
		{
			local body = this.getSprite("body");
			local head = this.getSprite("head");
			local decal = _tile.spawnDetail(body.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;

			if (_fatalityType != ::Const.FatalityType.Decapitated)
			{
				decal = _tile.spawnDetail(head.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = head.Color;
				decal.Saturation = head.Saturation;
				decal.Scale = 0.95;
			}
			else if (_fatalityType == ::Const.FatalityType.Decapitated)
			{
				local layers = [
					head.getBrush().Name + "_dead"
				];
				local decap = ::Tactical.spawnHeadEffect(this.getTile(), layers, ::createVec(0, 0), 0.0, head.getBrush().Name + "_bloodpool");
				decap[0].Color = head.Color;
				decap[0].Saturation = head.Saturation;
				decap[0].Scale = 0.95;
			}

			if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail(body.getBrush().Name + "_dead_arrows", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail(body.getBrush().Name + "_dead_javelin", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
			local corpse = clone ::Const.Corpse;
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

			if (_fatalityType != ::Const.FatalityType.Unconscious)
			{
				local isStollwurm = this.isStollwurm();
				local n = 1 + (::Math.rand(1, 100) <= ::World.Assets.getExtraLootChance() ? 1 : 0);

				for( local i = 0; i < n; ++i )
				{
					if (::Math.rand(1, 100) <= 35)
					{
						::new("scripts/items/misc/" + (isStollwurm ? "legend_stollwurm_blood_item" : "lindwurm_blood_item")).drop(_tile);
					}
					else if (r <= 70)
					{
						::new("scripts/items/misc/" + (isStollwurm ? "legend_stollwurm_scales_item" : "lindwurm_scales_item")).drop(_tile);
					}
					else
					{
						::new("scripts/items/misc/lindwurm_bones_item").drop(_tile);
					}
				}
			}

			::new("scripts/items/tools/acid_flask_item").drop(_tile);
		}
	}

	function kill( _killer = null, _skill = null, _fatalityType = ::Const.FatalityType.None, _silent = false )
	{
		this.m.IsDying = true;

		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			this.m.Tail.kill(_killer, _skill, _fatalityType, _silent);
			this.m.Tail = null;
		}

		this.nggh_mod_player_beast.kill(_killer, _skill, _fatalityType, _silent);
	}

	function updateOverlay()
	{
		this.nggh_mod_player_beast.updateOverlay();

		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			this.m.Tail.updateOverlay();
		}
	}

	function setFaction( _f )
	{
		this.nggh_mod_player_beast.setFaction(_f);

		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			this.m.Tail.setFaction(_f);
		}
	}

	function checkMorale( _change, _difficulty, _type = ::Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
	{
		this.nggh_mod_player_beast.checkMorale(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);

		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			this.m.Tail.setMoraleState(this.getMoraleState());
		}
	}
	
	function retreat()
	{
		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			this.m.Tail.m.IsAlive = false;
			this.m.Tail.die();
		}
		
		this.m.Tail = null;
		this.nggh_mod_player_beast.retreat();
	}
	
	function onCombatFinished()
	{
		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			this.m.Tail.m.IsAlive = false;
			this.m.Tail.die();
		}
		
		this.m.Tail = null;
		this.nggh_mod_player_beast.onCombatFinished();
	}

	function onTurnStart()
	{
		this.nggh_mod_player_beast.onTurnStart();

		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			local tail = this.m.Tail;

			::Time.scheduleEvent(::TimeUnit.Virtual, 100, function ( _e )
			{
				::Tactical.TurnSequenceBar.moveEntityToFront(tail.getID());
			}.bindenv(this), this);
		}
	}
	
	function onMovementFinish( _tile )
	{
		this.actor.onMovementFinish(_tile);

		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			::Tactical.TurnSequenceBar.moveEntityToFront(this.m.Tail.getID());
		}

		if (this.m.Tail == null || this.m.Tail.isNull())
		{
			for( local i = 0; i < 6; ++i )
			{
				if (!_tile.hasNextTile(i))
				{
				}
				else if (_tile.getNextTile(i).IsEmpty && !_tile.getNextTile(i).IsOccupiedByActor)
				{
					this.spawnTail(_tile.getNextTile(i));
					break;
				}
			}
		}
	}

	function onCombatStart()
	{
		this.nggh_mod_player_beast.onCombatStart();

		if (!this.isPlacedOnMap())
		{
			return;
		}

		if (this.m.Tail == null)
		{
			local myTile = this.getTile();
			local spawnTile;

			if (myTile.hasNextTile(::Const.Direction.NW) && myTile.getNextTile(::Const.Direction.NW).IsEmpty && !myTile.getNextTile(::Const.Direction.NW).IsOccupiedByActor)
			{
				spawnTile = myTile.getNextTile(::Const.Direction.NW);
			}
			else if (myTile.hasNextTile(::Const.Direction.SW) && myTile.getNextTile(::Const.Direction.SW).IsEmpty && !myTile.getNextTile(::Const.Direction.SW).IsOccupiedByActor)
			{
				spawnTile = myTile.getNextTile(::Const.Direction.SW);
			}
			else
			{
				for( local i = 0; i < 6; ++i )
				{
					if (!myTile.hasNextTile(i))
					{
					}
					else if (myTile.getNextTile(i).IsEmpty && !myTile.getNextTile(i).IsOccupiedByActor)
					{
						spawnTile = myTile.getNextTile(i);
						break;
					}
				}
			}

			if (spawnTile != null)
			{
				this.spawnTail(spawnTile);
			}
		}
	}

	function spawnTail( _tile )
	{
		local tail = ::Tactical.spawnEntity("scripts/entity/tactical/player_beast/nggh_mod_lindwurm_tail_player", _tile.Coords.X, _tile.Coords.Y, this.getID());		
		
		if (tail != null)
		{
			this.m.Tail = ::WeakTableRef(tail);
			//this.m.Tail.setBody(this);
			this.m.Tail.setName(this.getName() + "\'s Tail");
			this.m.Tail.setFaction(this.getFaction());
			this.m.Tail.setVariant(this.getFlags().get("Type"), this.getSprite("body").getBrush().Name);
			this.addPerksAndTraits();
		}
	}
	
	function addPerksAndTraits()
	{
		foreach (i, _skill in this.getSkills().m.Skills )
		{
			if (_skill == null || _skill.getItem() != null || _skill.m.IsWeaponSkill)
			{
				continue;
			}

			if ([
				"perk.lindwurm_acid",
				"perk.intimidate",
				"perk.ptr_discovered_talent"
				"perk.gifted",
				"trait.double_tongued",
				"trait.seductive",
				"trait.determined",
				"trait.gift_of_people",
				"special.mood_check",
				"special.stats_collector",
				"terrain.hidden",
				"terrain.swamp",
			].find(_skill.getID()) != null)
			{
				continue;
			}

			if (_skill.isType(::Const.SkillType.Background))
			{
				continue;
			}

			if (_skill.isType(::Const.SkillType.Active))
			{
				continue;
			}

		 	local script = ::IO.scriptFilenameByHash(_skill.ClassNameHash);

		   	if (script != null)
			{
				local _s = ::new(script)
				this.m.Tail.getSkills().add(_s);
				_s.onCombatStarted();
			}
		}

		this.m.Tail.getSkills().update();
	}

	function onAfterFactionChanged()
	{
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("accessory").setHorizontalFlipping(!flip);
		this.getSprite("accessory_special").setHorizontalFlipping(!flip);

		this.nggh_mod_player_beast.onAfterFactionChanged();
	}

	function onInit()
	{
		this.nggh_mod_player_beast.onInit();
		local b = this.m.BaseProperties;
		b.IsAffectedByNight = false;
		b.IsAffectedByRain = false;
		b.IsMovable = false;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToDisarm = true;

		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		
		//this.addSprite("body");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		this.addSprite("head");
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_lindwurm_body_01_injured");

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		local body_blood = this.addSprite("body_blood");
		body_blood.Visible = false;
		
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.63;
		this.setSpriteOffset("status_rooted", ::createVec(0, 15));
		this.setSpriteOffset("status_stunned", ::createVec(-5, 30));
		this.setSpriteOffset("arrow", ::createVec(-5, 30));
	}
	
	function onAfterInit()
	{
		this.nggh_mod_player_beast.onAfterInit();
		this.m.Skills.add(::new("scripts/skills/actives/gorge_skill"));
		this.m.Skills.add(::new("scripts/skills/racial/lindwurm_racial"));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.nggh_mod_player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local v = ::createVec(20, 5);

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, v);
			this.getSprite(a).Scale = 1.10;
		}

		this.setSpriteOffset("accessory", ::createVec(0, 0));
		this.setSpriteOffset("accessory_special", ::createVec(0, 0));
		this.setAlwaysApplySpriteOffset(true);
	}
	
	function setStartValuesEx( _isElite = false, _isStollwurm = false, _parameter_1 = null, _parameter_2 = null )
	{
		local b = this.m.BaseProperties;
		local type = _isStollwurm ? ::Const.EntityType.LegendStollwurm : ::Const.EntityType.Lindwurm;
		local body = this.getSprite("body");
		local head = this.getSprite("head");
		local injury = this.getSprite("injury");
		local body_blood = this.getSprite("body_blood");

		switch (true) 
		{
		case _isStollwurm:
		    b.setValues(::Const.Tactical.Actor.LegendStollwurm);
			body.setBrush("bust_stollwurm_body_01");
			head.setBrush("bust_stollwurm_head_01");
			injury.setBrush("bust_stollwurm_body_01_injured");
		    break;
		
		default:
			b.setValues(::Const.Tactical.Actor.Lindwurm);
			body.setBrush("bust_lindwurm_body_01");
			head.setBrush("bust_lindwurm_head_01");
			injury.setBrush("bust_lindwurm_body_01_injured");
		}

		// update the properties
		this.m.CurrentProperties = clone b;

		if (::Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.2);
		}

		if (::Math.rand(0, 100) < 90)
		{
			body.varyColor(0.08, 0.08, 0.08);
		}

		head.Color = body.Color;
		head.Saturation = body.Saturation;
		injury.Visible = false;
		body_blood.Visible = false;
		
		this.getSprite("status_rooted").Scale = 0.63;
		this.setSpriteOffset("status_rooted", ::createVec(0, 15));
		this.setSpriteOffset("status_stunned", ::createVec(-5, 30));
		this.setSpriteOffset("arrow", ::createVec(-5, 30));
		this.addDefaultBackground(type);
		
		this.setScenarioValues(type, _isElite);
	}

	function setScenarioValues( _type, _isElite = false, _randomizedTalents = false, _setName = false )
	{
		this.nggh_mod_player_beast.setScenarioValues(_type, _isElite, _randomizedTalents, _setName);

		if (this.m.Skills.hasSkill("racial.champion"))
		{
			this.m.Skills.add(::new("scripts/skills/traits/fearless_trait"));

			// a bit bias for the green scalie, especially the alpha one OwO
			if (_type == ::Const.EntityType.Lindwurm)
			{
				this.m.BaseProperties.ActionPoints = 8;
			}
		}
	}

	function getPossibleSprites( _layer )
	{
		switch (_layer) 
		{
	    case "body":
	        return [
	        	"bust_lindwurm_body_01",
	        	"bust_stollwurm_body_01",
	        ];

	    case "head":
	        return [
	        	"bust_lindwurm_head_01",
	        	"bust_stollwurm_head_01",
	        ];
		}

		return [];
	}
	
	function updateVariant()
	{
		local app = this.getItems().getAppearance();
		local brush = this.getSprite("body").getBrush().Name;
		app.Body = brush;
		app.Corpse = brush + "_dead";

		local b = this.m.BaseProperties;
		b.DailyFood = this.isStollwurm() ? 16 : 12; // very hungry boi UwU
	}
	
});

