this.nggh_mod_charmed_human_background <- ::inherit("scripts/skills/backgrounds/character_background", {
	m = {
		TempData = null,

		PerkGroupMultipliers = [],
		AdditionalPerks = null,
		AttMods = null,
		Skills = null,
	},
	
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.charmed_human";
		this.m.Name = "Charmed Human"
		this.m.Icon = "ui/backgrounds/background_charmed_17.png";
		this.m.BackgroundDescription = "Human fools who fell for your charm. They will gladly offer their lives to protect you.";
		this.m.HiringCost = 0;
		this.m.DailyCost = 0;
		this.m.Order = -1;
		this.m.Excluded = [
			"trait.dastard",
			"trait.gluttonous",
			"trait.insecure",
			"trait.disloyal",
			"trait.hesitant",
			"trait.greedy",
			"trait.craven",
			"trait.fainthearted",
			"trait.loyal"
		];
		
		this.m.Faces = ::Const.Faces.AllMale;
		this.m.Hairs = ::Const.Hair.UntidyMale;
		this.m.HairColors = ::Const.HairColors.All;
		this.m.Beards = ::Const.Beards.Untidy;
		this.m.Bodies = ::Const.Bodies.Skinny;
		this.m.BeardChance = 100;
		this.m.Names = ::Const.Strings.CharacterNames;
		this.m.AlignmentMin = ::Const.LegendMod.Alignment.NeutralMin;
		this.m.AlignmentMax = ::Const.LegendMod.Alignment.NeutralMax;
		this.m.Modifiers.Gathering = ::Const.LegendMod.ResourceModifiers.Gather[1];
		this.m.Modifiers.Barter = ::Const.LegendMod.ResourceModifiers.Barter[2];
		this.m.CustomPerkTree = ::Const.Perks.DefaultCustomPerkTree;
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
		if (this.m.Skills != null && this.m.Skills.len() != 0)
		{
			foreach ( script in this.m.Skills )
			{
				if (script.len() == 0)
				{
					continue;
				}

				local skill = this.new("scripts/skills/" + script);
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
		this.m.AttMods = ::Const.CharmedUnits.getStatsModifiers(this.m.TempData.Type);
		this.m.Skills = ::Const.CharmedUnits.getSpecialSkills(this.m.TempData.Type);
		this.m.Name = "Charmed " + ::Const.Strings.EntityName[this.m.TempData.Type];
		this.m.Icon = "ui/backgrounds/" + ::Const.CharmedUnits.getBackgroundIcon(this.m.TempData.Type);
		::Const.CharmedUtilities.processingCharmedBackground(this.m.TempData, this);
	}

	function setup( _nothing = null )
	{
		local actor = this.getContainer().getActor();
		actor.m.Background = this;
		actor.m.StarWeights = this.buildAttributes(null, null);
		local attributes = this.buildPerkTree();
		this.onfillTalents();
		this.setAppearance();
		
		if (this.m.AdditionalPerks != null)
		{
			foreach ( _array in this.m.AdditionalPerks )
			{
				this.addPerkGroup(_array);
			}
		}

		if (this.m.TempData.IsMiniboss)
		{
			this.getContainer().add(::new("scripts/skills/racial/champion_racial"));
		}
		else if (::Math.rand(1, 100) <= 1)
		{
			this.addPerk(::Const.Perks.PerkDefs.NggHMiscChampion, 6);
		}

		if (::Math.rand(1, 100) <= 5)
		{
			this.addPerk(::Const.Perks.PerkDefs.NggHMiscFairGame, 2);
		}

		if (this.m.Names.len() != 0)
		{
			actor.setName(::MSU.Array.rand(this.m.Names));
		}

		this.getContainer().add(::new("scripts/skills/traits/intensive_training_trait"));
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

		foreach (i, Const in this.m.TempData.Perks )
		{
			::World.Assets.getOrigin().addScenarioPerk(this, ::Const.Perks.PerkDefs[Const], i);
		}
	}

	function onfillTalents()
	{
		local type = this.m.TempData.Type;
		local actor = this.getContainer().getActor();
		actor.fillTalentValues(3);

		switch(type)
		{
		case ::Const.EntityType.Swordmaster:
		case ::Const.EntityType.DesertDevil:
			actor.m.Talents[::Const.Attributes.MeleeSkill] = 3;
			break;

		case ::Const.EntityType.MasterArcher:
		case ::Const.EntityType.DesertStalker:
			actor.m.Talents[::Const.Attributes.RangedSkill] = 3;
			break;

		case ::Const.EntityType.Executioner:
		case ::Const.EntityType.HedgeKnight:
			actor.m.Talents[::Const.Attributes.Fatigue] = 3;
			break;
		}

		actor.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);
		actor.getFlags().set("Type", type);
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		
		if (this.m.TempData != null && ("Items" in this.m.TempData) && this.m.TempData.Items != null)
		{
			this.m.TempData.Items.transferTo(items);
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

		if (entity != null && data != null && ("Appearance" in data) && data.Appearance != null && typeof data.Appearance == "array")
		{
			::logInfo("Identifying charmed target: " + ::Const.Strings.EntityName[entity.getType()]);
			::logInfo("Copying sprites to a new charmed slave container...");
			actor.copySpritesFrom(entity, data.Appearance);
			actor.setDirty(true);

			if (entity.m.Surcoat != null)
			{
				actor.m.Surcoat = entity.m.Surcoat;
			}
			
			if (entity.getEthnicity() != 0)
			{
				this.m.Ethnicity = entity.getEthnicity();
				actor.m.Ethnicity = entity.getEthnicity();
			}

			actor.onUpdateInjuryLayer();
		}
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

		if (!::Nggh_MagicConcept.IsOPMode)
		{
			b.ActionPoints = 9;
			b.FatigueRecoveryRate = ::Math.min(18, b.FatigueRecoveryRate);
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

		if (this.getContainer() == null || this.getContainer().getActor() == null)
		{
			return ret;
		}
		
		ret.extend(::Const.CharmedUtilities.getTooltip(this.getContainer().getActor()));
		ret.extend(this.getAttributesTooltip());
		return ret;
	}
	
	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeString(this.m.ID);
		_out.writeString(this.m.Icon);
		_out.writeString(this.m.Name);
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

		for( local i = 0; i != ::Const.CharmedUtilities.BackgroundTypeToCopy.len(); ++i )
		{
			local a = this.isBackgroundType(::Const.BackgroundType[::Const.CharmedUtilities.BackgroundTypeToCopy[i]]);
			_out.writeBool(a);
		}

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

		for( local i = 0; i != ::Const.CharmedUtilities.BackgroundTypeToCopy.len(); ++i )
		{
			if (_in.readBool())
			{
				this.addBackgroundType(::Const.BackgroundType[::Const.CharmedUtilities.BackgroundTypeToCopy[i]]);
			}
		}
	
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

