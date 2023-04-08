this.nggh_mod_luft_player <- ::inherit("scripts/entity/tactical/player_beast/nggh_mod_ghoul_player", {
	m = {},
	function isSkinGhoul()
	{
		return true;
	}
	
	function create()
	{
		this.nggh_mod_ghoul_player.create();
		this.m.Flags.set("IsPlayerCharacter", true);
		this.m.Flags.add("luft");

		// can't equip most thing
		local items = this.getItems();
		//items.getData()[::Const.ItemSlot.Offhand][0] = null;
		//items.getData()[::Const.ItemSlot.Mainhand][0] = null;
		//items.getData()[::Const.ItemSlot.Ammo][0] = null;
	}

	function onInit()
	{
		this.nggh_mod_ghoul_player.onInit();
	}

	function onAfterInit()
	{
		this.nggh_mod_ghoul_player.onAfterInit();
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_patting_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/legend_skin_ghoul_claws"));
		this.m.Skills.add(::new("scripts/skills/actives/legend_skin_ghoul_swallow_whole_skill"));
		this.m.Skills.add(::new("scripts/skills/hexe/nggh_mod_charm_captive_spell"));
		this.m.Skills.add(::new("scripts/skills/hexe/nggh_mod_charm_spell"));
	}

	function addDefaultStatusSprites()
	{
		if (this.m.IsInitGhoul)
		{
			local charm_body = this.addSprite("charm_body");
			charm_body.setHorizontalFlipping(true);
			charm_body.Visible = false;
			local charm_armor = this.addSprite("charm_armor");
			charm_armor.setHorizontalFlipping(true);
			charm_armor.Visible = false;
			local charm_head = this.addSprite("charm_head");
			charm_head.setHorizontalFlipping(true);
			charm_head.Visible = false;
			local charm_hair = this.addSprite("charm_hair");
			charm_hair.setHorizontalFlipping(true);
			charm_hair.Visible = false;
		}

		this.nggh_mod_ghoul_player.addDefaultStatusSprites();
	}
	
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		if (_appearance != null && _appearance.Helmet.len() != 0)
		{
			_appearance.HelmetDamage = "bust_helmet_86_damaged";
			_appearance.HelmetLayerVanityLower = "";
			_appearance.HelmetLayerVanity2Lower = "";
			_appearance.Helmet = "bust_helmet_86";
			_appearance.HelmetLayerHelm = "";
			_appearance.HelmetLayerTop = "";
		}

		if (_appearance.HelmetLayerVanity.len() != 0 && _appearance.HelmetLayerVanity.find("jester_hat") == null)
		{
			_appearance.HelmetLayerVanity = "";
		}

		if (_appearance.HelmetLayerVanity2.len() != 0 && _appearance.HelmetLayerVanity2.find("jester_hat") == null)
		{
			_appearance.HelmetLayerVanity2 = "";
		}

		this.nggh_mod_ghoul_player.onAppearanceChanged(_appearance, _setDirty);
	}

	function setStartValuesEx( _isElite = false , _isSkinGhoul = false , _size = 1 , _parameter = null )
	{
		this.nggh_mod_ghoul_player.setStartValuesEx(_isElite, true, _size, null);

		local b = this.m.BaseProperties;
		b.setValues({
			XP = 250,
			ActionPoints = 12,
			Hitpoints = 160,
			Bravery = 30,
			Stamina = 130,
			MeleeSkill = 65,
			RangedSkill = 0,
			MeleeDefense = 10,
			RangedDefense = 7,
			Initiative = 105,
			FatigueEffectMult = 1.0,
			MoraleEffectMult = 1.0,
			Armor = [0, 0]
		});
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;

		this.m.Items.equip(::Const.World.Common.pickHelmet([[1, "jesters_hat"]]));
		this.m.Skills.add(::new("scripts/skills/traits/player_character_trait"));
		this.getSprite("miniboss").setBrush("bust_miniboss_lone_wolf");
		this.setTitle("The Rat Enjoyer");
		this.setName("Luft");
	}

	function addDefaultBackground( _type )
	{
		local background = ::new("scripts/skills/backgrounds/nggh_mod_luft_background");
		this.m.Skills.add(background);
		background.buildDescription();
		this.setVeteranPerks(2);
	}

	function onTurnStart()
	{
		if (!this.isAlive())
		{
			return;
		}

		::Nggh_MagicConcept.spawnQuote("luft_idle_quote_" + ::Math.rand(1, 6), this.getTile());
		this.nggh_mod_ghoul_player.onTurnStart();
	}

	function onTurnResumed()
	{
		::Nggh_MagicConcept.spawnQuote("luft_idle_quote_" + ::Math.rand(1, 6), this.getTile());
		this.nggh_mod_ghoul_player.onTurnResumed();
	}

	function onAttacked( _attacker )
	{
		::Nggh_MagicConcept.spawnQuote("luft_damage_taken_quote_" + ::Math.rand(1, 3), this.getTile());
		this.nggh_mod_ghoul_player.onAttacked(_attacker);
	}

	function onActorKilled( _actor, _tile, _skill )
	{
		if (::Math.rand(1, 100) <= 10)
		{
			::Nggh_MagicConcept.spawnQuote("necro_quote_12", this.getTile());
		}

		this.nggh_mod_ghoul_player.onActorKilled(_actor, _tile, _skill);
	}

	function onMovementFinish( _tile )
	{
		this.nggh_mod_ghoul_player.onMovementFinish(_tile);

		if (!this.isAlive())
		{
			return;
		}

		::Nggh_MagicConcept.spawnQuote("luft_move_quote_" + ::Math.rand(1, 3), _tile);
	}

	function onUpdateInjuryLayer()
	{
		if (this.getBackground() != null && this.getBackground().m.IsCharming)
		{
			return;
		}

		this.nggh_mod_ghoul_player.onUpdateInjuryLayer();
	}

	function onCombatFinished()
	{
		this.nggh_mod_ghoul_player.onCombatFinished();
		local looks = ::World.Flags.getAsInt("looks");
		local size = 9990 + this.getSize();

		if (looks != size)
		{
			::World.Flags.set("looks", size);
			::World.Assets.updateLook(size);
		}
	}

});

