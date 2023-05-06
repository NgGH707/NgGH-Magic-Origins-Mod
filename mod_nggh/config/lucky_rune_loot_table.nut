
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

		_scripts.clear();
		_scripts.extend(valid);
	}
	function slicePrefixFromScripts(_scripts, _prefix = "")
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
	function enumerateScripts(_directory, _exclude = null)
	{
		local array = ::IO.enumerateFiles("scripts/items/" + _directory);

		if (array == null)
		{
			return [];
		}

		if (_exclude != null)
		{
			this.removeScript(_exclude, array, "scripts/items/" + _directory);
		}

		this.slicePrefixFromScripts(array, "scripts/items/");
		return array;
	}
};

// total weight: 100
local table = 
{
	final_pool = [],
	lucky_pool = [],
	loot_table = null
};

// 8th tier (27%): weird stuffs
table.loot_table = tools.enumerateScripts("tools/", [
	"faction_banner",
	"player_banner",
]);
table.loot_table.extend(tools.enumerateScripts("ammo/", [
	"ammo"
]));
table.loot_table.extend(tools.enumerateScripts("supplies/", [
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
table.lucky_pool.push([27, table.loot_table]);


// 7th tier (25%): trading good
table.loot_table = tools.enumerateScripts("trade/", [
	"trading_good_item"
]);
table.lucky_pool.push([25, table.loot_table]);


// 6th tier (20%): treasure
table.loot_table = tools.enumerateScripts("loot/");
table.lucky_pool.push([20, table.loot_table]);


// 5th tier (15%): misc items 
table.loot_table = tools.enumerateScripts("misc/", [
	"legend_ancient_scroll_item",
	"legend_scroll_item"
]);
tools.removeScriptWithText(table.loot_table, "anatomist/");
table.lucky_pool.push([15, table.loot_table]);


// 4th tier (10%): accessory items
table.loot_table = tools.enumerateScripts("accessory/", [
	"accessory",
	"accessory_dog",
	"legend_catapult_item",
	"nggh_mod_accessory_spider",
	"legendary/cursed_crystal_skull",
]);
tools.removeScriptWithText(table.loot_table, "special/");
tools.removeScriptWithText(table.loot_table, "named/");
table.lucky_pool.push([10, table.loot_table]);


// 3rd tier (2%): rare potions
table.loot_table = [
	"special/trade_jug_01_item",
	"special/trade_jug_02_item",
	"special/fountain_of_youth_item",
];
table.loot_table.extend(tools.enumerateScripts("misc/anatomist/", [
	//"anatomist_potion_item",
	"research_notes_beasts_item",
	"research_notes_greenskins_item",
	"research_notes_legendary_item",
	"research_notes_undead_item",
]));
table.lucky_pool.push([2, table.loot_table]);


// 2nd tier (1%): rare items
table.loot_table = [
	"special/black_book_item",
	"special/golden_goose_item",
	"misc/legend_ancient_scroll_item",
	"accessory/legendary/cursed_crystal_skull"
];
table.lucky_pool.push([1, table.loot_table]);

// checking each loot tier and then removing any tier with an empty array
while(true)
{
	local empty;
	foreach (i, t in table.lucky_pool)
	{
		if (t.len() == 0 || t[1].len() == 0)
		{
			::logError("Empty lucky loot table tier: " + (t.len() == 0 ? i : t[0]));
			empty = i;
			break;
		}
	}

	if (empty == null)
	{
		break;
	}

	table.lucky_pool.remove(empty);
}


// there is 2 loot pools, one for layered armor and one for non-layered armor
table.final_pool.push(clone table.lucky_pool);
table.final_pool.push(clone table.lucky_pool);


// 1st tier (1%): named items
table.loot_table = [];
table.loot_table.extend(clone ::Const.Items.NamedWeapons);
table.loot_table.extend(clone ::Const.Items.NamedUndeadWeapons);
table.loot_table.extend(clone ::Const.Items.NamedGoblinWeapons);
table.loot_table.extend(clone ::Const.Items.NamedOrcWeapons);
table.loot_table.extend(clone ::Const.Items.NamedOrcShields);
table.loot_table.extend(clone ::Const.Items.NamedUndeadShields);
table.loot_table.extend(clone ::Const.Items.NamedBanditShields);
table.loot_table.extend(clone ::Const.Items.NamedShields);

local vanilla = clone table.loot_table;
vanilla.extend(clone ::Const.Items.NamedArmors);
vanilla.extend(clone ::Const.Items.NamedHelmets);
table.final_pool[0].push([1, vanilla]);

local legends = clone table.loot_table;
legends.extend(clone ::Const.Items.LegendNamedArmorLayers);
legends.extend(clone ::Const.Items.LegendNamedHelmetLayers);
table.final_pool[1].push([1, legends]);

::Const.LuckyRuneLootWeightContainer_Vanilla <- ::MSU.Class.WeightedContainer(table.final_pool[0]);
::Const.LuckyRuneLootWeightContainer_Legends <- ::MSU.Class.WeightedContainer(table.final_pool[1]);