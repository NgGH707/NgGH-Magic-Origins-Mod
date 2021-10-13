this.ghoul_player <- this.inherit("scripts/entity/tactical/player_beast", {
	m = {
		Size = 1,
		Head = 1,
		IsSkin = false,
		IsLuft = false,
		ScaleStartTime = 0,
		IsLoadingSaveData = false,
		IsBringInBattle = false,
		IsDegrade = false,
	},
	
	function getStrength()
	{
		return this.getType(true) == this.Const.EntityType.LegendSkinGhoul ? 1.1 * this.getSize() : 0.85 + (this.getSize() - 1) * 0.6;
	}
	
	function getSize()
	{
		return this.m.Size;
	}
	
	function getHealthRecoverMult()
	{
		return this.m.Size;
	}
	
	function getXPValue()
	{
		return this.m.XP * this.m.Size;
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
	    	local isSkinGhoul = this.getType(true) == this.Const.EntityType.LegendSkinGhoul || this.m.IsSkin;
	    	this.getSprite("body").setBrush(isSkinGhoul ? "bust_ghoulskin_body_01" : "bust_ghoul_body_01");
			this.getSprite("head").setBrush(isSkinGhoul ? "bust_ghoulskin_head_01" : "bust_ghoul_head_01");
			this.getSprite("injury").setBrush(isSkinGhoul ? "bust_ghoulskin_01_injured" : "bust_ghoul_01_injured");
	    	this.m.BloodSplatterOffset = this.createVec(0, 0);
			this.m.DecapitateSplatterOffset = this.createVec(33, -26);
			this.m.DecapitateBloodAmount = 0.7;
			this.m.BloodPoolScale = 0.7;
			this.getSprite("status_rooted").Scale = 0.45;
			this.setSpriteOffset("status_rooted", this.createVec(-4, 7));
	    	this.m.Size = 1;
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

	function onCombatStart()
	{
		this.player_beast.onCombatStart();
		
		if (!this.m.IsBringInBattle)
		{
			local size = this.getSize();

			if (size <= 2)
			{
				return;
			}

			local count = this.getFlags().getAsInt("hunger");

			if (--count <= 0)
			{
				this.m.IsDegrade = true;
				this.getFlags().set("hunger", 2);
			}
			else 
			{
				this.m.IsDegrade = false;
			    this.getFlags().set("hunger", count);
			}

			this.m.IsBringInBattle = true;
		}
	} 

	function onCombatFinished()
	{
		this.player_beast.onCombatFinished();
		
		if (this.m.IsBringInBattle)
		{
			if (this.onFeastingLeftOverCorpse())
			{
				this.m.IsDegrade = false;
			}

			if (this.m.IsDegrade)
			{
				local size = this.getSize();
				local newSize = this.Math.max(2, size - 1);
				this.setSize(newSize);
			}

			this.m.IsDegrade = false;
		}

		this.m.IsBringInBattle = false;
	}

	function onFeastingLeftOverCorpse()
	{
		if (this.getFlags().getAsInt("hunger") >= 2)
		{
			return true;
		}

		local allCorpses = this.Tactical.Entities.getCorpses();
		local tiles = [];
		local isFull = false;

		foreach (i, tile in allCorpses)
		{
		    if (tile.Properties.get("Corpse").IsConsumable)
		    {
		    	tiles.push(tile);
				tile.Properties.remove("Corpse");
				this.getFlags().set("hunger", this.Math.min(2, this.getFlags().getAsInt("hunger") + 1));
				this.setHitpoints(this.Math.min(this.getHitpoints() + 50, this.getHitpointsMax()));
		    }

		    if (this.getFlags().getAsInt("hunger") >= 2)
			{
				isFull = true;
				break;
			}
		}
		
		foreach ( tile in tiles ) 
		{
			this.Tactical.Entities.removeCorpse(tile);
		}

		return isFull;
	}
	
	function create()
	{
		this.player_beast.create();
		this.m.Type = this.Const.EntityType.Player;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Ghoul.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(33, -26);
		this.m.DecapitateBloodAmount = 0.7;
		this.m.BloodPoolScale = 0.7;
		this.m.hitpointsMax = 300;
		this.m.braveryMax = 225;
		this.m.fatigueMax = 400;
		this.m.initiativeMax = 350;
		this.m.meleeSkillMax = 120;
		this.m.rangeSkillMax = 50;
		this.m.meleeDefenseMax = 100;
		this.m.rangeDefenseMax = 100;
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/ghoul_hurt_01.wav",
			"sounds/enemies/ghoul_hurt_02.wav",
			"sounds/enemies/ghoul_hurt_03.wav",
			"sounds/enemies/ghoul_hurt_04.wav",
			"sounds/enemies/ghoul_hurt_05.wav",
			"sounds/enemies/ghoul_hurt_06.wav",
			"sounds/enemies/ghoul_hurt_07.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/ghoul_hurt_08.wav",
			"sounds/enemies/ghoul_hurt_09.wav",
			"sounds/enemies/ghoul_hurt_10.wav",
			"sounds/enemies/ghoul_hurt_11.wav",
			"sounds/enemies/ghoul_hurt_12.wav",
			"sounds/enemies/ghoul_hurt_13.wav",
			"sounds/enemies/ghoul_hurt_14.wav",
			"sounds/enemies/ghoul_hurt_15.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/ghoul_flee_05.wav",
			"sounds/enemies/ghoul_flee_06.wav",
			"sounds/enemies/ghoul_flee_07.wav",
			"sounds/enemies/ghoul_flee_08.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/ghoul_flee_01.wav",
			"sounds/enemies/ghoul_flee_02.wav",
			"sounds/enemies/ghoul_flee_03.wav",
			"sounds/enemies/ghoul_flee_04.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/ghoul_death_01.wav",
			"sounds/enemies/ghoul_death_02.wav",
			"sounds/enemies/ghoul_death_03.wav",
			"sounds/enemies/ghoul_death_04.wav",
			"sounds/enemies/ghoul_death_05.wav",
			"sounds/enemies/ghoul_death_06.wav",
			"sounds/enemies/ghoul_death_07.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
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
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/ghoul_grows_01.wav",
			"sounds/enemies/ghoul_grows_02.wav",
			"sounds/enemies/ghoul_grows_03.wav",
			"sounds/enemies/ghoul_grows_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other2] = [
			"sounds/enemies/ghoul_death_fullbelly_01.wav",
			"sounds/enemies/ghoul_death_fullbelly_02.wav",
			"sounds/enemies/ghoul_death_fullbelly_03.wav"
		];
		this.m.SoundPitch = 1.15;
		local onArmorHitSounds = this.getItems().getAppearance().ImpactSound;
		onArmorHitSounds[this.Const.BodyPart.Body] = this.Const.Sound.ArmorLeatherImpact;
		onArmorHitSounds[this.Const.BodyPart.Head] = this.Const.Sound.ArmorLeatherImpact;
		this.m.Items.blockAllSlots();
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Accessory] = false;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Head] = false;
		this.getFlags().add("ghoul");
		this.getFlags().add("undead");
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.player_beast.onDeath(_killer, _skill, _tile, _fatalityType);
		local flip = this.Math.rand(0, 100) < 50;
		local isResurrectable = _fatalityType != this.Const.FatalityType.Decapitated;
		local sprite_body = this.getSprite("body");
		local sprite_head = this.getSprite("head");

		if (_tile != null)
		{
			local decal;
			local skin = this.getSprite("body");
			this.m.IsCorpseFlipped = flip;
			decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = skin.Color;
			decal.Saturation = skin.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);

			if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [
					sprite_head.getBrush().Name + "_dead"
				];
				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-45, 10), 55.0, sprite_head.getBrush().Name + "_bloodpool");

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
				decal = _tile.spawnDetail(sprite_head.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = skin.Color;
				decal.Saturation = skin.Saturation;
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.Tile = _tile;
			corpse.Value = 2.0;
			corpse.IsResurrectable = false;
			corpse.Armor = this.m.BaseProperties.Armor;
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);

			local n = 1 + (this.Math.rand(1, 100) <= this.World.Assets.getExtraLootChance() ? 1 : 0);
			
			if (this.m.IsSkin)
			{
				local loot;
				loot = this.new("scripts/items/misc/legend_skin_ghoul_skin_item");
				loot.drop(_tile);
			}

			for( local i = 0; i < n; i = ++i )
			{
				if (this.Const.DLC.Unhold)
				{
					local r = this.Math.rand(1, 100);
					local loot;

					if (r <= 35)
					{
						loot = this.new("scripts/items/misc/ghoul_teeth_item");
					}
					else if (r <= 70)
					{
						loot = this.new("scripts/items/misc/ghoul_horn_item");
					}
					else
					{
						loot = this.new("scripts/items/misc/ghoul_brain_item");
					}

					loot.drop(_tile);
				}
				else
				{
					local loot = this.new("scripts/items/misc/ghoul_teeth_item");
					loot.drop(_tile);
				}
			}

			local loot = this.new("scripts/items/loot/growth_pearls_item");
			loot.drop(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}
	
	function onAfterDeath( _tile )
	{
		if (this.m.Size < 3)
		{
			return;
		}

		local skill = this.getSkills().getSkillByID("actives.swallow_whole");

		if (skill == null)
		{
			skill = this.getSkills().getSkillByID("actives.legend_skin_ghoul_swallow_whole");
			
			if (skill == null)
			{
				return;
			}
		}
		
		if (skill.getSwallowedEntity() == null)
		{
			return;
		}

		local e = skill.getSwallowedEntity();
		e.setIsAlive(true);
		this.Tactical.addEntityToMap(e, _tile.Coords.X, _tile.Coords.Y);
		
		if (!e.isPlayerControlled() && e.getType() != this.Const.EntityType.Serpent)
		{
			this.Tactical.getTemporaryRoster().remove(e);
		}
		
		e.getFlags().set("Devoured", false);
		
		if (e.hasSprite("dirt"))
		{
			local slime = e.getSprite("dirt");
			slime.setBrush("bust_slime");
			slime.setHorizontalFlipping(!e.isAlliedWithPlayer());
			slime.Visible = true;
		}
		else
		{
			local slime = e.addSprite("dirt");
			slime.setBrush("bust_slime");
			slime.setHorizontalFlipping(!e.isAlliedWithPlayer());
			slime.Visible = true;
		}
	}
	
	function onFactionChanged()
	{
		this.player_beast.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
		this.getSprite("accessory").setHorizontalFlipping(flip);
		this.getSprite("accessory_special").setHorizontalFlipping(flip);
		this.getSprite("body_blood").setHorizontalFlipping(flip);

		foreach( a in this.Const.CharacterSprites.Helmets )
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
		this.player_beast.onInit();
		local b = this.m.BaseProperties;
		b.IsAffectedByNight = false;
		b.IsImmuneToDisarm = true;
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		this.addSprite("miniboss");
		this.addSprite("body");
		
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		
		this.addSprite("head");
		local injury = this.addSprite("injury");
		injury.setBrush("bust_ghoul_01_injured");
		injury.Visible = false;
		
		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		local v = -10;
		local v2 = 5;

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, this.createVec(v2, v));
		}
		
		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_body_bloodied_02");
		body_blood.Visible = false;
		
		local hex = this.addSprite("status_hex");
		hex.Visible = false;
		local sweat = this.addSprite("status_sweat");
		local stunned = this.addSprite("status_stunned");
		stunned.setBrush(this.Const.Combat.StunnedBrush);
		stunned.Visible = false;
		local shield_icon = this.addSprite("shield_icon");
		shield_icon.Visible = false;
		local arms_icon = this.addSprite("arms_icon");
		arms_icon.Visible = false;
		local rooted = this.addSprite("status_rooted");
		rooted.Visible = false;
		rooted.Scale = this.getSprite("status_rooted_back").Scale;

		if (this.m.MoraleState != this.Const.MoraleState.Ignore)
		{
			local morale = this.addSprite("morale");
			morale.Visible = false;
		}
		
		this.getSprite("status_rooted").Scale = 0.45;
		this.setSpriteOffset("status_rooted", this.createVec(-4, 7));
	}
	
	function onAfterInit()
	{
		this.player_beast.onAfterInit();
		this.onAppearanceChanged(this.m.Items.getAppearance());
		this.onFactionChanged();
		this.m.Skills.add(this.new("scripts/skills/actives/gruesome_feast"));
		this.m.Skills.add(this.new("scripts/skills/effects/gruesome_feast_effect"));
		this.m.Skills.update();
	}
	
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.actor.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local offSetX = [
			5,
			7,
			13
		];
		local offSetY = [
			-13,
			-10,
			-10
		];
		local s = this.m.IsLoadingSaveData ? this.getFlags().getAsInt("size") : this.getSize();
		local i = this.Math.max(0, s - 1);

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}
			
			this.setSpriteOffset(a, this.createVec(offSetX[i], offSetY[i]));
			this.getSprite(a).Scale = s == 3 ? 1.15 : 1.0;
		}
		
		this.setAlwaysApplySpriteOffset(true);
	}

	function setScenarioValues( _isElite = false , _isSkinGhoul = false , _size = 1 , _Dub = false )
	{
		local b = this.m.BaseProperties;
		local type = this.Const.EntityType.Ghoul;
		local body = this.getSprite("body");
		local head = this.getSprite("head");
		local injury = this.getSprite("injury");
		local body_blood = this.getSprite("body_blood");

		switch (true) 
		{
		case _isSkinGhoul:
			type = this.Const.EntityType.LegendSkinGhoul;
		    b.setValues(this.Const.Tactical.Actor.LegendSkinGhoul);
			this.m.IsSkin = true;
			body.setBrush("bust_ghoulskin_body_01");
			head.setBrush("bust_ghoulskin_head_01");
			injury.setBrush("bust_ghoulskin_01_injured");
		    break;
		
		default:
			b.setValues(this.Const.Tactical.Actor.Ghoul);
			body.setBrush("bust_ghoul_body_01");
			head.setBrush("bust_ghoul_head_01");
			injury.setBrush("bust_ghoul_01_injured");
		}
		
		this.m.Head = this.Math.rand(1, 3);
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		body.varySaturation(0.25);
		body.varyColor(0.06, 0.06, 0.06);
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		injury.Visible = false;
		body_blood.setBrush("bust_body_bloodied_02");
		body_blood.Visible = false;

		if (_isElite || this.Math.rand(1, 100) == 100)
		{
			this.grow(true);
			this.getSkills().add(this.new("scripts/skills/racial/champion_racial"));
		}
		
		local background = this.new("scripts/skills/backgrounds/charmed_beast_background");
		background.setTo(type);
		this.m.Skills.add(background);
		background.onSetUp();
		background.buildDescription();
		
		local c = this.m.CurrentProperties;
		this.m.ActionPoints = c.ActionPoints;
		this.m.Hitpoints = c.Hitpoints;
		this.m.Talents = [];
		this.m.Attributes = [];
		this.fillBeastTalentValues(this.Math.rand(6, 9), true);
		this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);

		if (_size > 1)
		{
			this.setSize(_size);
		}
	}
	
	function grow( _instant = false )
	{
		if (this.m.Size == 3)
		{
			return;
		}

		if (!_instant && this.m.Sound[this.Const.Sound.ActorEvent.Other1].len() != 0)
		{
			this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Other1][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Other1].len() - 1)], this.Const.Sound.Volume.Actor, this.getPos());
		}

		this.m.Size = this.Math.min(3, this.m.Size + 1);
		local isSkinGhoul = this.getType(true) == this.Const.EntityType.LegendSkinGhoul || this.m.IsSkin;
		
		if (!isSkinGhoul)
		{
			if (this.m.Size == 2)
			{
				this.getSprite("body").setBrush("bust_ghoul_body_02");
				this.getSprite("head").setBrush("bust_ghoul_02_head_0" + this.m.Head);
				this.getSprite("injury").setBrush("bust_ghoul_02_injured");
				this.getSprite("injury").Visible = false;

				if (!_instant)
				{
					this.setRenderCallbackEnabled(true);
					this.m.ScaleStartTime = this.Time.getVirtualTimeF();
				}

				this.m.DecapitateSplatterOffset = this.createVec(33, -26);
				this.m.DecapitateBloodAmount = 1.0;
				this.m.BloodPoolScale = 1.0;
				this.getSprite("status_rooted").Scale = 0.5;
				this.getSprite("status_rooted_back").Scale = 0.5;
				this.setSpriteOffset("status_rooted", this.createVec(-4, 10));
				this.setSpriteOffset("status_rooted_back", this.createVec(-4, 10));
			}
			else if (this.m.Size == 3)
			{
				this.getSprite("body").setBrush("bust_ghoul_body_03");
				this.getSprite("head").setBrush("bust_ghoul_03_head_0" + this.m.Head);
				this.getSprite("injury").setBrush("bust_ghoul_03_injured");
				this.getSprite("injury").Visible = false;

				if (!_instant)
				{
					this.setRenderCallbackEnabled(true);
					this.m.ScaleStartTime = this.Time.getVirtualTimeF();
				}

				this.m.DecapitateSplatterOffset = this.createVec(35, -26);
				this.m.DecapitateBloodAmount = 1.5;
				this.m.BloodPoolScale = 1.33;
				this.getSprite("status_rooted").Scale = 0.6;
				this.getSprite("status_rooted_back").Scale = 0.6;
				this.setSpriteOffset("status_rooted", this.createVec(-7, 14));
				this.setSpriteOffset("status_rooted_back", this.createVec(-7, 14));
			}
		}
		else
		{
			if (this.m.Size == 2)
			{
				this.m.SoundPitch = 1.06;
				this.getSprite("body").setBrush("bust_ghoulskin_body_02");
				this.getSprite("head").setBrush("bust_ghoulskin_02_head_0" + this.m.Head);
				this.getSprite("injury").setBrush("bust_ghoulskin_02_injured");
				this.getSprite("injury").Visible = false;

				if (!_instant)
				{
					this.setRenderCallbackEnabled(true);
					this.m.ScaleStartTime = this.Time.getVirtualTimeF();
				}

				this.m.DecapitateSplatterOffset = this.createVec(33, -26);
				this.m.DecapitateBloodAmount = 1.0;
				this.m.BloodPoolScale = 1.0;
				this.getSprite("status_rooted").Scale = 0.5;
				this.getSprite("status_rooted_back").Scale = 0.5;
				this.setSpriteOffset("status_rooted", this.createVec(-4, 10));
				this.setSpriteOffset("status_rooted_back", this.createVec(-4, 10));
			}
			else if (this.m.Size == 3)
			{
				this.m.SoundPitch = 1.0;
				this.getSprite("body").setBrush("bust_ghoulskin_body_03");
				this.getSprite("head").setBrush("bust_ghoulskin_03_head_0" + this.m.Head);
				this.getSprite("injury").setBrush("bust_ghoulskin_03_injured");
				this.getSprite("injury").Visible = false;

				if (!_instant)
				{
					this.setRenderCallbackEnabled(true);
					this.m.ScaleStartTime = this.Time.getVirtualTimeF();
				}

				this.m.DecapitateSplatterOffset = this.createVec(35, -26);
				this.m.DecapitateBloodAmount = 1.5;
				this.m.BloodPoolScale = 1.33;
				this.getSprite("status_rooted").Scale = 0.6;
				this.getSprite("status_rooted_back").Scale = 0.6;
				this.setSpriteOffset("status_rooted", this.createVec(-7, 14));
				this.setSpriteOffset("status_rooted_back", this.createVec(-7, 14));
			}
		}

		this.m.SoundPitch = 1.2 - this.m.Size * 0.1;
		this.onAdjustingSprite(this.m.Items.getAppearance());
		this.m.Skills.update();
		this.setDirty(true);
	}

	function onRender()
	{
		this.actor.onRender();

		if (this.m.Size == 2)
		{
			this.getSprite("body").Scale = this.Math.minf(1.0, 0.96 + 0.04 * ((this.Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));
			this.getSprite("head").Scale = this.Math.minf(1.0, 0.96 + 0.04 * ((this.Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));
			this.moveSpriteOffset("body", this.createVec(0, -1), this.createVec(0, 0), 0.3, this.m.ScaleStartTime);

			if (this.moveSpriteOffset("head", this.createVec(0, -1), this.createVec(0, 0), 0.3, this.m.ScaleStartTime))
			{
				this.setRenderCallbackEnabled(false);
			}
		}
		else if (this.m.Size == 3)
		{
			this.getSprite("body").Scale = this.Math.minf(1.0, 0.94 + 0.06 * ((this.Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));
			this.getSprite("head").Scale = this.Math.minf(1.0, 0.94 + 0.06 * ((this.Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));
			this.moveSpriteOffset("body", this.createVec(0, -1), this.createVec(0, 0), 0.3, this.m.ScaleStartTime);

			if (this.moveSpriteOffset("head", this.createVec(0, -1), this.createVec(0, 0), 0.3, this.m.ScaleStartTime))
			{
				this.setRenderCallbackEnabled(false);
			}
		}
	}
	
	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
		local AttributesLevelUp = [
			{
				Min = 1,
				Max = 2
			},
			{
				Min = 2,
				Max = 3
			},
			{
				Min = 3,
				Max = 4
			},
			{
				Min = 3,
				Max = 4
			},
			{
				Min = 2,
				Max = 3
			},
			{
				Min = 1,
				Max = 1
			},
			{
				Min = 1,
				Max = 2
			},
			{
				Min = 1,
				Max = 2
			}
		];
		
		if (this.m.Attributes.len() == 0)
		{
			this.m.Attributes.resize(this.Const.Attributes.COUNT);

			for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
			{
				this.m.Attributes[i] = [];
			}
		}

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			for( local j = 0; j < _amount; j = ++j )
			{
				if (_minOnly)
				{
					this.m.Attributes[i].insert(0, this.Math.rand(1, this.Math.rand(1, 2)));
				}
				else if (_maxOnly)
				{
					this.m.Attributes[i].insert(0, AttributesLevelUp[i].Max);
				}
				else
				{
					this.m.Attributes[i].insert(0, this.Math.rand(AttributesLevelUp[i].Min + (this.m.Talents[i] == 3 ? 2 : this.m.Talents[i]), AttributesLevelUp[i].Max + (this.m.Talents[i] == 3 ? 1 : 0)));
				}
			}
		}
	}
	
	function getExcludeTraits()
	{
		return [
			"trait.tiny",
			"trait.bright",
			"trait.deathwish",
			"trait.superstitious",
			"trait.greedy",
			"trait.spartan",
			"trait.irrational",
			"trait.loyal",
			"trait.disloyal",
			"trait.survivor",
			"trait.paranoid",
			"trait.gift_of_people",
			"trait.double_tongued",
			"trait.seductive",
		];
	}

	function getPossibleSprites( _type )
	{
		local ret = [];
		local s = this.getSize();

		if (s == 1)
		{
			switch (_type) 
			{
		    case "body":
		        ret = [
		        	"bust_ghoul_body_01",
		        	"bust_ghoulskin_body_01",
		        ];
		        break;

		    case "head":
		        ret = [
		        	"bust_ghoul_head_01",
		        	"bust_ghoulskin_head_01",
		        ];
		        break;
			}
		}
		else 
		{
		    switch (_type) 
			{
		    case "body":
		        ret = [
		        	"bust_ghoul_body_0" + s,
		        	"bust_ghoulskin_body_0" + s,
		        ];
		        break;

		    case "head":
		        ret = [
		        	"bust_ghoul_0" + s + "_head_01",
		        	"bust_ghoul_0" + s + "_head_02",
		        	"bust_ghoul_0" + s + "_head_03",
		        	"bust_ghoulskin_0" + s + "_head_01",
		        	"bust_ghoulskin_0" + s + "_head_02",
		        	"bust_ghoulskin_0" + s + "_head_03",
		        ];
		        break;
			}
		}

		return ret;
	}
	
	function onSerialize( _out )
	{
		this.getFlags().set("size", this.m.Size);
		this.player_beast.onSerialize(_out);
		_out.writeU8(this.m.Size);
		_out.writeU8(this.m.Head);
		_out.writeBool(this.m.IsSkin);
		_out.writeBool(this.m.IsLuft);
	}
	
	function onDeserialize( _in )
	{
		this.m.IsLoadingSaveData = true;
		this.player_beast.onDeserialize(_in);
		this.m.Size = _in.readU8();
		this.m.Head = _in.readU8();
		this.m.IsSkin = _in.readBool();
		
		if (this.m.IsSkin)
		{
			this.getFlags().add("isSkinGhoul");
		}
		
		this.m.IsLuft = _in.readBool();
		
		this.m.IsLoadingSaveData = false;
	}

});

