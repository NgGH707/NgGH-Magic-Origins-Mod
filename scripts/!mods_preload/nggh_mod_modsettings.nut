::Nggh_MagicConcept.mod_settings <- function ()
{
	// default value of settings
	::Nggh_MagicConcept.IsOPMode <- false;
	::Nggh_MagicConcept.IsCosmeticEnable <- true;
	::Nggh_MagicConcept.IsAbleToCharmInArena <- false;
	::Nggh_MagicConcept.IsNoKrakenVsKraken <- false;
	::Nggh_MagicConcept.HexeOriginRitual <- {
		IsLoseLevelWhenFail = true,
		UnluckyChance = 5,
		UnluckyMult = 10.0,
		RandomizeMin = 80,
		RandomizeMax = 150,
		Cooldown = 7,
		Mult = 7.0,
	};
	::Nggh_MagicConcept.RandomizedStatsMode <- {
		IsEnabled = true,
		Chance = 50,
		Min = 90,
		Max = 110,
	};

	local tools = 
	{
		processIntegerInput = function( _input , _oldValue )
		{
			if (typeof _input != "string")
			{
				return {
					Value = _oldValue.tointeger(),
					Result = false,
				};
			}

			local ret = _input.tointeger();

			if (typeof ret != "integer")
			{
				return {
					Value = _oldValue.tointeger(),
					Result = false,
				};
			}

			return {
				Value = ret,
				Result = true,
			};
		},

		processFloatInput = function( _input , _oldValue )
		{
			if (typeof _input != "string")
			{
				return {
					Value = _oldValue.tofloat(),
					Result = false,
				};
			}

			local ret = _input.tofloat();

			if (typeof ret != "float")
			{
				return {
					Value = _oldValue.tofloat(),
					Result = false,
				};
			}

			return {
				Value = ret,
				Result = true,
			};
		}
	}

	// add general page
	local page = ::Nggh_MagicConcept.Mod.ModSettings.addPage("general_page", "General");

	// 1-title
	page.addTitle("title_1", "Important").setDescription("This section contains settings for some of the most important mechanism of this mod.");

	// 1-content
	local OP_Mode = page.addBooleanSetting("balance_mode", !::Nggh_MagicConcept.IsOPMode, "Nerfed Non-human Players");
	OP_Mode.setDescription("Determines whether the charmed units you get have original or nerfed stats, it also affects the effect and efficiency of certain skills when those skills are used by player.");
	OP_Mode.setPersistence(true);
	OP_Mode.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		::logInfo("After change \'Nerfed Non-human Players\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.IsOPMode = !this.getValue();
	});
	local cosmetic = page.addBooleanSetting("cosmetic_helmet", ::Nggh_MagicConcept.IsCosmeticEnable, "Cosmetic Helmet");
	cosmetic.setDescription("Determines whether a beast-type player can make use of helmets or not. If enable, helmets only have decorative purpose for beast-type players.")
	cosmetic.setPersistence(true);
	cosmetic.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		::logInfo("After change \'Cosmetic Helmet\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.IsCosmeticEnable = this.getValue();
	});
	local arena = page.addBooleanSetting("arena_charm", ::Nggh_MagicConcept.IsAbleToCharmInArena, "Charm In Arena");
	arena.setDescription("Determines whether you can use [color=" + ::Const.UI.Color.NegativeValue + "]Captive Charm[/color] in the arena.");
	arena.setPersistence(true);
	arena.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		::logInfo("After change \'Charm In Arena\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.IsAbleToCharmInArena = this.getValue();
	});
	local kraken = page.addBooleanSetting("kraken_vs_kraken", ::Nggh_MagicConcept.IsNoKrakenVsKraken, "Skip Kraken vs Kraken");
	kraken.setDescription("If checked, allows you to skip the kraken vs kraken fight at the start of [color=" + ::Const.UI.Color.NegativeValue + "]Beast of Beasts[/color] origin.");
	kraken.setPersistence(true);
	kraken.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		::logInfo("After change \'Skip Kraken vs Kraken\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.IsNoKrakenVsKraken = this.getValue();
	});

	// 1-divider
	page.addDivider("divider_1");

	// 2-title
	page.addTitle("title_2", "Hexe Origin Ritual").setDescription("This section contains settings for the Ritual event that is tied with the [color=" + ::Const.UI.Color.NegativeValue + "]Elder Hexe[/color] background from Hexe origin.");

	// 2-content
	local loseLevel = page.addBooleanSetting("ritual_lose_level", ::Nggh_MagicConcept.HexeOriginRitual.IsLoseLevelWhenFail, "Is Lose Simp Level When Failing");
	loseLevel.setDescription("If checked, when you fail this ritual event, all your charmed characters also lose [color=" + ::Const.UI.Color.NegativeValue + "]1[/color] simp level. This level loss has [color=" + ::Const.UI.Color.PositiveValue + "]60%[/color] to be reversed if you successfully perform the next ritual.")
	loseLevel.setPersistence(true);
	loseLevel.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		::logInfo("After change \'Is Lose Simp Level When Failing\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.HexeOriginRitual.IsLoseLevelWhenFail = this.getValue();
	});
	local ritual = page.addRangeSetting("ritual_cooldown", ::Nggh_MagicConcept.HexeOriginRitual.Cooldown, 1, 30, 1, "Cooldown");
	ritual.setDescription("Determines how many days till the next mandatory Hexe Origin Ritual comes up again.");
	ritual.setPersistence(true);
	ritual.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		::logInfo("After change \'Hexe Origin Ritual - Cooldown\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.HexeOriginRitual.Cooldown = this.getValue();
	});
	local modFactor = page.addStringSetting("ritual_factor", "" + ::Nggh_MagicConcept.HexeOriginRitual.Mult + "", "Modifying Factor");
	modFactor.setDescription("An important factor to determine the offerings value. The higher it is, the more you have to sacrifice for the event. [color=" + ::Const.UI.Color.NegativeValue + "]Only inputs a postive float or integer number. Words or symbols are not allowed.[/color].\n\nExamples: \n• \'1.1\' is valid.\n• \'-1.1\' is invalid.\n• \'1\' is valid");
	modFactor.setPersistence(true);
	modFactor.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processFloatInput(this.getValue(), _oldValue);

		if (!ret.Result)
		{
			this.set(_oldValue);
		}

		::logInfo("After change \'Hexe Origin Ritual - Modifying Factor\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.HexeOriginRitual.Mult = ret.Value;
	});
	local randomizeMin = page.addStringSetting("ritual_min", ::Nggh_MagicConcept.HexeOriginRitual.RandomizeMin.tostring(), "Randomized Factor Min (%)");
	randomizeMin.setDescription("The minimum range of the randomized factor. [color=" + ::Const.UI.Color.NegativeValue + "]Only inputs an integer number. Words or symbols are not allowed.[/color]");
	randomizeMin.setPersistence(true);
	randomizeMin.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processIntegerInput(this.getValue(), _oldValue);

		if (!ret.Result)
		{
			this.set(_oldValue);
		}

		::logInfo("After change \'Hexe Origin Ritual - Randomized Factor Min\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.HexeOriginRitual.RandomizeMin = ret.Value;
	});
	local randomizeMax = page.addStringSetting("ritual_max", ::Nggh_MagicConcept.HexeOriginRitual.RandomizeMax.tostring(), "Randomized Factor Max (%)");
	randomizeMax.setDescription("The maximum range of the randomized factor. [color=" + ::Const.UI.Color.NegativeValue + "]Only inputs an integer number and please do not exceed 500. Words or symbols are not allowed.[/color]");
	randomizeMax.setPersistence(true);
	randomizeMax.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processIntegerInput(this.getValue(), _oldValue);

		if (!ret.Result)
		{
			this.set(_oldValue);
		}

		::logInfo("After change \'Hexe Origin Ritual - Randomized Factor Max\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.HexeOriginRitual.RandomizeMax = ret.Value;
	});
	local unluckyChance = page.addStringSetting("ritual_unlucky_chance", ::Nggh_MagicConcept.HexeOriginRitual.UnluckyChance.tostring(), "Unlucky Chance (%)");
	unluckyChance.setDescription("The chance for the Ritual event to ask for more sacrifice than usual. [color=" + ::Const.UI.Color.NegativeValue + "]Only inputs an integer number. Words or symbols are not allowed.[/color]");
	unluckyChance.setPersistence(true);
	unluckyChance.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processIntegerInput(this.getValue(), _oldValue);

		if (!ret.Result)
		{
			this.set(_oldValue);
		}

		::logInfo("After change \'Hexe Origin Ritual - Unlucky Chance\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.HexeOriginRitual.UnluckyChance = ret.Value;
	});
	local unluckyMult = page.addStringSetting("ritual_unlucky_mult", ::Nggh_MagicConcept.HexeOriginRitual.UnluckyMult.tostring(), "Unlucky Sacrifice Multiplier");
	unluckyMult.setDescription("A multiplier factor for how much sacrifice are needed when you get the unlucky roll. [color=" + ::Const.UI.Color.NegativeValue + "]Only inputs a postive float or integer number. Words or symbols are not allowed.[/color].\n\nExamples: \n• \'1.1\' is valid.\n• \'-1.1\' is invalid.\n• \'1\' is valid");
	unluckyMult.setPersistence(true);
	unluckyMult.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processFloatInput(this.getValue(), _oldValue);

		if (!ret.Result)
		{
			this.set(_oldValue);
		}

		::logInfo("After change \'Hexe Origin Ritual - Unlucky Sacrifice Multiplier\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.HexeOriginRitual.UnluckyMult = ret.Value;
	});

	// 2-divider
	page.addDivider("divider_2");

	// 3-title
	page.addTitle("title_3", "Randomized Stats").setDescription("This section contains settings for the randomized enemy stats system which will make any enemy to have chance to reroll its stats within a lower/upper (min/max) limit.\n\n[color=#4f1800][u]Affected Stats:[/u][/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Hitpoints[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Resolve[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Fatigue[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Initiative[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Melee Skill[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Melee Defense[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Ranged Skill[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Ranged Defense[/color]");

	// 3-content
	local enable = page.addBooleanSetting("randomize_stats_is_enabled", ::Nggh_MagicConcept.RandomizedStatsMode.IsEnabled, "Is Enabled");
	enable.setDescription("Turns [color=" + ::Const.UI.Color.PositiveValue + "]ON[/color]/[color=" + ::Const.UI.Color.NegativeValue + "]OFF[/color] this Randomized Stats system.");
	enable.setPersistence(true);
	enable.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		::logInfo("After change \'Randomized Stats - Is Enabled\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.RandomizedStatsMode.IsEnabled = this.getValue();
	});
	local chance = page.addStringSetting("randomize_stats_chance", ::Nggh_MagicConcept.RandomizedStatsMode.Chance.tostring() , "Chance (%)");
	chance.setDescription("The chance for an enemy to get its stats randomized. [color=" + ::Const.UI.Color.NegativeValue + "]Only inputs an integer number. Words or symbols are not allowed.[/color]");
	chance.setPersistence(true);
	chance.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processIntegerInput(this.getValue(), _oldValue);

		if (!ret.Result)
		{
			this.set(_oldValue);
		}

		::logInfo("After change \'Randomized Stats - Chance\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.RandomizedStatsMode.Chance = ret.Value;
	});
	local min = page.addStringSetting("randomize_stats_min", ::Nggh_MagicConcept.RandomizedStatsMode.Min.tostring(), "Default Lower Limit (%)");
	min.setDescription("The percentage of the original stats to be used as the lower limit when randomizing stats. [color=" + ::Const.UI.Color.NegativeValue + "]Only inputs an integer number. Words or symbols are not allowed.[/color]");
	min.setPersistence(true);
	min.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processIntegerInput(this.getValue(), _oldValue);

		if (!ret.Result)
		{
			this.set(_oldValue);
		}

		::logInfo("After change \'Randomized Stats - Default Lower Limit\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.RandomizedStatsMode.Min = ret.Value;
	});
	local max = page.addStringSetting("randomize_stats_max", ::Nggh_MagicConcept.RandomizedStatsMode.Max.tostring(), "Default Upper Limit (%)");
	max.setDescription("The percentage of the original stats to be used as the upper limit when randomizing stats. [color=" + ::Const.UI.Color.NegativeValue + "]Only inputs an integer number. Words or symbols are not allowed.[/color]");
	max.setPersistence(true);
	max.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processIntegerInput(this.getValue(), _oldValue);

		if (!ret.Result)
		{
			this.set(_oldValue);
		}

		::logInfo("After change \'Randomized Stats - Default Upper Limit\': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.RandomizedStatsMode.Max = ret.Value;
	});

	delete ::Nggh_MagicConcept.mod_settings;
}