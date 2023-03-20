this.mortar_entity <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		User = null,
		SiegeWeaponSkill = "scripts/skills/actives/fire_mortar",
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
		this.m.Type = this.Const.EntityType.Mortar;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.actor.create();
		this.m.IsAttackable = false;
		this.m.IsActingEachTurn = false;
		this.m.IsNonCombatant = true;
		this.m.IsShakingOnHit = false;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.Name = "Mortar";
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/donkey_agent");
		this.m.AIAgent.setActor(this);
		this.m.Flags.add("siege_weapon");
		this.m.Flags.set("isLoaded", false);
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
	}

	function setFlipped( _f )
	{
		this.getSprite("body").setHorizontalFlipping(_f);
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Mortar);
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.IsAffectedByInjuries = false;
		b.IsAffectedByNight = false;
		b.IsMovable = false;
		b.TargetAttractionMult = 2.0;
		b.DamageReceivedTotalMult = 0.0;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_player");
		local body = this.addSprite("body");
		body.setBrush("mortar_01");
		this.addDefaultStatusSprites();
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

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			_tile.spawnDetail("mortar_destroyed", this.Const.Tactical.DetailFlag.Corpse, false);
		}
	}

});

