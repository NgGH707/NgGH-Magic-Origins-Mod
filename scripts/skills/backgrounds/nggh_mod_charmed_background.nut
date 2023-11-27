this.nggh_mod_charmed_background <- ::inherit("scripts/skills/backgrounds/character_background", {
	m = {
		PerkGroupMultipliers = [],
		HasFixedName = false,
		IsOnDeserializing = false,
		IsSavingModifier = false,
		IsSavingBackgroundType = false,

		TempData = null,
		CharmID = null,
		AttMods = null,
		Race = 0,
	},

	function isHuman()
	{
		return this.m.Race == 0;
	}

	function isGoblin()
	{
		return this.m.Race == 1;
	}

	function isOrc()
	{
		return this.m.Race == 2;
	}

	function isBeast()
	{
		return this.m.Race == 3;
	}

	function onBuildDescription()
	{
		return this.m.BackgroundDescription;
	}

	function getCharmDataByID( _id )
	{
		return ::Const.CharmedUnits.getData(_id);
	}

	function setTempDataByType( _type, _isElite = false )
	{
		local ret = {Type = _type, Entity = null, IsHuman = false};

		if (_isElite) ret.IsMiniboss <- true;

		this.setTempData(ret);
	}

	function setTempData( _data )
	{
		this.m.CharmID = _data.Type;
		this.m.TempData = ::Const.CharmedUnits.addAdditionalData(_data);
		::Const.CharmedUtilities.processingCharmedBackground(this.m.TempData, this);
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
			return ::Const.DefaultChangeAttributes;

		return this.m.AttMods;
	}

	function onUpdate( _properties )
	{
		local data = this.getCharmDataByID(this.m.CharmID);

		this.character_background.onUpdate(_properties);

		if (data != null && ("onUpdate" in data) && typeof data.onUpdate == "function") data.onUpdate.call(this, _properties);
	}

	function onAdded()
	{
		local data = this.getCharmDataByID(this.m.CharmID);

		if (this.isOrc() || this.isGoblin())
		{
			this.m.AlignmentMin = ::Const.LegendMod.Alignment.Cruel;
			this.m.AlignmentMax = ::Const.LegendMod.Alignment.Merciless;
		}

		if (data != null && ("Skills" in data) && data.Skills != null && data.Skills.len() != 0)
		{
			foreach ( script in data.Skills )
			{
				if (script.len() == 0)
					continue;

				local skill = ::new("scripts/skills/" + script);
				skill.m.IsSerialized = false;
				this.getContainer().add(skill);
			}
		}
		
		if (data != null) this.m.AttMods = ::nggh_deepCopy(data.StatMod);

		if (!this.isHuman()) this.addBackgroundType(::Const.BackgroundType.Combat);

		if (!this.m.IsSavingModifier && data != null && ("Custom" in data) && typeof data.Custom == "table" && ("BgModifiers" in data.Custom) && data.Custom.BgModifiers != null) this.m.Modifiers = ::nggh_deepCopy(data.Custom.BgModifiers);

		if (data != null && ("onAdded" in data) && typeof data.onAdded == "function") data.onAdded.call(this);

		this.character_background.onAdded();
	}

	function onAddEquipment()
	{
		local data = this.getCharmDataByID(this.m.CharmID);
		local items = this.getContainer().getActor().getItems();
		
		if (this.m.TempData != null && ("Items" in this.m.TempData) && this.m.TempData.Items != null) this.m.TempData.Items.transferTo(items);
		
		if (data != null && ("onAddEquipment" in data) && typeof data.onAddEquipment == "function") data.onAddEquipment.call(this);
	}

	function setAppearance()
	{
		local actor = this.getContainer().getActor();
		local data = this.getCharmDataByID(this.m.CharmID);
		local entity = this.m.TempData.Entity;

		if (this.m.HasFixedName)
		{
			actor.setName(this.m.Names[0]);

			if (this.m.Titles.len() != 0)
				actor.setTitle(this.m.Titles[0]);
		}

		if (entity != null && this.m.TempData != null && ("Appearance" in this.m.TempData) && this.m.TempData.Appearance != null && typeof this.m.TempData.Appearance == "array")
		{
			::logInfo("Identifying charmed target: " + ::Const.Strings.EntityName[this.m.CharmID]);
			::logInfo("Copying sprites to a new charmed slave container...");
			actor.copySpritesFrom(entity, this.m.TempData.Appearance);

			if (data != null && ("onSetAppearance" in data) && typeof data.onSetAppearance == "function")
				data.onSetAppearance.call(this, actor, entity);

			if (this.isOrc())
			{
				if (actor.getSprite("body_rage").HasBrush)
					actor.updateRageVisuals(0);
				else 
				    actor.getSprite("body_rage").Visible = false;
			}
			
			if (this.isHuman())
			{
				if (entity.m.Surcoat != null)
					actor.m.Surcoat = entity.m.Surcoat;
				
				if (entity.getEthnicity() != 0)
				{
					this.m.Ethnicity = entity.getEthnicity();
					actor.m.Ethnicity = entity.getEthnicity();
				}
			}
			else
			{
				actor.updateVariant();
			}
			
			actor.onUpdateInjuryLayer();
		}

		if (this.m.HasFixedName) return;

		if (this.m.Names.len() != 0)
		{
			local name = ::MSU.Array.rand(this.m.Names);

			if (this.m.LastNames != 0) 
				name += " " +  ::MSU.Array.rand(this.m.LastNames);

			actor.setName(name);
		}

		if (actor.getTitle().len() == 0 && this.m.Titles.len() != 0)
			actor.setTitle(::MSU.Array.rand(this.m.Titles));
	}

	function pickCurrentLevel()
	{
		local r = ::Math.rand(1, 3);

		if (r == 1) 
			r += this.calculateAdditionalRecruitmentLevels();

		if (::World.getTime().Days >= 150) 
			r += 1;

		r = ::Math.min(7, r);
		this.getContainer().getActor().m.PerkPoints = r - 1;
		this.getContainer().getActor().m.Level = r;
		this.getContainer().getActor().m.LevelUps = r - 1;
		
		if (r > 1)
			this.getContainer().getActor().m.XP = ::Const.LevelXP[r - 1];
	}

	function onBeforeBuildPerkTree()
	{
		local perkTree = ::Const.CharmedUnits.getPerkTree(this.m.CharmID);

		if (perkTree != null)
		{
			switch (typeof perkTree)
			{
			case "array":
				this.m.CustomPerkTree = perkTree;
				break;

			case "table":
				this.m.PerkTreeDynamic = perkTree;
				break;
			}
		}

		if (this.m.PerkGroupMultipliers.len() == 0 && this.m.PerkTreeDynamic != null && ("WeightMultipliers" in this.m.PerkTreeDynamic))
		{
			this.m.PerkGroupMultipliers = this.m.PerkTreeDynamic.WeightMultipliers;
			delete this.m.PerkTreeDynamic.WeightMultipliers;
		}
		
		local data = this.getCharmDataByID(this.m.CharmID);

		if (data != null && ("onBeforeBuildPerkTree" in data) && typeof data.onBeforeBuildPerkTree == "function") data.onBeforeBuildPerkTree.call(this);
	}
	
	function buildPerkTree()
	{
		if (this.m.PerkTree != null)
			return ::Const.DefaultChangeAttributes;
		
		if (!this.isBeast())
		{
			if (!this.m.IsOnDeserializing && this.m.TempData != null) 
				this.onBeforeBuildPerkTree();
			
			local ret = this.character_background.buildPerkTree();
			
			if (!this.m.IsOnDeserializing) 
				this.onBuildPerkTree();

			return ret;
		}
		
		if (!this.m.IsOnDeserializing && this.m.TempData != null)
		{
			this.onBeforeBuildPerkTree();
			local isHumaniod = ::Const.HumanoidBeast.find(this.m.CharmID) != null;
			local hasAoE = ::Const.BeastHasAoE.find(this.m.CharmID) != null;
			local removeNimble = ::Const.BeastNeverHasNimble.find(this.m.CharmID) != null;
			this.m.CustomPerkTree = ::Nggh_MagicConcept.PerkTreeBuilder.fillWithRandomPerk(this.m.CustomPerkTree, this.getContainer(), isHumaniod, hasAoE, removeNimble);
		}

		local origin = this.World.Assets.getOrigin();
		local pT = this.Const.Perks.BuildCustomPerkTree(this.m.CustomPerkTree);
		this.m.PerkTree = pT.Tree;
		this.m.PerkTreeMap = pT.Map;

		if (origin != null) 
			this.World.Assets.getOrigin().onBuildPerkTree(this);

		if (!this.m.IsOnDeserializing) 
			this.onBuildPerkTree();

		return ::Const.DefaultChangeAttributes;
	}

	function onBuildPerkTree()
	{
		local actor = this.getContainer().getActor();
		local data = this.getCharmDataByID(this.m.CharmID);
		local perks = [];

		if (actor.getFlags().has("nggh_character")) perks.extend(actor.getSignaturePerks());

		if (data != null && ("Perks" in data) && typeof data.Perks == "array") perks.extend(data.Perks);

		this.addPerkGroup(::Const.Perks.NggH_SimpTree.Tree);

		foreach (i, Const in perks )
		{
			::World.Assets.getOrigin().addScenarioPerk(this, ::Const.Perks.PerkDefs[Const], i);
		}

		if (data != null && ("onBuildPerkTree" in data) && typeof data.onBuildPerkTree == "function") data.onBuildPerkTree.call(this);

		if (::Math.rand(1, 100) <= 5) this.addPerk(::Const.Perks.PerkDefs.NggHMiscFairGame, 2);
	}

	function onfillTalentsValues( _actor )
	{
		local data = this.getCharmDataByID(this.m.CharmID);

		if (this.isHuman())
		{
			if (_actor.m.Talents.len() == 0)
				_actor.m.Talents.resize(::Const.Attributes.COUNT, 0);

			_actor.fillTalentValues(3);

			if (data != null && ("onfillTalentsValues" in data) && typeof data.onfillTalentsValues == "function") data.onfillTalentsValues.call(this, _actor.getTalents());

			this.getContainer().add(::new("scripts/skills/traits/intensive_training_trait"));
			_actor.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);
			_actor.getFlags().set("Type", this.m.CharmID);
			return;
		}

		if (_actor.m.Talents.len() == 0)
			return;
		
		if (data != null && ("onfillTalentsValues" in data) && typeof data.onfillTalentsValues == "function") data.onfillTalentsValues.call(this, _actor.getTalents());
	}

	function onBuildAttributes( _properties )
	{
		local data = this.getCharmDataByID(this.m.CharmID);

		if (this.m.TempData != null && ("Stats" in this.m.TempData) && this.m.TempData.Stats != null)
			_properties.setValues(this.m.TempData.Stats);

		if (!::Nggh_MagicConcept.IsOPMode)
		{
			if (!this.getContainer().hasSkill("trait.player"))
			{
				if (_properties.ArmorMax[0] >= 500 || _properties.ArmorMax[1] >= 500)
				{
					_properties.ArmorMax[0] = ::Math.floor(_properties.ArmorMax[0] * 0.5);
					_properties.ArmorMax[1] = ::Math.floor(_properties.ArmorMax[1] * 0.5);
					_properties.Armor[0] = ::Math.floor(_properties.Armor[0] * 0.5);
					_properties.Armor[1] = ::Math.floor(_properties.Armor[1] * 0.5);
				}
				else if (_properties.ArmorMax[0] >= 250 || _properties.ArmorMax[1] >= 250)
				{
					_properties.ArmorMax[0] = ::Math.floor(_properties.ArmorMax[0] * 0.75);
					_properties.ArmorMax[1] = ::Math.floor(_properties.ArmorMax[1] * 0.75);
					_properties.Armor[0] = ::Math.floor(_properties.Armor[0] * 0.75);
					_properties.Armor[1] = ::Math.floor(_properties.Armor[1] * 0.75);
				}
			}
		}

		if (this.isGoblin() || this.isHuman())
		{
			_properties.ActionPoints = 9;
			_properties.FatigueRecoveryRate = ::Math.min(18, _properties.FatigueRecoveryRate);
		}

		if (data != null && ("onBuildAttributes" in data) && typeof data.onBuildAttributes == "function")
			data.onBuildAttributes.call(this, _properties);

		return _properties;
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

	function addTraits( _maxTraits = 2 )
	{
		local traits = [this];

		if (this.m.IsGuaranteed.len() > 0)
		{
			_maxTraits -= this.m.IsGuaranteed.len();

			foreach(trait in this.m.IsGuaranteed)
				traits.push(::new("scripts/skills/traits/" + trait));
		}

		if (this.getContainer().getActor().getFlags().has("nggh_character"))
			this.m.Excluded.extend(this.getContainer().getActor().getExcludedTraits());
			
		this.getContainer().getActor().pickTraits(traits, _maxTraits);

		for( local i = 1; i < traits.len(); ++i )
		{
			this.getContainer().add(traits[i]);

			if (traits[i].getContainer() != null)
				traits[i].addTitle();
		}
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
		
		if (this.getContainer() == null || this.getContainer().getActor() == null) return ret;

		local actor = this.getContainer().getActor();
		local data = this.getCharmDataByID(this.m.CharmID);

		if (data != null && ("addTooltip" in data) && typeof data.addTooltip == "function") data.addTooltip.call(this, ret);
		
		ret.extend(::Const.CharmedUtilities.getTooltip(actor));
		ret.extend(this.getAttributesTooltip());
		return ret;
	}
	
	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeString(this.m.ID);
		_out.writeString(this.m.Icon);
		_out.writeString(this.m.Name);
		_out.writeU32(this.m.CharmID);
		_out.writeU8(this.m.Race);
		_out.writeBool(this.m.IsSavingModifier);
		_out.writeBool(this.m.IsSavingBackgroundType);

		if (this.m.IsSavingModifier)
		{
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

			foreach ( _mod in this.m.Modifiers.Terrain )
			{
				_out.writeF32(_mod);
			}
		}

		if (this.m.IsSavingBackgroundType)
		{
			for( local i = 0; i != ::Const.CharmedUtilities.BackgroundTypeToCopy.len(); ++i )
			{
				_out.writeBool(this.isBackgroundType(::Const.BackgroundType[::Const.CharmedUtilities.BackgroundTypeToCopy[i]]));
			}
		}
	}

	function onDeserialize( _in )
	{
		this.m.IsOnDeserializing = true;
		this.character_background.onDeserialize(_in);
		this.m.ID = _in.readString();
		this.m.Icon = _in.readString();
		this.m.Name = _in.readString();
		this.m.CharmID = _in.readU32();
		this.m.Race = _in.readU8();
		this.m.IsSavingModifier = _in.readBool();
		this.m.IsSavingBackgroundType = _in.readBool();

		if (this.m.IsSavingModifier)
		{
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

			for( local i = 0; i != this.m.Modifiers.Terrain.len(); ++i )
			{
				this.m.Modifiers.Terrain[i] = _in.readF32();
			}
		}
		
		if (this.m.IsSavingBackgroundType)
		{
			for( local i = 0; i != ::Const.CharmedUtilities.BackgroundTypeToCopy.len(); ++i )
			{
				if (_in.readBool())
					this.addBackgroundType(::Const.BackgroundType[::Const.CharmedUtilities.BackgroundTypeToCopy[i]]);
			}
		}

		this.m.IsOnDeserializing = false;
	}

});

