this.nggh_mod_charmed_background <- ::inherit("scripts/skills/backgrounds/character_background", {
	m = {
		TempData = null,
		
		IsOrc = false,
		IsGoblin = false,
		
		PerkGroupMultipliers = [],
		AdditionalPerks = null,
		AttMods = null,
		Skills = null,
	},

	function isOrc()
	{
		return this.m.IsOrc;
	}

	function isGoblin()
	{
		return this.m.IsGoblin;
	}
	
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.charmed";
		this.m.BackgroundDescription = "A victim who has fallen for your wicked charm, now is no less than a slave for the mistress's desire.";
		this.m.HiringCost = 0;
		this.m.DailyCost = 0;
		this.m.Order = -1;
		this.m.Excluded = [
			"trait.dastard",
			"trait.insecure",
			"trait.disloyal",
			"trait.greedy",
			"trait.craven",
			"trait.fainthearted",
		];
		
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Hairs = null;
		this.m.HairColors = null;
		this.m.Beards = null;
		this.m.BeardChance = 0;
		this.m.Ethnicity = 0
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.NeutralMin;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.NeutralMax;
		this.m.CustomPerkTree = null;
	}

	function onChangeAttributes()
	{
		if (this.m.AttMods == null || ::Nggh_MagicConcept.IsOPMode)
		{
			return ::Const.DefaultChangeAttributes;
		}

		return this.m.AttMods;
	}

	function onBuildDescription()
	{
		return this.m.BackgroundDescription;
	}

	function onAdded()
	{
		if (this.isOrc() || this.isGoblin())
		{
			this.addBackgroundType(::Const.BackgroundType.Combat);
			this.m.AlignmentMin = ::Const.LegendMod.Alignment.Cruel;
			this.m.AlignmentMax = ::Const.LegendMod.Alignment.Merciless;
		}

		if (this.isGoblin())
		{
			this.m.Titles = ::Const.Strings.GoblinTitles;
		}

		if (this.m.Skills != null && this.m.Skills.len() != 0)
		{
			foreach ( script in this.m.Skills )
			{
				if (script.len() == 0)
				{
					continue;
				}

				local skill = ::new("scripts/skills/" + script);
				skill.m.IsSerialized = false;
				this.getContainer().add(skill);
			}
		}
		
		local type = this.getContainer().getActor().getFlags().getAsInt("Type");
		
		if (type > 0)
		{
			this.m.AttMods = ::Const.CharmedUnits.getStatsModifiers(type);
		}
		
		this.character_background.onAdded();
	}

	function setTempData( _data )
	{
		this.m.TempData = ::Const.CharmedUnits.addAdditionalData(_data);
		this.processTempData();
	}

	function setTempDataByType( _type )
	{
		this.setTempData({
			Type = _type,
			IsExperienced = true,
			Entity = null
		});
	}

	function processTempData()
	{
		this.m.IsOrc = ::Const.Orc.Variants.find(this.m.TempData.Type) != null;
		this.m.IsGoblin = ::Const.Goblin.Variants.find(this.m.TempData.Type) != null;
		this.m.AttMods = ::Const.CharmedUnits.getStatsModifiers(this.m.TempData.Type);
		this.m.Skills = ::Const.CharmedUnits.getSpecialSkills(this.m.TempData.Type);
		this.m.Name = "Charmed " + ::Const.Strings.EntityName[this.m.TempData.Type];
		this.m.Icon = "ui/backgrounds/" + ::Const.CharmedUnits.getBackgroundIcon(this.m.TempData.Type);
		::Const.CharmedUtilities.processingCharmedBackground(this.m.TempData, this);
	}
	
	function setup( _isFromScenario = true )
	{
		if (this.isOrc())
		{
			this.m.ExcludedTalents.extend([
				::Const.Attributes.Initiative,
				::Const.Attributes.RangedSkill,
				::Const.Attributes.RangedDefense
			]);
		}

		if (this.isGoblin())
		{
			this.m.ExcludedTalents.extend([
				::Const.Attributes.Hitpoints,
				::Const.Attributes.Fatigue,
				::Const.Attributes.Bravery
			]);
		}

		local actor = this.getContainer().getActor();
		actor.m.Background = this;
		actor.m.StarWeights = this.buildAttributes(null, null);
		local attributes = this.buildPerkTree();
		this.setAppearance();
		
		if (this.m.AdditionalPerks != null)
		{
			foreach ( _array in this.m.AdditionalPerks )
			{
				this.addPerkGroup(_array);
			}
		}

		if (this.m.Names.len() != 0)
		{
			actor.setName(::MSU.Array.rand(this.m.Names));
		}

		if (!_isFromScenario)
		{
			actor.setScenarioValues(this.m.TempData.Type, this.m.TempData.IsMiniboss, true, this.m.Names.len() == 0);
		}

		this.addBonusAttributes(attributes);
		this.onAfterSetUp();
		this.onAddEquipment();
	}

	function onAfterSetUp()
	{
		if (!("Perks" in this.m.TempData) || this.m.TempData.Perks == null)
		{
			return;
		}

		this.m.TempData.Perks.extend(this.getContainer().getActor().getSignaturePerks());

		foreach (i, Const in this.m.TempData.Perks )
		{
			::World.Assets.getOrigin().addScenarioPerk(this, ::Const.Perks.PerkDefs[Const], i);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		
		if (this.m.TempData != null && ("Items" in this.m.TempData) && this.m.TempData.Items != null)
		{
			this.m.TempData.Items.transferTo(items);
		}

		if (this.m.TempData.Type == ::Const.EntityType.GoblinWolfrider)
		{
			::World.Assets.getOrigin().addScenarioPerk(this, ::Const.Perks.PerkDefs.NggHGoblinMountTraining, 1);
			items.equip(::new("scripts/items/accessory/wolf_item"));
		}
		
		if (!("IsExperienced" in this.m.TempData))
		{
			return;
		}
		
		local r = this.m.TempData.IsExperienced ? ::Math.rand(2, 4) : 1;

		if (r == 1)
		{
			r += this.calculateAdditionalRecruitmentLevels();
		}

		if (::World.getTime().Days >= 150)
		{
			r += 1;
		}

		r = ::Math.min(7, r);
		this.getContainer().getActor().m.PerkPoints = r - 1;
		this.getContainer().getActor().m.Level = r;
		this.getContainer().getActor().m.LevelUps = r - 1;
		
		if (r > 1)
		{
			this.getContainer().getActor().m.XP = ::Const.LevelXP[r - 1];
		}
	}
	
	function setAppearance()
	{
		local actor = this.getContainer().getActor();
		local data = this.m.TempData;
		local entity = this.m.TempData.Entity;
		local b = actor.m.BaseProperties;

		if (entity != null && data != null && ("Appearance" in data) && data.Appearance != null && typeof data.Appearance == "array")
		{
			::logInfo("Identifying charmed target: " + ::Const.Strings.EntityName[entity.getType()]);
			::logInfo("Copying sprites to a new charmed slave container...");
			actor.copySpritesFrom(entity, data.Appearance);
			
			switch (data.Type)
			{
			case ::Const.EntityType.Spider:
			case ::Const.EntityType.LegendRedbackSpider:
				actor.setSize(entity.m.Size);
				if (!::Nggh_MagicConcept.IsOPMode && data.Type == ::Const.EntityType.LegendRedbackSpider)
				{
					b.ArmorMax[0] = 160;
					b.ArmorMax[1] = 160;
					b.Armor[0] = ::Math.floor(b.Armor[0] / 3 * 2);
					b.Armor[1] = ::Math.floor(b.Armor[1] / 3 * 2);
				}
				break;

			case ::Const.EntityType.Direwolf:
				if (entity.getSprite("head_frenzy").HasBrush)
				{
					local head_frenzy = actor.getSprite("head_frenzy");
					head_frenzy.setBrush(actor.getSprite("head").getBrush().Name + "_frenzy");
					actor.getFlags().add("frenzy");
				}
				else
				{
					this.addPerk(::Const.Perks.PerkDefs.NggHWolfRabies, 6);
				}
				break;

			case ::Const.EntityType.Hyena:
				if (entity.m.IsHigh)
				{
					actor.getFlags().add("frenzy");
				}
				else
				{
					this.addPerk(::Const.Perks.PerkDefs.NggHWolfRabies, 6);
				}
				break;

			case ::Const.EntityType.Ghoul:
			case ::Const.EntityType.LegendSkinGhoul:
				actor.setVariant(entity.m.Head);
				actor.getFlags().set("has_eaten", true);
				actor.getFlags().set("Type", data.Type);
				local n = ::Math.max(0, entity.getSize() - 1);
				for (local i = 0; i < n; ++i)
				{
					actor.grow(true);
				}
				break;

			case ::Const.EntityType.Serpent:
				actor.setVariant(entity.m.Variant);
				break;

			case ::Const.EntityType.UnholdFrost:
			case ::Const.EntityType.BarbarianUnholdFrost:
				actor.getFlags().add("regen_armor");
				actor.setVariant(1);
				break;

			case ::Const.EntityType.Unhold:
			case ::Const.EntityType.BarbarianUnhold:
				actor.setVariant(2);
				break;

			case ::Const.EntityType.UnholdBog:
				actor.setVariant(3);
				break;

			case ::Const.EntityType.LegendRockUnhold:
				actor.getFlags().add("regen_armor")
				actor.setVariant(4);
				break;

			case ::Const.EntityType.LegendBear:
				actor.getFlags().add("regen_armor")
				actor.setVariant(5);
				break;
			}

			if (this.isOrc())
			{
				if (actor.getSprite("body_rage").HasBrush)
				{
					actor.updateRageVisuals(0);
				}
				else 
				{
				    actor.getSprite("body_rage").Visible = false;
				}
			}
			
			actor.updateVariant();
			actor.onUpdateInjuryLayer();
		}
	}
	
	function buildPerkTree()
	{
		if (this.isOrc() || this.isGoblin())
		{
			return this.character_background.buildPerkTree();
		}

		if (this.m.PerkTree != null)
		{
			return ::Const.DefaultChangeAttributes;
		}
		
		if (this.m.TempData != null)
		{
			this.m.CustomPerkTree = clone this.m.TempData.PerkTree;
			local isHumaniod = ::Const.HumanoidBeast.find(this.m.TempData.Type) != null;
			local hasAoE = ::Const.BeastHasAoE.find(this.m.TempData.Type) != null;
			local removeNimble = ::Const.BeastNeverHasNimble.find(this.m.TempData.Type) != null;
			this.m.CustomPerkTree = ::Nggh_MagicConcept.PerkTreeBuilder.fillWithRandomPerk(this.m.CustomPerkTree, this.getContainer(), isHumaniod, hasAoE, removeNimble);
		}
		
		local origin = this.World.Assets.getOrigin();
		local pT = this.Const.Perks.BuildCustomPerkTree(this.m.CustomPerkTree);
		this.m.PerkTree = pT.Tree;
		this.m.PerkTreeMap = pT.Map;

		if (origin != null)
		{
			this.World.Assets.getOrigin().onBuildPerkTree(this);
		}

		return ::Const.DefaultChangeAttributes;
	}

	function addBonusAttributes( _attr )
	{
		local b = this.getContainer().getActor().getBaseProperties();
		b.Hitpoints += ::Math.rand(_attr.Hitpoints[0], _attr.Hitpoints[1]);
		b.Bravery += ::Math.rand(_attr.Bravery[0], _attr.Bravery[1]);
		b.Stamina += ::Math.rand(_attr.Stamina[0], _attr.Stamina[1]);
		b.MeleeSkill += ::Math.rand(_attr.MeleeSkill[0], _attr.MeleeSkill[1]);
		b.RangedSkill += ::Math.rand(_attr.RangedSkill[0], _attr.RangedSkill[1]);
		b.MeleeDefense += ::Math.rand(_attr.MeleeDefense[0], _attr.MeleeDefense[1]);
		b.RangedDefense += ::Math.rand(_attr.RangedDefense[0], _attr.RangedDefense[1]);
		b.Initiative += ::Math.rand(_attr.Initiative[0], _attr.Initiative[1]);
		this.getContainer().getActor().m.CurrentProperties = clone b;
	}

	function addTraits()
	{
		local maxTraits = 2;
		local traits = [this];

		if (this.m.IsGuaranteed.len() > 0)
		{
			maxTraits = maxTraits - this.m.IsGuaranteed.len();
			foreach(trait in this.m.IsGuaranteed)
			{
				traits.push(::new("scripts/skills/traits/" + trait));
			}
		}

		this.m.Excluded.extend(this.getContainer().getActor().getExcludedTraits());
		this.getContainer().getActor().pickTraits(traits, maxTraits);

		for( local i = 1; i < traits.len(); i = ++i )
		{
			this.getContainer().add(traits[i]);

			if (traits[i].getContainer() != null)
			{
				traits[i].addTitle();
			}
		}
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

		local b = this.getContainer().getActor().getBaseProperties();
		
		if (this.m.TempData != null && ("Stats" in this.m.TempData) && this.m.TempData.Stats != null)
		{
			b.setValues(this.m.TempData.Stats);
		}

		if (this.isGoblin())
		{
			b.ActionPoints = 9;
			b.FatigueRecoveryRate = ::Nggh_MagicConcept.IsOPMode ? b.FatigueRecoveryRate : ::Math.min(18, b.FatigueRecoveryRate);
		}

		if (!Nggh_MagicConcept.IsOPMode && !this.getContainer().hasSkill("trait.player"))
		{
			if (b.ArmorMax[0] >= 500 || b.ArmorMax[1] >= 500)
			{
				b.ArmorMax[0] = ::Math.floor(b.ArmorMax[0] * 0.5);
				b.ArmorMax[1] = ::Math.floor(b.ArmorMax[1] * 0.5);
				b.Armor[0] = ::Math.floor(b.Armor[0] * 0.5);
				b.Armor[1] = ::Math.floor(b.Armor[1] * 0.5);
			}
			else if (b.ArmorMax[0] >= 250 || b.ArmorMax[1] >= 250)
			{
				b.ArmorMax[0] = ::Math.floor(b.ArmorMax[0] * 0.75);
				b.ArmorMax[1] = ::Math.floor(b.ArmorMax[1] * 0.75);
				b.Armor[0] = ::Math.floor(b.Armor[0] * 0.75);
				b.Armor[1] = ::Math.floor(b.Armor[1] * 0.75);
			}
		}
		
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
		
		this.addTraits();
		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.getContainer().getActor().setHitpoints(b.Hitpoints);
		return array(8, 50);
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
		];

		if (this.isGoblin())
		{
			if (::Is_PTR_Exist)
			{
				ret.push({
					id = 9,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Reduce AP cost of all melee attack skills by [color=" + ::Const.UI.Color.PositiveValue + "]1[/color] "
				})
			}

			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Receive [color=" + ::Const.UI.Color.NegativeValue + "]penalties[/color] if the total penalty to Maximum Fatigue from body and head armor above " + ::Const.Goblin.ArmorFatigueThreshold
			});
		}
		
		if (this.getContainer() == null || this.getContainer().getActor() == null)
		{
			return ret;
		}

		local actor = this.getContainer().getActor();

		if (actor.getFlags().has("has_eaten") && actor.getSize() > 1)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/asset_food.png",
				text = "Needs to eat a [color=" + ::Const.UI.Color.NegativeValue + "]corpse[/color] every battle or will shrink in size"
			})
		}
		
		ret.extend(::Const.CharmedUtilities.getTooltip(actor));
		ret.extend(this.getAttributesTooltip());
		return ret;
	}

	function onCombatStarted()
	{
	}
	
	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeString(this.m.ID);
		_out.writeString(this.m.Icon);
		_out.writeString(this.m.Name);
		_out.writeBool(this.m.IsOrc);
		_out.writeBool(this.m.IsGoblin);
		_out.writeF32(this.m.Modifiers.Ammo);
		_out.writeF32(this.m.Modifiers.ArmorParts);
		_out.writeF32(this.m.Modifiers.Meds);
		_out.writeF32(this.m.Modifiers.Stash);
		_out.writeF32(this.m.Modifiers.Healing);
		_out.writeF32(this.m.Modifiers.Injury);
		_out.writeF32(this.m.Modifiers.Repair);
		_out.writeF32(this.m.Modifiers.Salvage);
		_out.writeF32(this.m.Modifiers.Crafting);
		_out.writeF32(this.m.Modifiers.Barter);
		_out.writeF32(this.m.Modifiers.ToolConsumption);
		_out.writeF32(this.m.Modifiers.MedConsumption);
		_out.writeF32(this.m.Modifiers.Hunting);
		_out.writeF32(this.m.Modifiers.Fletching);
		_out.writeF32(this.m.Modifiers.Scout);
		_out.writeF32(this.m.Modifiers.Gathering);
		_out.writeF32(this.m.Modifiers.Training);
		_out.writeF32(this.m.Modifiers.Enchanting);
		
		_out.writeU8(this.m.Skills.len());
		for( local i = 0; i != this.m.Skills.len(); ++i )
		{
			_out.writeString(this.m.Skills[i]);
		}

		foreach ( _mod in this.m.Modifiers.Terrain )
		{
			_out.writeF32(_mod);
		}
	}

	function onDeserialize( _in )
	{
		this.character_background.onDeserialize(_in);
		this.m.ID = _in.readString();
		this.m.Icon = _in.readString();
		this.m.Name = _in.readString();
		this.m.IsOrc = _in.readBool();
		this.m.IsGoblin = _in.readBool();
		this.m.Modifiers.Ammo = _in.readF32();
		this.m.Modifiers.ArmorParts = _in.readF32();
		this.m.Modifiers.Meds = _in.readF32();
		this.m.Modifiers.Stash = _in.readF32();
		this.m.Modifiers.Healing = _in.readF32();
		this.m.Modifiers.Injury = _in.readF32();
		this.m.Modifiers.Repair = _in.readF32();
		this.m.Modifiers.Salvage = _in.readF32();
		this.m.Modifiers.Crafting = _in.readF32();
		this.m.Modifiers.Barter = _in.readF32();
		this.m.Modifiers.ToolConsumption = _in.readF32();
		this.m.Modifiers.MedConsumption = _in.readF32();
		this.m.Modifiers.Hunting = _in.readF32();
		this.m.Modifiers.Fletching = _in.readF32();
		this.m.Modifiers.Scout = _in.readF32();
		this.m.Modifiers.Gathering = _in.readF32();
		this.m.Modifiers.Training = _in.readF32();
		this.m.Modifiers.Enchanting = _in.readF32();
		
		local numSkills = _in.readU8();
		this.m.Skills = array(numSkills, "");

		for( local i = 0; i != numSkills; ++i )
		{
			this.m.Skills[i] = _in.readString();
		}

		for( local i = 0; i != this.m.Modifiers.Terrain.len(); ++i )
		{
			this.m.Modifiers.Terrain[i] = _in.readF32();
		}
	}

});

