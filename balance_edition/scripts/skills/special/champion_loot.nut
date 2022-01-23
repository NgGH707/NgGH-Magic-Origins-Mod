this.champion_loot <- this.inherit("scripts/skills/skill", {
	m = {
		ChampionType = null,
		LootScript = null,
		Killer = null
	},
	function create()
	{
		this.m.ID = "special.champion_loot";
		this.m.Icon = "skills/passive_07.png";
		this.m.IconMini = "passive_07_mini";
		this.m.Type = this.Const.SkillType.Special;
		this.m.IsHidden = true
		this.m.IsActive = false;
		this.m.IsSerialized = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local orcs = [
			this.Const.EntityType.LegendOrcBehemoth,
			this.Const.EntityType.LegendOrcElite,
			this.Const.EntityType.OrcBerserker,
			this.Const.EntityType.OrcWarlord,
			this.Const.EntityType.OrcWarrior
		];

		if (actor.getFlags().has("human") || actor.getFlags().has("undead") || actor.getFlags().has("goblin") || orcs.find(actor.getType()) != null)
		{
			this.removeSelf();
		}
		else 
		{
		    this.m.ChampionType = actor.getType();
		    this.pickLoot();
		}
	}

	function pickLoot()
	{
		this.m.LootScript = [];
		switch (this.Math.rand(1, 3)) 
		{
	    case 1:
	        this.m.LootScript.extend([
	        	"misc/legend_ancient_scroll_item",
	        	"misc/potion_of_knowledge_item",
	        	"misc/potion_of_knowledge_item",
	        ]);
	        break;

	    case 2:
	        this.m.LootScript.extend([
	        	"loot/jade_broche_item",
	        	"loot/lindwurm_hoard_item",
	        	"loot/jeweled_crown_item",
	        ]);
	        break;

	    case 3:
	       	this.m.LootScript.extend([
	       		"special/spiritual_reward_item",
	       		"special/bodily_reward_item",
	       		"special/bodily_reward_item"
	        ]);
	        break;
		}

		if (this.Math.rand(1, 10) <= 2)
		{
			this.m.LootScript.extend([
				"misc/legend_stollwurm_blood_item",
				"misc/legend_stollwurm_scales_item",
				"misc/legend_white_wolf_pelt_item",
				"misc/legend_skin_ghoul_skin_item",
				"misc/legend_rock_unhold_hide_item",
				"misc/legend_rock_unhold_bones_item",
				"misc/legend_redback_poison_gland_item",
				"misc/legend_demon_third_eye_item",
				"misc/legend_demon_hound_bones_item",
				"misc/legend_demon_alp_skin_item",
				"misc/legend_banshee_essence_item",
				"misc/legend_ancient_green_wood_item",
				"special/fountain_of_youth_item",
				"special/fountain_of_youth_item",
				"special/fountain_of_youth_item",
	        ]);
		}
	}

	function onDamageReceived(_attacker, _damageHitpoints, _damageArmor)
	{
		if (_damageHitpoints >= this.getContainer().getActor().getHitpoints())
		{
			this.m.Killer = _attacker;
		}
	}

	function onDeath()
	{
		this.skill.onDeath();
		local actor = this.getContainer().getActor();
		local XP = this.Math.max(600, actor.getXPValue() * 1.5);

		if (this.m.Killer != null && this.isKindOf(this.m.Killer, "player"))
		{
			this.addXP(this.m.Killer, XP);
		}

		if (this.Tactical.State.m.StrategicProperties != null && !this.Tactical.State.m.StrategicProperties.IsArenaMode && this.m.LootScript != null && this.m.LootScript.len() > 0)
		{
			if (!("Loot" in this.Tactical.State.m.StrategicProperties))
			{
				this.Tactical.State.m.StrategicProperties.Loot <- [];
			}
			
			local script = "scripts/items/" + this.m.LootScript[this.Math.rand(0, this.m.LootScript.len() - 1)];
			this.Tactical.State.m.StrategicProperties.Loot.push(script);
		}
	}

	function addXP( _actor, _xp )
	{
		local isScenarioMode = !(("State" in this.World) && this.World.State != null);

		if (_actor.m.Level >= this.Const.LevelXP.len() || _actor.isGuest() || !isScenarioMode && this.World.Assets.getOrigin().getID() == "scenario.manhunters" && _actor.m.Level >= 7 && _actor.getBackground().getID() == "background.slave")
		{
			return;
		}

		_xp = _xp * this.World.Assets.m.XPMult;

		if (this.World.Retinue.hasFollower("follower.drill_sergeant"))
		{
			_xp = _xp * this.Math.maxf(1.0, 1.2 - 0.02 * (this.m.Level - 1));
		}

		if (_actor.m.XP + _xp * _actor.m.CurrentProperties.XPGainMult >= this.Const.LevelXP[this.Const.LevelXP.len() - 1])
		{
			_actor.m.CombatStats.XPGained += this.Const.LevelXP[this.Const.LevelXP.len() - 1] - _actor.m.XP;
			_actor.m.XP = this.Const.LevelXP[this.Const.LevelXP.len() - 1];
			return;
		}
		else if (!isScenarioMode && this.World.Assets.getOrigin().getID() == "scenario.manhunters" && _actor.m.XP + _xp * _actor.m.CurrentProperties.XPGainMult >= this.Const.LevelXP[6] && _actor.getBackground().getID() == "background.slave")
		{
			_actor.m.CombatStats.XPGained += this.Const.LevelXP[6] - _actor.m.XP;
			_actor.m.XP = this.Const.LevelXP[6];
			return;
		}

		_actor.m.XP += this.Math.floor(_xp * _actor.m.CurrentProperties.XPGainMult);
		_actor.m.CombatStats.XPGained += this.Math.floor(_xp * _actor.m.CurrentProperties.XPGainMult);
	}

});

