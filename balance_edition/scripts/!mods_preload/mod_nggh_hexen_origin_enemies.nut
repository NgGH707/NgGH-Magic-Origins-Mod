this.getroottable().HexenHooks.hookEnemies <- function ()
{
	local randomlyRollPerk = function( _actor, _perks, _chance = 25 )
	{
		foreach ( scripts in _perks )
		{
			if (this.Math.rand(1, 100) <= _chance)
			{
				_actor.getSkills().add(this.new("scripts/skills/" + scripts));
			}
		}
	};
	::mods_hookExactClass("entity/tactical/enemies/legend_stollwurm", function(obj) {
		local onInit = obj.onInit;
		obj.onInit = function()
		{
			onInit();
			local chance = 10;

			if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 200)
			{
				chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 200));
			}

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				chance = 100;
			}

			randomlyRollPerk(this, [
				"perks/perk_lindwurm_acid"
			], chance);
			randomlyRollPerk(this, [
				"perks/perk_lindwurm_body"
			], chance + 15);
		}

		obj.makeMiniboss <- function()
		{
			if (!this.actor.makeMiniboss())
			{
				return false;
			}

			this.m.Skills.add(this.new("scripts/skills/perks/perk_lindwurm_body"));
			this.m.XP *= 1.5;
			return true;
		}
	});
	::mods_hookExactClass("entity/tactical/enemies/lindwurm", function(obj) {
		local onInit = obj.onInit;
		obj.onInit = function()
		{
			onInit();
			local chance = 25;

			if (!this.Tactical.State.isScenarioMode())
			{
				if (this.World.getTime().Days >= 170)
				{
					chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 170));
				}
			}

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				chance = 75;
			}

			randomlyRollPerk(this, [
				"perks/perk_lindwurm_acid",
				"perks/perk_lindwurm_body"
			], chance);
		}

		obj.makeMiniboss <- function()
		{
			if (!this.actor.makeMiniboss())
			{
				return false;
			}

			this.m.XP *= 1.5;
			this.m.Skills.add(this.new("scripts/skills/perks/perk_lindwurm_body"));
			return true;
		}
	});

	local hyenas = [
		"hyena",
		"hyena_high"
	];
	foreach ( name in hyenas ) 
	{
		::mods_hookExactClass("entity/tactical/enemies/" + name, function(obj) {
			local onInit = obj.onInit;
			obj.onInit = function()
			{
				onInit();
				local chance = 25;

				if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 100)
				{
					chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 100));
				}

				if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
				{
					chance = 100;
				}

				randomlyRollPerk(this, [
					"perks/perk_hyena_bite",
					"perks/perk_thick_hide",
					"perks/perk_enrage_wolf"
				], chance);
			}

			obj.makeMiniboss <- function()
			{
				if (!this.actor.makeMiniboss())
				{
					return false;
				}

				this.m.Skills.add(this.new("scripts/skills/perks/perk_enrage_wolf"));
				this.m.Skills.add(this.new("scripts/skills/perks/perk_hyena_bite"));
				this.m.XP *= 1.5;
				local b = this.m.BaseProperties;
				b.MeleeSkill += 10;
				return true;
			}
		});
	}

	local wolves = [
		"direwolf",
		"direwolf_high",
		"legend_white_direwolf",
	];
	foreach ( name in wolves ) 
	{
		::mods_hookExactClass("entity/tactical/enemies/" + name, function(obj) {
			local onInit = obj.onInit;
			obj.onInit = function()
			{
				onInit();
				local chance = 25;

				if (!this.Tactical.State.isScenarioMode())
				{
					if (this.World.getTime().Days >= 100)
					{
						chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 100));
					}
				}

				if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
				{
					chance = 100;
				}

				randomlyRollPerk(this, [
					"perks/perk_wolf_bite",
					"perks/perk_thick_hide",
					"perks/perk_enrage_wolf"
				], chance);
			}

			obj.makeMiniboss <- function()
			{
				if (!this.actor.makeMiniboss())
				{
					return false;
				}

				this.m.Skills.add(this.new("scripts/skills/perks/perk_wolf_bite"));
				this.m.Skills.add(this.new("scripts/skills/perks/perk_enrage_wolf"));
				this.m.XP *= 1.5;
				local b = this.m.BaseProperties;
				b.MeleeSkill += 10;
				return true;
			}
		});
	}

	local spiders = [
		[
			"spider",
		],
		[
			"legend_redback_spider",
		]
	];
	foreach ( name in spiders[0] ) 
	{
		::mods_hookExactClass("entity/tactical/enemies/" + name, function(obj) {
			local onInit = obj.onInit;
			obj.onInit = function()
			{
				onInit();
				local chance = 15;

				if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 150)
				{
					chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 150));
				}

				if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
				{
					chance = 110;
				}
				else 
				{
				    randomlyRollPerk(this, [
						"perks/perk_spider_web"
					], chance - 10);
				}

				randomlyRollPerk(this, [
					"perks/perk_spider_bite",
					"perks/perk_spider_venom",
				], chance);

				obj.makeMiniboss <- function()
				{
					if (!this.actor.makeMiniboss())
					{
						return false;
					}

					this.m.XP *= 1.5;
					this.m.Skills.add(this.new("scripts/skills/perks/perk_spider_bite"));
					return true;
				}
			}
		});
	}
	foreach ( name in spiders[1] ) 
	{
		::mods_hookExactClass("entity/tactical/enemies/" + name, function(obj) {
			local onInit = obj.onInit;
			obj.onInit = function()
			{
				onInit();
				local chance = 25;

				if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
				{
					chance = 100;
				}
				else 
				{
				    randomlyRollPerk(this, [
						"perks/perk_spider_web"
					], chance - 15);
				}

				if (!this.Tactical.State.isScenarioMode())
				{
					if (this.World.getTime().Days >= 135)
					{
						chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 135));
					}
				}

				randomlyRollPerk(this, [
					"perks/perk_spider_bite",
					"perks/perk_spider_venom",
				], chance);
			}

			obj.makeMiniboss <- function()
			{
				if (!this.actor.makeMiniboss())
				{
					return false;
				}

				this.m.XP *= 1.5;
				this.m.Skills.add(this.new("scripts/skills/perks/perk_spider_bite"));
				this.m.Skills.add(this.new("scripts/skills/perks/perk_spider_web"));
				return true;
			}
		});
	}

	::mods_hookExactClass("entity/tactical/enemies/serpent", function(obj) {
		local onInit = obj.onInit;
		obj.onInit = function()
		{
			onInit();
			local chance = 25;

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				chance = 115;
			}

			if (!this.Tactical.State.isScenarioMode())
			{
				if (this.World.getTime().Days >= 100)
				{
					chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 100));
				}
			}

			randomlyRollPerk(this, [
				"perks/perk_serpent_bite",
				"perks/perk_snake_venom",
			], chance - 15);
			randomlyRollPerk(this, [
				"perks/perk_serpent_drag",
				"perks/perk_giant_serpent",
			], chance);
		}

		obj.makeMiniboss <- function()
		{
			if (!this.actor.makeMiniboss())
			{
				return false;
			}

			this.m.XP *= 1.5;
			this.m.Skills.add(this.new("scripts/skills/perks/perk_serpent_bite"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_serpent_drag"));
			local b = this.m.BaseProperties;
			b.MeleeSkill += 15;
			return true;
		}
	});

	local ghouls = [
		"ghoul_medium",
		"ghoul_high",
		"legend_skin_ghoul_medium",
		"legend_skin_ghoul_high"
	];
	foreach ( name in ghouls ) 
	{
		::mods_hookExactClass("entity/tactical/enemies/" + name, function(obj) {
			local onInit = obj.onInit;
			obj.onInit = function()
			{
				onInit();
				local chance = 25;

				if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
				{
					chance = 100;
				}

				if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 125)
				{
					chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 200));
				}

				randomlyRollPerk(this, [
					"perks/perk_frenzy",
					"perks/perk_nacho",
					"perks/perk_nacho_eat"
				], chance);
			}

			obj.makeMiniboss <- function()
			{
				if (!this.actor.makeMiniboss())
				{
					return false;
				}

				this.m.Skills.add(this.new("scripts/skills/perks/perk_nacho"));
				this.m.Skills.add(this.new("scripts/skills/perks/perk_frenzy"));
				this.m.XP *= 1.5;
				return true;
			}
		});
	}

	::mods_hookExactClass("entity/tactical/enemies/alp", function(obj) {
		local onInit = obj.onInit;
		obj.onInit = function()
		{
			onInit();
			local chance = 15;

			if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 120)
			{
				chance = this.Math.min(100, chance + this.Math.max(1, this.World.getTime().Days - 120));
			}

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				chance = 110;
			}

			randomlyRollPerk(this, [
				"perks/perk_mastery_sleep",
				"perks/perk_mastery_nightmare",
			], chance - 10);

			randomlyRollPerk(this, [
				"perks/perk_afterimage",
			], chance - 5);
			
			randomlyRollPerk(this, [
				"perks/perk_after_wake",
			], chance);
		}

		obj.makeMiniboss <- function()
		{
			if (!this.actor.makeMiniboss())
			{
				return false;
			}

			this.m.XP *= 1.5;
			this.m.Skills.add(this.new("scripts/skills/perks/perk_mastery_nightmare"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_mastery_sleep"));
			return true;
		}
	});

	local schrats = [
		"schrat",
		"legend_greenwood_schrat",
	];
	foreach ( name in schrats ) 
	{
		::mods_hookExactClass("entity/tactical/enemies/" + name, function(obj) {
			local onInit = obj.onInit;
			obj.onInit = function()
			{
				onInit();
				local chance = 25;

				if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 150)
				{
					chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 150));
				}

				if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
				{
					chance = 100;
				}

				randomlyRollPerk(this, [
					"perks/perk_grow_shield",
					"perks/perk_uproot",
					"perks/perk_uproot_aoe"
				], chance);
			}

			obj.makeMiniboss <- function()
			{
				if (!this.actor.makeMiniboss())
				{
					return false;
				}

				this.m.Skills.add(this.new("scripts/skills/perks/perk_grow_shield"));
				this.m.Skills.add(this.new("scripts/skills/perks/perk_uproot_aoe"));
				this.m.XP *= 1.5;
				return true;
			}
		});
	}

	local runes_melee = [
		[
			"legend_RSH_shielding"
		],
		[
			"legend_RSA_diehard",
			"legend_RSA_repulsion",
			"legend_RSA_thorns"
		],
		[
			"legend_RSW_corrosion",
			"legend_RSW_flame",
			"legend_RSW_precision",
			"legend_RSW_steadfast",
		],
	];
	local runes_ranged = [
		[
			"legend_RSH_shielding"
		],
		[
			"legend_RSA_diehard",
			"legend_RSA_repulsion",
		],
		[
			"legend_RSW_corrosion",
			"legend_RSW_flame",
			"legend_RSW_precision",
			"legend_RSW_steadfast",
			"legend_RSW_snipping"
		],
	];
	local rune_weak = [
		[
			"legend_RSH_shielding"
		],
		[
			"legend_RSA_repulsion",
		],
		[
			"legend_RSW_corrosion",
			"legend_RSW_precision",
		],
	];
	local getRandomeWeakRune = function( _items )
	{
		local valid = [];

		if (_items.getItemAtSlot(this.Const.ItemSlot.Body) != null)
		{
			valid.extend(rune_weak[1]);
		}

		if (_items.getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
		{
			valid.extend(rune_weak[2]);
		}

		return valid.len() == 0 ? null : valid[this.Math.rand(0, valid.len() - 1)];
	};
	local getRandomeRuneForMelee = function( _items )
	{
		local valid = [];

		if (_items.getItemAtSlot(this.Const.ItemSlot.Body) != null)
		{
			valid.extend(runes_melee[1]);
		}

		if (_items.getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
		{
			valid.extend(runes_melee[2]);
		}

		return valid.len() == 0 ? null : valid[this.Math.rand(0, valid.len() - 1)];
	};
	local getRandomeRuneForRanged = function( _items )
	{
		local valid = [];

		if (_items.getItemAtSlot(this.Const.ItemSlot.Head) != null)
		{
			valid.extend(runes_ranged[0]);
		}

		if (_items.getItemAtSlot(this.Const.ItemSlot.Body) != null)
		{
			valid.extend(runes_ranged[1]);
		}

		if (_items.getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
		{
			valid.extend(runes_ranged[2]);
		}

		return valid.len() == 0 ? null : valid[this.Math.rand(0, valid.len() - 1)];
	};
	local addRune = function(script, actor)
	{
		if (script != null)
		{
			local rune = this.new("scripts/skills/rune_sigils/" + script);
			rune.m.IsForceEnabled = true;
			actor.m.Skills.add(rune);
		}
	};

	local bandits = [
		"legend_bandit_warlord",
		"bandit_leader",
		"nomad_leader"
	];
	foreach ( name in bandits )
	{
		::mods_hookExactClass("entity/tactical/enemies/" + name, function(obj) {
			local ws_assignRandomEquipment = obj.assignRandomEquipment;
			obj.assignRandomEquipment = function()
			{
				ws_assignRandomEquipment();

				if (this.World.getTime().Days > 30)
				{
					local days = this.World.getTime().Days;
					local chance = 30;

					if (days > 75) chance += days - 75;
					if (this.Math.rand(1, 100) <= chance) 
					{
						addRune(getRandomeRuneForMelee(this.m.Items), this);
					}
				}
			}

			local ws_makeMiniBoss = ::mods_getMember(obj, "makeMiniboss");
			obj.makeMiniboss = function()
			{
				ws_makeMiniBoss();

				if (this.World.getTime().Days > 30)
				{
					if (this.Math.rand(1, 100) <= 50) 
					{
						addRune(getRandomeRuneForMelee(this.m.Items), this);
					}
				}
			}
		});
	}

	local strong = [
		"desert_devil",
		"executioner",
		"hedge_knight",
		"swordmaster",
		"knight",
		"officer",
		"barbarian_chosen",
	];
	foreach ( name in strong )
	{
		::mods_hookExactClass("entity/tactical/humans/" + name, function(obj) {
			local ws_assignRandomEquipment = obj.assignRandomEquipment;
			obj.assignRandomEquipment = function()
			{
				ws_assignRandomEquipment();

				if (this.World.getTime().Days > 50)
				{
					local days = this.World.getTime().Days;
					local chance = 15;

					if (days > 100) chance += days - 100;
					if (this.Math.rand(1, 100) <= chance) 
					{
						addRune(getRandomeRuneForMelee(this.m.Items), this);
					}
				}
			}

			local ws_makeMiniBoss = ::mods_getMember(obj, "makeMiniboss");
			obj.makeMiniboss = function()
			{
				ws_makeMiniBoss();

				if (this.World.getTime().Days > 50)
				{
					if (this.Math.rand(1, 100) <= 10) 
					{
						addRune(getRandomeRuneForMelee(this.m.Items), this);
					}
				}
			}
		});
	}

	local ranged = [
		"desert_stalker",
		"master_archer",
	];
	foreach ( name in ranged )
	{
		::mods_hookExactClass("entity/tactical/humans/" + name, function(obj) {
			local ws_assignRandomEquipment = obj.assignRandomEquipment;
			obj.assignRandomEquipment = function()
			{
				ws_assignRandomEquipment();

				if (this.World.getTime().Days > 50)
				{
					local days = this.World.getTime().Days;
					local chance = 15;

					if (days > 100) chance += days - 100;
					if (this.Math.rand(1, 100) <= chance) 
					{
						addRune(getRandomeRuneForRanged(this.m.Items), this);
					}
				}
			}

			local ws_makeMiniBoss = ::mods_getMember(obj, "makeMiniboss");
			obj.makeMiniboss = function()
			{
				ws_makeMiniBoss();

				if (this.World.getTime().Days > 50)
				{
					if (this.Math.rand(1, 100) <= 10) 
					{
						addRune(getRandomeRuneForRanged(this.m.Items), this);
					}
				}
			}
		});
	}

	local pretty_strong = [
		"humans/noble_greatsword",
		"humans/gladiator",
		"humans/legend_noble_fencer",
		"humans/noble_sergeant",
		"humans/legend_peasant_squire",
		"enemies/legend_bandit_veteran"
	];

	foreach ( name in pretty_strong )
	{
		::mods_hookExactClass("entity/tactical/" + name, function(obj) {
			local ws_assignRandomEquipment = obj.assignRandomEquipment;
			obj.assignRandomEquipment = function()
			{
				ws_assignRandomEquipment();

				if (this.World.getTime().Days > 70)
				{
					local days = this.World.getTime().Days;
					local chance = 25;

					if (days > 120) chance += days - 120;
					if (this.Math.rand(1, 100) <= chance) 
					{
						addRune(getRandomeWeakRune(this.m.Items), this);
					}
				}
			}
		});
	}

	delete this.HexenHooks.hookEnemies;
}