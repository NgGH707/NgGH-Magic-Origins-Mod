this.charmed_beast_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		Entity = null,
		Info = null,
		AttMods = null,
		Skills = null,
		AdditionalPerks = null,
		IsUnhold = false,
	},
	
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.charmed_beast";
		this.m.Name = "Charmed Beast"
		this.m.Icon = "ui/backgrounds/background_charmed_54.png";
		this.m.Order = -1;
		this.m.BackgroundDescription = "Monster that under your control. Who wouldn\'t think hexe\'s magic can be this strong.";
		this.m.HiringCost = 0;
		this.m.DailyCost = 0;
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
	
	function transferInfo( _beast , _info )
	{
		local type = _beast.getType();

		this.m.Entity = _beast;
		this.m.Info = this.Const.CharmedSlave.addMissingData(_info, this.m.Entity);
		this.m.AttMods = this.Const.CharmedSlave.getStatsModifiers(type);
		this.m.Skills = this.Const.CharmedSlave.getSpecialPerks(type);
		this.m.Name = "Charmed " + this.Const.Strings.EntityName[type];
		this.m.Icon = "ui/backgrounds/" + this.Const.CharmedSlave.getIconName(type);
		this.m.IsUnhold = this.isKindOf(_beast, "unhold");
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

		this.m.Excluded = this.getContainer().getActor().getExcludeTraits();
		local index = this.getContainer().getActor().getFlags().getAsInt("bewitched");
		
		if (this.m.AttMods == null && index != 0)
		{
			this.m.AttMods = this.Const.CharmedSlave.getStatsModifiers(index);
		}
		
		this.character_background.onAdded();
	}
	
	function onSetUp()
	{
		local attributes = this.buildPerkTreeBeast();
		this.getContainer().getActor().getFlags().set("bewitched", this.m.Info.Type);
		this.getContainer().getActor().m.Background = this;
		this.getContainer().getActor().m.StarWeights = this.buildAttributes(null, attributes);
		this.getContainer().getActor().fillTalentValues();
		this.getContainer().getActor().fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		this.setAppearance();
		this.onAddEquipment();
		this.getContainer().add(this.new("scripts/skills/traits/intensive_training_trait"));

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
	
	function onChangeAttributes()
	{
		return this.m.AttMods;
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
			
			if (info.Type == this.Const.EntityType.Spider || info.Type == this.Const.EntityType.LegendRedbackSpider)
			{
				actor.setSize(entity.m.Size);
			}
	
			if (this.m.IsUnhold)
			{
				local variant = 1;

				switch(info.Type)
				{
				case this.Const.EntityType.Unhold:
				case this.Const.EntityType.BarbarianUnhold:
					variant = 2;
					break;

				case this.Const.EntityType.UnholdBog:
					variant = 3;
					break;

				case this.Const.EntityType.LegendRockUnhold:
					variant = 4;
					break;

				case this.Const.EntityType.LegendBear:
					variant = 5;
					actor.changeBearSounds();
					actor.m.IsBear = true;
					break;
				}

				actor.m.Variant = variant;
			}
			
			if (info.Type == this.Const.EntityType.Hyena)
			{
				actor.m.IsHigh = entity.m.IsHigh;
				
				if (!entity.m.IsHigh)
				{
					this.addPerk(this.Const.Perks.PerkDefs.Rabies, 6);
				}
			}
			
			if (info.Type == this.Const.EntityType.Direwolf)
			{
				if (entity.getSprite("head_frenzy").HasBrush)
				{
					local head_frenzy = actor.getSprite("head_frenzy");
					head_frenzy.setBrush(actor.getSprite("head").getBrush().Name + "_frenzy");
					actor.getFlags().add("frenzy_wolf");
				}
				else
				{
					this.addPerk(this.Const.Perks.PerkDefs.Rabies, 6);
				}
			}
			
			if (info.Type == this.Const.EntityType.Serpent)
			{
				actor.m.Variant = entity.m.Variant;
			}
			
			if (info.Type == this.Const.EntityType.Ghoul || info.Type == this.Const.EntityType.LegendSkinGhoul)
			{
				actor.m.Head = entity.m.Head;
				actor.m.IsSkin = info.Type == this.Const.EntityType.LegendSkinGhoul;
				actor.getFlags().set("hunger", 2);
				
				if (entity.getSize() > 1)
				{
					actor.grow(true);
				}
				
				if (entity.getSize() == 3)
				{
					actor.grow(true);
				}
			}

			actor.onUpdateInjuryLayer();
		}
	}
	
	function buildPerkTreeBeast()
	{
		local a = {Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0]};
		
		if (this.m.PerkTree != null)
		{
			return a;
		}
		
		this.m.CustomPerkTree = clone this.m.Info.PerkTree;
		local isHumaniod = this.Const.HumanoidBeast.find(this.m.Info.Type) != null;
		local hasAoE = this.Const.BeastHasAoE.find(this.m.Info.Type) != null;
		local removeNimble = this.Const.BeastNeverHasNimble.find(this.m.Info.Type) != null;
		local origin = this.World.Assets.getOrigin();
		local helper = this.getroottable().PerkTreeBuilder;
		this.m.CustomPerkTree = helper.fillWithRandomPerk(this.m.CustomPerkTree, this.getContainer(), isHumaniod, hasAoE, removeNimble);

		if (origin != null)
		{
			this.World.Assets.getOrigin().onBuildPerkTree(this);
		}

		local pT = this.Const.Perks.BuildCustomPerkTree(this.m.CustomPerkTree);
		this.m.PerkTree = pT.Tree;
		this.m.PerkTreeMap = pT.Map;
		return a;
	}
	
	function setTo( _type )
	{
		local info = {};
		info.Type <- _type;
		info.IsExperienced <- true;
		this.m.Info = this.Const.CharmedSlave.addMissingData(info);
		this.m.AttMods = this.Const.CharmedSlave.getStatsModifiers(_type);
		this.m.Skills = this.Const.CharmedSlave.getSpecialPerks(_type)
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

		if (!this.getContainer().hasSkill("trait.player"))
		{
			if (b.ArmorMax[0] >= 500 || b.ArmorMax[1] >= 500)
			{
				b.ArmorMax[0] = this.Math.floor(b.ArmorMax[0] * 0.5);
				b.ArmorMax[1] = this.Math.floor(b.ArmorMax[1] * 0.5);
				b.Armor[0] = this.Math.floor(b.Armor[0] * 0.5);
				b.Armor[1] = this.Math.floor(b.Armor[1] * 0.5);
			}
			else if (b.ArmorMax[0] >= 250 || b.ArmorMax[1] >= 250)
			{
				b.ArmorMax[0] = this.Math.floor(b.ArmorMax[0] * 0.75);
				b.ArmorMax[1] = this.Math.floor(b.ArmorMax[1] * 0.75);
				b.Armor[0] = this.Math.floor(b.Armor[0] * 0.75);
				b.Armor[1] = this.Math.floor(b.Armor[1] * 0.75);
			}
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

		local actor = this.getContainer().getActor();

		if (actor.getFlags().has("hunger"))
		{
			local count = actor.getFlags().getAsInt("hunger");

			if (count > 0 && actor.getSize() == 3)
			{
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/asset_food.png",
					text = "Will degrade after [color=" + this.Const.UI.Color.NegativeValue + "]"+ count +"[/color] battle(s) if you don't eat any corpse"
				})
			}
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

