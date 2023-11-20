
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

/////////////////////////////////////////////////////////

	function processingCharmedBackground( _data, _background )
	{
		if (_data == null || typeof _data != "table")
			return;

		local names;
		local lastNames;

		if (("Background" in _data) && _data.Background != null)
		{
		    local bg = ::new("scripts/skills/backgrounds/" + _data.Background);
		    _background.m.ID = bg.m.ID;
			_background.m.ExcludedTalents = bg.m.ExcludedTalents;
			_background.m.BackgroundType = bg.m.BackgroundType;
			_background.m.Modifiers = bg.m.Modifiers;
			_background.m.IsSavingBackgroundType = true;
			_background.m.IsSavingModifier = true;
			
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
		}
			
		if (_data.Entity != null && _data.Entity.getName() != ::Const.Strings.EntityName[_data.Type])
		{
			_background.m.HasFixedName = true;
			_background.m.Titles = [_data.Entity.getTitle()];
			names = [_data.Entity.getNameOnly()];
		}
		else
		{
			names = [];
		}

		if (("Custom" in _data) && typeof _data.Custom == "table" && _data.Custom.len() != 0)
		{
			if ("ID" in _data.Custom)
			{
				_background.m.ID = _data.Custom.ID;
			}

			if ("ExcludedTalents" in _data.Custom)
			{
				if (_data.Custom.ExcludedTalents.len() == ::Const.Attributes.COUNT)
				{
					_background.addBackgroundType(::Const.BackgroundType.Untalented);
				}
				else
				{
					_background.m.ExcludedTalents.extend(_data.Custom.ExcludedTalents);
				}
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

		if (::Const.Goblin.Variants.find(_data.Type) != null)
			_background.m.Race = 1;
		else if (::Const.Orc.Variants.find(_data.Type) != null)
			_background.m.Race = 2;
		else if (!_data.IsHuman)
			_background.m.Race = 3;
		
		_background.m.Names = names != null ? names : [];
		_background.m.Name = "Charmed " + ::Const.Strings.EntityName[_data.Type];
		_background.m.Icon = "ui/backgrounds/" + ::Const.CharmedUnits.getBackgroundIcon(_data.Type);
	}

	function setup( _background, _isFromScenario = true )
	{
		local actor = _background.getContainer().getActor();
		actor.m.Background = _background;
		actor.m.StarWeights = this.buildAttributes.call(_background, null, null);
		_background.onfillTalentsValues(actor);
		local attributes = _background.buildPerkTree();
		_background.setAppearance();

		if (!_isFromScenario && actor.getFlags().has("nggh_character"))
			actor.setScenarioValues(_background.m.CharmID, _background.m.TempData.IsMiniboss, true, _background.m.Names.len() == 0);

		_background.addBonusAttributes(attributes);
		_background.pickCurrentLevel();
		_background.onAddEquipment();

		// finishing
		this.onSetup.call(_background);
	}

	// special functions, all of them will use call.(background);
	function onSetup()
	{
		local data = this.getCharmDataByID(this.m.CharmID);

		if (this.isHuman()) 
		{
			if (this.m.TempData != null && this.m.TempData.IsMiniboss)
				this.getContainer().add(::new("scripts/skills/racial/champion_racial"));
			else if (::Math.rand(1, 100) <= 1)
				this.addPerk(::Const.Perks.PerkDefs.NggHMiscChampion, 6);
		}

		if (("onSetup" in data) && typeof data.onSetup == "function") data.onSetup.call(this);
	}

	function buildAttributes( _tag = null, _attrs = null )
	{
		local a = this.onChangeAttributes();

		if (_attrs != null)
		{
			a.Hitpoints[0] += _attrs.Hitpoints[0];
			a.Hitpoints[1] += _attrs.Hitpoints[1];
			a.Bravery[0] += _attrs.Bravery[0];
			a.Bravery[1] += _attrs.Bravery[1];
			a.Stamina[0] += _attrs.Stamina[0];
			a.Stamina[1] += _attrs.Stamina[1];
			a.MeleeSkill[0] += _attrs.MeleeSkill[0];
			a.MeleeSkill[1] += _attrs.MeleeSkill[1];
			a.MeleeDefense[0] += _attrs.MeleeDefense[0];
			a.MeleeDefense[1] += _attrs.MeleeDefense[1];
			a.RangedSkill[0] += _attrs.RangedSkill[0];
			a.RangedSkill[1] += _attrs.RangedSkill[1];
			a.RangedDefense[0] += _attrs.RangedDefense[0];
			a.RangedDefense[1] += _attrs.RangedDefense[1];
			a.Initiative[0] += _attrs.Initiative[0];
			a.Initiative[1] += _attrs.Initiative[1];
		}

		local b = this.onBuildAttributes(this.getContainer().getActor().getBaseProperties());
		local Hitpoints1 = ::Math.rand(a.Hitpoints[0] - 2, a.Hitpoints[1] + 2);
		local Bravery1 = ::Math.rand(a.Bravery[0] - 2, a.Bravery[1] + 2);
		local Stamina1 = ::Math.rand(a.Stamina[0] - 10, a.Stamina[1] + 5);
		local MeleeSkill1 = ::Math.rand(a.MeleeSkill[0] - 2, a.MeleeSkill[1] + 2);
		local RangedSkill1 = ::Math.rand(a.RangedSkill[0] - 2, a.RangedSkill[1] + 2);
		local MeleeDefense1 = ::Math.rand(a.MeleeDefense[0] - 2, a.MeleeDefense[1] + 2);
		local RangedDefense1 = ::Math.rand(a.RangedDefense[0] - 2, a.RangedDefense[1] + 2);
		local Initiative1 = ::Math.rand(a.Initiative[0] - 10, a.Initiative[1] + 5);
		
		local Hitpoints2 = ::Math.rand(a.Hitpoints[0] - 2, a.Hitpoints[1] + 2);
		local Bravery2 = ::Math.rand(a.Bravery[0] - 2, a.Bravery[1] + 2);
		local Stamina2 = ::Math.rand(a.Stamina[0] - 10, a.Stamina[1] + 5);
		local MeleeSkill2 = ::Math.rand(a.MeleeSkill[0] - 2,  a.MeleeSkill[1] + 2);
		local RangedSkill2 = ::Math.rand(a.RangedSkill[0] - 2, a.RangedSkill[1] + 2);
		local MeleeDefense2 = ::Math.rand(a.MeleeDefense[0] - 2, a.MeleeDefense[1] + 2);
		local RangedDefense2 = ::Math.rand(a.RangedDefense[0] - 2, a.RangedDefense[1] + 2);
		local Initiative2 = ::Math.rand(a.Initiative[0] - 10, a.Initiative[1] + 5);
		
		local HitpointsAvg = ::Math.round((Hitpoints1 + Hitpoints2) / 2);
		local BraveryAvg = ::Math.round((Bravery1 + Bravery2) / 2);
		local StaminaAvg = ::Math.round((Stamina1 + Stamina2) / 2);
		local MeleeSkillAvg = ::Math.round((MeleeSkill1 + MeleeSkill2) / 2);
		local RangedSkillAvg = ::Math.round((RangedSkill1 + RangedSkill2) / 2);
		local MeleeDefenseAvg = ::Math.round((MeleeDefense1 + MeleeDefense2) / 2);
		local RangedDefenseAvg = ::Math.round((RangedDefense1 + RangedDefense2) / 2);
		local InitiativeAvg = ::Math.round((Initiative1 + Initiative2) / 2);
		
		b.Hitpoints += HitpointsAvg;
		b.Bravery += BraveryAvg;
		b.Stamina += StaminaAvg;
		b.MeleeSkill += MeleeSkillAvg;
		b.RangedSkill += RangedSkillAvg;
		b.MeleeDefense += MeleeDefenseAvg;
		b.RangedDefense += RangedDefenseAvg;
		b.Initiative += InitiativeAvg;
		
		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.getContainer().getActor().setHitpoints(b.Hitpoints);

		this.addTraits();
		return array(8, 50);
	}
	

/////////////////////////////////////////////////////////
	
	function TypeToInfo( _entity , _returnViable = false )
	{	
		local _type = _entity.getType();
		
		if (_returnViable)
			return ::Const.CharmedUnits.getRequirements(_type, _entity.getFlags().has("human"));

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
};

::Const.CharmedUtilities.BackgroundTypeToCopy <- [
	"Crusader",
	"Combat",
	"Druid",
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
