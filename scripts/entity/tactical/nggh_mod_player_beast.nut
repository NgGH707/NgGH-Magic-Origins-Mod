this.nggh_mod_player_beast <- ::inherit("scripts/entity/tactical/nggh_mod_inhuman_player", {
	m = {
		// for display in level up stats UI
		AttributesMax = {
			Hitpoints = 900,
			Bravery = 200,
			Fatigue = 300,
			Initiative = 250,
			MeleeSkill = 150,
			RangedSkill = 150,
			MeleeDefense = 125,
			RangedDefense = 125,
		}
	},
	function create()
	{
		this.nggh_mod_inhuman_player.create();
		this.m.AttributesLevelUp = ::Const.AttributesLevelUp;
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.DefaultBeast;
		// important flags for many crucial mechanisms
		this.m.Flags.add("bonus_regen");
	}

	function onAfterFactionChanged()
	{
		local flip = !this.isAlliedWithPlayer();
		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.getSprite(a).setHorizontalFlipping(flip);
		}
	}

	function onInit()
	{
		this.nggh_mod_inhuman_player.onInit();

		// remove all human sprite layers
		::Const.CharmedUtilities.removeAllHumanSprites(this, null, true);

		// the cosmetic effect
		this.m.Skills.add(::new("scripts/skills/special/nggh_mod_cosmetic"));

		// animals usually don't have hands to punch they only have paws
		this.m.Skills.removeByID("actives.hand_to_hand");
	}

	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("dirt"))
		{
			this.addSprite("dirt");
		}
		
		this.nggh_mod_inhuman_player.addDefaultStatusSprites();
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		local helmet = this.m.Items.getItemAtSlot(::Const.ItemSlot.Head);

		// remove the base layer of layered helmet
		// why? that layer barely has any sprite suitable for beast
		if (helmet != null && ::isKindOf(helmet, "legend_helmet"))
		{
			_appearance.HelmetDamage = "";
			_appearance.Helmet = "";
		}
		
		this.nggh_mod_inhuman_player.onAppearanceChanged(_appearance, _setDirty);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local flip = ::Math.rand(0, 100) < 50;
		this.m.IsCorpseFlipped = flip;
		local isResurrectable = false;
		local appearance = this.getItems().getAppearance();
		local sprite_body = this.getSprite("body");
		local sprite_head = !this.hasSprite("head") ? this.addSprite("head") : this.getSprite("head");
		local sprite_accessory = !this.hasSprite("accessory") ? this.addSprite("accessory") : this.getSprite("accessory");

		if (!this.isGuest())
		{
			local stub = ::Tactical.getCasualtyRoster().create("scripts/entity/tactical/player_corpse_stub");
			stub.setCommander(this.isCommander());
			stub.setOriginalID(this.getID());
			stub.setName(this.getNameOnly());
			stub.setTitle(this.getTitle());
			stub.setCombatStats(this.m.CombatStats);
			stub.setLifetimeStats(this.m.LifetimeStats);
			stub.m.DaysWithCompany = this.getDaysWithCompany();
			stub.m.Level = this.getLevel();
			stub.m.DailyCost = this.getDailyCost();

			if (::Const.BloodPoolDecals[this.m.BloodType].len() != 0)
			{
				stub.addSprite("blood_1").setBrush(::MSU.Array.rand(::Const.BloodPoolDecals[this.m.BloodType]));
				stub.setSpriteOffset("blood_1", ::createVec(0, -15));
			}

			if (::Const.BloodDecals[this.m.BloodType].len() != 0)
			{
				stub.addSprite("blood_2").setBrush(::MSU.Array.rand(::Const.BloodDecals[this.m.BloodType]));
				stub.setSpriteOffset("blood_2", ::createVec(0, -30));
			}

			if (_fatalityType == ::Const.FatalityType.Devoured)
			{
				if (this.m.BloodType == ::Const.BloodType.Red || this.m.BloodType == ::Const.BloodType.Dark)
				{
					for( local i = 0; i != ::Const.CorpsePart.len(); ++i )
					{
						stub.addSprite("stuff_" + i).setBrush(::Const.CorpsePart[i]);
					}
				}
			}
			else if (this.getFlags().has("single_body"))
			{
				local decal = stub.addSprite("body");
				decal.setBrush(body.getBrush().Name + "_dead");
				decal.Color = sprite_body.Color;
				decal.Saturation = sprite_body.Saturation;
			}
			else
			{
				local decal = stub.addSprite("body");

				// a few dead sprites aren't generic so i have to put a specific sprite id for such entity
				switch(this.getFlags().get("Type"))
				{
				case ::Const.EntityType.LegendWhiteDirewolf:
				case ::Const.EntityType.Direwolf:
					decal.setBrush("bust_direwolf_01_body_dead");
					break;

				case ::Const.EntityType.Hyena:
					decal.setBrush("bust_hyena_01_body_dead");
					break;

				case ::Const.EntityType.Serpent:
					decal.setBrush("bust_snake_body_0" + this.m.Variant + "_dead");
					break;

				default:
					decal.setBrush(sprite_body.getBrush().Name + "_dead");
				}

				decal.Color = sprite_body.Color;
				decal.Saturation = sprite_body.Saturation;

				if (appearance.CorpseArmor != "")
				{
					decal = stub.addSprite("armor");
					decal.setBrush(appearance.CorpseArmor);
				}

				if (appearance.CorpseArmorUpgradeBack != "")
				{
					decal = stub.addSprite("upgrade_back");
					decal.setBrush(appearance.CorpseArmorUpgradeBack);
				}

				if (sprite_accessory.HasBrush)
				{
					decal = stub.addSprite("accessory");
					decal.setBrush(sprite_accessory.getBrush().Name + "_dead");
				}

				if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Arrow)
				{
					if (appearance.CorpseArmor != "")
					{
						stub.addSprite("arrows").setBrush(appearance.CorpseArmor + "_arrows");
					}
					else
					{
						stub.addSprite("arrows").setBrush(appearance.Corpse + "_arrows");
					}
				}
				else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Javelin)
				{
					if (appearance.CorpseArmor != "")
					{
						stub.addSprite("arrows").setBrush(appearance.CorpseArmor + "_javelin");
					}
					else
					{
						stub.addSprite("arrows").setBrush(appearance.Corpse + "_javelin");
					}
				}

				if (_fatalityType != ::Const.FatalityType.Decapitated)
				{
					if (!appearance.HideCorpseHead)
					{
						decal = stub.addSprite("head");

						if (sprite_head.HasBrush)
						{
							decal.setBrush(sprite_head.getBrush().Name + "_dead");
							decal.Color = sprite_head.Color;
							decal.Saturation = sprite_head.Saturation;
						}
						else if (this.getFlags().get("Type") == ::Const.EntityType.Serpent)
						{
							decal.setBrush("bust_snake_body_0" + this.m.Variant + "_head_dead");
							decal.Color = sprite_body.Color;
							decal.Saturation = sprite_body.Saturation;
						}
					}
					
					if (appearance.HelmetCorpse != "")
					{
						decal = stub.addSprite("helmet");
						decal.setBrush(this.getItems().getAppearance().HelmetCorpse);
					}
				}

				if (appearance.CorpseArmorUpgradeFront != "")
				{
					decal = stub.addSprite("upgrade_front");
					decal.setBrush(appearance.CorpseArmorUpgradeFront);
				}
			}
		}

		this.nggh_mod_inhuman_player.onDeath(_killer, _skill, _tile, _fatalityType);
	}
	
	function setScenarioValues( _type, _isElite = false, _randomizedTalents = false, _setName = false )
	{
		local c = this.m.CurrentProperties;
		this.m.ActionPoints = c.ActionPoints;
		this.m.Hitpoints = c.Hitpoints;
		this.m.Talents = [];
		this.m.Attributes = [];

		/*if (_randomizedTalents)
		{
			this.fillTalentValues();
		}
		else if (this.getFlags().has("egg"))*/
		{
			this.player.fillTalentValues(3);
		}
		/*else
		{
			this.fillModsTalentValues(::Math.rand(6, 9), true);
		}
		*/
		
		this.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);

		if (_setName)
		{
			this.setName(::Const.Strings.EntityName[_type]);
		}

		if (_isElite || (!_randomizedTalents && ::Math.rand(1, 100) == 1))
		{
			this.m.Skills.add(::new("scripts/skills/racial/champion_racial"));
		}
		else if (::Math.rand(1, 100) <= 1)
		{
			this.getBackground().addPerk(::Const.Perks.PerkDefs.NggHMiscChampion, 6);
		}

		if (::Math.rand(1, 100) <= 5)
		{
			this.getBackground().addPerk(::Const.Perks.PerkDefs.NggHMiscFairGame, 2);
		}

		if (!this.m.Skills.hasSkill("trait.intensive_training_trait"))
		{
			this.m.Skills.add(::new("scripts/skills/traits/intensive_training_trait"));
		}

		this.getFlags().set("Type", _type);
		this.updateVariant();
	}
	
	function setStartValuesEx( _parameter_1 = null, _parameter_2 = null, _parameter_3 = null, _parameter_4 = null )
	{
		// do nothing but its children will
	}
	
	function fillModsTalentValues( _stars = 0 , _force = false )
	{
		if (this.getBackground() != null && ("Custom" in this.getBackground().m.TempData))
		{
			::Nggh_MagicConcept.TalentFiller.fillModdedTalentValues(this , this.getBackground().m.TempData.Custom.Talents , _stars , _force);
		}
	}

	function fillTalentValues( _num = null , _force = false )
	{
		local stars = 0;
		
		if (_num == null)
		{
			stars = ::Math.rand(1, 9);
		}
		else
		{
			_num = ::Math.max(1, ::Math.min(_num, 3));
			stars = ::Math.rand(_num, _num * 3);
		}
		
		this.m.Talents.resize(::Const.Attributes.COUNT, 0);
		this.fillModsTalentValues(stars, _force);
	}

	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
		if (this.m.Attributes.len() == 0)
		{
			this.m.Attributes.resize(::Const.Attributes.COUNT);

			for( local i = 0; i != ::Const.Attributes.COUNT; ++i )
			{
				this.m.Attributes[i] = [];
			}
		}

		for( local i = 0; i != ::Const.Attributes.COUNT; ++i )
		{
			for( local j = 0; j < _amount; ++j )
			{
				if (_minOnly)
				{
					this.m.Attributes[i].insert(0, this.m.AttributesLevelUp[i].Min);
				}
				else if (_maxOnly)
				{
					this.m.Attributes[i].insert(0, this.m.AttributesLevelUp[i].Max);
				}
				else
				{
					this.m.Attributes[i].insert(0, ::Math.rand(this.m.AttributesLevelUp[i].Min + (this.m.Talents[i] == 3 ? 2 : this.m.Talents[i]), this.m.AttributesLevelUp[i].Max + (this.m.Talents[i] == 3 ? 1 : 0)));
				}
			}
		}
	}

	function setAttributeLevelUpValues( _v )
	{
		// free max armor upon leveling up
		if (this.getFlags().has("regen_armor") && !this.getFlags().has("unhold"))
		{
			local value = this.getLevel() <= 11 ? ::Math.rand(this.m.AttributesLevelUp[::Const.Attributes.Hitpoints].Min, this.m.AttributesLevelUp[::Const.Attributes.Hitpoints].Max) : this.getHitpointsPerVeteranLevel();
			local b = this.getBaseProperties();
			b.Armor[0] += value;
			b.ArmorMax[0] += value;
			b.Armor[1] += value;
			b.ArmorMax[1] += value;
		}
		
		this.nggh_mod_inhuman_player.setAttributeLevelUpValues(_v);
	}

	function getAttributeLevelUpValues()
	{
		if (this.m.Attributes.len() != 0)
		{
			for( local i = 0; i != ::Const.Attributes.COUNT; ++i )
			{
				if (this.m.Attributes[i].len() != 0) 
				{
					continue;
				}

				if (i == ::Const.Attributes.Hitpoints)
				{
					this.m.Attributes[i].push(this.getHitpointsPerVeteranLevel());
					continue;
				}

				this.m.Attributes[i].push(1);
			}
		}

		local ret = this.nggh_mod_inhuman_player.getAttributeLevelUpValues();
		ret.hitpointsMax = this.m.AttributesMax.Hitpoints;
		ret.braveryMax = this.m.AttributesMax.Bravery;
		ret.fatigueMax = this.m.AttributesMax.Fatigue;
		ret.initiativeMax = this.m.AttributesMax.Initiative;
		ret.meleeSkillMax = this.m.AttributesMax.MeleeSkill;
		ret.rangeSkillMax = this.m.AttributesMax.RangedSkill;
		ret.meleeDefenseMax = this.m.AttributesMax.MeleeDefense;
		ret.rangeDefenseMax = this.m.AttributesMax.RangedDefense;
		return ret;
	}

	function isAbleToEquip( _item )
	{
		if (_item.isItemType(::Const.Items.ItemType.Armor) && ::Const.Items.NotForHumanArmorList.find(_item.getID()) != null)
		{
			return false;	
		}

		if (_item.isItemType(::Const.Items.ItemType.Helmet) && ::Const.Items.NotForHumanHelmetList.find(_item.getID()) != null)
		{
			return false;
		}

		return true;
	}

});

