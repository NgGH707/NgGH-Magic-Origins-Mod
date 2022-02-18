this.charmed_orc_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		Entity = null,
		Info = null,
		AttMods = null,
		Skills = null,
		Perks = null,
		AdditionalPerks = null,
		Food = 2,
	},
	
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.charmed_orc";
		this.m.Name = "Charmed Orc"
		this.m.Icon = "ui/backgrounds/background_charmed_13.png";
		this.m.Order = -1;
		this.m.BackgroundDescription = "Orc brutes who were enthralled by your charmed. They will fight to the death for your cause.";
		this.m.HiringCost = 0;
		this.m.DailyCost = 0;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.weasel",
			"trait.fear_beasts",
			"trait.ailing",
			"trait.bleeder",
			"trait.fragile",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.fat",
			"trait.clumsy",
			"trait.asthmatic",
			"trait.craven",
			"trait.dastard",
			"trait.disloyal",
			"trait.fainthearted",
			"trait.greedy",
			"trait.hesitant",
			"trait.insecure",
			"trait.pessimist",
			"trait.spartan",
			"trait.tiny"
		];
		this.m.ExcludedTalents = [
			3,
			5,
			6,
			7
		];
		
		this.addBackgroundType(this.Const.BackgroundType.Combat);
		this.m.Names = this.Const.Strings.OrcNames;
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.Cruel;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.Merciless;
	}
	
	function transferInfo( _orc , _info )
	{
		local type = _orc.getType();

		this.m.Entity = _orc;
		this.m.Info = this.Const.CharmedSlave.addMissingData(_info, this.m.Entity);
		this.m.AttMods = this.Const.CharmedSlave.getStatsModifiers(type);
		this.m.Perks = this.Const.CharmedSlave.getSpecialPerks(type);
		this.m.Skills = this.Const.CharmedSlave.getSpecialSkills(type);
		this.m.Name = "Charmed " + this.Const.Strings.EntityName[type];
		this.m.Icon = "ui/backgrounds/" + this.Const.CharmedSlave.getIconName(type);
		this.Const.HexenOrigin.CharmedSlave.processingCharmedBackground(this.m.Info, this);
	}
	
	function onUpdate( _properties )
	{
		_properties.DailyFood += this.m.Food;
		this.character_background.onUpdate(_properties);
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

		local type = this.getContainer().getActor().getFlags().getAsInt("bewitched");

		switch (type) 
		{	
		case this.Const.EntityType.OrcBerserker:
			this.m.Food = 3;
			break;
			
		case this.Const.EntityType.OrcWarrior:
		case this.Const.EntityType.LegendOrcElite:
			this.m.Food = 4;
			break;
			
		case this.Const.EntityType.OrcWarlord:
			this.m.Food = 5;
			break;
			
		case this.Const.EntityType.LegendOrcBehemoth:
			this.m.Food = 7;
			break;

		default:
			this.m.Food = 2;
		}
		
		this.character_background.onAdded();
	}
	
	function onSetUp()
	{
		this.getContainer().getActor().m.Background = this;
		this.getContainer().getActor().m.StarWeights = this.buildAttributes(null, null);
		this.getContainer().getActor().fillTalentValues();
		this.getContainer().getActor().fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		local attributes = this.buildPerkTree();
		this.getContainer().add(this.new("scripts/skills/traits/intensive_training_trait"));
		this.getContainer().getActor().getFlags().set("bewitched", this.m.Info.Type);
		this.getContainer().getActor().setWarLord();
		this.getContainer().getActor().setBehemoth();
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

			if (actor.getSprite("body_rage").HasBrush)
			{
				actor.updateRageVisuals(0);
			}
			else 
			{
			    actor.getSprite("body_rage").Visible = false;
			}

			actor.onUpdateInjuryLayer();
		}
	}
	
	function setTo( _type )
	{
		local info = {};
		info.Type <- _type;
		info.IsExperienced <- true;
		this.m.Info = this.Const.CharmedSlave.addMissingData(info);
		this.m.AttMods = this.Const.CharmedSlave.getStatsModifiers(_type);
		this.m.Perks = this.Const.CharmedSlave.getSpecialPerks(type);
		this.m.Skills = this.Const.CharmedSlave.getSpecialSkills(type);
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
	
	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();

		if (actor.getFlags().getAsInt("bewitched") == this.Const.EntityType.LegendOrcBehemoth)
		{
			actor.m.Sound[this.Const.Sound.ActorEvent.Death] = [
				"sounds/enemies/orcgiant_death_01.wav",
				"sounds/enemies/orcgiant_death_02.wav",
				"sounds/enemies/orcgiant_death_03.wav",
				"sounds/enemies/orcgiant_death_04.wav"
			];
			actor.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
				"sounds/enemies/orcgiant_flee_01.wav",
				"sounds/enemies/orcgiant_flee_02.wav",
				"sounds/enemies/orcgiant_flee_03.wav"
			];
			actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
				"sounds/enemies/orcgiant_hurt_01.wav",
				"sounds/enemies/orcgiant_hurt_02.wav",
				"sounds/enemies/orcgiant_hurt_03.wav",
				"sounds/enemies/orcgiant_hurt_04.wav",
				"sounds/enemies/orcgiant_hurt_05.wav",
				"sounds/enemies/orcgiant_hurt_06.wav",
				"sounds/enemies/orcgiant_hurt_07.wav",
				"sounds/enemies/orcgiant_hurt_08.wav"
			];
			actor.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
				"sounds/enemies/orcgiant_idle_01.wav",
				"sounds/enemies/orcgiant_idle_02.wav",
				"sounds/enemies/orcgiant_idle_03.wav",
				"sounds/enemies/orcgiant_idle_04.wav",
				"sounds/enemies/orcgiant_idle_05.wav",
				"sounds/enemies/orcgiant_idle_06.wav",
				"sounds/enemies/orcgiant_idle_07.wav",
				"sounds/enemies/orcgiant_idle_08.wav",
				"sounds/enemies/orcgiant_idle_09.wav",
				"sounds/enemies/orcgiant_idle_10.wav",
				"sounds/enemies/orcgiant_idle_11.wav",
				"sounds/enemies/orcgiant_idle_12.wav",
				"sounds/enemies/orcgiant_idle_13.wav",
				"sounds/enemies/orcgiant_idle_14.wav",
				"sounds/enemies/orcgiant_idle_15.wav",
				"sounds/enemies/orcgiant_idle_16.wav",
				"sounds/enemies/orcgiant_idle_17.wav"
			];
			actor.m.Sound[this.Const.Sound.ActorEvent.Move] = [
				"sounds/enemies/orc_fatigue_01.wav",
				"sounds/enemies/orc_fatigue_02.wav",
				"sounds/enemies/orc_fatigue_03.wav"
			];
			actor.m.SoundPitch = 0.6;
			actor.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 1.25;
			actor.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 1.0;
			actor.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 0.75;
		}
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
			}
		];
		
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

