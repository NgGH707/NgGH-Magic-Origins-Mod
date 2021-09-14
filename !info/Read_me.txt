How to add custom charmed unit entry?

*First you need to know what is the valid entry so not to get an error while trying to add one

Entry is split into 2 types: Human and Non-human. For example:

A Swordmaster entry
{
	StatMod = { Hitpoints = [-30, -30], Bravery = [-30, -20], Stamina = [-15, -15], MeleeSkill = [-25, -25], RangedSkill = [-10, -10], MeleeDefense = [-35, -30], RangedDefense = [-15, -10], Initiative = [-5, -5] },
	Perks = ["perks/perk_duelist", "perks/perk_mastery_sword", "perks/perk_mastery_greatsword"],
	Difficulty = 110,
	Custom = {},
	Requirements = ["perk.appearance_charm"],
	PerkTree = "swordmaster_background"
}

And a Direwolf entry
{
	StatMod = { Hitpoints = [-30, 0], Bravery = [-5, -5], Stamina = [-30, 0], MeleeSkill = [-5, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [-10, 0] },
	Perks = [],
	Difficulty = 25,
	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 3, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.3, Gathering = 0.1, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		Talents = {
			ExcludedTalents = [5],
			PrimaryTalents = [3, 4, 6],
			SecondaryTalents = [0],
			StarsMax = 9,
			StarsMin = 1,
		},
		Names = "WolfNames",
	},
	PerkTree = "WolfTree",
	Script = "player_beast/direwolf_player",
	Background = "charmed_beast_background",
	Requirements = ["perk.charm_enemy_direwolf"],
}

**An entry is consisted of some important memebers:

1. 'StatMod' 
Modifying the base stats of that enemy after being charmed (generally a nerf). You can check the base stats of said enemy and make your own 'StatMod'. If you are using OP version of hexe origin, 'StatMod' is reduntent just return it as StatMod = {}

	Example:
		StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },


2. 'Perks'
The name might confuse you (i write this long ago, changing this to other name would cause trouble so....), It's basically an arry contains directory to specific skills/perks/racial/effects, anything as long as that script is in "scripts/skills". That would be the skills/perks/racial/effects that charmed unit would start with at default

	Example:
		Perks = ["racial/goblin_shaman_racial", "actives/root_skill", "perks/perk_overwhelm"],


3. 'Difficulty'
Determine how hard that enemy can be charmed, is affected by surrounded count. A positive value would make that enemy harder to charm while a negative value would make that enemy easier to charm. 

	Example:
		Difficulty = 25, //harder to charm (reduce 8-25% chance to charm)
		Difficulty = -25, //easier to charm (increase 8-25% chance to charm)
		Difficulty = 0, //O is unnecessary because when you leave out this member, the system would automatically give it 0 as its default value


4. 'Custom'
Must be a table. Consists of 4 members: 'ID', 'AdditionalPerkGroup', 'BgModifiers', 'Talents' and 'Names'. Custom may not need to have all of mentioned members, missing a fews of them doesn't hurt a bit. Custom = {}, is still valid.

	4.1 'ID'
	Determine the background ID of your charmed unit, very important for certain events. The value must be a string and mustn't be null.
		Example: 
			ID = "background.cultist",
			ID = "background.butcher",

	4.2 'AdditionalPerkGroup'
	Allow you to add a specific perk group to the finished perk tree, very useful to add the perk you want when 'PerkTree' is using a background as a way to get perk tree. This value must be an array consist of 2 slots, the first slot contains a number (1 or 0), the second slot contains either a string or an array.
		Example: 
			AdditionalPerkGroup = [0, "NecroTree"],
		//0 means add all perk group in 'this.Const.PerksCharmedUnit["NecroTree"]'

	        AdditionalPerkGroup = [1, [
		         	this.Const.Perks.BardClassTree.Tree,
		         	this.Const.Perks.ShieldTree.Tree,
		         	this.Const.Perks.BeastsTree.Tree,
		        ],
	        ],
		//1 means randomly choose 1 perk group in this array

	4.3 'BgModifiers'
	Contains camping modifiers, will overwrite camping modifier of background when 'PerkTree' is using a background.
		Example: 
			BgModifiers = {
				Ammo = 0, ArmorParts = 3, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.3, Gathering = 0.1, Training = 0.0, Enchanting = 0.0,
				Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
			},

	4.4 'Talents'
	Only usable when 'Script' is not "player" or your entry is not a human. Affecting the amount of talent star and which stat would get the priority to gain talent, which stat is excluded, you can check "this.Const.Attributes" in config/character to know the indentification of stats.
		Example: 
			Talents = {
				ExcludedTalents = [5], //ranged skill
				PrimaryTalents = [3, 4, 6], //initiative, melee skill, melee defense
				SecondaryTalents = [0], //hitpoints
				StarsMax = 9,
				StarsMin = 1,
			},

	4.5 'Names'
	It contains a string to get a string array from "this.Const.Strings" you can see some example of names in "config/character_names.nut".
		Example:
			Names = "WolfNames",
			Names = "CharacterNames",
			Names = "OrcWarlordNames",

	4.6 'Custom' examples
		Custom = {},
		Custom = {
			ID = "background.monk",
			Names = "SouthernNames"
		},
		Custom = {
			ID = "background.noble",
			BgModifiers = {
				Ammo = 0, ArmorParts = 3, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.3, Gathering = 0.1, Training = 0.0, Enchanting = 0.0,
				Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
			},
		},
		Custom = {
			BgModifiers = {
				Ammo = 0, ArmorParts = 3, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.3, Gathering = 0.1, Training = 0.0, Enchanting = 0.0,
				Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
			},
			AdditionalPerkGroup = [1, [
		        	this.Const.Perks.BardClassTree.Tree,
		        	this.Const.Perks.ShieldTree.Tree,
		        	this.Const.Perks.BeastsTree.Tree,
		        ],
	        ],
		},
		Custom = {
			Names = "KrakenNames",
		},


