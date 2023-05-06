
if (!("CharmedUtilities" in ::Const))
{
	::Const.CharmedUtilities <- {};
}

::Const.CharmedUtilities <- 
{
	ExcludedSkills = [
		"effects.charmed_captive",
		"special.bag_fatigue",
		"special.double_grip",
		"special.mood_check",
		"special.morale.check",
		"special.no_ammo_warning",
		"special.stats_collector",
		"special.weapon_breaking_warning",
		"terrain.hidden",
		"terrain.swamp",
		"actives.load_mortar",
		"actives.fire_mortar",
		"actives.shieldwall",
		"actives.knock_back",
		"actives.drums_of_war",
		"actives.legend_piercing_shot",
		"actives.legend_cascade",
		"actives.legend_daze",
		"actives.legend_entice",
		"actives.legend_drums_of_life",
		"actives.legend_drums_of_war",
		"actives.load_mortar_player",
	],

	function removeAllHumanSprites( _entity, _exclude = null, _removeDefaultSprites = false )
	{
		_exclude = _exclude != null ? _exclude : [];

		foreach (id in ::Const.CharmedUtilities.SpritesToRemove)
		{
			if (_exclude.find(id) == null)
		    {
		    	_entity.removeSprite(id);
		    }
		}

		if (!_removeDefaultSprites)
		{
			return;
		}

		foreach (id in ::Const.CharmedUtilities.DefaultSprites)
		{
		    _entity.removeSprite(id);
		}

		if (_entity.getMoraleState() != ::Const.MoraleState.Ignore)
		{
			_entity.removeSprite("morale");
		}
	}

	function processingCharmedBackground( _data, _background )
	{
		if (_data == null || typeof _data != "table")
		{
			return;
		}

		local names;
		local lastNames;

		if (("PerkTree" in _data) && _data.PerkTree != null)
		{
			switch (typeof _data.PerkTree)
			{
			case "array":
				_background.m.CustomPerkTree = _data.PerkTree;
				break;

			case "table":
				_background.m.PerkTreeDynamic = _data.PerkTree;
				break;

			case "string":
			    local bg = ::new("scripts/skills/backgrounds/" + _data.PerkTree);
			    _background.m.ID = bg.m.ID;
				_background.m.ExcludedTalents = bg.m.ExcludedTalents;
				_background.m.BackgroundType = bg.m.BackgroundType;
				_background.m.Modifiers = bg.m.Modifiers;
				
				if (bg.m.CustomPerkTree != null)
				{
					_background.m.CustomPerkTree = bg.m.CustomPerkTree;
				}
				else if (bg.m.PerkTreeDynamic != null)
				{
					_background.m.CustomPerkTree = null;
					_background.m.PerkTreeDynamic = bg.m.PerkTreeDynamic;
				}

				if ("PerkGroupMultipliers" in bg.m)
				{
					_background.m.PerkGroupMultipliers = bg.m.PerkGroupMultipliers;
				}
			    break;
			}
		}
		
			
		if (_data.Entity != null && _data.Entity.getName() != ::Const.Strings.EntityName[_data.Type])
		{
			names = [_data.Entity.getName()];
		}
		else
		{
			names = [];
		}

		if (("Custom" in _data) && _data.Custom.len() != 0)
		{
			if ("ID" in _data.Custom)
			{
				_background.m.ID = _data.Custom.ID;
			}

			if ("AdditionalPerkGroup" in _data.Custom)
			{
				local input = [];
				_background.m.AdditionalPerks = [];

				foreach (_string in _data.Custom.AdditionalPerkGroup[1])
				{
					if (!(_string in ::Const.Perks))
					{
						continue;
					}

					input.push(::Const.Perks[_string].Tree);
				}

				if (_data.Custom.AdditionalPerkGroup[0] == 0)
				{
					_background.m.AdditionalPerks.extend(input);
				}
				else
				{
				    _background.m.AdditionalPerks.push(::MSU.Array.rand(input));
				}
			}
			
			if ("BgModifiers" in _data.Custom)
			{
				_background.m.Modifiers = _data.Custom.BgModifiers;
			}

			if ("Talents" in _data.Custom)
			{
				_background.m.ExcludedTalents.extend(_data.Custom.Talents.ExcludedTalents);
			}

			if (("Names" in _data.Custom) && typeof _data.Custom.Names == "string" && (_data.Custom.Names in ::Const.Strings))
			{
				names.extend(::Const.Strings[_data.Custom.Names]);
			}
			else
			{
				names.extend(::Const.Strings.CharacterNames);
			}
		}

		if (_background.m.PerkGroupMultipliers.len() == 0 && _background.m.PerkTreeDynamic != null && ("WeightMultipliers" in _background.m.PerkTreeDynamic))
		{
			_background.m.PerkGroupMultipliers = _background.m.PerkTreeDynamic.WeightMultipliers;
			delete _background.m.PerkTreeDynamic.WeightMultipliers;
		}
		
		_background.m.Names = names != null ? names : [];
	}
	
	function TypeToInfoHuman( _human, _returnViable = false )
	{
		local _type = _human.getType();

		if (_returnViable)
		{
			return ::Const.CharmedUnits.getRequirements(_type, true);
		}
		
		local ret = {
			Type = _type,
			Entity = _human,
			Script = "player",
			Background = "nggh_mod_charmed_human_background",
		};

		::Const.CharmedUnits.addBasicData(ret, _human);
		return ret;
	}
	
	function TypeToInfoNonHuman( _entity , _returnViable = false )
	{	
		local _type = _entity.getType();
		
		if (_returnViable)
		{
			return ::Const.CharmedUnits.getRequirements(_type);
		}
		
		local ret = {
			Type = _type,
			Entity = _entity
		};
		::Const.CharmedUnits.addBasicData(ret, _entity);

		switch (_type)
		{
		case ::Const.EntityType.BarbarianUnhold:
			ret.Type = ::Const.EntityType.Unhold;
			break;
			
		case ::Const.EntityType.BarbarianUnholdFrost:
			ret.Type = ::Const.EntityType.UnholdFrost;
			break;
		}

		return ret;
	}

	function getTooltip( _actor )
	{
		local ret = [];
		local _baseProperties = _actor.getBaseProperties();
		local _currentProperties = _actor.getCurrentProperties();

		if (_baseProperties.FatigueRecoveryRate > 15)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (_baseProperties.FatigueRecoveryRate - 15) + "[/color] Fatigue Recovery per turn"
			});
		}
		else if (_baseProperties.FatigueRecoveryRate < 15)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (15 - _baseProperties.FatigueRecoveryRate) + "[/color] Fatigue Recovery per turn"
			});
		}

		local value = ::Math.floor(_baseProperties.DamageTotalMult * 100);

		if (value > 100)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (value - 100) + "%[/color] Attack damage"
			});
		}
		else if (value < 100)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (100 - value) + "%[/color] Attack damage"
			});
		}

		local value = ::Math.floor(_baseProperties.DamageDirectMult * 100);

		if (value > 100)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (value - 100) + "%[/color]  Damage that ignores armor"
			});
		}
		else if (value < 100)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (100 - value) + "%[/color]  Damage that ignores armor"
			});
		}

		if (_currentProperties.IsImmuneToOverwhelm)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + ::Const.UI.Color.NegativeValue + "]Overwhelm[/color]"
			});
		}
		
		if (_currentProperties.IsImmuneToZoneOfControl)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + ::Const.UI.Color.NegativeValue + "]Zone of Control[/color]"
			});
		}
		
		if (_currentProperties.IsImmuneToStun)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + ::Const.UI.Color.NegativeValue + "]Stun[/color]"
			});
		}
		
		if (_currentProperties.IsImmuneToRoot)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + ::Const.UI.Color.NegativeValue + "]Root[/color], [color=" + ::Const.UI.Color.NegativeValue + "]Net[/color], [color=" + ::Const.UI.Color.NegativeValue + "]Web[/color], [color=" + ::Const.UI.Color.NegativeValue + "]Ensnare[/color]"
			});
		}
		
		if (_currentProperties.IsImmuneToKnockBackAndGrab)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + ::Const.UI.Color.NegativeValue + "]Knock Back[/color] and [color=" + ::Const.UI.Color.NegativeValue + "]Grab[/color]"
			});
		}
		
		if (_currentProperties.IsImmuneToDisarm)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + ::Const.UI.Color.NegativeValue + "]Disarm[/color]"
			});
		}
		
		if (_currentProperties.IsImmuneToSurrounding)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to being [color=" + ::Const.UI.Color.NegativeValue + "]Surrounded[/color]"
			});
		}
		
		if (_currentProperties.IsImmuneToBleeding)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + ::Const.UI.Color.NegativeValue + "]Bleeding[/color]"
			});
		}
		
		if (_currentProperties.IsImmuneToPoison)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + ::Const.UI.Color.NegativeValue + "]Poison[/color]"
			});
		}
		
		if (_currentProperties.IsImmuneToDamageReflection)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + ::Const.UI.Color.NegativeValue + "]Damage Reflection[/color]"
			});
		}
			
		if (_currentProperties.IsImmuneToFire)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + ::Const.UI.Color.NegativeValue + "]Fire[/color]"
			});
		}	
		
		if (!_currentProperties.IsAffectedByNight)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Not being affected by [color=" + ::Const.UI.Color.NegativeValue + "]Nighttime[/color] penalties"
			});
		}
		
		if (!_currentProperties.IsAffectedByInjuries)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Not being affected by [color=" + ::Const.UI.Color.NegativeValue + "]Injuries[/color]"
			});
		}
		
		if (!_currentProperties.IsAffectedByFreshInjuries)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Not being affected by [color=" + ::Const.UI.Color.NegativeValue + "]Fresh Injuries[/color]"
			});
		}

		return ret;
	}
	
};

