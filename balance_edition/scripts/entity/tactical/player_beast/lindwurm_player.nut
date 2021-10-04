this.lindwurm_player <- this.inherit("scripts/entity/tactical/player_beast", {
	m = {
		Tail = null,
		Mode = 0,
	},
	
	function getStrength()
	{
		return this.getType(true) == this.Const.EntityType.LegendStollwurm ? 9.0 : 3.0;
	}
	
	function getImageOffsetY()
	{
		return this.getType(true) == this.Const.EntityType.LegendStollwurm ? 0 : 20;
	}
	
	function getMode()
	{
		return this.m.Mode;
	}
	
	function getHealthRecoverMult()
	{
		return 5;
	}

	function setMode( _m )
	{
		this.m.Mode = _m;

		if (this.isPlacedOnMap())
		{
			if (this.m.Mode == 0 && _m == 1)
			{
				this.m.IsUsingZoneOfControl = true;
				this.getTile().addZoneOfControl(this.getFaction());
			}

			this.onUpdateInjuryLayer();
		}
	}
	
	function getIdealRange()
	{
		return 2;
	}

	function create()
	{
		this.player_beast.create();
		this.m.Type = this.Const.EntityType.Player;
		this.m.BloodType = this.Const.BloodType.Green;
		this.m.XP = this.Const.Tactical.Actor.Lindwurm.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(-30, -15);
		this.m.DecapitateBloodAmount = 2.0;
		this.m.hitpointsMax = 3000;
		this.m.braveryMax = 400;
		this.m.fatigueMax = 700;
		this.m.initiativeMax = 200;
		this.m.meleeSkillMax = 150;
		this.m.rangeSkillMax = 150;
		this.m.meleeDefenseMax = 120;	
		this.m.rangeDefenseMax = 120;
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/lindwurm_fleeing_01.wav",
			"sounds/enemies/lindwurm_fleeing_02.wav",
			"sounds/enemies/lindwurm_fleeing_03.wav",
			"sounds/enemies/lindwurm_fleeing_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/lindwurm_hurt_01.wav",
			"sounds/enemies/lindwurm_hurt_02.wav",
			"sounds/enemies/lindwurm_hurt_03.wav",
			"sounds/enemies/lindwurm_hurt_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/lindwurm_idle_01.wav",
			"sounds/enemies/lindwurm_idle_02.wav",
			"sounds/enemies/lindwurm_idle_03.wav",
			"sounds/enemies/lindwurm_idle_04.wav",
			"sounds/enemies/lindwurm_idle_05.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/lindwurm_flee_01.wav",
			"sounds/enemies/lindwurm_flee_02.wav",
			"sounds/enemies/lindwurm_flee_03.wav",
			"sounds/enemies/lindwurm_flee_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/lindwurm_death_01.wav",
			"sounds/enemies/lindwurm_death_02.wav",
			"sounds/enemies/lindwurm_death_03.wav",
			"sounds/enemies/lindwurm_death_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/lindwurm_idle_06.wav",
			"sounds/enemies/lindwurm_idle_07.wav",
			"sounds/enemies/lindwurm_idle_08.wav",
			"sounds/enemies/lindwurm_idle_09.wav",
			"sounds/enemies/lindwurm_idle_10.wav",
			"sounds/enemies/lindwurm_idle_11.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 1.5;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 1.5;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Flee] = 1.5;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 1.5;
		this.m.SoundPitch = this.Math.rand(95, 105) * 0.01;
		this.m.Items.blockAllSlots();
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Accessory] = false;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Head] = false;
		this.getFlags().add("body_immune_to_acid");
		this.getFlags().add("head_immune_to_acid");
		this.getFlags().add("lindwurm");
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == this.Const.Sound.ActorEvent.Move && this.Math.rand(1, 100) <= 50)
		{
			return;
		}

		this.actor.playSound(_type, _volume, _pitch);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.player_beast.onDeath(_killer, _skill, _tile, _fatalityType);
		
		if (_tile != null)
		{
			local flip = this.Math.rand(0, 100) < 50;
			local decal;
			this.m.IsCorpseFlipped = flip;
			local body = this.getSprite("body");
			local head = this.getSprite("head");
			decal = _tile.spawnDetail("bust_lindwurm_body_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;

			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				decal = _tile.spawnDetail("bust_lindwurm_head_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = head.Color;
				decal.Saturation = head.Saturation;
				decal.Scale = 0.95;
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [
					head.getBrush().Name + "_dead"
				];
				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(0, 0), 0.0, "bust_lindwurm_head_01_bloodpool");
				decap[0].Color = head.Color;
				decap[0].Saturation = head.Saturation;
				decap[0].Scale = 0.95;
			}

			if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail("bust_lindwurm_body_01_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail("bust_lindwurm_body_01_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);

			local n = 1 + (!this.Tactical.State.isScenarioMode() && this.Math.rand(1, 100) <= this.World.Assets.getExtraLootChance() ? 1 : 0);

			for( local i = 0; i < n; i = ++i )
			{
				if (this.Const.DLC.Unhold)
				{
					local r = this.Math.rand(1, 100);
					local loot;

					if (r <= 35)
					{
						loot = this.new("scripts/items/misc/lindwurm_blood_item");
					}
					else if (r <= 70)
					{
						loot = this.new("scripts/items/misc/lindwurm_scales_item");
					}
					else
					{
						loot = this.new("scripts/items/misc/lindwurm_bones_item");
					}

					loot.drop(_tile);
				}
				else
				{
					local loot = this.new("scripts/items/tools/acid_flask_item");
					loot.drop(_tile);
				}
			}

			local loot = this.new("scripts/items/loot/lindwurm_hoard_item");
			loot.drop(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function kill( _killer = null, _skill = null, _fatalityType = this.Const.FatalityType.None, _silent = false )
	{
		this.m.IsDying = true;

		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			this.m.Tail.kill(_killer, _skill, _fatalityType, _silent);
			this.m.Tail = null;
		}

		this.actor.kill(_killer, _skill, _fatalityType, _silent);
	}

	function updateOverlay()
	{
		this.player_beast.updateOverlay();

		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			this.m.Tail.updateOverlay();
		}
	}

	function setFaction( _f )
	{
		this.actor.setFaction(_f);

		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			this.m.Tail.setFaction(_f);
		}
	}

	function checkMorale( _change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
	{
		this.actor.checkMorale(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);

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
			this.m.Tail = null;
		}
		
		if (!this.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " has retreated from battle");
		}

		this.m.IsTurnDone = true;
		this.m.IsAbleToDie = false;
		this.Tactical.getRetreatRoster().add(this);
		this.removeFromMap();
		this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.PlayerRetreated);
	}
	
	function onCombatFinished()
	{
		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			this.m.Tail.m.IsAlive = false;
			this.m.Tail.die();
			this.m.Tail = null;
		}
		
		this.player_beast.onCombatFinished();
	}
	
	function onMovementFinish( _tile )
	{
		this.actor.onMovementFinish(_tile);

		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			this.Tactical.TurnSequenceBar.moveEntityToFront(this.m.Tail.getID());
		}

		if (this.m.Tail == null || this.m.Tail.isNull())
		{
			local spawnTile;

			for( local i = 0; i < 6; i = ++i )
			{
				if (!_tile.hasNextTile(i))
				{
				}
				else if (_tile.getNextTile(i).IsEmpty && !_tile.getNextTile(i).IsOccupiedByActor)
				{
					spawnTile = _tile.getNextTile(i);
					break;
				}
			}

			if (spawnTile != null)
			{
				local type = this.getType(true) == this.Const.EntityType.LegendStollwurm ? "stollwurm_tail_player" : "lindwurm_tail_player";	
				local body = this.getSprite("body");				
				this.m.Tail = this.WeakTableRef(this.Tactical.spawnEntity("scripts/entity/tactical/player_beast/" + type, spawnTile.Coords.X, spawnTile.Coords.Y, this.getID()));
				this.m.Tail.m.Body = this.WeakTableRef(this);
				this.m.Tail.setName(this.getName() + "\'s Tail");
				this.m.Tail.setFaction(this.getFaction());
				this.m.Tail.getSprite("body").Color = body.Color;
				this.m.Tail.getSprite("body").Saturation = body.Saturation;
				this.addPerksAndTraits(this.m.Tail);
			}
		}
	}
	
	function onFactionChanged()
	{
		this.player_beast.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
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
	}

	function onCombatStart()
	{
		this.player_beast.onCombatStart();

		if (!this.isPlacedOnMap())
		{
			return;
		}

		if (this.m.Tail == null)
		{
			local myTile = this.getTile();
			local spawnTile;

			if (myTile.hasNextTile(this.Const.Direction.NW) && myTile.getNextTile(this.Const.Direction.NW).IsEmpty && !myTile.getNextTile(this.Const.Direction.NW).IsOccupiedByActor)
			{
				spawnTile = myTile.getNextTile(this.Const.Direction.NW);
			}
			else if (myTile.hasNextTile(this.Const.Direction.SW) && myTile.getNextTile(this.Const.Direction.SW).IsEmpty && !myTile.getNextTile(this.Const.Direction.SW).IsOccupiedByActor)
			{
				spawnTile = myTile.getNextTile(this.Const.Direction.SW);
			}
			else
			{
				for( local i = 0; i < 6; i = ++i )
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
				local type = this.getType(true) == this.Const.EntityType.LegendStollwurm ? "stollwurm_tail_player" : "lindwurm_tail_player";	
				local body = this.getSprite("body");				
				this.m.Tail = this.WeakTableRef(this.Tactical.spawnEntity("scripts/entity/tactical/player_beast/" + type, spawnTile.Coords.X, spawnTile.Coords.Y, this.getID()));
				this.m.Tail.m.Body = this.WeakTableRef(this);
				this.m.Tail.setName(this.getName() + "\'s Tail");
				this.m.Tail.setFaction(this.getFaction());
				this.m.Tail.getSprite("body").Color = body.Color;
				this.m.Tail.getSprite("body").Saturation = body.Saturation;
				this.addPerksAndTraits(this.m.Tail);
			}
		}
	}
	
	function addPerksAndTraits( _tail )
	{
		local allSkills = this.getSkills().m.Skills;
		local exclude = [
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
		];

		foreach (i, _skill in allSkills )
		{
			if (_skill == null || _skill.getItem() != null || _skill.m.IsWeaponSkill)
			{
				continue;
			}

			if (_skill.isType(this.Const.SkillType.Background))
			{
				continue;
			}

		   	local className = _skill.ClassNameHash;
		 	local script = this.IO.scriptFilenameByHash(className);

		   	if (script != null)
			{
				local _s = this.new(script)
				_tail.getSkills().add(_s);
				_s.onCombatStarted();
			}
		}

		_tail.getSkills().update();
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

	function onInit()
	{
		this.player_beast.onInit();
		local b = this.m.BaseProperties;
		b.IsAffectedByNight = false;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsMovable = false;
		b.IsImmuneToDisarm = true;
		b.DailyFood = 12;

		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		this.addSprite("body");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		this.addSprite("head");
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_lindwurm_body_01_injured");

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		local body_blood = this.addSprite("body_blood");
		body_blood.Visible = false;
		
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.63;
		this.setSpriteOffset("status_rooted", this.createVec(0, 15));
		this.setSpriteOffset("status_stunned", this.createVec(-5, 30));
		this.setSpriteOffset("arrow", this.createVec(-5, 30));
	}
	
	function onAfterInit()
	{
		this.player_beast.onAfterInit();
		local p = this.new("scripts/skills/perks/perk_fearsome");
		p.m.IsSerialized = false;
		this.m.Skills.add(p);
		this.m.Skills.add(this.new("scripts/skills/actives/gorge_skill"));
		this.m.Skills.add(this.new("scripts/skills/racial/lindwurm_racial"));
		this.m.Skills.update();
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local v = 5;
		local v2 = 20;

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, this.createVec(v2, v));
			this.getSprite(a).Scale = 1.10;
		}

		this.setSpriteOffset("accessory", this.createVec(0, 0));
		this.setSpriteOffset("accessory_special", this.createVec(0, 0));
		this.setAlwaysApplySpriteOffset(true);
	}
	
	function setScenarioValues( _isElite = false, _isStollwurm = false, _Dub = false, _Dub_two = false )
	{
		local b = this.m.BaseProperties;
		local type = this.Const.EntityType.Lindwurm;
		local body = this.getSprite("body");
		local head = this.getSprite("head");
		local injury = this.getSprite("injury");
		local body_blood = this.getSprite("body_blood");

		switch (true) 
		{
		case _isStollwurm:
			type = this.Const.EntityType.LegendStollwurm;
		    b.setValues(this.Const.Tactical.Actor.LegendStollwurm);
			body.setBrush("bust_stollwurm_body_01");
			head.setBrush("bust_stollwurm_head_01");
			injury.setBrush("bust_stollwurm_body_01_injured");
		    break;
		
		default:
			b.setValues(this.Const.Tactical.Actor.Lindwurm);
			body.setBrush("bust_lindwurm_body_01");
			head.setBrush("bust_lindwurm_head_01");
			injury.setBrush("bust_lindwurm_body_01_injured");
		}

		if (this.Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.2);
		}

		if (this.Math.rand(0, 100) < 90)
		{
			body.varyColor(0.08, 0.08, 0.08);
		}

		head.Color = body.Color;
		head.Saturation = body.Saturation;
		injury.Visible = false;
		body_blood.Visible = false;
		
		this.getSprite("status_rooted").Scale = 0.63;
		this.setSpriteOffset("status_rooted", this.createVec(0, 15));
		this.setSpriteOffset("status_stunned", this.createVec(-5, 30));
		this.setSpriteOffset("arrow", this.createVec(-5, 30));

		if (_isElite || this.Math.rand(1, 100) == 100)
		{
			this.getSkills().add(this.new("scripts/skills/racial/champion_racial"));
			this.m.Skills.add(this.new("scripts/skills/traits/fearless_trait"));
			this.getFlags().add("isElite");
		}
		
		local background = this.new("scripts/skills/backgrounds/charmed_beast_background");
		background.setTo(type);
		this.m.Skills.add(background);
		background.onSetUp();
		background.buildDescription();
		
		local c = this.m.CurrentProperties;
		this.m.ActionPoints = c.ActionPoints;
		this.m.Hitpoints = c.Hitpoints;
		this.m.Talents = [];
		this.m.Attributes = [];
		this.fillBeastTalentValues(this.Math.rand(6, 9), true);
		this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
	}
	
	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
		local AttributesLevelUp = [
			{
				Min = 4,
				Max = 8
			},
			{
				Min = 3,
				Max = 5
			},
			{
				Min = 3,
				Max = 5
			},
			{
				Min = 2,
				Max = 2
			},
			{
				Min = 2,
				Max = 3
			},
			{
				Min = 1,
				Max = 1
			},
			{
				Min = 1,
				Max = 2
			},
			{
				Min = 1,
				Max = 2
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
					this.m.Attributes[i].insert(0, this.Math.rand(1, this.Math.rand(1, 2)));
				}
				else if (_maxOnly)
				{
					this.m.Attributes[i].insert(0, AttributesLevelUp[i].Max);
				}
				else
				{
					this.m.Attributes[i].insert(0, this.Math.rand(AttributesLevelUp[i].Min + (this.m.Talents[i] == 3 ? 2 : this.m.Talents[i]), AttributesLevelUp[i].Max + (this.m.Talents[i] == 3 ? 1 : 0)));
				}
			}
		}
	}

	function setAttributeLevelUpValues( _v )
	{
		local value = this.Math.rand(4, 8) * 2;
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
		b.Armor[0] += value;
		b.ArmorMax[0] += value;
		b.Armor[1] += value;
		b.ArmorMax[1] += value;
		this.m.LevelUps = this.Math.max(0, this.m.LevelUps - 1);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			this.m.Attributes[i].remove(0);
		}
		
		this.m.CurrentProperties = clone b;
		
		this.getSkills().update();
		this.setDirty(true);
	}

	function getPossibleSprites( _type )
	{
		local ret = [];

		switch (_type) 
		{
	    case "body":
	        ret = [
	        	"bust_lindwurm_body_01",
	        	"bust_stollwurm_body_01",
	        ];
	        break;

	    case "head":
	        ret = [
	        	"bust_lindwurm_head_01",
	        	"bust_stollwurm_head_01",
	        ];
	        break;
		}

		return ret;
	}
	
	function getExcludeTraits()
	{
		return [
			"trait.tiny",
			"trait.drunkard",
			"trait.dastard",
			"trait.deathwish",
			"trait.insecure",
			"trait.superstitious",
			"trait.craven",
			"trait.greedy",
			"trait.spartan",
			"trait.loyal",
			"trait.disloyal",
			"trait.survivor",
			"trait.night_blind",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.weasel",
			"trait.steady_hands",
			"trait.light",
			"trait.gift_of_people",
			"trait.double_tongued",
		];
	}
	
});

