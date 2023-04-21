this.nggh_mod_schrat_small_minion <- ::inherit("scripts/entity/tactical/nggh_mod_minion", {
	m = {},
	function create()
	{
		this.m.Type = ::Const.EntityType.SchratSmall;
		this.m.BloodType = ::Const.BloodType.Wood;
		this.m.XP = ::Const.Tactical.Actor.SchratSmall.XP;
		this.m.BloodSplatterOffset = ::createVec(0, -20);
		this.m.DecapitateSplatterOffset = ::createVec(-10, -25);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.DeathBloodAmount = 0.35;
		this.nggh_mod_minion.create();
		this.m.IsControlledByPlayer = false;
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/schrat_hurt_shield_up_01.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_02.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_03.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_04.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_05.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_06.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Resurrect] = [
			"sounds/enemies/dlc2/schrat_regrowth_01.wav",
			"sounds/enemies/dlc2/schrat_regrowth_02.wav",
			"sounds/enemies/dlc2/schrat_regrowth_03.wav",
			"sounds/enemies/dlc2/schrat_regrowth_04.wav"
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
		this.m.Sound[::Const.Sound.ActorEvent.Move] = this.m.Sound[::Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] = 4.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Resurrect] = 4.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Death] = 4.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 1.5;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Move] = 1.5;
		this.m.SoundPitch = ::Math.rand(101, 110) * 0.01;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/direwolf_agent");
		this.m.AIAgent.setActor(this);
	}

	function makeControllable()
	{
		this.m.IsControlledByPlayer = true;
		this.m.AIAgent = ::new("scripts/ai/tactical/player_agent");
		this.m.AIAgent.setActor(this);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			local flip = ::Math.rand(0, 100) < 50;
			local decal;
			this.m.IsCorpseFlipped = flip;
			local body = this.getSprite("body");
			decal = _tile.spawnDetail("bust_schrat_body_small_01_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;
			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone ::Const.Corpse;
			corpse.CorpseName = "A " + this.getName();
			corpse.IsHeadAttached = true;
			_tile.Properties.set("Corpse", corpse);
			::Tactical.Entities.addCorpse(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();

		if (!flip)
		{
			this.m.AIAgent = ::new("scripts/ai/tactical/agents/direwolf_agent");
			this.m.AIAgent.setActor(this);
		}
		else 
		{
		    this.m.AIAgent = ::new("scripts/ai/tactical/player_agent");
			this.m.AIAgent.setActor(this);
		}
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.SchratSmall);
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsIgnoringArmorOnAttack = true;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_schrat_body_small_01");
		body.varySaturation(0.2);
		body.varyColor(0.05, 0.05, 0.05);
		this.m.BloodColor = body.Color;
		this.addDefaultStatusSprites();
		local morale = this.addSprite("morale");
		morale.Visible = false;
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", ::createVec(0, 0));
		this.setSpriteOffset("status_stunned", ::createVec(-10, -10));
		this.setSpriteOffset("arrow", ::createVec(-10, -10));
		this.m.Skills.add(::new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(::new("scripts/skills/actives/uproot_small_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/uproot_small_zoc_skill"));

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			this.m.Skills.add(::new("scripts/skills/perks/perk_legend_lacerate"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_fast_adaption"));
			this.m.Skills.add(::new("scripts/skills/traits/fearless_trait"));
		}
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = ::Const.BodyPart.Body;
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function onUpdateInjuryLayer()
	{
		local body = this.getSprite("body");
		local p = this.getHitpointsPct();

		if (p >= 0.5)
		{
			body.setBrush("bust_schrat_body_small_01");
		}
		else
		{
			body.setBrush("bust_schrat_body_small_01_injured");
		}

		this.setDirty(true);
	}

});

