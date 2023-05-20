this.nggh_mod_hexe_background <- ::inherit("scripts/skills/backgrounds/character_background", {
	m = {
		IsCharming = false,
		IsDeserializing = false,
		PerkGroupMultipliers = [],
	},
	function create()
	{
		this.character_background.create();
		this.m.Icon = "ui/backgrounds/background_hexe.png";
		this.m.HiringCost = 30000;
		this.m.DailyCost = 0;
		this.m.Excluded = [
			"trait.strong",
			"trait.tough",
			"trait.dumb",
			"trait.superstitious",
			"trait.brute",
			"trait.fear_beasts",
			"trait.huge",
			"trait.heavy",
			"trait.aggressive",
		];
		
		this.m.ExcludedTalents = [
			::Const.Attributes.Hitpoints,
			::Const.Attributes.Fatigue,
			::Const.Attributes.MeleeSkill,
			::Const.Attributes.MeleeDefense
		];
		this.m.Names = ::Const.Strings.HexePlayerNames;
		this.m.HairColors = ::Const.HairColors.Old;
		this.m.Beards = null;
		this.m.BeardChance = 0;
		
		this.addBackgroundType(::Const.BackgroundType.Educated);
		this.addBackgroundType(::Const.BackgroundType.Female);

		this.m.AlignmentMin = ::Const.LegendMod.Alignment.Dreaded;
		this.m.AlignmentMax = ::Const.LegendMod.Alignment.Merciless;
		this.m.Modifiers.Meds = ::Const.LegendMod.ResourceModifiers.Meds[2];
		this.m.Modifiers.Stash = ::Const.LegendMod.ResourceModifiers.Stash[0];
		this.m.Modifiers.Healing = ::Const.LegendMod.ResourceModifiers.Healing[3];
		this.m.Modifiers.Barter = ::Const.LegendMod.ResourceModifiers.Barter[1];
	}

	function addPerkTreesToCustomPerkTree(_customPerkTree, _treesToAdd)
	{
		foreach (tree in _treesToAdd)
		{
			for (local i = 0; i < tree.Tree.len(); i++)
			{
				foreach (perk in tree.Tree[i])
				{
					_customPerkTree[i].push(perk);
				}
			}
		}
	}

	function removePerkFromCustomPerkTree( _perk )
	{
		local r;
		local index;

		foreach (i, row in this.m.CustomPerkTree)
		{
			foreach (j, perk in row)
			{
				if (perk == _perk)
				{
					r = i;
					index = j;
					break;
				}
			}
		}

		if (r == null || index == null)
		{
			return false;
		}

		this.m.CustomPerkTree[r].remove(index);
		return true;
	}

	function onAdded()
	{
		if (this.m.IsNew)
		{
			// add the unique flag
			this.getContainer().getActor().getFlags().set("Hexe", 0);
			this.getContainer().getActor().getFlags().get("IsSpecial");
		}

		this.character_background.onAdded();
		this.setupSpriteLayers();
		this.setupUpdateInjuryLayer();
		this.setupSoundSettings();
		this.setupDefaultSkills();
		this.getContainer().getActor().setDirty(true);
	}

	function setupSpriteLayers()
	{
		local actor = this.getContainer().getActor().get();
		actor.m.DecapitateSplatterOffset = ::createVec(-8, -26);

		actor.removeSprite("miniboss");
		actor.removeSprite("status_hex");
		actor.removeSprite("status_sweat");
		actor.removeSprite("status_stunned");
		actor.removeSprite("shield_icon");
		actor.removeSprite("arms_icon");
		actor.removeSprite("status_rooted");
		actor.removeSprite("morale");
		
		local charm_body = actor.addSprite("charm_body");
		charm_body.setHorizontalFlipping(true);
		charm_body.Visible = false;
		local charm_armor = actor.addSprite("charm_armor");
		charm_armor.setHorizontalFlipping(true);
		charm_armor.Visible = false;
		local charm_head = actor.addSprite("charm_head");
		charm_head.setHorizontalFlipping(true);
		charm_head.Visible = false;
		local charm_hair = actor.addSprite("charm_hair");
		charm_hair.setHorizontalFlipping(true);
		charm_hair.Visible = false;
		
		actor.addDefaultStatusSprites();
		actor.getSprite("status_rooted").Scale = 0.55;
		actor.setSpriteOffset("status_rooted", ::createVec(0, 5));

		local old_getBarterModifier = actor.getBarterModifier;
		actor.getBarterModifier = function()
		{
			local mod = old_getBarterModifier();

			local skill = this.getSkills().getSkillByID("perk.boobas_charm");

			if (skill != null)
			{
				mod += skill.getModifier();
			}

			return mod;
		}
	}

	function setupUpdateInjuryLayer()
	{
		local actor = this.getContainer().getActor().get();

		// she will always die, no salvation
		actor.isReallyKilled = function( _fatalityType )
		{
			return true;
		}

		// she has a bit different way to show her injuries
		actor.onUpdateInjuryLayer = function()
		{
			local cursed = this.getSkills().getSkillByID("effects.cursed");
			local lesserCursed = this.getSkills().getSkillByID("effects.lesser_cursed");
			local injury = this.getSprite("injury");
			local injury_body = this.getSprite("injury_body");
			local p = this.getHitpointsPct();
			
			if (cursed != null || lesserCursed != null)
			{
				if (this.getBackground().m.IsCharming)
				{
					return;
				}

				if (p > 0.66)
				{
					this.setDirty(this.m.IsDirty || injury.Visible || injury_body.Visible);
					injury.Visible = false;
					injury_body.Visible = false;
				}
				else
				{
					this.setDirty(this.m.IsDirty || !injury.Visible || !injury_body.Visible);
					injury.setBrush("bust_head_injured_01");
					injury.Visible = true;
					injury_body.Visible = true;

					if (p > 0.4)
					{
						injury_body.Visible = false;
					}
					else
					{
						injury_body.setBrush("bust_hexen_true_body_injured");
						injury_body.Visible = true;
					}
				}

				return;
			}

			if (p > 0.66)
			{
				this.setDirty(this.m.IsDirty || injury.Visible || injury_body.Visible);
				injury.Visible = false;
				injury_body.Visible = false;
			}
			else
			{
				this.setDirty(this.m.IsDirty || !injury.Visible || !injury_body.Visible);
				injury.Visible = true;
				injury_body.Visible = true;

				if (p > 0.33)
				{
					injury.setBrush("bust_head_injured_01");
				}
				else
				{
					injury.setBrush("bust_head_injured_02");
				}

				if (p > 0.4)
				{
					injury_body.Visible = false;
				}
				else
				{
					injury_body.setBrush("bust_hexen_fake_body_00_injured");
					injury_body.Visible = true;
				}
			}
		}
	}

	function setupSoundSettings()
	{
		local actor = this.getContainer().getActor().get();

		actor.playIdleSound <- function()
		{
			if (::Math.rand(1, 30) <= 10)
			{
				this.playSound(::Const.Sound.ActorEvent.Idle, ::Const.Sound.Volume.Actor * ::Const.Sound.Volume.ActorIdle * this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] * this.m.SoundVolumeOverall * (::Math.rand(60, 100) * 0.01) * (this.isHiddenToPlayer ? 0.33 : 1.0), this.m.SoundPitch * (::Math.rand(85, 115) * 0.01));
			}
			else
			{
				this.playSound(::Const.Sound.ActorEvent.Other1, ::Const.Sound.Volume.Actor * ::Const.Sound.Volume.ActorIdle * this.m.SoundVolume[::Const.Sound.ActorEvent.Other1] * this.m.SoundVolumeOverall * (::Math.rand(60, 100) * 0.01) * (this.isHiddenToPlayer ? 0.33 : 1.0), this.m.SoundPitch * (::Math.rand(85, 115) * 0.01));
			}
		}
	}

	function setupDefaultSkills()
	{
	}

	function getMagicalDefense()
	{
		local lv = this.getContainer().getActor().getLevel();
		return lv < 11 ? lv * 2 : (lv - 11) * 1 + 20;
	}

	function onTurnStart()
	{
		this.getContainer().getActor().playIdleSound();
	}

	function onResumeTurn()
	{
		this.getContainer().getActor().playIdleSound();
	}

	function onUpdate( _properties )
	{
		// being too beautiful/ugly has its disadvantage
		_properties.TargetAttractionMult *= 1.25;

		// why not
		_properties.Vision += 1;

		// should i remove this, it's kinda an unfair advantage
		//_properties.IsImmuneToDisarm = true;

		// she has way to defend against this kind of magic/curse
		_properties.IsImmuneToDamageReflection = true;

		// she is not a fighter, being allowed to stay out of violent or a threat of getting killed always a thing she will never refuse
		_properties.IsContentWithBeingInReserve = true;

		// she has certain amount of magic/curse resistance
		_properties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack] += this.getMagicalDefense();
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
			{
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + ::Const.UI.Color.NegativeValue + "]Charm[/color] and [color=" + ::Const.UI.Color.NegativeValue + "]Hex[/color]"
			},
		];

		if (this.getContainer() == null || this.getContainer().getActor() == null)
		{
			return ret;
		}

		ret.extend(this.getAttributesTooltip());
		return ret;
	}

	function getNachoAppearance()
	{
		if (!::World.Flags.get("IsLuftAdventure"))
		{
			return null;
		}

		local r = ::Math.rand(1, 4);
		local ret = [];
		ret.push(r == 1 ? "bust_ghoulskin_head_01" : "bust_ghoulskin_0" + r + "_head_0" + ::Math.rand(1, 3));
		ret.push((::Math.rand(1, 2) == 1 ? "bust_boobas_ghoul_body_0" : "bust_boobas_ghoul_with_dress_0") + r);
		return ret;
	}
	
	function setCharming( _f )
	{
		if (_f == this.m.IsCharming)
		{
			return;
		}
		
		this.m.IsCharming = _f;
		local t = 300;
		local isNude = false;
		local actor = this.getContainer().getActor();
		local nudist = actor.getSkills().getSkillByID("perk.charm_nudist")

		if (nudist != null)
		{
			isNude = nudist.getBonus() != 0;
		}

		if (this.m.IsCharming)
		{
			local a = this.getNachoAppearance();
			local sprite;

			if (a != null)
			{
				sprite = actor.getSprite("charm_body");
				sprite.setBrush(a[1]);
				sprite.Visible = true;
				sprite.fadeIn(t);

				sprite = actor.getSprite("charm_head");
				sprite.setBrush(a[0]);
				sprite.Visible = true;
				sprite.fadeIn(t);

				sprite = actor.getSprite("charm_armor");
				sprite.resetBrush();
				
				sprite = actor.getSprite("charm_hair");
				sprite.resetBrush();
			}
			else 
			{
			    sprite = actor.getSprite("charm_body");
				sprite.setBrush("bust_hexen_charmed_body_01");
				sprite.Visible = true;
				sprite.fadeIn(t);
				sprite = actor.getSprite("charm_armor");
				sprite.setBrush("bust_hexen_charmed_dress_0" + ::Math.rand(1, 3));
				sprite.Visible = !isNude;
				sprite.fadeIn(t);
				sprite = actor.getSprite("charm_head");
				sprite.setBrush("bust_hexen_charmed_head_0" + ::Math.rand(1, 2));
				sprite.Visible = true;
				sprite.fadeIn(t);
				sprite = actor.getSprite("charm_hair");
				sprite.setBrush("bust_hexen_charmed_hair_0" + ::Math.rand(1, 5));
				sprite.Visible = true;
				sprite.fadeIn(t);
			}
			
			this.onAllSpritesHidden(true);
			::Time.scheduleEvent(::TimeUnit.Virtual, t + 100, function ( _e )
			{
				if (!_e.isAlive())
				{
					return;
				}
				
				local sprite;
				local isNude = false;
				local nudist = _e.getSkills().getSkillByID("perk.charm_nudist")

				if (nudist != null)
				{
					isNude = nudist.getBonus() != 0;
				}

				sprite = _e.getSprite("charm_body");
				sprite.Visible = true;
				sprite = _e.getSprite("charm_armor");
				sprite.Visible = !isNude;
				sprite = _e.getSprite("charm_head");
				sprite.Visible = true;
				sprite = _e.getSprite("charm_hair");
				sprite.Visible = true;
				this.onAllSpritesHidden(true);
				_e.setDirty(true);
			}.bindenv(this), actor.get());
		}
		else
		{
			local sprite;
			sprite = actor.getSprite("charm_body");
			sprite.fadeOutAndHide(t);
			sprite = actor.getSprite("charm_armor");
			sprite.fadeOutAndHide(t);
			sprite = actor.getSprite("charm_head");
			sprite.fadeOutAndHide(t);
			sprite = actor.getSprite("charm_hair");
			sprite.fadeOutAndHide(t);
			
			this.onAllSpritesHidden(false);
			actor.onUpdateInjuryLayer();
			::Time.scheduleEvent(::TimeUnit.Virtual, t + 100, function ( _e )
			{
				if (!_e.isAlive())
				{
					return;
				}

				local sprite;
				sprite = _e.getSprite("charm_body");
				sprite.Visible = false;
				sprite = _e.getSprite("charm_armor");
				sprite.Visible = false;
				sprite = _e.getSprite("charm_head");
				sprite.Visible = false;
				sprite = _e.getSprite("charm_hair");
				sprite.Visible = false;
				this.onAllSpritesHidden(false);
				_e.setDirty(true);
			}.bindenv(this), actor.get());
		}

		::Const.HexeOrigin.Magic.SpawnCharmParticleEffect(actor.getTile());
	}
	
	function onAllSpritesHidden( _isHidden = true )
	{
		local actor = this.getContainer().getActor();

		foreach( a in ::Const.HexeOrigin.AffectedSprites )
		{
			if (!actor.hasSprite(a))
			{
				continue;
			}

			if (actor.getSprite(a).HasBrush)
			{
				if (_isHidden)
				{
					actor.getSprite(a).fadeOutAndHide(300);
				}
				else
				{
					actor.getSprite(a).fadeIn(300);
				}
			}

			actor.getSprite(a).Visible = !_isHidden;
		}
		
		if (!_isHidden)
		{
			actor.updateInjuryVisuals(true);
			actor.onAppearanceChanged(actor.getItems().getAppearance());
		}
	}

	function randomizeStartingStats( _properties )
	{
	}

	function buildAttributes( _tag = null, _attrs = null )
	{
		local b = this.getContainer().getActor().getBaseProperties();
		this.randomizeStartingStats(b);
		
		if (_attrs != null)
		{
			b.Hitpoints += _attrs.Hitpoints[1];
			b.Bravery += _attrs.Bravery[1];
			b.Stamina += _attrs.Stamina[1];
			b.MeleeSkill += _attrs.MeleeSkill[1];
			b.MeleeDefense += _attrs.MeleeDefense[1];
			b.RangedSkill += _attrs.RangedSkill[1];
			b.RangedDefense += _attrs.RangedDefense[1];
			b.Initiative += _attrs.Initiative[1];
		}
		
		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.getContainer().getActor().setHitpoints(b.Hitpoints);
		this.getContainer().getActor().setName(::MSU.Array.rand(this.m.Names));
		
		local weighted = [];

		for (local i = 0; i < 8; ++i)
		{
			weighted.push(50);
		}
		
		return weighted;
	}
	
	function onMakePlayerCharacter()
	{
		local a = {
			Hitpoints = [
				10,
				10
			],
			Bravery = [
				5,
				10
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				40,
				45
			],
			RangedSkill = [
				50,
				55
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				0,
				0
			]
		};
		local b = this.getContainer().getActor().getBaseProperties();
		b.Hitpoints += ::Math.rand(a.Hitpoints[0], a.Hitpoints[1]);
		b.Bravery += ::Math.rand(a.Bravery[0], a.Bravery[1]);
		b.Stamina += ::Math.rand(a.Stamina[0], a.Stamina[1]);
		b.MeleeSkill += ::Math.rand(a.MeleeSkill[0], a.MeleeSkill[1]);
		b.RangedSkill += ::Math.rand(a.RangedSkill[0], a.RangedSkill[1]);
		b.MeleeDefense += ::Math.rand(a.MeleeDefense[0], a.MeleeDefense[1]);
		b.RangedDefense += ::Math.rand(a.RangedDefense[0], a.RangedDefense[1]);
		b.Initiative += ::Math.rand(a.Initiative[0], a.Initiative[1]);
		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.getContainer().getActor().setHitpoints(b.Hitpoints);
	}
	
	function setAppearance()
	{
		if (this.m.HairColors == null)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (this.m.Faces != null)
		{
			local sprite = actor.getSprite("head");
			sprite.setBrush(::MSU.Array.rand(this.m.Faces));
			sprite.Color = ::createColor("#fbffff");
			sprite.varyColor(0.05, 0.05, 0.05);
			sprite.varySaturation(0.1);
			local body = actor.getSprite("body");
			body.Color = sprite.Color;
			body.Saturation = sprite.Saturation;
		}

		if (this.m.Hairs != null)
		{
			local sprite = actor.getSprite("hair");
			sprite.setBrush(::MSU.Array.rand(this.m.Hairs));
			sprite.varyBrightness(0.1);
		}

		if (this.m.Bodies != null)
		{
			local body = ::MSU.Array.rand(this.m.Bodies);
			actor.getSprite("body").setBrush(body);
			actor.getSprite("injury_body").setBrush(body + "_injured");
		}

		this.onSetAppearance();
	}

	function onFinishingPerkTree()
	{
	}

	function buildPerkTree()
	{
		local a = this.character_background.buildPerkTree();

		if (!this.m.IsDeserializing)
		{
			this.onFinishingPerkTree();
		}

		return a;
	}

	function onDeserialize( _in )
	{
		this.m.IsDeserializing = true;
		this.character_background.onDeserialize(_in);
		this.m.IsDeserializing = false;
	} 

});

