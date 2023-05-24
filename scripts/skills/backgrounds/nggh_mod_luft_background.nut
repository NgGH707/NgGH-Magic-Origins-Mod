this.nggh_mod_luft_background <- ::inherit("scripts/skills/backgrounds/character_background", {
	m = {
		IsCharming = false,
		IsDeserializing = false,
		PerkGroupMultipliers = [],
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.luft";
		this.m.Name = "Skin Ghoul Mascot";
		this.m.Icon = "ui/backgrounds/background_luft.png";
		this.m.HiringCost = 9999999;
		this.m.DailyCost = 0;
		this.m.Excluded = [
			"trait.dumb",
			"trait.superstitious"
		];
		
		this.addBackgroundType(::Const.BackgroundType.Educated);
		this.addBackgroundType(::Const.BackgroundType.Noble);
		this.addBackgroundType(::Const.BackgroundType.Performing);
		this.m.AlignmentMin = ::Const.LegendMod.Alignment.Dreaded;
		this.m.AlignmentMax = ::Const.LegendMod.Alignment.Merciless;
		this.m.Modifiers.Stash = ::Const.LegendMod.ResourceModifiers.Stash[2];
		this.m.Modifiers.Crafting = ::Const.LegendMod.ResourceModifiers.Crafting[1];
		this.m.Modifiers.Enchanting = 0.5;

		this.m.CustomPerkTree = [
			[
				// 0
				::Const.Perks.PerkDefs.FastAdaption,
				::Const.Perks.PerkDefs.CoupDeGrace,
				::Const.Perks.PerkDefs.Backstabber,
				::Const.Perks.PerkDefs.Pathfinder,
				::Const.Perks.PerkDefs.CripplingStrikes,
				::Const.Perks.PerkDefs.LegendOnslaught,
				::Const.Perks.PerkDefs.LegendAlert,
				::Const.Perks.PerkDefs.Recover
			],
			[
				// 1
				::Const.Perks.PerkDefs.Dodge,
				::Const.Perks.PerkDefs.SteelBrow,
				::Const.Perks.PerkDefs.Gifted,
				::Const.Perks.PerkDefs.Debilitate,
				::Const.Perks.PerkDefs.SunderingStrikes,
				::Const.Perks.PerkDefs.Taunt,
				::Const.Perks.PerkDefs.NggHNachoFrenzy,
				::Const.Perks.PerkDefs.NggHLuftUnholyFruits,
				::Const.Perks.PerkDefs.NggHCharmEnemySpider
			],
			[
				// 2
				::Const.Perks.PerkDefs.Anticipation,
				::Const.Perks.PerkDefs.Sprint,
				::Const.Perks.PerkDefs.Footwork,
				::Const.Perks.PerkDefs.Rotation,
				::Const.Perks.PerkDefs.DevastatingStrikes,
				::Const.Perks.PerkDefs.InspiringPresence,
				::Const.Perks.PerkDefs.NggHCharmEnemyAlp,
				::Const.Perks.PerkDefs.NggHCharmEnemyDirewolf
			],
			[
				// 3
				::Const.Perks.PerkDefs.Adrenaline,
				::Const.Perks.PerkDefs.Underdog,
				::Const.Perks.PerkDefs.LegendLeap,
				::Const.Perks.PerkDefs.Fearsome,
				::Const.Perks.PerkDefs.Inspire,
				::Const.Perks.PerkDefs.FortifiedMind,
				::Const.Perks.PerkDefs.LegendMindOverBody,
				::Const.Perks.PerkDefs.NggHNacho,
				::Const.Perks.PerkDefs.NggHLuftPattingSpec,
				::Const.Perks.PerkDefs.NggHLuftInnocentLook,
				::Const.Perks.PerkDefs.NggHCharmEnemyGhoul
			],
			[
				// 4
				::Const.Perks.PerkDefs.PushTheAdvantage,
				::Const.Perks.PerkDefs.Steadfast,
				::Const.Perks.PerkDefs.Rebound,
				::Const.Perks.PerkDefs.LoneWolf,
				::Const.Perks.PerkDefs.NggHMiscLineBreaker,
				::Const.Perks.PerkDefs.NggHNachoEat,
				::Const.Perks.PerkDefs.NggHCharmEnemyGoblin,
				::Const.Perks.PerkDefs.NggHCharmEnemyOrk
			],
			[
				// 5
				::Const.Perks.PerkDefs.KillingFrenzy,
				::Const.Perks.PerkDefs.LegendAssuredConquest,
				::Const.Perks.PerkDefs.LegendTerrifyingVisage,
				::Const.Perks.PerkDefs.Berserk,
				::Const.Perks.PerkDefs.LastStand,
				::Const.Perks.PerkDefs.Nimble,
				::Const.Perks.PerkDefs.NggHNachoBigTummy,
				::Const.Perks.PerkDefs.NggHCharmEnemyUnhold,
				::Const.Perks.PerkDefs.NggHCharmEnemySchrat
			],
			[
				// 6
				::Const.Perks.PerkDefs.Colossus,
				::Const.Perks.PerkDefs.LegendMuscularity,
				::Const.Perks.PerkDefs.PerfectFocus,
				::Const.Perks.PerkDefs.BattleFlow,
				::Const.Perks.PerkDefs.Indomitable,
				::Const.Perks.PerkDefs.NggHCharmSpec,
				::Const.Perks.PerkDefs.NggHLuftGhoulBeauty,
				::Const.Perks.PerkDefs.NggHCharmEnemyLindwurm,
				::Const.Perks.PerkDefs.NggHNachoScavenger,
			],
			[],
			[],
			[],
			[]
		];

		if (::Is_PTR_Exist)
		{
			this.addPerkTreesToCustomPerkTree(this.m.CustomPerkTree, [
				::Const.Perks.ViciousTree,
				::Const.Perks.LightArmorTree,
				::Const.Perks.ResilientTree,
				::Const.Perks.TalentedTree,
				::Const.Perks.RangedTree
			]);
			this.m.CustomPerkTree[5].push(::Const.Perks.PerkDefs.PTRUnstoppable);
			this.m.CustomPerkTree[5].push(::Const.Perks.PerkDefs.PTRFreshAndFurious);
			this.m.CustomPerkTree[5].push(::Const.Perks.PerkDefs.PTRTheRushOfBattle);
		}
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

	function onAdded()
	{
		if (this.m.IsNew)
		{
			// add the unique flag
			this.getContainer().getActor().getFlags().set("Hexe", 0);
			this.getContainer().getActor().getFlags().get("IsSpecial");

			// build stats
			this.getContainer().getActor().m.StarWeights = this.buildAttributes(null, null);
			this.addBonusAttributes(this.buildPerkTree());
		}

		this.character_background.onAdded();
	}

	function getMagicalDefense()
	{
		local lv = this.getContainer().getActor().getLevel();
		return lv < 11 ? lv : (lv - 11) * 1 + 10;
	}

	function onUpdate( _properties )
	{
		// being too beautiful/ugly has its disadvantage
		_properties.TargetAttractionMult *= 1.25;

		// bonus from the magical jester had
		_properties.HitChance[::Const.BodyPart.Head] += 10;

		// she has way to defend against this kind of magic/curse
		_properties.IsImmuneToDamageReflection = true;

		// she is not a fighter, being allowed to stay out of violent or a threat of getting killed always a thing she will never refuse
		_properties.IsContentWithBeingInReserve = true;

		// she has certain amount of magic/curse resistance
		_properties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack] += this.getMagicalDefense();
	}

	function onBuildDescription()
	{
		return "You know him when you join BB Legends Mod discord. The one and only lovable nacho who knows more than scratching and eating, he can pet you and charm you. With his sassy ghoulish body and cute jester hat, no nacho can resist his call. \n\nHe likes to pet everything from Unholds, Direwolves to his own nacho buddies, Poss, discord members. His pat meets no bounds, if he saw you, he will pet you. \n\nPssss! Some said he likes to eat discord member for dinner.";
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
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Discord Mod"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Likes to pet everything"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Magically turns any hat put on his head into a jester hat"
			},
			/*
			{
				id = 15,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "Higher Chance To Hit Head"
			}
			*/
		];

		if (this.getContainer() == null || this.getContainer().getActor() == null)
		{
			return ret;
		}

		local actor = this.getContainer().getActor();

		if (actor.getFlags().has("has_eaten") && actor.getSize() > 1)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/asset_food.png",
				text = "Needs to eat a [color=" + ::Const.UI.Color.NegativeValue + "]corpse[/color] every battle or will shrink in size"
			})
		}

		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Immune to [color=" + ::Const.UI.Color.NegativeValue + "]Charm[/color] and [color=" + ::Const.UI.Color.NegativeValue + "]Hex[/color]"
		});
		ret.extend(::Const.CharmedUtilities.getTooltip(actor));
		ret.extend(this.getAttributesTooltip());
		return ret;
	}

	function getNachoAppearance()
	{
		if (!::World.Flags.get("IsLuftAdventure"))
		{
			return null;
		}

		local ret = [];
		local actor = this.getContainer().getActor();
		ret.push(r == 1 ? "bust_ghoulskin_head_01" : "bust_ghoulskin_0" + actor.getSize() + "_head_0" + actor.getVariant());
		ret.push((::Math.rand(1, 2) == 1 ? "bust_boobas_ghoul_body_0" : "bust_boobas_ghoul_with_dress_0") + actor.getSize());
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
		local actor = this.getContainer().getActor();

		if (this.m.IsCharming)
		{
			local a = this.getNachoAppearance();
			local sprite;
			
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
			
			this.onAllSpritesHidden(true);
			::Time.scheduleEvent(::TimeUnit.Virtual, t + 100, function ( _e )
			{
				if (!_e.isAlive())
				{
					return;
				}
				
				local sprite;
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

		this.m.Excluded.extend(this.getContainer().getActor().getExcludedTraits());
		this.getContainer().getActor().pickTraits(traits, maxTraits);

		for( local i = 1; i < traits.len(); ++i )
		{
			this.getContainer().add(traits[i]);

			if (traits[i].getContainer() != null)
			{
				traits[i].addTitle();
			}
		}
	}
	
	function buildAttributes( _tag = null, _attrs = null )
	{
		this.addTraits();
		local b = this.getContainer().getActor().getBaseProperties();
		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.getContainer().getActor().setHitpoints(b.Hitpoints);
		return array(8, 50);
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
	
	function setAppearance()
	{
		this.onSetAppearance();
	}

	function onNewDay()
	{
		local name = this.getContainer().getActor().getNameOnly();
		local wrongName = name.find("Luft") == null;
		local title = this.getContainer().getActor().m.Title;
		local wrongTitle = title.len() == 0 || title.find("Rat Enjoyer") == null;

		if (wrongName)
		{
			this.getContainer().getActor().setName("Luft");
			this.getContainer().getActor().worsenMood(0.5, "My name is Luft. Quit changing it");
		}

		if (wrongTitle)
		{
			this.getContainer().getActor().setTitle("The Rat Enjoyer");
			this.getContainer().getActor().worsenMood(0.5, "I like rat. Please don\'t changing it");
		}
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

