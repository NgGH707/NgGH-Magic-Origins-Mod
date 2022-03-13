this.getroottable().Nggh_MagicConcept.createLuckyRuneLootTable <- function ()
{
	local gt = this.getroottable();
	local tools = 
	{
		function removeScript(_scripts, _array, _prefix = "")
		{
			foreach (script in _scripts)
			{
				local i = _array.find(_prefix + script);

				if (i != null)
				{
					_array.remove(i)
				}		
			}
		}
		function removeScriptWithText(_scripts, _text)
		{
			local valid = [];

			foreach (script in _scripts)
			{
				if (script.find(_text) == null)
				{
					valid.push(script);
				}		
			}

			_scripts = valid;
		}
		function slicePretextFromScripts(_scripts, _prefix = "")
		{
			if (_prefix.len() == 0)
			{
				return;
			}

			foreach (i, script in _scripts)
			{
				local idx = script.find(_prefix);

				if (idx != null)
				{
					_scripts[i] = script.slice(idx + _prefix.len());
				}
			}
		}
		function enumerateScripts(_directory, _prefix = "", _remove = null)
		{
			local array = this.IO.enumerateFiles(_prefix + _directory);

			if (_remove != null)
			{
				this.removeScript(_remove, array, _prefix + _directory);
			}

			this.slicePretextFromScripts(array, _prefix);
			return array;
		}
	};
	gt.Const.LuckyRuneLootTable <- [];
	local pretext = "scripts/items/";
	local loot_pool = [];
	local loot_table;

	// 8th tier (27%): weird stuffs
	loot_table = tools.enumerateScripts("tools/", pretext, [
		"faction_banner",
		"player_banner",
	]);
	loot_table.extend(tools.enumerateScripts("ammo/", pretext, [
		"ammo"
	]));
	loot_table.extend(tools.enumerateScripts("supplies/", pretext, [
		"ammo_item",
		"armor_parts_item",
		"medicine_item",
		"ammo_small_item"
		"armor_parts_small_item",
		"medicine_small_item",
		"money_item",
		"food_item",
		"legend_usable_food",
	]));
	loot_pool.push(27, loot_table);


	// 7th tier (25%): trading good
	loot_table = tools.enumerateScripts("trade/", pretext, [
		"trading_good_item"
	]);
	loot_pool.push(25, loot_table);

	
	// 6th tier (20%): treasure
	loot_table = tools.enumerateScripts("loot/", pretext);
	loot_pool.push(20, loot_table);


	// 5th tier (15%): misc items 
	loot_table = tools.enumerateScripts("misc/", pretext, [
		"legend_ancient_scroll_item",
		"legend_scroll_item"
	]);
	tools.removeScriptWithText(loot_table, "anatomist/");
	loot_pool.push(15, loot_table);


	// 4th tier (10%): accessory items
	loot_table = tools.enumerateScripts("accessory/", pretext, [
		"accessory",
		"accessory_dog",
		"legendary/cursed_crystal_skull"
	]);
	tools.removeScriptWithText(loot_table, "special/");
	loot_pool.push(10, loot_table);


	// 3rd tier (1%): rare items
	loot_table = [
		"special/black_book_item",
		"special/golden_goose_item",
		"misc/legend_ancient_scroll_item",
		"misc/legend_scroll_item",
		"accessory/legendary/cursed_crystal_skull"
	];
	loot_pool.push(1, loot_table);


	// 2nd tier (2%): rare potions
	loot_table = [
		"special/trade_jug_01_item",
		"special/trade_jug_02_item",
		"special/fountain_of_youth_item",
	];
	loot_table.extend(tools.enumerateScripts("misc/anatomist/", pretext, [
		"anatomist_potion_item",
		"research_notes_beasts_item",
		"research_notes_greenskins_item",
		"research_notes_legendary_item",
		"research_notes_undead_item",
	]));
	loot_pool.push(2, loot_table);

	gt.Const.LuckyRuneLootTable.push(clone loot_pool);
	gt.Const.LuckyRuneLootTable.push(clone loot_pool);

	// 1st tier (1%): named items
	loot_table = [];
	loot_table.extend(clone this.Const.Items.NamedWeapons);
	loot_table.extend(clone this.Const.Items.NamedUndeadWeapons);
	loot_table.extend(clone this.Const.Items.NamedGoblinWeapons);
	loot_table.extend(clone this.Const.Items.NamedOrcWeapons);
	loot_table.extend(clone this.Const.Items.NamedOrcShields);
	loot_table.extend(clone this.Const.Items.NamedUndeadShields);
	loot_table.extend(clone this.Const.Items.NamedBanditShields);
	loot_table.extend(clone this.Const.Items.NamedShields);
	
	
	local vanilla = clone loot_table;
	vanilla.extend(clone this.Const.Items.NamedArmors);
	vanilla.extend(clone this.Const.Items.NamedHelmets);
	gt.Const.LuckyRuneLootTable[0].push(1, vanilla);

	local legends = clone loot_table;
	legends.extend(clone this.Const.Items.LegendNamedArmorLayers);
	legends.extend(clone this.Const.Items.LegendNamedHelmetLayers);
	gt.Const.LuckyRuneLootTable[1].push(1, legends);

	delete this.Nggh_MagicConcept.createLuckyRuneLootTable;
}