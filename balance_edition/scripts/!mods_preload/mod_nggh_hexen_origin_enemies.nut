this.getroottable().HexenHooks.hookEnemies <- function ()
{
	local randomlyRollPerk = function( _actor, _perks, _chance = 25 )
	{
		foreach ( scripts in _perks )
		{
			if (this.Math.rand(1, 100) <= _chance)
			{
				_actor.getSkills().add(this.new("scripts/skills/perks/" + scripts));
			}
		}
	};
	::mods_hookExactClass("entity/tactical/enemies/legend_stollwurm", function(obj) {
		local onInit = obj.onInit;
		obj.onInit = function()
		{
			onInit();
			local chance = 10;

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				chance = 100;
			}

			if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 200)
			{
				chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 200));
			}

			randomlyRollPerk(this, [
				"perk_lindwurm_acid"
			], chance);
			randomlyRollPerk(this, [
				"perk_lindwurm_body"
			], chance + 15);
		}
	});
	::mods_hookExactClass("entity/tactical/enemies/lindwurm", function(obj) {
		local onInit = obj.onInit;
		obj.onInit = function()
		{
			onInit();
			local chance = 25;

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				chance = 75;
			}

			if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 235)
			{
				chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 235));
			}

			randomlyRollPerk(this, [
				"perk_lindwurm_acid",
				"perk_lindwurm_body"
			], chance);
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

				if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
				{
					chance = 100;
				}

				if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 100)
				{
					chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 100));
				}

				randomlyRollPerk(this, [
					"perk_hyena_bite",
					"perk_thick_hide",
					"perk_enrage_wolf"
				], chance);
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

				if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
				{
					chance = 100;
				}

				if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 100)
				{
					chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 100));
				}

				randomlyRollPerk(this, [
					"perk_wolf_bite",
					"perk_thick_hide",
					"perk_enrage_wolf"
				], chance);
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

				if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
				{
					chance = 100;
				}
				else 
				{
				    randomlyRollPerk(this, [
						"perk_spider_web"
					], chance - 10);
				}

				if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 300)
				{
					chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 300));
				}

				randomlyRollPerk(this, [
					"perk_spider_bite",
					"perk_spider_venom",
				], chance);
				
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
						"perk_spider_web"
					], chance - 15);
				}

				if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 200)
				{
					chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 200));
				}

				randomlyRollPerk(this, [
					"perk_spider_bite",
					"perk_spider_venom",
				], chance);
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
				chance = 100;
			}

			if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 200)
			{
				chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 200));
			}

			randomlyRollPerk(this, [
				"perk_serpent_bite",
				"perk_snake_venom",
			], chance - 15);
			randomlyRollPerk(this, [
				"perk_serpent_drag",
				"perk_giant_serpent",
			], chance);
		}
	});

	local ghouls = [
		"ghoul",
		"ghoul_medium",
		"ghoul_high",
		"legend_skin_ghoul",
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

				if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 200)
				{
					chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 200));
				}

				randomlyRollPerk(this, [
					"perk_frenzy",
					"perk_nacho",
					"perk_nacho_eat"
				], chance);
			}
		});
	}

	::mods_hookExactClass("entity/tactical/enemies/alp", function(obj) {
		local onInit = obj.onInit;
		obj.onInit = function()
		{
			onInit();
			local chance = 15;

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				chance = 100;
			}

			if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 120)
			{
				chance = this.Math.min(100, chance + this.Math.max(1, this.World.getTime().Days - 120));
			}

			randomlyRollPerk(this, [
				"perk_afterimage",
			], chance - 5);
			
			randomlyRollPerk(this, [
				"perk_mastery_nightmare",
				"perk_mastery_sleep",
				"perk_after_wake",
			], chance);
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

				if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
				{
					chance = 100;
				}

				if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 150)
				{
					chance = this.Math.min(100, chance + this.Math.max(10, this.World.getTime().Days - 150));
				}

				randomlyRollPerk(this, [
					"perk_grow_shield",
					"perk_uproot",
					"perk_uproot_aoe"
				], chance);
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
		[],
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

		if (_items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
		{
			valid.extend(rune_weak[1]);
		}

		if (_items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
		{
			valid.extend(rune_weak[2]);
		}

		return valid[this.Math.rand(0, valid.len() - 1)];
	};
	local getRandomeRuneForMelee = function( _items )
	{
		local valid = [];

		if (_items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
		{
			valid.extend(runes_melee[1]);
		}

		if (_items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
		{
			valid.extend(runes_melee[2]);
		}

		return valid[this.Math.rand(0, valid.len() - 1)];
	};
	local getRandomeRuneForRanged = function( _items )
	{
		local valid = [];

		if (_items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
		{
			valid.extend(runes_ranged[1]);
		}

		if (_items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
		{
			valid.extend(runes_ranged[2]);
		}

		return valid[this.Math.rand(0, valid.len() - 1)];
	};

	local bandits = [
		"legend_bandit_veteran",
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
						local rune = this.new("scripts/skills/rune_sigils/" + getRandomeRuneForMelee(this.m.Items));
						rune.m.IsForceEnabled = true;
						this.m.Skills.add(rune);
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
						local rune = this.new("scripts/skills/rune_sigils/" + getRandomeRuneForMelee(this.m.Items));
						rune.m.IsForceEnabled = true;
						this.m.Skills.add(rune);
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
						local rune = this.new("scripts/skills/rune_sigils/" + getRandomeRuneForMelee(this.m.Items));
						rune.m.IsForceEnabled = true;
						this.m.Skills.add(rune);
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
						local rune = this.new("scripts/skills/rune_sigils/" + getRandomeRuneForMelee(this.m.Items));
						rune.m.IsForceEnabled = true;
						this.m.Skills.add(rune);
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
						local rune = this.new("scripts/skills/rune_sigils/" + getRandomeRuneForRanged(this.m.Items));
						rune.m.IsForceEnabled = true;
						this.m.Skills.add(rune);
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
						local rune = this.new("scripts/skills/rune_sigils/" + getRandomeRuneForRanged(this.m.Items));
						rune.m.IsForceEnabled = true;
						this.m.Skills.add(rune);
					}
				}
			}
		});
	}

	local pretty_strong = [
		"noble_greatsword",
		"gladiator",
		"legend_noble_fencer",
		"noble_sergeant",
		"legend_peasant_squire",
	];

	::mods_hookExactClass("entity/tactical/humans/gladiator", function(obj) {
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
					local rune = this.new("scripts/skills/rune_sigils/" + getRandomeWeakRune(this.m.Items));
					rune.m.IsForceEnabled = true;
					this.m.Skills.add(rune);
				}
			}
		}
	});

	delete this.HexenHooks.hookEnemies;
}