5. 'PerkTree'
Must be a string. The string can be the name of a background script or the name of a member of "this.Cosnt.PerksCharmedUnit".

	5.1 As a Background name
	When you use a background script name for this 'PerkTree' and when that charmed background is creating, it will copy camping modifiers, ID, CustomPerkTree, PerkTreeDynamic from that background to your charmed background. Rememberm, The ID will be overwritten by 'Custom.ID', the Camping modifiers will be overwritten by 'Custom.BgModifiers'. Just check out "scripts/skills/backgrounds" to find suitable one for your entry.
		Example:
			PerkTree = "swordmaster_background"
			PerkTree = "legend_beggar_commander_op_background"
			PerkTree = "legend_noble_2h"
	Note: 'PerkTree' mustn't be "charmed_beast_background", "charmed_goblin_background", "charmed_human_background", "charmed_human_engineer_background", "charmed_orc_background", "hexen_background", "lesser_hexen_background", "luft_background", "spider_eggs_background".

	5.1 From "this.Cosnt.PerksCharmedUnit"
	Just looking in "scripts/config/zz_hexen_defs_perk" or "scripts/config/zzz_charmed_greenkins_perks" of my mod to know which one you want to use. Or just create one yourself then put it in this. You can use a CustomPerkTree or PerkTreeDynamic in a background as template for this.
		Example
			PerkTree = "WolfTree",
			PerkTree = "LindwurmTree",


*** Some less important members in an entry:

1. 'Script'
If you are making a human entry, this member isn't needed, you can skip it. For non-human entry, it's extremely important. It would give the directory to a player entity script. Something that isn't a human requires a different player file for it, because of this non-human entry would require more work to be done. If your entry is just a different variant of an existed enemy, it would be easier to do. Such as a pink direwolf, you can just reuse "player_beast/direwolf_player" script for that XD.
	Example:
		Script = "player_beast/direwolf_player",
		Script = "player_beast/lindwurm_player",
		Script = "player_beast/spider_player",


2. 'Background'
Charmed background is divided into 4 groups: "charmed_human_background", "charmed_beast_background", "charmed_goblin_background" and "charmed_orc_background". Consider and choose one of these for 'Background'. Remember if that's a human entry, you can skip this.
	Example:
		Background = "charmed_beast_background",
		Background = "charmed_goblin_background",
		Background = "charmed_orc_background",

3. 'Requirements'
This would contains ID of actives/perks/traits/racial or whatever skills you want in an array as a requirement to be able to charm that enemy. if you're making a non-human entry and don't put this in your entry or  Requirements = null, that enemy would be impossible to charm. By default, all human can be charmed so you don't have add Requirements = [] if you want to charm that enemy without any restriction.
	Example:
		Requirements = ["perk.charm_enemy_direwolf"], //need to have this skill to charm
		Requirements = [],                            //no restriction to charm
		Requirements = null,                          //can't be charmed if that enemy isn't a human

5. 'IsExperienced'
Determine if that charmed unit is at lv 1 by default or a random lv between 2 and 5. Can be skipped without any issue
	Example:
		IsExperienced = true;

6. 'Icon'
Set a icon image for that charmed background, that image must exist or there would be an error. Remember to put that image in "gfx/ui/backgrounds". if you leave out this member, the system will pick a suitable icon based on 'this.Const.EntityType'. If it can't, it will have "background_charmed_unknown.png" as default value.
	Exmaple:
		Icon = "background_charmed_83.png",
		Icon = "background_charmed_peasant.png",
		Icon = "background_123.png",
		Icon = "background_witch_hunter.png",


**** In addition to the entry, you may want to put a new backgound icon in "gfx/ui/backgrounds", a charmed icon so the game won't bring any error for not being able to find the image file or get an icon you don't want. That new icon should have name likes this:
	"background_charmed_" + this.Const.EntityType

	Example: an orc berserker has "this.Const.EntityType.OrcBerserker = 14" so its charmed background icon file should be named "background_charmed_14"


