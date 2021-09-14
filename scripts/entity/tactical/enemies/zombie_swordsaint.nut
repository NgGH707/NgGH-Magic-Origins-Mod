this.zombie_swordsaint <- this.inherit("scripts/entity/tactical/enemies/zombie_knight", {
	m = {},
	function create()
	{
		this.zombie_knight.create();
		this.m.Type = this.Const.EntityType.ZombieBetrayer;
		this.m.BloodType = this.Const.BloodType.Dark;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = 100000;
		this.m.Name = "Fallen Sword Saint";
		this.m.ResurrectWithScript = "scripts/entity/tactical/enemies/zombie_swordsaint";
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
		this.m.AIAgent.setActor(this);
		this.m.Flags.add("isSwordSaint");
	}

	function onInit()
	{
		this.zombie_knight.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.ZombieBetrayer);
		b.ActionPoints = 9;
		b.Hitpoints = 300;
		b.Bravery = 999;
		b.Stamina = 200;
		b.MeleeSkill = 999;
		b.MeleeSkillMult = 999;
		b.RangedSkill = 0;
		b.MeleeDefense = 999;
		b.MeleeDefenseMult = 999;
		b.RangedDefense = 0;
		b.Initiative = 100;
		b.InitiativeForTurnOrderAdditional = -300;
		b.Threat = 25;
		b.ThreatOnHit = 25;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsAffectedByRain = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToSurrounding = true;
		b.IsImmuneToZoneOfControl = true;
		b.IsRiposting = true;
		b.DamageMinimum = 10;
		b.DamageDirectMult = 1.25;
		b.DamageReceivedMeleeMult = 0.25;
		b.DamageReceivedRangedMult = 0.67;
		b.ThresholdToInflictInjuryMult = 0.1;
		b.TargetAttractionMult = 5.0;
		b.FatalityChanceMult = 10000.0;
		b.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] = 10000.0;
		b.DamageAgainstMult = [
			1.0,
			1000.0
		];
		b.HitChance = [
			67,
			33
		];
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.SameMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.MaxTraversibleLevels = 4;
		
		if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
		{
			b.ActionPoints += 9;
			this.m.Hitpoints = b.Hitpoints * 2;
			this.m.Skills.add(this.new("scripts/skills/perks/perk_return_favor"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
		}
		
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_flow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_duelist"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_full_force"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_feint"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_composure"));
		this.m.Skills.add(this.new("scripts/skills/actives/footwork"));
		this.m.Skills.add(this.new("scripts/skills/traits/fearless_trait"));
		this.makeMiniboss()
		this.m.Skills.update();
	}
	
	function assignRandomEquipment()
	{
		local r;

		if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			local sword = this.new("scripts/items/weapons/legendary/lightbringer_sword");
			this.m.Items.equip(sword);
		}

		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
		{
			local a = this.new("scripts/items/armor/noble_mail_armor");
			local upgrade = this.new("scripts/items/armor_upgrades/lindwurm_scales_upgrade");
			this.m.Items.equip(a);
			a.setUpgrade(upgrade);
		}

		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
		{
			local h = this.new("scripts/items/helmets/greatsword_faction_helm");
			this.m.Items.equip(h);
		}
	}
	
	function onTurnStart()
	{
		if (!this.isAlive())
		{
			return;
		}
		
		this.Tactical.spawnSpriteEffect("sword_saint_quote_" + this.Math.rand(1, 6), this.createColor("#ffffff"), this.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 160, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
		this.actor.onTurnStart();
	}
	
	function onTurnResumed()
	{
		this.Tactical.spawnSpriteEffect("sword_saint_quote_" + this.Math.rand(1, 6), this.createColor("#ffffff"), this.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 160, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
		this.actor.onTurnResumed();
	}
	
	function makeMiniboss()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}
		
		this.getSprite("miniboss").setBrush("bust_miniboss"); 
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
		return true;
	}
	
	function activateCheatPunish()
	{
		local b = this.m.BaseProperties;
		b.ActionPoints = 18;
		b.HitChance = [
			0,
			100
		];
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts =  [0, 0, 0, 0, 0, 0, 0, 0, 0];
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " has become enraged and want to hunt you down to the last one");
	}
	
	function killSilently()
	{
		this.activateCheatPunish();
	}
	
	function kill( _killer = null, _skill = null, _fatalityType = this.Const.FatalityType.None, _silent = false )
	{
		_fatalityType = this.Const.FatalityType.None;
		
		if (_killer == null && _skill == null && _fatalityType == this.Const.FatalityType.None && !_silent)
		{
			this.m.Hitpoints = this.m.Hitpoints == 0 ? 1 : this.m.Hitpoints;
			this.Tactical.EventLog.log("[color=" + this.Const.UI.Color.DamageValue + "]Cheater!!! You have angered me[/color]");
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

