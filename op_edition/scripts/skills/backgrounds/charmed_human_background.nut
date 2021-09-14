this.charmed_human_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		Entity = null,
		Info = null,
		AttMods = null,
		Skills = null,
		AdditionalPerks = null,
		FatigueRecoveryRate = 15,
	},
	
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.charmed_human";
		this.m.Name = "Charmed Human"
		this.m.Icon = "ui/backgrounds/background_charmed_17.png";
		this.m.Order = -1;
		this.m.BackgroundDescription = "Human slave who fell for your charm. They will gladly offer their lives to protect you.";
		this.m.HiringCost = 0;
		this.m.DailyCost = 0;
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
		
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 100;
		this.m.Names = this.Const.Strings.CharacterNames;
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.NeutralMin;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.NeutralMax;
		this.m.Modifiers.Gathering = this.Const.LegendMod.ResourceModifiers.Gather[1];
		this.m.Modifiers.Barter = this.Const.LegendMod.ResourceModifiers.Barter[2];
		this.m.CustomPerkTree = this.Const.Perks.DefaultCustomPerkTree;
	}
	
	function transferInfo( _human , _info )
	{
		local type = _human.getType();

		this.m.Entity = _human;
		this.m.Info = this.Const.CharmedSlave.addMissingData(_info, this.m.Entity);
		this.m.AttMods = this.Const.CharmedSlave.getStatsModifiers(type);
		this.m.Skills = this.Const.CharmedSlave.getSpecialPerks(type);
		this.m.Name = "Charmed " + this.Const.Strings.EntityName[type];
		this.m.Icon = "ui/backgrounds/" + this.Const.CharmedSlave.getIconName(type);
		this.Const.HexenOrigin.CharmedSlave.processingCharmedBackground(this.m.Info, this);
	}
	
	function onAdded()
	{
		local b = this.getContainer().getActor().getBaseProperties();
		
		if (this.m.FatigueRecoveryRate != 15)
		{
			b.FatigueRecoveryRate = this.m.FatigueRecoveryRate;
		}
		
		this.getContainer().getActor().m.CurrentProperties = clone b;
		
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
		
		this.character_background.onAdded();
	}
	
	function onSetUp()
	{
		local attributes = this.buildPerkTree();
		local actor = this.getContainer().getActor();
		actor.m.Background = this;
		actor.m.StarWeights = this.buildAttributes(null, attributes);
		actor.fillTalentValues(3);

		if (this.m.Info.Type == this.Const.EntityType.Swordmaster || this.m.Info.Type == this.Const.EntityType.DesertDevil)
		{
			actor.m.Talents[this.Const.Attributes.MeleeSkill] = 3;
		}

		if (this.m.Info.Type == this.Const.EntityType.MasterArcher || this.m.Info.Type == this.Const.EntityType.DesertStalker)
		{
			actor.m.Talents[this.Const.Attributes.RangedSkill] = 3;
		}

		if (this.m.Info.Type == this.Const.EntityType.Executioner || this.m.Info.Type == this.Const.EntityType.HedgeKnight)
		{
			actor.m.Talents[this.Const.Attributes.Fatigue] = 3;
		}

		actor.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		actor.getFlags().set("bewitched", this.m.Info.Type);
		this.getContainer().add(this.new("scripts/skills/traits/intensive_training_trait"));
		this.setAppearance();

		if (this.m.Names.len() != 0)
		{
			this.getContainer().getActor().setName(this.m.Names[this.Math.rand(0, this.m.Names.len() - 1)]);
		}

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
		
		if (!("IsExperienced" in this.m.Info))
		{
			return;
		}
		
		local r = this.m.Info.IsExperienced ? this.Math.rand(2, 4) : 1;

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
	
	function setTo( _type )
	{
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

		b.ActionPoints = 9;
		b.FatigueRecoveryRate = this.Math.min(18, b.FatigueRecoveryRate);
		
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
		this.m.FatigueRecoveryRate = b.FatigueRecoveryRate;
		
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

		local p = this.getContainer().getActor().getBaseProperties();
		ret.extend(this.Const.HexenOrigin.CharmedSlave.getTooltip(p));
		ret.extend(this.getAttributesTooltip());
		return ret;
	}
	
	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeString(this.m.ID);
		_out.writeString(this.m.Icon);
		_out.writeString(this.m.Name);
		_out.writeU8(this.Math.floor(this.m.FatigueRecoveryRate));
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


		local p = [
			"Untalented",
			"OffendedByViolence",
			"Combat",
			"Educated",
			"Noble",
			"Lowborn",
			"Ranger",
			"Druid",
			"Crusader",
			"Performing",
			"Outlaw",
		];

		for( local i = 0; i != p.len(); i = i )
		{
			local a = this.isBackgroundType(this.Const.BackgroundType[p[i]]);
			_out.writeBool(a);
			i = ++i;
		}

		//_out.writeBool(this.m.IsUntalented);
		//_out.writeBool(this.m.IsOffendedByViolence);
		//_out.writeBool(this.m.IsCombatBackground);
		//_out.writeBool(this.m.IsEducatedBackground);
		//_out.writeBool(this.m.IsNoble);
		//_out.writeBool(this.m.IsLowborn);
		//_out.writeBool(this.m.IsRangerRecruitBackground);
		//_out.writeBool(this.m.IsDruidRecruitBackground);
		//_out.writeBool(this.m.IsCrusaderRecruitBackground);
		//_out.writeBool(this.m.IsPerformingBackground);
		//_out.writeBool(this.m.IsOutlawBackground);


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
		this.m.FatigueRecoveryRate = _in.readU8();
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


		local p = [
			"Untalented",
			"OffendedByViolence",
			"Combat",
			"Educated",
			"Noble",
			"Lowborn",
			"Ranger",
			"Druid",
			"Crusader",
			"Performing",
			"Outlaw",
		];

		for( local i = 0; i != p.len(); i = i )
		{
			if (_in.readBool())
			{
				this.addBackgroundType(this.Const.BackgroundType[p[i]]);
			}

			i = ++i;
		}
	
		//this.m.IsUntalented = _in.readBool();
		//this.m.IsOffendedByViolence = _in.readBool();
		//this.m.IsCombatBackground = _in.readBool();
		//this.m.IsEducatedBackground = _in.readBool();
		//this.m.IsNoble = _in.readBool();
		//this.m.IsLowborn = _in.readBool();
		//this.m.IsRangerRecruitBackground = _in.readBool();
		//this.m.IsDruidRecruitBackground = _in.readBool();
		//this.m.IsCrusaderRecruitBackground = _in.readBool();
		//this.m.IsPerformingBackground = _in.readBool();
		//this.m.IsOutlawBackground = _in.readBool();
		
		
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

