
::Const.ChanceToHitMount <- 70;
::Const.EggSpriteOffsets <- [ [-27, 10], [15, 0], [-10, -20] ];

::Const.UnleashSkills <- [
	"actives.unleash_companion",
	"actives.unleash_wardog",
	"actives.unleash_wolf",
	"actives.legend_unleash_white_wolf",
	"actives.legend_unleash_warbear",
];

::Const.DogArmor <- [
	{
		Type = "wardog_armor",
		Condition = 55,
		ConditionMax = 55,
		StaminaModifier = -10,
		Sprite = "bust_dog_01_armor_01",
		SpriteDamaged = "bust_dog_01_armor_01_damaged",
		SpriteCorpse = "bust_dog_01_armor_01_dead",
	},
	{
		Type = "wardog_heavy_armor",
		Condition = 85,
		ConditionMax = 85,
		StaminaModifier = -15,
		Sprite = "bust_dog_01_armor_02",
		SpriteDamaged = "bust_dog_01_armor_02_damaged",
		SpriteCorpse = "bust_dog_01_armor_02_dead",
	},
	{
		Type = "warwolf_armor",
		Condition = 55,
		ConditionMax = 55,
		StaminaModifier = -10,
		Sprite = "bust_wolf_01_armor_01",
		SpriteDamaged = "bust_wolf_01_armor_01_damaged",
		SpriteCorpse = "bust_dog_01_armor_01_dead",
	},
	{
		Type = "warwolf_heavy_armor",
		Condition = 85,
		ConditionMax = 85,
		StaminaModifier = -15,
		Sprite = "bust_wolf_01_armor_02",
		SpriteDamaged = "bust_wolf_01_armor_02_damaged",
		SpriteCorpse = "bust_dog_01_armor_02_dead",
	},
];

::Const.ExcludedQuirks <- [
	"scripts/companions/quirks/companions_good_boy",
	"scripts/companions/quirks/companions_regenerative",
	"scripts/companions/quirks/companions_healthy",
	"scripts/skills/perks/perk_champion",
	"scripts/skills/perks/perk_dodge",
	"scripts/skills/perks/perk_colossus",
];

