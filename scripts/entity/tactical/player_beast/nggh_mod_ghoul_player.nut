this.nggh_mod_ghoul_player <- ::inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {
		Head = 0,
		Size = 1,
		ScaleStartTime = 0,
		IsLoadingSaveData = false,
		IsBroughtInBattle = false,
		IsInitGhoul = false,
	},
	function isSkinGhoul()
	{
		return this.getFlags().get("Type") == ::Const.EntityType.LegendSkinGhoul;
	}
	
	function getStrengthMult()
	{
		return this.isSkinGhoul() ? 1.1 * this.getSize() : 0.85 + (this.getSize() - 1) * 0.6;
	}

	function getHitpointsPerVeteranLevel()
	{
		return ::Math.rand(1, 2);
	}
	
	function getSize()
	{
		return this.m.Size;
	}
	
	// the bigger the boi the faster their regeneration OwO
	function getBonusHealthRecoverMult()
	{
		return this.getSize() * this.m.BonusHealthRecoverMult;
	}

	function setSize( _s ) 
	{
		if (this.m.Size == _s)
		{
			this.onAdjustingSprite(this.m.Items.getAppearance());
			return;
		}

	    if (_s <= 1)
	    {
	    	local isSkinGhoul = this.isSkinGhoul();
			this.m.Size = 1;
			this.m.BloodPoolScale = 0.7;
			this.m.DecapitateBloodAmount = 0.7;
			this.m.BloodSplatterOffset = ::createVec(0, 0);
			this.m.DecapitateSplatterOffset = ::createVec(33, -26);
			this.getSprite("body").setBrush(isSkinGhoul ? "bust_ghoulskin_body_01" : "bust_ghoul_body_01");
			this.getSprite("head").setBrush(isSkinGhoul ? "bust_ghoulskin_head_01" : "bust_ghoul_head_01");
			this.getSprite("injury").setBrush(isSkinGhoul ? "bust_ghoulskin_01_injured" : "bust_ghoul_01_injured");
			this.getSprite("status_rooted").Scale = 0.45;
			this.setSpriteOffset("status_rooted", ::createVec(-4, 7));
	    	this.onAdjustingSprite(this.m.Items.getAppearance());
	    }
	    else if (_s <= 2)
	    {
	    	this.m.Size = 1;
	    	this.grow(true);
	    }
	    else
	    {
	    	this.m.Size = 1;
	    	this.grow(true);
	    	this.grow(true);
	    }
	}
	
	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.BloodType = ::Const.BloodType.Red;
		this.m.BloodSplatterOffset = ::createVec(0, 0);
		this.m.DecapitateSplatterOffset = ::createVec(33, -26);
		this.m.DecapitateBloodAmount = 0.7;
		this.m.BloodPoolScale = 0.7;
		this.m.SignaturePerks = ["Pathfinder"];
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.Ghoul;
		this.m.AttributesLevelUp = ::Const.Nggh_AttributesLevelUp.Ghoul;
		this.m.BonusHealthRecoverMult = 0.35;
		this.m.AttributesMax = {
			Hitpoints = 300,
			Bravery = 200,
			Fatigue = 350,
			Initiative = 175,
			MeleeSkill = 120,
			RangedSkill = 50,
			MeleeDefense = 100,
			RangedDefense = 100,
		};
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/ghoul_hurt_01.wav",
			"sounds/enemies/ghoul_hurt_02.wav",
			"sounds/enemies/ghoul_hurt_03.wav",
			"sounds/enemies/ghoul_hurt_04.wav",
			"sounds/enemies/ghoul_hurt_05.wav",
			"sounds/enemies/ghoul_hurt_06.wav",
			"sounds/enemies/ghoul_hurt_07.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/ghoul_hurt_08.wav",
			"sounds/enemies/ghoul_hurt_09.wav",
			"sounds/enemies/ghoul_hurt_10.wav",
			"sounds/enemies/ghoul_hurt_11.wav",
			"sounds/enemies/ghoul_hurt_12.wav",
			"sounds/enemies/ghoul_hurt_13.wav",
			"sounds/enemies/ghoul_hurt_14.wav",
			"sounds/enemies/ghoul_hurt_15.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/ghoul_flee_05.wav",
			"sounds/enemies/ghoul_flee_06.wav",
			"sounds/enemies/ghoul_flee_07.wav",
			"sounds/enemies/ghoul_flee_08.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/ghoul_flee_01.wav",
			"sounds/enemies/ghoul_flee_02.wav",
			"sounds/enemies/ghoul_flee_03.wav",
			"sounds/enemies/ghoul_flee_04.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/ghoul_death_01.wav",
			"sounds/enemies/ghoul_death_02.wav",
			"sounds/enemies/ghoul_death_03.wav",
			"sounds/enemies/ghoul_death_04.wav",
			"sounds/enemies/ghoul_death_05.wav",
			"sounds/enemies/ghoul_death_06.wav",
			"sounds/enemies/ghoul_death_07.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/ghoul_idle_01.wav",
			"sounds/enemies/ghoul_idle_02.wav",
			"sounds/enemies/ghoul_idle_03.wav",
			"sounds/enemies/ghoul_idle_04.wav",
			"sounds/enemies/ghoul_idle_05.wav",
			"sounds/enemies/ghoul_idle_06.wav",
			"sounds/enemies/ghoul_idle_07.wav",
			"sounds/enemies/ghoul_idle_08.wav",
			"sounds/enemies/ghoul_idle_09.wav",
			"sounds/enemies/ghoul_idle_10.wav",
			"sounds/enemies/ghoul_idle_11.wav",
			"sounds/enemies/ghoul_idle_12.wav",
			"sounds/enemies/ghoul_idle_13.wav",
			"sounds/enemies/ghoul_idle_14.wav",
			"sounds/enemies/ghoul_idle_15.wav",
			"sounds/enemies/ghoul_idle_16.wav",
			"sounds/enemies/ghoul_idle_17.wav",
			"sounds/enemies/ghoul_idle_18.wav",
			"sounds/enemies/ghoul_idle_19.wav",
			"sounds/enemies/ghoul_idle_20.wav",
			"sounds/enemies/ghoul_idle_21.wav",
			"sounds/enemies/ghoul_idle_22.wav",
			"sounds/enemies/ghoul_idle_23.wav",
			"sounds/enemies/ghoul_idle_24.wav",
			"sounds/enemies/ghoul_idle_25.wav",
			"sounds/enemies/ghoul_idle_26.wav",
			"sounds/enemies/ghoul_idle_27.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/ghoul_grows_01.wav",
			"sounds/enemies/ghoul_grows_02.wav",
			"sounds/enemies/ghoul_grows_03.wav",
			"sounds/enemies/ghoul_grows_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Other2] = [
			"sounds/enemies/ghoul_death_fullbelly_01.wav",
			"sounds/enemies/ghoul_death_fullbelly_02.wav",
			"sounds/enemies/ghoul_death_fullbelly_03.wav"
		];
		this.m.SoundPitch = 1.15;
		this.m.Flags.add("undead");
		this.m.Flags.add("ghoul");

		// can't equip most thing
		local items = this.getItems();
		items.getData()[::Const.ItemSlot.Offhand][0] = -1;
		items.getData()[::Const.ItemSlot.Mainhand][0] = -1;
		items.getData()[::Const.ItemSlot.Body][0] = -1;
		items.getData()[::Const.ItemSlot.Ammo][0] = -1;
		local onArmorHitSounds = items.getAppearance().ImpactSound;
		onArmorHitSounds[::Const.BodyPart.Body] = ::Const.Sound.ArmorLeatherImpact;
		onArmorHitSounds[::Const.BodyPart.Head] = ::Const.Sound.ArmorLeatherImpact;
	}

	function onCombatStart()
	{
		this.nggh_mod_player_beast.onCombatStart();
		
		if (this.getSize() <= 1)
		{
			return;
		}

		this.getFlags().set("has_eaten", false);
		this.m.IsBroughtInBattle = true;
	} 

	function onCombatFinished()
	{
		this.nggh_mod_player_beast.onCombatFinished();
		
		if (this.m.IsBroughtInBattle && !this.checkHunger())
		{
			this.setSize(::Math.max(1, this.getSize() - 1));
		}

		this.m.IsBroughtInBattle = false;
	}

	function checkHunger()
	{
		if (this.onFeastingLeftoverCorpses())
		{
			this.improveMood(0.5, "Had a great meal");
			return true;
		}

		this.worsenMood(1.5, "Starved");
		return false;
	}

	// hungry boi luv cleaning up the feasting field :3
	function onFeastingLeftoverCorpses()
	{	
		local hasEaten = this.getFlags().get("has_eaten");
		local perk = this.getSkills().getSkillByID("perk.nacho_scavenger");

		if (perk == null)
		{
			return hasEaten;
		}

		if (hasEaten)
		{
			perk.applyEffect();
			return true;
		}

		local garbage = [];
		local corpses = ::Tactical.Entities.getCorpses();
		local hp = ::Nggh_MagicConcept.IsOPMode ? 100 : 25;
		local num = corpses.len() - 1;

		for (local i = num; i >= 0; --i) 
		{
			local tile = corpses[i];

			if (tile.Properties.get("Corpse") == null)
			{
				garbage.push(tile);
				continue;
			}

		    if (tile.Properties.get("Corpse").IsConsumable)
		    {
				this.getFlags().set("has_eaten", true);
				this.setHitpoints(::Math.min(this.getHitpoints() + hp, this.getHitpointsMax()));
				tile.Properties.remove("Corpse");
				garbage.push(tile);
				perk.applyEffect();
				hasEaten = true;
				break;
		    }
		}

		foreach (tile in garbage)
		{
			::Tactical.Entities.removeCorpse(tile);
		}

		return hasEaten;
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.nggh_mod_player_beast.onDeath(_killer, _skill, _tile, _fatalityType);
		local flip = this.m.IsCorpseFlipped;
		local sprite_body = this.getSprite("body");
		local sprite_head = this.getSprite("head");

		if (_tile != null)
		{
			local skin = this.getSprite("body");
			local decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = skin.Color;
			decal.Saturation = skin.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);

			if (_fatalityType == ::Const.FatalityType.Decapitated)
			{
				local layers = [
					sprite_head.getBrush().Name + "_dead"
				];
				local decap = ::Tactical.spawnHeadEffect(this.getTile(), layers, ::createVec(-45, 10), 55.0, sprite_head.getBrush().Name + "_bloodpool");

				foreach( sprite in decap )
				{
					sprite.Color = skin.Color;
					sprite.Saturation = skin.Saturation;
					sprite.Scale = 0.9;
					sprite.setBrightness(0.9);
				}
			}
			else
			{
				decal = _tile.spawnDetail(sprite_head.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = skin.Color;
				decal.Saturation = skin.Saturation;
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_arrows", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}
			else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_javelin", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
			local corpse = clone ::Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsResurrectable = false;
			corpse.IsConsumable = _fatalityType != ::Const.FatalityType.Unconscious;
			corpse.Items = _fatalityType != ::Const.FatalityType.Unconscious ? this.getItems() : null;
			corpse.IsHeadAttached = _fatalityType != ::Const.FatalityType.Decapitated;
			corpse.Tile = _tile;
			corpse.Value = 10.0;
			corpse.IsPlayer = true;
			_tile.Properties.set("Corpse", corpse);
			::Tactical.Entities.addCorpse(_tile);

			// always drop
			::new("scripts/items/loot/growth_pearls_item").drop(_tile);

			if (_fatalityType == ::Const.FatalityType.Unconscious)
			{
				return;
			}

			local n = 1 + (::Math.rand(1, 100) <= ::World.Assets.getExtraLootChance() ? 1 : 0);
			local isSkinGhoul = this.isSkinGhoul();

			for( local i = 0; i < n; i = ++i )
			{
				local r = ::Math.rand(1, 100);

				if (isSkinGhoul && r <= 35)
				{
					::new("scripts/items/misc/legend_skin_ghoul_skin_item").drop(_tile);
				}
				else if (r <= 35)
				{
					::new("scripts/items/misc/ghoul_teeth_item").drop(_tile);
				}
				else if (r <= 70)
				{
					::new("scripts/items/misc/ghoul_horn_item").drop(_tile);
				}
				else
				{
					::new("scripts/items/misc/ghoul_brain_item").drop(_tile);
				}
			}
		}
	}
	
	function onAfterDeath( _tile )
	{
		if (this.m.Size < 3)
		{
			return null;
		}

		local skill = this.getSkills().getSkillByID("actives.swallow_whole");

		if (skill == null)
		{
			skill = this.getSkills().getSkillByID("actives.legend_skin_ghoul_swallow_whole");
			
			if (skill == null)
			{
				return null;
			}
		}
		
		if (skill.getSwallowedEntity() == null)
		{
			return null;
		}

		local e = skill.getSwallowedEntity();
		e.setIsAlive(true);
		::Tactical.addEntityToMap(e, _tile.Coords.X, _tile.Coords.Y);
		e.getFlags().set("Devoured", false);
		
		// serpents are weird so i have to make an exception 
		if (!e.isPlayerControlled() && e.getType() != ::Const.EntityType.Serpent)
		{
			::Tactical.getTemporaryRoster().remove(e);
		}

		::Tactical.TurnSequenceBar.addEntity(e);
		
		if (e.hasSprite("dirt"))
		{
			local slime = e.getSprite("dirt");
			slime.setBrush("bust_slime");
			slime.setHorizontalFlipping(!e.isAlliedWithPlayer());
			slime.Visible = true;
		}

		return e;
	}
	
	function onAfterFactionChanged()
	{
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("accessory").setHorizontalFlipping(!flip);
		this.getSprite("accessory_special").setHorizontalFlipping(!flip);
		this.getSprite("body_blood").setHorizontalFlipping(flip);

		this.nggh_mod_player_beast.onAfterFactionChanged();
	}

	function onInit()
	{
		this.nggh_mod_player_beast.onInit();
		local b = this.m.BaseProperties;
		b.IsAffectedByNight = false;
		b.IsImmuneToDisarm = true;
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		this.removeSprite("body");

		this.addSprite("miniboss");
		this.addSprite("body");
		
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		
		this.addSprite("head");
		local injury = this.addSprite("injury");
		injury.setBrush("bust_ghoul_01_injured");
		injury.Visible = false;
		
		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}
		
		/* i probably should remove this part
		local v = ::createVec(5, -10);
		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, v);
		}
		*/
		
		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_body_bloodied_02");
		body_blood.Visible = false;
		
		this.m.IsInitGhoul = true;
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.45;
		this.setSpriteOffset("status_rooted", ::createVec(-4, 7));
	}
	
	function onAfterInit()
	{
		this.nggh_mod_player_beast.onAfterInit();
		this.m.Skills.add(::new("scripts/skills/actives/gruesome_feast"));
		this.m.Skills.add(::new("scripts/skills/effects/gruesome_feast_effect"));
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_nacho_vomit_skill"));
	}

	function addDefaultStatusSprites()
	{
		if (this.m.IsInitGhoul)
		{
			this.addSprite("dirt");
		}
		
		local hex = this.addSprite("status_hex");
		hex.Visible = false;
		local sweat = this.addSprite("status_sweat");
		local stunned = this.addSprite("status_stunned");
		stunned.setBrush(::Const.Combat.StunnedBrush);
		stunned.Visible = false;
		local shield_icon = this.addSprite("shield_icon");
		shield_icon.Visible = false;
		local arms_icon = this.addSprite("arms_icon");
		arms_icon.Visible = false;
		local rooted = this.addSprite("status_rooted");
		rooted.Visible = false;
		rooted.Scale = this.getSprite("status_rooted_back").Scale;

		if (this.m.MoraleState != ::Const.MoraleState.Ignore)
		{
			local morale = this.addSprite("morale");
			morale.Visible = false;
		}
	}
	
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.actor.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local offSetX = [5, 7, 13];
		local offSetY = [-13,-10,-10];
		local size = this.m.IsLoadingSaveData ? this.getFlags().getAsInt("Size") : this.getSize();
		local i = ::Math.max(0, size - 1);
		local v = ::createVec(offSetX[i], offSetY[i]);
		local s = size == 3 ? 1.15 : 1.0;

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}
			
			this.setSpriteOffset(a, v);
			this.getSprite(a).Scale = s;
		}
		
		this.setAlwaysApplySpriteOffset(true);
	}

	function setStartValuesEx( _isElite = false , _isSkinGhoul = false , _size = 1 , _parameter = null )
	{
		local b = this.m.BaseProperties;
		local type = _isSkinGhoul ? ::Const.EntityType.LegendSkinGhoul : ::Const.EntityType.Ghoul;
		local body = this.getSprite("body");
		local head = this.getSprite("head");
		local injury = this.getSprite("injury");
		local body_blood = this.getSprite("body_blood");

		switch (true) 
		{
		case _isSkinGhoul:
		    b.setValues(::Const.Tactical.Actor.LegendSkinGhoul);
			body.setBrush("bust_ghoulskin_body_01");
			head.setBrush("bust_ghoulskin_head_01");
			injury.setBrush("bust_ghoulskin_01_injured");
		    break;
		
		default:
			b.setValues(::Const.Tactical.Actor.Ghoul);
			body.setBrush("bust_ghoul_body_01");
			head.setBrush("bust_ghoul_head_01");
			injury.setBrush("bust_ghoul_01_injured");
		}
		
		// update the properties
		this.m.Variant = ::Math.rand(1, 3);
		this.m.CurrentProperties = clone b;
		
		body.varySaturation(0.25);
		body.varyColor(0.06, 0.06, 0.06);
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		injury.Visible = false;
		body_blood.setBrush("bust_body_bloodied_02");
		body_blood.Visible = false;
		this.addDefaultBackground(type);

		if (_size > 1)
		{
			this.setSize(_size);
		}

		this.setScenarioValues(type, _isElite);
	}

	function setScenarioValues( _type, _isElite = false, _randomizedTalents = false, _setName = false )
	{
		this.nggh_mod_player_beast.setScenarioValues(_type, _isElite, _randomizedTalents, _setName);

		if (this.m.Skills.hasSkill("racial.champion"))
		{
			// UwU champion nacho is always a big bara boi
			this.grow(true);
		}
	}
	
	function grow( _instant = false )
	{
		if (this.m.Size >= 3)
		{
			return;
		}

		if (!_instant && this.m.Sound[::Const.Sound.ActorEvent.Other1].len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.Sound[::Const.Sound.ActorEvent.Other1]), ::Const.Sound.Volume.Actor, this.getPos());
		}

		this.m.Size = ::Math.min(3, this.m.Size + 1);
		local isSkinGhoul = this.isSkinGhoul();
		
		if (!isSkinGhoul)
		{
			if (this.m.Size == 2)
			{
				this.getSprite("body").setBrush("bust_ghoul_body_02");
				this.getSprite("head").setBrush("bust_ghoul_02_head_0" + this.m.Variant);
				this.getSprite("injury").setBrush("bust_ghoul_02_injured");
				this.getSprite("injury").Visible = false;

				if (!_instant)
				{
					this.setRenderCallbackEnabled(true);
					this.m.ScaleStartTime = ::Time.getVirtualTimeF();
				}

				this.m.DecapitateSplatterOffset = ::createVec(33, -26);
				this.m.DecapitateBloodAmount = 1.0;
				this.m.BloodPoolScale = 1.0;
				this.getSprite("status_rooted").Scale = 0.5;
				this.getSprite("status_rooted_back").Scale = 0.5;
				this.setSpriteOffset("status_rooted", ::createVec(-4, 10));
				this.setSpriteOffset("status_rooted_back", ::createVec(-4, 10));
			}
			else if (this.m.Size == 3)
			{
				this.getSprite("body").setBrush("bust_ghoul_body_03");
				this.getSprite("head").setBrush("bust_ghoul_03_head_0" + this.m.Variant);
				this.getSprite("injury").setBrush("bust_ghoul_03_injured");
				this.getSprite("injury").Visible = false;

				if (!_instant)
				{
					this.setRenderCallbackEnabled(true);
					this.m.ScaleStartTime = ::Time.getVirtualTimeF();
				}

				this.m.DecapitateSplatterOffset = ::createVec(35, -26);
				this.m.DecapitateBloodAmount = 1.5;
				this.m.BloodPoolScale = 1.33;
				this.getSprite("status_rooted").Scale = 0.6;
				this.getSprite("status_rooted_back").Scale = 0.6;
				this.setSpriteOffset("status_rooted", ::createVec(-7, 14));
				this.setSpriteOffset("status_rooted_back", ::createVec(-7, 14));
			}
		}
		else
		{
			if (this.m.Size == 2)
			{
				this.m.SoundPitch = 1.06;
				this.getSprite("body").setBrush("bust_ghoulskin_body_02");
				this.getSprite("head").setBrush("bust_ghoulskin_02_head_0" + this.m.Variant);
				this.getSprite("injury").setBrush("bust_ghoulskin_02_injured");
				this.getSprite("injury").Visible = false;

				if (!_instant)
				{
					this.setRenderCallbackEnabled(true);
					this.m.ScaleStartTime = ::Time.getVirtualTimeF();
				}

				this.m.DecapitateSplatterOffset = ::createVec(33, -26);
				this.m.DecapitateBloodAmount = 1.0;
				this.m.BloodPoolScale = 1.0;
				this.getSprite("status_rooted").Scale = 0.5;
				this.getSprite("status_rooted_back").Scale = 0.5;
				this.setSpriteOffset("status_rooted", ::createVec(-4, 10));
				this.setSpriteOffset("status_rooted_back", ::createVec(-4, 10));
			}
			else if (this.m.Size == 3)
			{
				this.m.SoundPitch = 1.0;
				this.getSprite("body").setBrush("bust_ghoulskin_body_03");
				this.getSprite("head").setBrush("bust_ghoulskin_03_head_0" + this.m.Variant);
				this.getSprite("injury").setBrush("bust_ghoulskin_03_injured");
				this.getSprite("injury").Visible = false;

				if (!_instant)
				{
					this.setRenderCallbackEnabled(true);
					this.m.ScaleStartTime = ::Time.getVirtualTimeF();
				}

				this.m.DecapitateSplatterOffset = ::createVec(35, -26);
				this.m.DecapitateBloodAmount = 1.5;
				this.m.BloodPoolScale = 1.33;
				this.getSprite("status_rooted").Scale = 0.6;
				this.getSprite("status_rooted_back").Scale = 0.6;
				this.setSpriteOffset("status_rooted", ::createVec(-7, 14));
				this.setSpriteOffset("status_rooted_back", ::createVec(-7, 14));
			}
		}

		this.m.SoundPitch = 1.2 - this.m.Size * 0.1;
		this.onAdjustingSprite(this.m.Items.getAppearance());
		this.m.Skills.update();
		this.setDirty(true);
	}

	function onRender()
	{
		this.nggh_mod_player_beast.onRender();

		if (this.m.Size == 2)
		{
			this.getSprite("body").Scale = ::Math.minf(1.0, 0.96 + 0.04 * ((::Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));
			this.getSprite("head").Scale = ::Math.minf(1.0, 0.96 + 0.04 * ((::Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));
			this.moveSpriteOffset("body", ::createVec(0, -1), ::createVec(0, 0), 0.3, this.m.ScaleStartTime);

			if (this.moveSpriteOffset("head", ::createVec(0, -1), ::createVec(0, 0), 0.3, this.m.ScaleStartTime))
			{
				this.setRenderCallbackEnabled(false);
			}
		}
		else if (this.m.Size == 3)
		{
			this.getSprite("body").Scale = ::Math.minf(1.0, 0.94 + 0.06 * ((::Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));
			this.getSprite("head").Scale = ::Math.minf(1.0, 0.94 + 0.06 * ((::Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));
			this.moveSpriteOffset("body", ::createVec(0, -1), ::createVec(0, 0), 0.3, this.m.ScaleStartTime);

			if (this.moveSpriteOffset("head", ::createVec(0, -1), ::createVec(0, 0), 0.3, this.m.ScaleStartTime))
			{
				this.setRenderCallbackEnabled(false);
			}
		}
	}

	function getPossibleSprites( _layer )
	{
		local s = this.getSize();

		// has to do this cuz tier 1 nacho doesn't have different variant 
		if (s == 1) 
		{
			switch (_layer) 
			{
		    case "body":
		        return [
		        	"bust_ghoul_body_01",
		        	"bust_ghoulskin_body_01",
		        ];

		    case "head":
		        return [
		        	"bust_ghoul_head_01",
		        	"bust_ghoulskin_head_01",
		        ];
			}

			return [];
		}
		
	    switch (_layer) 
		{
	    case "body":
	        return [
	        	"bust_ghoul_body_0" + s,
	        	"bust_ghoulskin_body_0" + s,
	        ];

	    case "head":
	        return [
	        	"bust_ghoul_0" + s + "_head_01",
	        	"bust_ghoul_0" + s + "_head_02",
	        	"bust_ghoul_0" + s + "_head_03",
	        	"bust_ghoulskin_0" + s + "_head_01",
	        	"bust_ghoulskin_0" + s + "_head_02",
	        	"bust_ghoulskin_0" + s + "_head_03",
	        ];
		}

		return [];
	}

	function updateVariant()
	{
		local app = this.getItems().getAppearance();
		local brush = this.getSprite("body").getBrush().Name;
		app.Body = brush;
		app.Corpse = brush + "_dead";

		this.m.Head = this.m.Variant;
	}
	
	function onSerialize( _out )
	{
		this.getFlags().set("Size", this.m.Size);
		this.nggh_mod_player_beast.onSerialize(_out);
		_out.writeU8(this.m.Size);
	}
	
	function onDeserialize( _in )
	{
		this.m.IsLoadingSaveData = true;
		this.nggh_mod_player_beast.onDeserialize(_in);
		this.m.Size = _in.readU8();
		this.m.IsLoadingSaveData = false;

		this.getBackground().addPerk(::Const.Perks.PerkDefs.NggHNachoScavenger, 6);
	}

});

