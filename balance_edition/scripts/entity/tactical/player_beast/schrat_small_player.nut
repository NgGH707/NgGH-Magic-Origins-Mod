this.schrat_small_player <- this.inherit("scripts/entity/tactical/player_beast", {
	m = {},
	
	function getStrength()
	{
		return this.getType(true) == this.Const.EntityType.LegendGreenwoodSchratSmall ? 1.15 : 0.67;
	}
	
	function create()
	{
		this.player_beast.create();
		this.m.Type = this.Const.EntityType.Player;
		this.m.BloodType = this.Const.BloodType.Wood;
		this.m.XP = this.Const.Tactical.Actor.SchratSmall.XP;
		this.m.BloodSplatterOffset = this.createVec(0, -20);
		this.m.DecapitateSplatterOffset = this.createVec(-10, -25);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.DeathBloodAmount = 0.35;
		this.m.hitpointsMax = 250;
		this.m.braveryMax = 300;
		this.m.fatigueMax = 600;
		this.m.initiativeMax = 200;
		this.m.meleeSkillMax = 200;
		this.m.rangeSkillMax = 200;
		this.m.meleeDefenseMax = 150;
		this.m.rangeDefenseMax = 125;
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/ambience/terrain/forest_branch_crack_00.wav",
			"sounds/ambience/terrain/forest_branch_crack_01.wav",
			"sounds/ambience/terrain/forest_branch_crack_02.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/schrat_shield_damage_01.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_02.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_03.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_04.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/ambience/terrain/forest_branch_crack_00.wav",
			"sounds/ambience/terrain/forest_branch_crack_01.wav",
			"sounds/ambience/terrain/forest_branch_crack_02.wav",
			"sounds/ambience/terrain/forest_branch_crack_03.wav",
			"sounds/ambience/terrain/forest_branch_crack_04.wav",
			"sounds/ambience/terrain/forest_branch_crack_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/dlc2/schrat_death_01.wav",
			"sounds/enemies/dlc2/schrat_death_02.wav",
			"sounds/enemies/dlc2/schrat_death_03.wav",
			"sounds/enemies/dlc2/schrat_death_04.wav",
			"sounds/enemies/dlc2/schrat_death_05.wav",
			"sounds/enemies/dlc2/schrat_death_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/sapling_death_01.wav",
			"sounds/enemies/dlc2/sapling_death_02.wav",
			"sounds/enemies/dlc2/sapling_death_03.wav",
			"sounds/enemies/dlc2/sapling_death_04.wav",
			"sounds/enemies/dlc2/sapling_death_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc2/schrat_idle_01.wav",
			"sounds/enemies/dlc2/schrat_idle_02.wav",
			"sounds/enemies/dlc2/schrat_idle_03.wav",
			"sounds/enemies/dlc2/schrat_idle_04.wav",
			"sounds/enemies/dlc2/schrat_idle_05.wav",
			"sounds/enemies/dlc2/schrat_idle_06.wav",
			"sounds/enemies/dlc2/schrat_idle_07.wav",
			"sounds/enemies/dlc2/schrat_idle_08.wav",
			"sounds/enemies/dlc2/schrat_idle_09.wav",
			"sounds/ambience/terrain/forest_branch_crack_00.wav",
			"sounds/ambience/terrain/forest_branch_crack_01.wav",
			"sounds/ambience/terrain/forest_branch_crack_02.wav",
			"sounds/ambience/terrain/forest_branch_crack_03.wav",
			"sounds/ambience/terrain/forest_branch_crack_04.wav",
			"sounds/ambience/terrain/forest_branch_crack_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Resurrect] = [
			"sounds/enemies/dlc2/schrat_regrowth_01.wav",
			"sounds/enemies/dlc2/schrat_regrowth_02.wav",
			"sounds/enemies/dlc2/schrat_regrowth_03.wav",
			"sounds/enemies/dlc2/schrat_regrowth_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 4.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Resurrect] = 4.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 4.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 1.5;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 1.5;
		this.m.SoundPitch = this.Math.rand(101, 110) * 0.01;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Head] = true;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Body] = true;
		this.getFlags().add("isSmallSchrat");
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
			decal = _tile.spawnDetail("bust_schrat_body_small_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;
			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = "A " + this.getName();
			corpse.IsHeadAttached = true;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}
		
		local loot = this.new("scripts/items/loot/ancient_amber_item");
		loot.drop(_tile);

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onInit()
	{
		this.player_beast.onInit();
		local b = this.m.BaseProperties;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsIgnoringArmorOnAttack = true;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;
		b.DailyFood = 1;
		
		if (!this.isInitialized())
		{
			this.m.Items.setUnlockedBagSlots(2);
		}
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		this.removeSprite("socket");
		this.addSprite("background");
		this.addSprite("socket").setBrush("bust_base_player");
		this.addSprite("quiver");
		
		local body = this.addSprite("body");
		body.setBrush("bust_schrat_body_small_01");
		body.varySaturation(0.2);
		body.varyColor(0.05, 0.05, 0.05);
		this.m.BloodColor = body.Color;
		this.addSprite("shaft");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", this.createVec(0, 0));
		this.setSpriteOffset("status_stunned", this.createVec(-10, -10));
		this.setSpriteOffset("arrow", this.createVec(-10, -10));
		this.m.Skills.add(this.new("scripts/skills/special/weapon_breaking_warning"));
		this.m.Skills.add(this.new("scripts/skills/special/bag_fatigue"));
		this.m.Skills.add(this.new("scripts/skills/special/no_ammo_warning"));
		this.m.Skills.add(this.new("scripts/skills/special/double_grip"));
		this.m.Skills.update();
	}
	
	function onAfterInit()
	{
		this.player_beast.onAfterInit();
		local perks = ["perk_crippling_strikes", "perk_steel_brow", "perk_pathfinder"];
		
		foreach ( script in perks )
		{
			local s = this.new("scripts/skills/perks/" + script);
			s.m.IsSerialized = false;
			this.m.Skills.add(s);
		}
		
		this.m.Skills.add(this.new("scripts/skills/actives/uproot_small_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/uproot_small_zoc_skill"));
		this.m.Skills.update();
	}
	
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		_appearance.Quiver = "bust_goblin_quiver";
		this.actor.onAppearanceChanged(_appearance, _setDirty);
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = this.Const.BodyPart.Body;
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function onUpdateInjuryLayer()
	{
		local body = this.getSprite("body");
		local p = this.m.Hitpoints / this.getHitpointsMax();
		local sapling = this.getFlags().has("isGreenwood") ? "bust_schrat_green_body_small_01" : "bust_schrat_body_small_01";

		if (p >= 0.5)
		{
			body.setBrush("bust_schrat_body_small_01");
		}
		else
		{
			body.setBrush(sapling + "_injured");
		}

		this.setDirty(true);
	}
	
	function setScenarioValues( _isElite = false, _isGreenWood = false, _Dub = false, _Dub_two = false )
	{
		local b = this.m.BaseProperties;
		local type = this.Const.EntityType.SchratSmall;
		local body = this.getSprite("body");

		switch (true) 
		{
		case _isGreenWood:
			type = this.Const.EntityType.LegendGreenwoodSchratSmall;
		    b.setValues(this.Const.Tactical.Actor.LegendGreenwoodSchratSmall);
			body.setBrush("bust_schrat_green_body_small_01");
			this.getFlags().add("isGreenwood");
		    break;
		
		default:
			b.setValues(this.Const.Tactical.Actor.SchratSmall);
			body.setBrush("bust_schrat_body_small_01");
		}
		
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		body.varySaturation(0.2);
		body.varyColor(0.05, 0.05, 0.05);
		this.m.BloodColor = body.Color;

		if (_isElite || this.Math.rand(1, 100) == 100)
		{
			this.getSkills().add(this.new("scripts/skills/racial/champion_racial"));
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
	
	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("background").setHorizontalFlipping(!flip);
		this.getSprite("quiver").setHorizontalFlipping(flip);
		this.getSprite("shaft").setHorizontalFlipping(!flip);
		this.getSprite("accessory").setHorizontalFlipping(!flip);
		this.getSprite("accessory_special").setHorizontalFlipping(!flip);
	}
	
	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
		if (this.m.Attributes.len() == 0)
		{
			this.m.Attributes.resize(this.Const.Attributes.COUNT);

			for( local i = 0; i != this.Const.Attributes.COUNT; i = i )
			{
				this.m.Attributes[i] = [];
				i = ++i;
			}
		}

		for( local i = 0; i != this.Const.Attributes.COUNT; i = i )
		{
			for( local j = 0; j < _amount; j = j )
			{
				if (_minOnly)
				{
					this.m.Attributes[i].insert(0, this.Math.rand(1, this.Math.rand(1, 2)));
				}
				else if (_maxOnly)
				{
					this.m.Attributes[i].insert(0, this.Const.AttributesLevelUp[i].Max);
				}
				else
				{
					this.m.Attributes[i].insert(0, this.Math.rand(this.Const.AttributesLevelUp[i].Min + (this.m.Talents[i] == 3 ? 2 : this.m.Talents[i]), this.Const.AttributesLevelUp[i].Max + (this.m.Talents[i] == 3 ? 1 : 0)));
				}

				j = ++j;
			}

			i = ++i;
		}
	}

	function getBarberSpriteChange()
	{
		return [
			"body",
		];
	}

	function getPossibleSprites( _type = "body" )
	{
		return [
			"bust_schrat_body_small_01",
	        "bust_schrat_green_body_small_01",
		];
	}

	function onDeserialize( _in )
	{
		this.player_beast.onDeserialize(_in);
		this.m.BloodColor = this.getSprite("body").Color;
	}

});

