this.charmed_goblin_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		Entity = null,
		Info = null,
		AttMods = null,
		Skills = null,
		Perks = null,
		IsWolfrider = false,
		AdditionalPerks = null,
	},
	
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.charmed_goblin";
		this.m.Name = "Charmed Goblin"
		this.m.Icon = "ui/backgrounds/background_charmed_40.png";
		this.m.Order = -1;
		this.m.BackgroundDescription = "Goblin slave who was enthralled by your charm. They will gladly offer their lives to protect you.";
		this.m.HiringCost = 0;
		this.m.DailyCost = 0;
		this.m.Excluded = [
			"trait.clubfooted",
			"trait.gluttonous",
			"trait.disloyal",
			"trait.cocky",
			"trait.superstitious",
			"trait.iron_lungs",
			"trait.greedy",
			"trait.huge",
			"trait.brute_trait",
			"trait.short_sighted_trait",
			"trait.spartan_trait"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue,
			this.Const.Attributes.Bravery
		];
		this.m.Faces = "bust_goblin_01_head_01";
		this.m.Bodies = "bust_goblin_01_body";
		this.m.Hairs = null;
		this.m.HairColors = null;
		this.m.Beards = null;
		this.m.BeardChance = 0;
		this.m.Names = this.Const.Strings.GoblinNames;
		this.m.Titles = this.Const.Strings.GoblinTitles;
		this.addBackgroundType(this.Const.BackgroundType.Combat);
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.Cruel;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.Merciless;
	}
	
	function transferInfo( _goblin , _info )
	{
		local type = _goblin.getType();

		this.m.Entity = _goblin;
		this.m.Info = this.Const.CharmedSlave.addMissingData(_info, this.m.Entity);
		this.m.AttMods = this.Const.CharmedSlave.getStatsModifiers(type);
		this.m.Perks = this.Const.CharmedSlave.getSpecialPerks(type);
		this.m.Skills = this.Const.CharmedSlave.getSpecialSkills(type);
		this.m.Name = "Charmed " + this.Const.Strings.EntityName[type];
		this.m.Icon = "ui/backgrounds/" + this.Const.CharmedSlave.getIconName(type);
		this.m.IsWolfrider = this.isKindOf(_goblin, "goblin_wolfrider");
		this.Const.HexenOrigin.CharmedSlave.processingCharmedBackground(this.m.Info, this);
	}
	
	function onAdded()
	{
		if (this.m.Skills != null && this.m.Skills.len() != 0)
		{
			foreach ( script in this.m.Skills )
			{
				if (script == "")
				{
					continue;
				}

				local s = this.new("scripts/skills/" + script);
				s.m.IsSerialized = false;
				this.getContainer().add(s);
			}
		}
		
		local index = this.getContainer().getActor().getFlags().getAsInt("bewitched");
		
		if (this.m.AttMods == null && index != 0)
		{
			this.m.AttMods = this.Const.CharmedSlave.getStatsModifiers(index);
		}
		
		this.character_background.onAdded();
	}
	
	function onSetUp()
	{
		this.getContainer().getActor().m.Background = this;
		this.getContainer().getActor().m.StarWeights = this.buildAttributes(null, null);
		this.getContainer().getActor().fillTalentValues();
		this.getContainer().getActor().fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		this.getContainer().add(this.new("scripts/skills/traits/intensive_training_trait"));
		local attributes = this.buildPerkTree();

		this.addPerk(this.Const.Perks.PerkDefs.BoondockBlade, 0);
		this.addPerk(this.Const.Perks.PerkDefs.GoblinWolfRider, 1);
		this.addPerk(this.Const.Perks.PerkDefs.GoblinMountedCharge, 2);
		this.addPerk(this.Const.Perks.PerkDefs.LegendHorseLiberty, 3);
		this.addPerk(this.Const.Perks.PerkDefs.GoblinMountedArchery, 5);

		this.setAppearance();

		if (this.m.Names.len() != 0)
		{
			this.getContainer().getActor().setName(this.m.Names[this.Math.rand(0, this.m.Names.len() - 1)]);
		}

		if (this.m.Names.len() != 0 && this.Math.rand(1, 100) <= 50)
		{
			this.getContainer().getActor().setTitle(this.Const.Strings.GoblinTitles[this.Math.rand(0, this.Const.Strings.GoblinTitles.len() - 1)]);
		}

		this.getContainer().getActor().getFlags().set("bewitched", this.m.Info.Type);

		if (this.m.AdditionalPerks != null)
		{
			foreach ( _array in this.m.AdditionalPerks )
			{
				this.addPerkGroup(_array);
			}
		}

		if (!this.getContainer().hasSkill("racial.champion") && this.Math.rand(1, 100) >= 99)
		{
			this.addPerk(this.Const.Perks.PerkDefs.HexenChampion, 6);
		}

		if (this.Math.rand(1, 100) >= 95)
		{
			this.addPerk(this.Const.Perks.PerkDefs.FairGame, 2);
		}

		local b = this.getContainer().getActor().getBaseProperties();

		b.Hitpoints += this.Math.rand(attributes.Hitpoints[0], attributes.Hitpoints[1]);
		b.Bravery += this.Math.rand(attributes.Bravery[0], attributes.Bravery[1]);
		b.Stamina += this.Math.rand(attributes.Stamina[0], attributes.Stamina[1]);
		b.MeleeSkill += this.Math.rand(attributes.MeleeSkill[0], attributes.MeleeSkill[1]);
		b.RangedSkill += this.Math.rand(attributes.RangedSkill[0], attributes.RangedSkill[1]);
		b.MeleeDefense += this.Math.rand(attributes.MeleeDefense[0], attributes.MeleeDefense[1]);
		b.RangedDefense += this.Math.rand(attributes.RangedDefense[0], attributes.RangedDefense[1]);
		b.Initiative += this.Math.rand(attributes.Initiative[0], attributes.Initiative[1]);

		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.onAfterSetUp();
	}

	function onAfterSetUp()
	{
		if (this.m.Perks == null)
		{
			return;
		}

		this.m.Perks.extend(this.getContainer().getActor().getSignaturePerks());

		foreach (i, Const in this.m.Perks )
		{
			this.World.Assets.getOrigin().addScenarioPerk(this, this.Const.Perks.PerkDefs[Const], i);
		}
	}
	
	function onUpdate( _properties )
	{
		_properties.DailyFood -= 1.0;
		this.character_background.onUpdate(_properties);
	}

	function onBuildDescription()
	{
		return this.m.BackgroundDescription;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		
		if (this.m.Info != null && ("Items" in this.m.Info) && this.m.Info.Items != null)
		{
			this.m.Info.Items.transferTo(items);
		}
		
		if (this.m.IsWolfrider)
		{
			this.getContainer().add(this.new("scripts/skills/perks/perk_wolf_rider"));
			items.equip(this.new("scripts/items/accessory/wolf_item"));
		}
		
		if (!("IsExperienced" in this.m.Info))
		{
			return;
		}
		
		local r = this.m.Info.IsExperienced ? this.Math.rand(2, 3) : 1;

		if (r == 1)
		{
			r += this.calculateAdditionalRecruitmentLevels();
		}

		if (this.World.getTime().Days >= 150)
		{
			r += 1;
		}
		
		r = this.Math.min(7, r);
		this.getContainer().getActor().m.PerkPoints = r - 1;
		this.getContainer().getActor().m.Level = r;
		this.getContainer().getActor().m.LevelUps = r - 1;
		
		if (r > 1)
		{
			this.getContainer().getActor().m.XP = this.Const.LevelXP[r - 1];
		}
	}
	
	function setAppearance()
	{
		local actor = this.getContainer().getActor();
		local info = this.m.Info;
		local entity = this.m.Entity;

		if (entity != null && info != null && ("Appearance" in info) && info.Appearance != null && typeof info.Appearance == "array")
		{
			this.logInfo("Identifying charmed target: " + this.Const.Strings.EntityName[entity.getType()]);
			this.logInfo("Copying sprites to new charmed slave...");
			actor.copySpritesFrom(entity, info.Appearance);
			actor.setDirty(true);
		}
	}

	function onChangeAttributes()
	{
		return this.m.AttMods;
	}
	
	function setTo( _type )
	{
		local info = {};
		info.Type <- _type;
		info.IsExperienced <- true;
		this.m.Info = this.Const.CharmedSlave.addMissingData(info);
		this.m.AttMods = this.Const.CharmedSlave.getStatsModifiers(_type);
		this.m.Perks = this.Const.CharmedSlave.getSpecialPerks(_type);
		this.m.Skills = this.Const.CharmedSlave.getSpecialSkills(_type);
		this.m.Name = "Charmed " + this.Const.Strings.EntityName[_type];
		this.m.Icon = "ui/backgrounds/" + this.Const.CharmedSlave.getIconName(_type);
		this.Const.HexenOrigin.CharmedSlave.processingCharmedBackground(this.m.Info, this);
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
		local info = this.m.Info;
		
		if (info != null && ("Stats" in info) && info.Stats != null)
		{
			b.setValues(info.Stats);
		}

		b.FatigueRecoveryRate = this.Math.min(18, b.FatigueRecoveryRate);
		b.ActionPoints = 9;
		
		local Hitpoints1 = this.Math.rand(a.Hitpoints[0] - 2, a.Hitpoints[1] + 2);
		local Bravery1 = this.Math.rand(a.Bravery[0] - 2, a.Bravery[1] + 2);
		local Stamina1 = this.Math.rand(a.Stamina[0] - 10, a.Stamina[1] + 5);
		local MeleeSkill1 = this.Math.rand(a.MeleeSkill[0] - 2, a.MeleeSkill[1] + 2);
		local RangedSkill1 = this.Math.rand(a.RangedSkill[0] - 2, a.RangedSkill[1] + 2);
		local MeleeDefense1 = this.Math.rand(a.MeleeDefense[0] - 2, a.MeleeDefense[1] + 2);
		local RangedDefense1 = this.Math.rand(a.RangedDefense[0] - 2, a.RangedDefense[1] + 2);
		local Initiative1 = this.Math.rand(a.Initiative[0] - 10, a.Initiative[1] + 5);
		
		local Hitpoints2 = this.Math.rand(a.Hitpoints[0] - 2, a.Hitpoints[1] + 2);
		local Bravery2 = this.Math.rand(a.Bravery[0] - 2, a.Bravery[1] + 2);
		local Stamina2 = this.Math.rand(a.Stamina[0] - 10, a.Stamina[1] + 5);
		local MeleeSkill2 = this.Math.rand(a.MeleeSkill[0] - 2,  a.MeleeSkill[1] + 2);
		local RangedSkill2 = this.Math.rand(a.RangedSkill[0] - 2, a.RangedSkill[1] + 2);
		local MeleeDefense2 = this.Math.rand(a.MeleeDefense[0] - 2, a.MeleeDefense[1] + 2);
		local RangedDefense2 = this.Math.rand(a.RangedDefense[0] - 2, a.RangedDefense[1] + 2);
		local Initiative2 = this.Math.rand(a.Initiative[0] - 10, a.Initiative[1] + 5);
		
		local HitpointsAvg = this.Math.round((Hitpoints1 + Hitpoints2) / 2);
		local BraveryAvg = this.Math.round((Bravery1 + Bravery2) / 2);
		local StaminaAvg = this.Math.round((Stamina1 + Stamina2) / 2);
		local MeleeSkillAvg = this.Math.round((MeleeSkill1 + MeleeSkill2) / 2);
		local RangedSkillAvg = this.Math.round((RangedSkill1 + RangedSkill2) / 2);
		local MeleeDefenseAvg = this.Math.round((MeleeDefense1 + MeleeDefense2) / 2);
		local RangedDefenseAvg = this.Math.round((RangedDefense1 + RangedDefense2) / 2);
		local InitiativeAvg = this.Math.round((Initiative1 + Initiative2) / 2);
		
		b.Hitpoints += HitpointsAvg;
		b.Bravery += BraveryAvg;
		b.Stamina += StaminaAvg;
		b.MeleeSkill += MeleeSkillAvg;
		b.RangedSkill += RangedSkillAvg;
		b.MeleeDefense += MeleeDefenseAvg;
		b.RangedDefense += RangedDefenseAvg;
		b.Initiative += InitiativeAvg;
		
		local maxTraits = this.Math.rand(this.Math.rand(0, 1) == 0 ? 0 : 1, 2);
		local traits = [this];

		for( local i = 0; i < maxTraits; i = ++i )
		{
			for( local j = 0; j < 10; j = ++j )
			{
				local trait = this.Const.CharacterTraits[this.Math.rand(0, this.Const.CharacterTraits.len() - 1)];
				local nextTrait = false;

				for( local k = 0; k < traits.len(); k = ++k )
				{
					if (traits[k].getID() == trait[0] || traits[k].isExcluded(trait[0]))
					{
						nextTrait = true;
						break;
					}
				}

				if (!nextTrait)
				{
					traits.push(this.new(trait[1]));
					break;
				}
			}
		}

		for( local i = 1; i < traits.len(); i = ++i )
		{
			this.getContainer().add(traits[i]);
		}
		
		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.getContainer().getActor().setHitpoints(b.Hitpoints);
		return [50, 50, 50, 50, 50, 50, 50 ,50];
	}

	function getTooltip()
	{
		local p = this.getContainer().getActor().getBaseProperties();
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

		if (::mods_getRegisteredMod("mod_legends_PTR") != null)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/special",
				text = "Reduce AP cost of all melee attack skills by [color=" + this.Const.UI.Color.PositiveValue + "]1[/color] "
			})
		}

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/warning.png",
			text = "Receive [color=" + this.Const.UI.Color.NegativeValue + "]penalties[/color] if the total penalty to Maximum Fatigue from body and head armor above 20"
		});
		
		if (this.getContainer() == null || this.getContainer().getActor() == null)
		{
			return ret;
		}

		ret.extend(this.Const.HexenOrigin.CharmedSlave.getTooltip(this.getContainer().getActor()));
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
		
		_out.writeU8(this.m.Skills.len());
		for( local i = 0; i != this.m.Skills.len(); i = i )
		{
			_out.writeString(this.m.Skills[i]);
			i = ++i;
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

		local numSkills = _in.readU8();
		this.m.Skills = [];
		this.m.Skills.resize(numSkills, "");

		for( local i = 0; i != numSkills; i = i )
		{
			this.m.Skills[i] = _in.readString();
			i = ++i;
		}

		for( local i = 0; i != this.m.Modifiers.Terrain.len(); i = i )
		{
			this.m.Modifiers.Terrain[i] = _in.readF32();
			i = ++i;
		}
	}

});