**** Here are templates of custom entry

Human template: Sacrifice for Davkul of Davkul Rising mod
{
	ID = "Sacrifice for Davkul", //a filler name so when this entry is in processing it would be annouced as this
	Type = this.Const.EntityType.Cultist_Sacrifice, //make sure this.Const.EntityType.Cultist_Sacrifice exist
	Icon = "background_charmed_83.png" //Name of that background icon image
	StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = ["effects/mindcontrolled_effect"],
	Difficulty = -10,
	Custom = "background.cultist",
	PerkTree = "cultist_background"
}


Non-human template: Pink Direwolf ???
{
	ID = "Pink Direwolf", //a filler name so when this entry is in processing it would be annouced as this
	Type = this.Const.EntityType.PinkDirewolf, //make sure this.Const.EntityType.PinkDirewolf exist
	Icon = "background_charmed_83.png"
	StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Perks = [],
	Difficulty = 69,
	Custom =  {
		BgModifiers = {
			Ammo = 0, ArmorParts = 3, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.3, Gathering = 0.1, Training = 0.0, Enchanting = 0.0,
			Terrain = [0.0, 0.0, 0.025, 0.0, 0.0, 0.025, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		},
		Talents = {
			ExcludedTalents = [5],
			PrimaryTalents = [3, 4, 6],
			SecondaryTalents = [0],
			StarsMax = 9,
			StarsMin = 1,
		},
	},
	PerkTree = "WolfTree",
	Names = "WolfNames",
	Script = "player_beast/direwolf_player",
	Background = "charmed_beast_background",
	Requirements = ["perk.charm_enemy_direwolf"],
}


***** Adding new entries with ::mc_registerCharmedEntries( _array )
Registers new charmed unit entries

Example: create a nut file and put it in "scripts/!mods_preload"

::mods_registerMod("mod_additional_charmed_unit_entries", 1.0);
::mods_queue("mod_additional_charmed_unit_entries", "<mod_mage_trio_hexe_origin", function()
{
	local entries = [
		{
			ID = "Sacrifice for Davkul",
			Type = this.Const.EntityType.Cultist_Sacrifice,
			Icon = "background_charmed_83.png"
			StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
			Perks = ["effects/mindcontrolled_effect"],
			Difficulty = -10,
			Custom = {},
			PerkTree = "cultist_background"
		},
		{
			ID = "Mancatcher of Davkul",
			Type = this.Const.EntityType.Cultist_Mancatcher,
			Icon = "background_charmed_77.png"
			StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
			Perks = ["traits/cultist_fanatic_trait"],
			Difficulty = 25,
			Custom = {},
			PerkTree = "cultist_background"
		},
		{
			ID = "High Priest of Davkul",
			Type = this.Const.EntityType.Cultist_High_Priest,
			StatMod = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
			Perks = ["perks/perk_nimble", "perks/perk_fearsome"],
			Difficulty = 100,
			Custom = {},
			PerkTree = "cultist_background"
		},
	];

	::mc_registerCharmedEntries(entries);
	
});



****** Overwriting an exsited entries with ::mc_registerCharmedEntries( _array )
Unlike adding new entry, you only need to have 'ID' to identity the entry and 'Type' so the system can find the entry to overwrite its contain. Any other member you add to will be added to that entry (if it doesn't have that) or overwritten said member with your new value.

Example: create a nut file and put it in "scripts/!mods_preload"

::mods_registerMod("mod_change_direwolf_entry", 1.0);
::mods_queue("mod_change_direwolf_entry", "<mod_mage_trio_hexe_origin", function()
{
	local entries = [
		{
			ID = "Direwolf",
			Type = this.Const.EntityType.Direwolf,
			Difficulty = -10, //decreasing difficulty
			Requirements = [], //remove skill requirement
		},
		{
			ID = "White Direwolf",
			Type = this.Const.EntityType.LegendWhiteDirewolf, 
			Difficulty = -10, //decreasing difficulty
			Custom =  {
				ID = "background.butcher", //adding background id
				BgModifiers = {
					Ammo = 0, ArmorParts = 3, Meds = 0, Stash = 5, Healing = 0.0, Injury = 0.0, Repair = 0.0, Salvage = 0.0, Crafting = 0.0, Barter = 0.0, ToolConsumption = 0.0, MedConsumption = 0.0, Hunting = 0.3, Fletching = 0.0, Scout = 0.3, Gathering = 0.1, Training = 0.0, Enchanting = 0.0,
					Terrain = [0.0, 0.0, 0.03, 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.03, 0.03, 0.0, 0.0, 0.0, 0.0, 0.0],
				},
				Talents = {
					ExcludedTalents = [5],
					PrimaryTalents = [3, 4, 6],
					SecondaryTalents = [0],
					StarsMax = 9,
					StarsMin = 1,
				},
				Names = "WolfNames",
			},
		},
	];

	::mc_registerCharmedEntries(entries);
	
});