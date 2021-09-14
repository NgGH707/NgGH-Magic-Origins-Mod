this.catapult_entity <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		User = null,
		SiegeWeaponSkill = "scripts/skills/actives/catapult_sling_stone_control",
	},
	function setUser( _u )
	{
		this.m.User = _u;
	}

	function getUser()
	{
		return this.m.User;
	}

	function isLoaded()
	{
		return this.m.Flags.get("isLoaded");
	}

	function create()
	{
		this.m.IsAttackable = false;
		this.m.IsActingEachTurn = false;
		this.m.IsNonCombatant = true;
		this.m.IsShakingOnHit = false;
		this.m.Type = this.Const.EntityType.GreenskinCatapult;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.Donkey.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/catapult_hurt_01.wav",
			"sounds/enemies/catapult_hurt_02.wav",
			"sounds/enemies/catapult_hurt_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/catapult_death_02.wav"
		];
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/donkey_agent");
		this.m.AIAgent.setActor(this);
		this.m.Flags.add("siege_weapon");
	}

	function assignUser( _user , _manningSkill )
	{
		if (this.m.User != null)
		{
			local skill = this.m.User.getSkills().getSkillByID("actives.man_siege_weapon");
			skill.clear();
		}

		local skill = this.new(this.m.SiegeWeaponSkill);
		skill.setWeapon(this);
		_user.getSkills().add(skill);
		_manningSkill.m.BorrowedSkills.push(skill);
		_manningSkill.m.SiegeWeapon = this;
		this.setUser(_user);
		local effect = this.new("scripts/skills/effects/manning_siege_weapon_effect");
		effect.m.SiegeWeapon = this;
		_user.getSkills().add(effect);
		local skill = this.getSkills().getSkillByID("actives.catapult_sling_stone");
		skill.m.User = _user;
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("top").setHorizontalFlipping(flip);
	}

	function setFlipped( _f )
	{
		this.getSprite("body").setHorizontalFlipping(_f);
		this.getSprite("top").setHorizontalFlipping(_f);
	}

	function onAfterDeath( _tile )
	{
		_tile.spawnObject("entity/tactical/objects/destroyed_greenskin_catapult");
		local offset = this.createVec(0, -10);

		for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, _tile, this.Const.Tactical.BurnParticles[i].Delay, this.Math.max(1, this.Const.Tactical.BurnParticles[i].Quantity), this.Math.max(1, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity), this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, offset);
		}
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.GreenskinCatapult);
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.IsAffectedByNight = false;
		b.IsMovable = false;
		b.TargetAttractionMult = 1.5;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		local body = this.addSprite("body");
		body.setBrush("greenskin_catapult_bottom");
		body.varySaturation(0.1);
		local top = this.addSprite("top");
		top.setBrush("greenskin_catapult_top");
		this.setSpriteOcclusion("top", 1, 2, -3);
		this.addDefaultStatusSprites();
		this.getSkills().add(this.new("scripts/skills/actives/catapult_sling_stone_skill"));
		this.m.Skills.update();
	}

	function onAfterInit()
	{
		this.setFaction(this.Const.Faction.PlayerAnimals);
		this.setDiscovered(true);
		this.updateOverlay();
		this.setSpriteOffset("status_rooted_back", this.getSpriteOffset("status_rooted"));
		this.getSprite("status_rooted_back").Scale = this.getSprite("status_rooted").Scale;
	}

	function onActorKilled( _actor, _tile, _skill )
	{
		this.actor.onActorKilled(_actor, _tile, _skill);

		if (this.getFaction() == this.Const.Faction.PlayerAnimals && this.m.User != null)
		{
			local XPkiller = this.Math.floor(_actor.getXPValue() * this.Const.XP.XPForKillerPct);
			local XPgroup = _actor.getXPValue() * (1.0 - this.Const.XP.XPForKillerPct);
			this.m.User.addXP(XPkiller);
			local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

			if (brothers.len() == 1)
			{
				this.m.User.addXP(XPgroup);
			}
			else
			{
				foreach( bro in brothers )
				{
					bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
				}
			}

			local roster = this.World.getPlayerRoster().getAll();

			foreach( bro in roster )
			{
				if (bro.isInReserves() && bro.getSkills().hasSkill("perk.legend_peaceful"))
				{
					bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
				}
			}
		}
	}

});