::Const.CharmedUtilities.BackgroundTypeToCopy <- [
	"Combat",
	"ConvertedCultist",
	"Educated",
	"Noble",
	"Lowborn",
	"OffendedByViolence",
	"Outlaw",
	"Performing",
	"Scenario",
	"Ranger",
	"Untalented",
	"Cultist",
];

::Const.CharmedUtilities.SpritesToCloneHuman <- [
	"body",
	"head",
	"beard",
	"hair",
	"tattoo_body",
	"tattoo_head",
	"beard_top"
];

::Const.CharmedUtilities.SpritesToClone <- [
	"surcoat", 
	"body", 
	"tattoo_body", 
	"body_rage", 
	"injury_body", 
	"head", 
	"tattoo_head", 
	"beard", 
	"hair", 
	"beard_top", 
	"injury", 
	"body_blood", 
	"head_frenzy", 
	"accessory_special", 
	"legs_back", 
	"legs_front"
];

::Const.CharmedUtilities.SpritesToRemove <- [
	"quiver",
	"tattoo_body",
	"scar_body",
	"injury_body",
	"armor",
	"armor_layer_chain",
	"armor_layer_plate",
	"armor_layer_tabbard",
	"surcoat",
	"armor_layer_cloak",
	"armor_layer_cloak_front",
	"armor_upgrade_back",
	"bandage_2",
	"bandage_3",
	"shaft",
	"head",
	"eye_rings",
	"closed_eyes",
	"tattoo_head",
	"scar_head",
	"injury",
	"permanent_injury_3",
	"permanent_injury_2",
	"permanent_injury_scarred",
	"permanent_injury_burned",
	"beard",
	"hair",
	"permanent_injury_4",
	"permanent_injury_1",
	"beard_top",
	"armor_upgrade_front",
	"bandage_1",
	"body_blood",
	"dirt",
	"accessory",
	"accessory_special",
];
::Const.CharmedUtilities.SpritesToRemove.extend(::Const.CharacterSprites.Helmets);

::Const.CharmedUtilities.SpritesToIgnoreOrc <- [
	"quiver",
	"tattoo_body",
	"injury_body",
	"armor",
	"armor_layer_chain",
	"armor_layer_plate",
	"armor_layer_tabbard",
	"armor_layer_cloak",
	"armor_layer_cloak_front",
	"armor_upgrade_back",
	"shaft",
	"head",
	"tattoo_head",
	"injury",
	"armor_upgrade_front",
	"body_blood",
];
::Const.CharmedUtilities.SpritesToIgnoreOrc.extend(::Const.CharacterSprites.Helmets);

::Const.CharmedUtilities.Armor <- [
	"armor",
	"armor_layer_chain",
	"armor_layer_plate",
	"armor_layer_tabbard",
	"armor_layer_cloak_front",
	"armor_layer_cloak",
	"armor_upgrade_back",
	"armor_upgrade_front",
];

::Const.CharmedUtilities.DefaultSprites <- [
	"miniboss",
	"status_hex",
	"status_sweat",
	"status_stunned",
	"shield_icon",
	"arms_icon",
	"status_rooted",
];
