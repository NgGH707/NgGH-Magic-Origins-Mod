
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
local final_pool = [];
local lucky_pool = [];
local loot_table;

// 8th tier (27%): weird stuffs
loot_table = tools.enumerateScripts("tools/", [
	"faction_banner",
	"player_banner",
]);
loot_table.extend(tools.enumerateScripts("ammo/", [
	"ammo"
]));
loot_table.extend(tools.enumerateScripts("supplies/", [
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
lucky_pool.push([27, loot_table]);


// 7th tier (25%): trading good
loot_table = tools.enumerateScripts("trade/", [
	"trading_good_item"
]);
lucky_pool.push([25, loot_table]);


// 6th tier (20%): treasure
loot_table = tools.enumerateScripts("loot/");
lucky_pool.push([20, loot_table]);


// 5th tier (15%): misc items 
loot_table = tools.enumerateScripts("misc/", [
	"legend_ancient_scroll_item",
	"legend_scroll_item"
]);
tools.removeScriptWithText(loot_table, "anatomist/");
lucky_pool.push([15, loot_table]);


// 4th tier (10%): accessory items
loot_table = tools.enumerateScripts("accessory/", [
	"accessory",
	"accessory_dog",
	"legend_catapult_item",
	"legendary/cursed_crystal_skull"
]);
tools.removeScriptWithText(loot_table, "special/");
lucky_pool.push([10, loot_table]);


// 3rd tier (2%): rare potions
loot_table = [
	"special/trade_jug_01_item",
	"special/trade_jug_02_item",
	"special/fountain_of_youth_item",
];
loot_table.extend(tools.enumerateScripts("misc/anatomist/", [
	//"anatomist_potion_item",
	"research_notes_beasts_item",
	"research_notes_greenskins_item",
	"research_notes_legendary_item",
	"research_notes_undead_item",
]));
lucky_pool.push([2, loot_table]);


// 2nd tier (1%): rare items
loot_table = [
	"special/black_book_item",
	"special/golden_goose_item",
	"misc/legend_ancient_scroll_item",
	"accessory/legendary/cursed_crystal_skull"
];
lucky_pool.push([1, loot_table]);

// checking each loot tier and then removing any tier with an empty array
while(true)
{
	local empty;
	foreach (i, t in lucky_pool)
	{
		if (t.len() == 0)
		{
			empty = i;
			break;
		}
	}

	if (empty == null)
	{
		break;
	}

	lucky_pool.remove(empty);
}


// there is 2 loot pools, one for layered armor and one for non-layered armor
final_pool.push(clone lucky_pool);
final_pool.push(clone lucky_pool);


// 1st tier (1%): named items
loot_table = [];
loot_table.extend(clone ::Const.Items.NamedWeapons);
loot_table.extend(clone ::Const.Items.NamedUndeadWeapons);
loot_table.extend(clone ::Const.Items.NamedGoblinWeapons);
loot_table.extend(clone ::Const.Items.NamedOrcWeapons);
loot_table.extend(clone ::Const.Items.NamedOrcShields);
loot_table.extend(clone ::Const.Items.NamedUndeadShields);
loot_table.extend(clone ::Const.Items.NamedBanditShields);
loot_table.extend(clone ::Const.Items.NamedShields);

local vanilla = clone loot_table;
vanilla.extend(clone ::Const.Items.NamedArmors);
vanilla.extend(clone ::Const.Items.NamedHelmets);
final_pool[0].push([1, vanilla]);

local legends = clone loot_table;
legends.extend(clone ::Const.Items.LegendNamedArmorLayers);
legends.extend(clone ::Const.Items.LegendNamedHelmetLayers);
final_pool[1].push([1, legends]);

::Const.LuckyRuneLootWeightContainer_Vanilla <- ::MSU.Class.WeightedContainer(final_pool[0]);
::Const.LuckyRuneLootWeightContainer_Legends <- ::MSU.Class.WeightedContainer(final_pool[1]);