::Const.GoblinRider <- 
{
	RiderMovementAPCost = [
		0, // Impassable
		2, // PavedGround
		2, // FlatGround
		3, // RoughGround
		3, // Forest
		4, // Rocks
		5, // Swamp
		3, // Sand
		4  // ShallowWater
	],
	RiderMovementFatigueCost = [
		0,  // Impassable
		1,  // PavedGround
		1,  // FlatGround
		3,  // RoughGround
		3,  // Forest
		5,  // Rocks
		12, // Swamp
		10, // Sand
		10  // ShallowWater
	],
	Mounts = {
		Wardog = 0,
		Hound = 1,
		Wolf = 2,
		WhiteWolf = 3,
		Direwolf = 4,
		DirewolfFrenzied = 5,
		Hyena = 6,
		HyenaFrenzied = 7,
		Bear = 8,
		Spider = 9,
		COUNT = 10
	},

	ID = [
		"accessory.legend_white_warwolf",
		"accessory.wardog",
		"accessory.warhound",
		"accessory.warwolf",
		"accessory.armored_wardog",
		"accessory.armored_warhound",
		"accessory.armored_wolf",
		"accessory.heavily_armored_warhound",
		"accessory.heavily_armored_wardog",
		"accessory.heavily_armored_wolf",
		"accessory.legend_warbear",
		"accessory.hyena",
		"accessory.hyena_frenzied",
		"accessory.direwolf",
		"accessory.direwolf_frenzied",
		"accessory.spider",
		"accessory.temp_spider"
	],

	ShakeLayers = [
		[
			"mount",
			"mount_armor",
			"mount_extra1",
			"mount_extra2",
		],
		[
			"mount_head",
			"mount_extra",
			"mount_restrain"
		]
	],

	SoundsMove = [
		"sounds/enemies/goblin_wolfrider_move_00.wav",
		"sounds/enemies/goblin_wolfrider_move_01.wav",
		"sounds/enemies/goblin_wolfrider_move_02.wav",
		"sounds/enemies/goblin_wolfrider_move_03.wav",
		"sounds/enemies/goblin_wolfrider_move_04.wav",
		"sounds/enemies/goblin_wolfrider_move_05.wav",
		"sounds/enemies/goblin_wolfrider_move_06.wav",
		"sounds/enemies/goblin_wolfrider_move_07.wav",
		"sounds/enemies/goblin_wolfrider_move_08.wav",
		"sounds/enemies/goblin_wolfrider_move_09.wav",
		"sounds/enemies/goblin_wolfrider_move_10.wav",
		"sounds/enemies/goblin_wolfrider_move_11.wav",
		"sounds/enemies/goblin_wolfrider_move_12.wav",
		"sounds/enemies/goblin_wolfrider_move_13.wav"
	],
	
	function getMountType( _item )
	{
		switch(_item.getID())
		{
		case "accessory.wardog":
		case "accessory.armored_wardog":
		case "accessory.heavily_armored_wardog":
			return ::Const.GoblinRider.Mounts.Wardog;
			
		case "accessory.warhound":
		case "accessory.armored_warhound":
		case "accessory.heavily_armored_warhound":
			return ::Const.GoblinRider.Mounts.Hound;

		case "accessory.warwolf":
		case "accessory.armored_wolf":
		case "accessory.heavily_armored_wolf":
			return ::Const.GoblinRider.Mounts.Wolf;
		
		case "accessory.legend_white_warwolf":
			return ::Const.GoblinRider.Mounts.WhiteWolf;

		case "accessory.direwolf":
			return ::Const.GoblinRider.Mounts.Direwolf;

		case "accessory.direwolf_frenzied":
			return ::Const.GoblinRider.Mounts.DirewolfFrenzied;

		case "accessory.hyena":
			return ::Const.GoblinRider.Mounts.Hyena;

		case "accessory.hyena_frenzied":
			return ::Const.GoblinRider.Mounts.HyenaFrenzied;

		case "accessory.legend_warbear":
			return ::Const.GoblinRider.Mounts.Bear;

		case "accessory.spider":
		case "accessory.temp_spider":
			return ::Const.GoblinRider.Mounts.Spider;
		}
		
		return null;
	}

	function updateMountArmor( _item , _appearance, _armor )
	{
		if (typeof _item == "instance")
		{
			_item = _item.get();
		}

		if (!::isKindOf(_item, "accessory_dog"))
		{
			return;
		}

		local index;
		local script = _item.m.ArmorScript;

		if (script == null || typeof script != "string" || script.len() == 0)
		{
			::logInfo("mount doesn\'t have armor");
			return;
		}

		foreach (i, armor in ::Const.DogArmor )
		{
		    if (script.find(armor.Type) != null)
		    {
		    	index = i;
		    	::logInfo("mount has armor");
		    	break;
		    }
		}

		if (index == null)
		{
			::logInfo("can\'t identify mount armor")
			return;
		}

		_armor.Condition = ::Const.DogArmor[index].Condition;
		_armor.ConditionMax = ::Const.DogArmor[index].ConditionMax;
		_armor.StaminaModifier = ::Const.DogArmor[index].StaminaModifier;
		_appearance.Armor = ::Const.DogArmor[index].Sprite;
		_appearance.ArmorDamage = ::Const.DogArmor[index].SpriteDamaged;
		_appearance.CorpseArmor = ::Const.DogArmor[index].SpriteCorpse;
	}
	
	function updateMountSprites( _item , _appearance )
	{
		local _id = _item.getID();
		local variant = _item.getVariant();
		
		switch(_id)
		{
		case "accessory.wardog":
		case "accessory.armored_wardog":
		case "accessory.heavily_armored_wardog":
			_appearance.Body = "bust_dog_01_body_0" + variant;
			_appearance.Head = "bust_dog_01_head_0" + variant;
			_appearance.Injury = "bust_dog_01_injured";
			_appearance.Bloodpool = _appearance.Head + "_dead_bloodpool";
			break;
			
		case "accessory.warhound":
		case "accessory.armored_warhound":
		case "accessory.heavily_armored_warhound":
			_appearance.Body = "bust_hound_0" + variant + "_body";
			_appearance.Head = "bust_hound_0" + variant + "_head";
			_appearance.Injury = "bust_hound_01_injured";
			_appearance.Bloodpool = _appearance.Head + "_dead_bloodpool";
			break;

		case "accessory.warwolf":
		case "accessory.armored_wolf":
		case "accessory.heavily_armored_wolf":
			_appearance.Flipping = true;
			_appearance.Body = "bust_wolf_0" + variant + "_body";
			_appearance.Head = "bust_wolf_0" + variant + "_head";
			_appearance.Injury = "bust_wolf_01_injured";
			_appearance.Restrain = "bust_wolf_02_armor_01";
			break;

		case "accessory.direwolf":
			_appearance.Flipping = true;
			_appearance.Scale = 0.9;
			_appearance.Body = "bust_direwolf_0" + variant;
			_appearance.Head = "bust_direwolf_0" + variant + "_head";
			_appearance.Injury = "bust_direwolf_injured";
			_appearance.Bloodpool = "bust_direwolf_head_bloodpool";
			_appearance.Corpse = "bust_direwolf_01_body_dead";
			break;

		case "accessory.direwolf_frenzied":
			_appearance.Flipping = true;
			_appearance.Scale = 0.9;
			_appearance.Body = "bust_direwolf_0" + variant;
			_appearance.Head = "bust_direwolf_0" + variant + "_head";
			_appearance.Extra = _appearance.Head + "_frenzy";
			_appearance.Injury = "bust_direwolf_injured";
			_appearance.Bloodpool = "bust_direwolf_head_bloodpool";
			_appearance.Corpse = "bust_direwolf_01_body_dead";
			break;

		case "accessory.legend_white_warwolf":
			_appearance.Flipping = true;
			_appearance.Scale = 0.9;
			_appearance.Body = "bust_direwolf_white_01_body";
			_appearance.Head = "bust_direwolf_white_01_head";
			_appearance.Injury = "bust_direwolf_white_injured";
			_appearance.Restrain = "bust_wolf_02_armor_01";
			break;

		case "accessory.hyena":
		case "accessory.hyena_frenzied":
			_appearance.Flipping = true;
			_appearance.Scale = 0.9;
			_appearance.Body = "bust_hyena_0" + variant;
			_appearance.Head = "bust_hyena_0" + variant + "_head";
			_appearance.Injury = "bust_hyena_injured";
			_appearance.Bloodpool = "bust_hyena_head_bloodpool";
			_appearance.Corpse = "bust_hyena_01_body_dead";
			break;

		case "accessory.legend_warbear":
			_appearance.Flipping = true;
			_appearance.Scale = 0.7;
			_appearance.Body = "bear_01";
			_appearance.Head = "bear_head_01";
			_appearance.Injury = "bear_01_injured";
			break;

		case "accessory.spider":
			_appearance.Flipping = true;
			_appearance.Scale = 0.8;
			_appearance.Extra1 = "bust_spider_legs_back";
			_appearance.Extra2 = "bust_spider_body_0" + variant;
			_appearance.Body = "bust_spider_legs_front";
			_appearance.Head = "bust_spider_head_01";
			_appearance.Injury = "bust_spider_01_injured";
			_appearance.Corpse = "bust_spider_body_01_dead";
			_appearance.CorpseHead = "bust_spider_head_01_dead";
			break;

		case "accessory.temp_spider":
			_appearance.Flipping = true;
			_appearance.Scale = 0.8;
			local entity = _item.getEntity();
			_appearance.Extra1 = entity.getSprite("legs_back").getBrush().Name;
			_appearance.Extra2 = entity.getSprite("body").getBrush().Name;
			_appearance.Body = entity.getSprite("legs_front").getBrush().Name;
			_appearance.Head = entity.getSprite("head").getBrush().Name;
			_appearance.Injury = entity.getSprite("injury").getBrush().Name;
			_appearance.Bloodpool = "bust_spider_head_01_dead_bloodpool";
			_appearance.Corpse = _item.m.IsRedBack ? "bust_spider_redback_body_01_dead" : "bust_spider_body_01_dead";
			_appearance.CorpseHead = _item.m.IsRedBack ? "bust_spider_redback_head_01_dead" : "bust_spider_head_01_dead";
			break;
		}

		if (_appearance.Corpse == "")
		{
			_appearance.Corpse = _appearance.Body + "_dead";
		}

		if (_appearance.CorpseHead == "")
		{
			_appearance.CorpseHead = _appearance.Head + "_dead";
		}
	}
};

