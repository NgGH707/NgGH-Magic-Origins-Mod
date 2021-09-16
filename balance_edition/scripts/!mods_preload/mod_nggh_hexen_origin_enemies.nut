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
			local chance = 25;

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				chance = 100;
			}

			if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 60)
			{
				chance = this.Math.min(100, chance + this.Math.max(1, this.World.getTime().Days - 60));
			}

			randomlyRollPerk(this, [
				"perk_afterimage",
			], chance + 15);
			
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

	delete this.HexenHooks.hookEnemies;
}