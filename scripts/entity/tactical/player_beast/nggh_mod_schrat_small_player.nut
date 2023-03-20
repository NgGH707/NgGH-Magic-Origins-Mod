this.nggh_mod_schrat_small_player <- ::inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {},
	function isGreenWood()
	{
		return this.getFlags().get("Type") == ::Const.EntityType.LegendGreenwoodSchratSmall;
	}
	
	function getStrengthMult()
	{
		return this.isGreenWood() ? 1.1 : 0.67;
	}
	
	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.BloodType = ::Const.BloodType.Wood;
		this.m.BloodSplatterOffset = ::createVec(0, -20);
		this.m.DecapitateSplatterOffset = ::createVec(-10, -25);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.DeathBloodAmount = 0.35;
		this.m.SignaturePerks = ["Pathfinder", "SteelBrow", "CripplingStrikes"];
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.SchratSmall;
		this.m.BonusHealthRecoverMult = 0.67;
		this.m.HitpointsPerVeteranLevel = 2;
		this.m.AttributesMax = {
			Hitpoints = 250,
			Bravery = 300,
			Fatigue = 300,
			Initiative = 200,
			MeleeSkill = 200,
			RangedSkill = 200,
			MeleeDefense = 150,
			RangedDefense = 125,
		};
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/ambience/terrain/forest_branch_crack_00.wav",
			"sounds/ambience/terrain/forest_branch_crack_01.wav",
			"sounds/ambience/terrain/forest_branch_crack_02.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/schrat_shield_damage_01.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_02.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_03.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_04.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/ambience/terrain/forest_branch_crack_00.wav",
			"sounds/ambience/terrain/forest_branch_crack_01.wav",
			"sounds/ambience/terrain/forest_branch_crack_02.wav",
			"sounds/ambience/terrain/forest_branch_crack_03.wav",
			"sounds/ambience/terrain/forest_branch_crack_04.wav",
			"sounds/ambience/terrain/forest_branch_crack_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/dlc2/schrat_death_01.wav",
			"sounds/enemies/dlc2/schrat_death_02.wav",
			"sounds/enemies/dlc2/schrat_death_03.wav",
			"sounds/enemies/dlc2/schrat_death_04.wav",
			"sounds/enemies/dlc2/schrat_death_05.wav",
			"sounds/enemies/dlc2/schrat_death_06.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/sapling_death_01.wav",
			"sounds/enemies/dlc2/sapling_death_02.wav",
			"sounds/enemies/dlc2/sapling_death_03.wav",
			"sounds/enemies/dlc2/sapling_death_04.wav",
			"sounds/enemies/dlc2/sapling_death_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
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
		this.m.Sound[::Const.Sound.ActorEvent.Resurrect] = [
			"sounds/enemies/dlc2/schrat_regrowth_01.wav",
			"sounds/enemies/dlc2/schrat_regrowth_02.wav",
			"sounds/enemies/dlc2/schrat_regrowth_03.wav",
			"sounds/enemies/dlc2/schrat_regrowth_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Move] = this.m.Sound[::Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] = 4.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Resurrect] = 4.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Death] = 4.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 1.5;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Move] = 1.5;
		this.m.SoundPitch = ::Math.rand(101, 110) * 0.01;
		this.m.Flags.add("single_body");
		this.m.Flags.add("regen_armor");
		this.m.Flags.add("sapling");

		// can't equip armors
		local items = this.getItems(); 
		items.getData()[::Const.ItemSlot.Head][0] = -1;
		items.getData()[::Const.ItemSlot.Body][0] = -1;
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = ::Const.BodyPart.Body;
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local body = this.getSprite("body");
		local i = body.getBrush().Name.find("_injured");

		if (i != null)
		{
			body.setBrush(body.getBrush().Name.slice(0, i));
		}

		this.nggh_mod_player_beast.onDeath(_killer, _skill, _tile, _fatalityType);
		local flip = this.m.IsCorpseFlipped;
		
		if (_tile != null)
		{
			local decal = _tile.spawnDetail(body.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;

			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone ::Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsResurrectable = false;
			corpse.IsConsumable = false;
			corpse.IsHeadAttached = true;
			corpse.Items = _fatalityType != ::Const.FatalityType.Unconscious ? this.getItems() : null;
			corpse.Tile = _tile;
			corpse.Value = 10.0;
			corpse.IsPlayer = true;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);

			if (_fatalityType == ::Const.FatalityType.Unconscious)
			{
				::new("scripts/items/loot/ancient_amber_item").drop(_tile);
			}
			else
			{
				::new("scripts/items/misc/" + (this.isGreenWood() ? "legend_ancient_green_wood_item" : "ancient_wood_item")).drop(_tile);
			}			
		}
	}

	function onAfterFactionChanged()
	{
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("background").setHorizontalFlipping(!flip);
		this.getSprite("quiver").setHorizontalFlipping(flip);
		this.getSprite("shaft").setHorizontalFlipping(!flip);
		this.getSprite("accessory").setHorizontalFlipping(!flip);
		this.getSprite("accessory_special").setHorizontalFlipping(!flip);
	}

	function onInit()
	{
		this.nggh_mod_player_beast.onInit();
		local b = this.m.BaseProperties;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsIgnoringArmorOnAttack = true;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		
		this.removeSprite("socket");
		this.removeSprite("body");
		
		this.addSprite("background");
		this.addSprite("socket").setBrush("bust_base_player");
		this.addSprite("quiver");
		this.addSprite("body");
		this.addSprite("shaft");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", ::createVec(0, 0));
		this.setSpriteOffset("status_stunned", ::createVec(-10, -10));
		this.setSpriteOffset("arrow", ::createVec(-10, -10));
	}
	
	function onAfterInit()
	{
		this.nggh_mod_player_beast.onAfterInit();
		this.m.Skills.add(::new("scripts/skills/actives/uproot_small_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/uproot_small_zoc_skill"));
	}
	
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		_appearance.Quiver = "bust_goblin_quiver";
		this.player.onAppearanceChanged(_appearance, _setDirty);
	}
	
	function setStartValuesEx( _isElite = false, _isGreenWood = false, _parameter_1 = null, _parameter_2 = null )
	{
		local b = this.m.BaseProperties;
		local type = _isGreenWood ? ::Const.EntityType.LegendGreenwoodSchratSmall : ::Const.EntityType.SchratSmall;
		local body = this.getSprite("body");

		switch (true) 
		{
		case _isGreenWood:
		    b.setValues(::Const.Tactical.Actor.LegendGreenwoodSchratSmall);
			body.setBrush("bust_schrat_green_body_small_01");
		    break;
		
		default:
			b.setValues(::Const.Tactical.Actor.SchratSmall);
			body.setBrush("bust_schrat_body_small_01");
		}
		
		// update the properties
		this.m.CurrentProperties = clone b;
		
		body.varySaturation(0.2);
		body.varyColor(0.05, 0.05, 0.05);
		this.m.BloodColor = body.Color;
		this.addDefaultBackground(type);

		this.setScenarioValues(type, _isElite);
	}

	function getBarberSpriteChange()
	{
		return [
			"body",
		];
	}

	function getPossibleSprites( _layer = "body" )
	{
		return [
			"bust_schrat_body_small_01",
	        "bust_schrat_green_body_small_01",
		];
	}

	function setAttributeLevelUpValues( _v )
	{
		// free max armor upon leveling up
		local b = this.getBaseProperties();
		local value = this.getLevel() > 11 ? this.getHitpointsPerVeteranLevel() : 10;
		b.Armor[0] += value;
		b.ArmorMax[0] += value;
		b.Armor[1] += value;
		b.ArmorMax[1] += value;
		
		this.player.setAttributeLevelUpValues(_v);
	}

	function onUpdateInjuryLayer()
	{
		local body = this.getSprite("body");
		
		if (!body.HasBrush)
		{
			return;
		}
		
		local brush = body.getBrush().Name;
		local isInjuryBrush = brush.find("_injured");
		local p = this.getHitpoints() / this.getHitpointsMax();

		if (isInjuryBrush != null)
		{
			brush = brush.slice(0, isInjuryBrush);
		}

		if (p >= 0.5)
		{
			body.setBrush(brush);
		}
		else
		{
			body.setBrush(brush + "_injured");
		}

		this.setDirty(true);
	}

	function updateVariant()
	{
		local app = this.getItems().getAppearance();
		local brush = this.getSprite("body").getBrush().Name;
		app.Body = brush;
		app.Corpse = brush + "_dead";

		local b = this.m.BaseProperties;
		b.DailyFood = this.isGreenWood() ? 2 : 1; // very smol boi UwU, don't eat much
	}

	function onDeserialize( _in )
	{
		this.nggh_mod_player_beast.onDeserialize(_in);
		this.m.BloodColor = this.getSprite("body").Color;
	}

});