::Const.GoblinRiderMounts <- [
	//0 - Wardog
	{
		Attributes = "Wardog",
		Skills = [/*"actives/wardog_bite", "perks/perk_pathfinder"*/],
		Strength = 1.1,
		Flags = [],
		Sprite = [
			[-5, 10], //For rider
			[10, -8], //For mount
		],
		MountedBonus = { ActionPoints = 3, Stamina = 5, Initiative = 10, MeleeDefense = 3, RangedDefense = 3, Threat = 0, },
		SoundsOther1 = [
			"sounds/enemies/wardog_hurt_00.wav",
			"sounds/enemies/wardog_hurt_01.wav",
			"sounds/enemies/wardog_hurt_02.wav",
			"sounds/enemies/wardog_hurt_03.wav",
			"sounds/enemies/wardog_hurt_04.wav",
			"sounds/enemies/wardog_hurt_05.wav"
		],
		SoundsOther2 = [
			"sounds/enemies/wardog_death_00.wav",
			"sounds/enemies/wardog_death_01.wav",
			"sounds/enemies/wardog_death_02.wav",
			"sounds/enemies/wardog_death_03.wav"
		],
		SoundsIdle = [
			"sounds/enemies/wardog_idle_01.wav",
			"sounds/enemies/wardog_idle_02.wav",
			"sounds/enemies/wardog_idle_03.wav",
			"sounds/enemies/wardog_idle_04.wav",
			"sounds/enemies/wardog_idle_05.wav"
		],
	},

	//1 - Hound
	{
		Attributes = "Warhound",
		Skills = [/*"actives/warhound_bite"*/],
		Strength = 1.15,
		Flags = [],
		Sprite = [
			[-5, 15], //For rider
			[ 5, -8], //For mount
		],
		MountedBonus = { ActionPoints = 3, Stamina = 10, Initiative = 8, MeleeDefense = 5, RangedDefense = 0, Threat = 0, },
		SoundsOther1 = [
			"sounds/enemies/wardog_hurt_00.wav",
			"sounds/enemies/wardog_hurt_01.wav",
			"sounds/enemies/wardog_hurt_02.wav",
			"sounds/enemies/wardog_hurt_03.wav",
			"sounds/enemies/wardog_hurt_04.wav",
			"sounds/enemies/wardog_hurt_05.wav"
		],
		SoundsOther2 = [
			"sounds/enemies/wardog_death_00.wav",
			"sounds/enemies/wardog_death_01.wav",
			"sounds/enemies/wardog_death_02.wav",
			"sounds/enemies/wardog_death_03.wav"
		],
		SoundsIdle = [
			"sounds/enemies/wardog_idle_01.wav",
			"sounds/enemies/wardog_idle_02.wav",
			"sounds/enemies/wardog_idle_03.wav",
			"sounds/enemies/wardog_idle_04.wav",
			"sounds/enemies/wardog_idle_05.wav"
		],
	},

	//2 - Wolf
	{
		Attributes = "WarWolf",
		Skills = [/*"actives/wolf_bite",*/ "perks/perk_pathfinder"],
		Strength = 1.2,
		Flags = [],
		Sprite = [
			[-8, 13], //For rider
			[ 0, -18], //For mount
		],
		MountedBonus = { ActionPoints = 3, Stamina = 8, Initiative = 12, MeleeDefense = 4, RangedDefense = 4, Threat = 0, },
		SoundsOther1 = [
			"sounds/enemies/wolf_hurt_00.wav",
			"sounds/enemies/wolf_hurt_01.wav",
			"sounds/enemies/wolf_hurt_02.wav",
			"sounds/enemies/wolf_hurt_03.wav"
		],
		SoundsOther2 = [
			"sounds/enemies/wolf_death_00.wav",
			"sounds/enemies/wolf_death_01.wav",
			"sounds/enemies/wolf_death_02.wav",
			"sounds/enemies/wolf_death_03.wav",
			"sounds/enemies/wolf_death_04.wav",
			"sounds/enemies/wolf_death_05.wav"
		],
		SoundsIdle = [
			"sounds/enemies/wolf_idle_00.wav",
			"sounds/enemies/wolf_idle_01.wav",
			"sounds/enemies/wolf_idle_02.wav",
			"sounds/enemies/wolf_idle_03.wav",
			"sounds/enemies/wolf_idle_04.wav",
			"sounds/enemies/wolf_idle_06.wav",
			"sounds/enemies/wolf_idle_07.wav",
			"sounds/enemies/wolf_idle_08.wav",
			"sounds/enemies/wolf_idle_09.wav"
		],
	},

	//3 - WhiteWolf
	{
		Attributes = "LegendWhiteWarwolf",
		Skills = [/*"actives/werewolf_bite",*/ "actives/rotation", "perks/perk_pathfinder"],
		Strength = 1.5,
		Flags = ["frenzy"],
		Sprite = [
			[-8, 13], //For rider
			[ 0, -18], //For mount
		],
		MountedBonus = { ActionPoints = 3, Stamina = 30, Initiative = 30, MeleeDefense = 11, RangedDefense = 5, Threat = 5, },
		SoundsOther1 = [
			"sounds/enemies/wolf_hurt_00.wav",
			"sounds/enemies/wolf_hurt_01.wav",
			"sounds/enemies/wolf_hurt_02.wav",
			"sounds/enemies/wolf_hurt_03.wav"
		],
		SoundsOther2 = [
			"sounds/enemies/wolf_death_00.wav",
			"sounds/enemies/wolf_death_01.wav",
			"sounds/enemies/wolf_death_02.wav",
			"sounds/enemies/wolf_death_03.wav",
			"sounds/enemies/wolf_death_04.wav",
			"sounds/enemies/wolf_death_05.wav"
		],
		SoundsIdle = [
			"sounds/enemies/wolf_idle_00.wav",
			"sounds/enemies/wolf_idle_01.wav",
			"sounds/enemies/wolf_idle_02.wav",
			"sounds/enemies/wolf_idle_03.wav",
			"sounds/enemies/wolf_idle_04.wav",
			"sounds/enemies/wolf_idle_06.wav",
			"sounds/enemies/wolf_idle_07.wav",
			"sounds/enemies/wolf_idle_08.wav",
			"sounds/enemies/wolf_idle_09.wav"
		],
	},

	//4 - Direwolf
	{
		Attributes = "Direwolf",
		Skills = [/*"actives/werewolf_bite", "perks/perk_pathfinder"*/],
		Strength = 1.25,
		Flags = [],
		Sprite = [
			[-8, 13], //For rider
			[ 0, -18], //For mount
		],
		MountedBonus = { ActionPoints = 3, Stamina = 10, Initiative = 12, MeleeDefense = 4, RangedDefense = 4, Threat = 0, },
		SoundsOther1 = [
			"sounds/enemies/werewolf_hurt_01.wav",
			"sounds/enemies/werewolf_hurt_02.wav",
			"sounds/enemies/werewolf_hurt_03.wav",
			"sounds/enemies/werewolf_hurt_04.wav"
		],
		SoundsOther2 = [
			"sounds/enemies/werewolf_death_01.wav",
			"sounds/enemies/werewolf_death_02.wav",
			"sounds/enemies/werewolf_death_03.wav",
			"sounds/enemies/werewolf_death_04.wav",
			"sounds/enemies/werewolf_death_05.wav"
		],
		SoundsIdle = [
			"sounds/enemies/werewolf_idle_01.wav",
			"sounds/enemies/werewolf_idle_02.wav",
			"sounds/enemies/werewolf_idle_03.wav",
			"sounds/enemies/werewolf_idle_04.wav",
			"sounds/enemies/werewolf_idle_05.wav",
			"sounds/enemies/werewolf_idle_06.wav",
			"sounds/enemies/werewolf_idle_07.wav",
			"sounds/enemies/werewolf_idle_08.wav",
			"sounds/enemies/werewolf_idle_09.wav",
			"sounds/enemies/werewolf_idle_10.wav",
			"sounds/enemies/werewolf_idle_11.wav",
			"sounds/enemies/werewolf_idle_12.wav",
			"sounds/enemies/werewolf_idle_13.wav",
			"sounds/enemies/werewolf_idle_14.wav",
			"sounds/enemies/werewolf_idle_15.wav",
			"sounds/enemies/werewolf_idle_16.wav",
			"sounds/enemies/werewolf_idle_17.wav",
			"sounds/enemies/werewolf_idle_18.wav",
			"sounds/enemies/werewolf_idle_19.wav",
			"sounds/enemies/werewolf_idle_20.wav",
			"sounds/enemies/werewolf_idle_21.wav"
		],
	},

	//5 - DirewolfFrenzied
	{
		Attributes = "FrenziedDirewolf",
		Skills = [/*"actives/werewolf_bite", "perks/perk_pathfinder"*/],
		Strength = 1.30,
		Flags = ["frenzy"],
		Sprite = [
			[-8, 13], //For rider
			[ 0, -18], //For mount
		],
		MountedBonus = { ActionPoints = 3, Stamina = 10, Initiative = 15, MeleeDefense = 5, RangedDefense = 5, Threat = 0, },
		SoundsOther1 = [
			"sounds/enemies/werewolf_hurt_01.wav",
			"sounds/enemies/werewolf_hurt_02.wav",
			"sounds/enemies/werewolf_hurt_03.wav",
			"sounds/enemies/werewolf_hurt_04.wav"
		],
		SoundsOther2 = [
			"sounds/enemies/werewolf_death_01.wav",
			"sounds/enemies/werewolf_death_02.wav",
			"sounds/enemies/werewolf_death_03.wav",
			"sounds/enemies/werewolf_death_04.wav",
			"sounds/enemies/werewolf_death_05.wav"
		],
		SoundsIdle = [
			"sounds/enemies/werewolf_idle_01.wav",
			"sounds/enemies/werewolf_idle_02.wav",
			"sounds/enemies/werewolf_idle_03.wav",
			"sounds/enemies/werewolf_idle_04.wav",
			"sounds/enemies/werewolf_idle_05.wav",
			"sounds/enemies/werewolf_idle_06.wav",
			"sounds/enemies/werewolf_idle_07.wav",
			"sounds/enemies/werewolf_idle_08.wav",
			"sounds/enemies/werewolf_idle_09.wav",
			"sounds/enemies/werewolf_idle_10.wav",
			"sounds/enemies/werewolf_idle_11.wav",
			"sounds/enemies/werewolf_idle_12.wav",
			"sounds/enemies/werewolf_idle_13.wav",
			"sounds/enemies/werewolf_idle_14.wav",
			"sounds/enemies/werewolf_idle_15.wav",
			"sounds/enemies/werewolf_idle_16.wav",
			"sounds/enemies/werewolf_idle_17.wav",
			"sounds/enemies/werewolf_idle_18.wav",
			"sounds/enemies/werewolf_idle_19.wav",
			"sounds/enemies/werewolf_idle_20.wav",
			"sounds/enemies/werewolf_idle_21.wav"
		],
	},

	//6 - Hyena
	{
		Attributes = "Hyena",
		Skills = [/*"actives/hyena_bite_skill", "perks/perk_pathfinder"*/],
		Strength = 1.25,
		Flags = [],
		Sprite = [
			[-8, 13], //For rider
			[ 0, -18], //For mount
		],
		MountedBonus = { ActionPoints = 3, Stamina = 10, Initiative = 11, MeleeDefense = 5, RangedDefense = 4, Threat = 0, },
		SoundsOther1 = [
			"sounds/enemies/dlc6/hyena_hurt_01.wav",
			"sounds/enemies/dlc6/hyena_hurt_02.wav",
			"sounds/enemies/dlc6/hyena_hurt_03.wav",
			"sounds/enemies/dlc6/hyena_hurt_04.wav"
		],
		SoundsOther2 = [
			"sounds/enemies/dlc6/hyena_death_01.wav",
			"sounds/enemies/dlc6/hyena_death_02.wav",
			"sounds/enemies/dlc6/hyena_death_03.wav",
			"sounds/enemies/dlc6/hyena_death_04.wav"
		],
		SoundsIdle = [
			"sounds/enemies/dlc6/hyena_idle_01.wav",
			"sounds/enemies/dlc6/hyena_idle_02.wav",
			"sounds/enemies/dlc6/hyena_idle_03.wav",
			"sounds/enemies/dlc6/hyena_idle_04.wav",
			"sounds/enemies/dlc6/hyena_idle_05.wav",
			"sounds/enemies/dlc6/hyena_idle_06.wav",
			"sounds/enemies/dlc6/hyena_idle_07.wav",
			"sounds/enemies/dlc6/hyena_idle_08.wav",
			"sounds/enemies/dlc6/hyena_idle_09.wav",
			"sounds/enemies/dlc6/hyena_idle_10.wav",
			"sounds/enemies/dlc6/hyena_idle_11.wav",
			"sounds/enemies/dlc6/hyena_idle_12.wav",
			"sounds/enemies/dlc6/hyena_idle_13.wav",
			"sounds/enemies/dlc6/hyena_idle_14.wav",
			"sounds/enemies/dlc6/hyena_idle_15.wav",
			"sounds/enemies/dlc6/hyena_idle_16.wav",
			"sounds/enemies/dlc6/hyena_idle_17.wav",
			"sounds/enemies/dlc6/hyena_idle_18.wav",
			"sounds/enemies/dlc6/hyena_idle_19.wav",
			"sounds/enemies/dlc6/hyena_idle_20.wav",
			"sounds/enemies/dlc6/hyena_idle_21.wav",
		],
	},

	//7 - HyenaFrenzied
	{
		Attributes = "FrenziedHyena",
		Skills = [/*"actives/hyena_bite_skill", "perks/perk_pathfinder"*/],
		Strength = 1.30,
		Flags = ["frenzy"],
		Sprite = [
			[-8, 13], //For rider
			[ 0, -18], //For mount
		],
		MountedBonus = { ActionPoints = 3, Stamina = 10, Initiative = 13, MeleeDefense = 6, RangedDefense = 5, Threat = 0, },
		SoundsOther1 = [
			"sounds/enemies/dlc6/hyena_hurt_01.wav",
			"sounds/enemies/dlc6/hyena_hurt_02.wav",
			"sounds/enemies/dlc6/hyena_hurt_03.wav",
			"sounds/enemies/dlc6/hyena_hurt_04.wav"
		],
		SoundsOther2 = [
			"sounds/enemies/dlc6/hyena_death_01.wav",
			"sounds/enemies/dlc6/hyena_death_02.wav",
			"sounds/enemies/dlc6/hyena_death_03.wav",
			"sounds/enemies/dlc6/hyena_death_04.wav"
		],
		SoundsIdle = [
			"sounds/enemies/dlc6/hyena_idle_01.wav",
			"sounds/enemies/dlc6/hyena_idle_02.wav",
			"sounds/enemies/dlc6/hyena_idle_03.wav",
			"sounds/enemies/dlc6/hyena_idle_04.wav",
			"sounds/enemies/dlc6/hyena_idle_05.wav",
			"sounds/enemies/dlc6/hyena_idle_06.wav",
			"sounds/enemies/dlc6/hyena_idle_07.wav",
			"sounds/enemies/dlc6/hyena_idle_08.wav",
			"sounds/enemies/dlc6/hyena_idle_09.wav",
			"sounds/enemies/dlc6/hyena_idle_10.wav",
			"sounds/enemies/dlc6/hyena_idle_11.wav",
			"sounds/enemies/dlc6/hyena_idle_12.wav",
			"sounds/enemies/dlc6/hyena_idle_13.wav",
			"sounds/enemies/dlc6/hyena_idle_14.wav",
			"sounds/enemies/dlc6/hyena_idle_15.wav",
			"sounds/enemies/dlc6/hyena_idle_16.wav",
			"sounds/enemies/dlc6/hyena_idle_17.wav",
			"sounds/enemies/dlc6/hyena_idle_18.wav",
			"sounds/enemies/dlc6/hyena_idle_19.wav",
			"sounds/enemies/dlc6/hyena_idle_20.wav",
			"sounds/enemies/dlc6/hyena_idle_21.wav",
		],
	},

	//8 - Bear
	{
		Attributes = "LegendBear",
		Skills = [/*"actives/werewolf_bite",*/ "actives/line_breaker", "perks/perk_battering_ram", "perks/perk_stalwart"],
		Strength = 1.35,
		Flags = ["ride_bear"],
		Sprite = [
			[-12, 15], //For rider
			[0, -15], //For mount
		],
		MountedBonus = { ActionPoints = 2, Stamina = 25, Initiative = 0, MeleeDefense = 7, RangedDefense = -5, Threat = 0, },
		SoundsOther1 = [
			"sounds/enemies/bear_hit1.wav",
			"sounds/enemies/bear_hit2.wav"
		],
		SoundsOther2 = [
			"sounds/enemies/bear_dead.wav"
		],
		SoundsIdle = [
			"sounds/enemies/bear_idle1.wav",
			"sounds/enemies/bear_idle2.wav"
		],
	},

	//9 - Spider
	{
		Attributes = "Spider",
		Skills = ["actives/spider_bite_skill", "actives/web_skill" , "racial/spider_racial"],
		Strength = 1.12,
		Flags = ["spider"],
		Sprite = [
			[-25, 40], //For rider
			[0, 0], //For mount
		],
		MountedBonus = { ActionPoints = 3, Stamina = 0, Initiative = 25, MeleeDefense = 5, RangedDefense = 8, Threat = 0, },
		SoundsOther1 = [
			"sounds/enemies/dlc2/giant_spider_hurt_01.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_02.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_03.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_04.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_05.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_06.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_07.wav"
		],
		SoundsOther2 = [
			"sounds/enemies/dlc2/giant_spider_death_01.wav",
			"sounds/enemies/dlc2/giant_spider_death_02.wav",
			"sounds/enemies/dlc2/giant_spider_death_03.wav",
			"sounds/enemies/dlc2/giant_spider_death_04.wav",
			"sounds/enemies/dlc2/giant_spider_death_05.wav",
			"sounds/enemies/dlc2/giant_spider_death_06.wav",
			"sounds/enemies/dlc2/giant_spider_death_07.wav",
			"sounds/enemies/dlc2/giant_spider_death_08.wav"
		],
		SoundsIdle = [
			"sounds/enemies/dlc2/giant_spider_idle_01.wav",
			"sounds/enemies/dlc2/giant_spider_idle_02.wav",
			"sounds/enemies/dlc2/giant_spider_idle_03.wav",
			"sounds/enemies/dlc2/giant_spider_idle_04.wav",
			"sounds/enemies/dlc2/giant_spider_idle_05.wav",
			"sounds/enemies/dlc2/giant_spider_idle_06.wav",
			"sounds/enemies/dlc2/giant_spider_idle_07.wav",
			"sounds/enemies/dlc2/giant_spider_idle_08.wav",
			"sounds/enemies/dlc2/giant_spider_idle_09.wav",
			"sounds/enemies/dlc2/giant_spider_idle_10.wav",
			"sounds/enemies/dlc2/giant_spider_idle_11.wav",
			"sounds/enemies/dlc2/giant_spider_idle_12.wav",
			"sounds/enemies/dlc2/giant_spider_idle_13.wav",
			"sounds/enemies/dlc2/giant_spider_idle_14.wav",
			"sounds/enemies/dlc2/giant_spider_idle_15.wav",
			"sounds/enemies/dlc2/giant_spider_idle_16.wav"
		],
	},
];
