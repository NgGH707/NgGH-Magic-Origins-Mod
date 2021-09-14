this.true_necromancer <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.Necromancer;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = 1000000;
		this.human.create();
		this.m.Name = "NgGH707";
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

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Necromancer);
		b.ActionPoints = 9;
		b.Hitpoints = 100;
		b.Bravery = 989;
		b.Stamina = 250;
		b.MeleeSkill = 200;
		b.RangedSkill = 999;
		b.MeleeDefense = 50;
		b.RangedDefense = 50;
		b.Initiative = 100;
		b.InitiativeForTurnOrderAdditional = -999;
		b.DamageMinimum = 25;
		b.MoraleEffectMult = 0.0;
		b.Vision = 99;
		b.Threat = 999;
		b.DamageReceivedTotalMult = 0.67;
		b.FatigueReceivedPerHitMult = 0.0;
		b.FatigueDealtPerHitMult = 1000.0;
		b.ThresholdToReceiveInjuryMult = 1000.0;
		b.ThresholdToInflictInjuryMult = 0.1;
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
		b.IsImmuneToDamageReflection = true;
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
		touch.m.ActionPointCost = 2;
		this.m.Skills.add(touch);
		this.m.Skills.add(this.new("scripts/skills/actives/raise_all_undead"));
		this.m.Skills.add(this.new("scripts/skills/actives/possess_all_undead"));
		this.m.Skills.add(this.new("scripts/skills/spells/death_spell"));
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
	
	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		local hitInfo = clone _hitInfo;
		
		this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
		
		if (_attacker != null && _attacker.isAlive() && _attacker.getHitpoints() > 0 && _attacker.getID() != this.getID())
		{
			this.Tactical.spawnSpriteEffect("effect_skull_02", this.createColor("#ffffff"), _attacker.getTile(), 0, 40, 1.0, 0.25, 0, 400, 300);
			hitInfo.DamageRegular *= 0.5;
			hitInfo.DamageMinimum = 10;
			_attacker.onDamageReceived(this, _skill, hitInfo);
		}
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (!this.Tactical.State.isScenarioMode() && _killer != null && _killer.isPlayerControlled())
		{
			this.updateAchievement("ManInBlack", 1, 1);
		}
		
		this.Tactical.EventLog.log("[color=" + this.Const.UI.Color.DamageValue + "]IMPOSSIBLE!!![/color]");
		this.human.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function assignRandomEquipment()
	{
		local skull = this.new("scripts/items/weapons/nggh707_skull_of_the_dead");
		this.m.Items.equip(skull);
		
		local helmet = this.new("scripts/items/helmets/nggh707_headgear");
		this.m.Items.equip(helmet);
		
		local armor = this.new("scripts/items/armor/named/named_noble_mail_armor");
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

