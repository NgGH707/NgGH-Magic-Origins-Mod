::mods_hookExactClass("entity/tactical/humans/legend_peasant_witchhunter", function(obj) {
	obj.m.IsMeleeWitchHunter <- false;

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();

		if (::Math.rand(1, 100) <= 33)
		{
			this.m.IsMeleeWitchHunter = true;
			this.m.AIAgent = ::new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
			this.m.AIAgent.setActor(this);
		}
	}

	local ws_onInit = obj.onInit;
	obj.onInit = function()
	{
		if (!this.m.IsMeleeWitchHunter)
		{
			ws_onInit();
			this.m.BaseProperties.MoraleCheckBravery[1] += 20;
			return;
		}
		
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues({
			XP = 250,
			ActionPoints = 9,
			Hitpoints = 110,
			Bravery = 100,
			Stamina = 135,
			MeleeSkill = 75,
			RangedSkill = 65,
			MeleeDefense = 25,
			RangedDefense = 20,
			Initiative = 120,
			FatigueEffectMult = 1.0,
			MoraleEffectMult = 1.0,
			Armor = [0, 0],
			FatigueRecoveryRate = 20
		});

		b.MoraleCheckBravery[1] += 20;
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInAxes = true;
		b.IsSpecializedInMaces = true;
		b.IsSpecializedInFlails = true;
		b.IsSpecializedInPolearms = true;
		b.IsSpecializedInThrowing = true;
		b.IsSpecializedInHammers = true;
		b.IsSpecializedInSpears = true;
		b.IsSpecializedInCleavers = true;
		b.IsSpecializedInDaggers = true;

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();

		local dirt = this.getSprite("dirt");
		dirt.Visible = true;
		dirt.Alpha = ::Math.rand(0, 255);

		this.m.Skills.add(::new("scripts/skills/perks/perk_bullseye"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_quick_hands"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_overwhelm"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_footwork"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_recover"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_legend_net_casting"));

		if (::Is_PTR_Exist)
		{
			this.m.Skills.add(::new("scripts/skills/perks/perk_ptr_follow_up"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_legend_assured_conquest"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_legend_net_repair"));
		}

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			this.m.Skills.add(::new("scripts/skills/perks/perk_pathfinder"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_head_hunter"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_push_the_advantage"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_legend_clarity"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_sundering_strikes"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_anticipation"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_legend_mastery_nets"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_legend_net_repair"));

			if (::Is_PTR_Exist)
			{
				this.m.Skills.add(::new("scripts/skills/perks/perk_ptr_pattern_recognition"));
			}

			this.m.Skills.add(::new("scripts/skills/traits/fearless_trait"));
		}
	}

	local ws_assignRandomEquipment = obj.assignRandomEquipment;
	obj.assignRandomEquipment = function()
	{
		local hasWitchHunterTag = this.m.WorldTroop != null && ("Party" in this.m.WorldTroop) && this.m.WorldTroop.Party != null && !this.m.WorldTroop.Party.isNull() && this.m.WorldTroop.Party.getFlags().has("WitchHunters")

		if (hasWitchHunterTag)
		{
			this.getFlags().set("WitchHunters", true);
		}
		else if (!this.m.IsMeleeWitchHunter)
		{
			// regular ranged witch hunter
			ws_assignRandomEquipment();
			return;
		}

		if (this.m.IsMeleeWitchHunter)
		{
			local weapon = ::new("scripts/items/weapons/spetum");

			if (::Is_PTR_Exist)
			{
				// shenanigans shit to make this boy has better perk
				this.m.Items.equip(weapon);

				if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
				{
					this.m.BaseProperties.MeleeSkill += 5;
					this.m.Skills.addTreeOfEquippedWeapon(7);
				}
				else
				{
					this.m.Skills.addTreeOfEquippedWeapon(5);
				}

				this.m.Items.unequip(weapon);
			}
			
			// put it back to the bag
			this.m.Items.addToBag(weapon);

			// weapon for first encounter, throw first ask questions later :)
			this.m.Items.equip(::new("scripts/items/weapons/" + (hasWitchHunterTag && ::Math.rand(1, 100) <= 50 ? "javelin" : "throwing_spear")));
			this.m.Items.equip(::new("scripts/items/tools/" + (hasWitchHunterTag && ::Math.rand(1, 100) <= 33 ? "reinforced_throwing_net" : "throwing_net")));
			
			if (::Is_PTR_Exist)
			{
				this.m.Skills.addTreeOfEquippedWeapon(7);
			}

			// special melee witch hunter
			if (hasWitchHunterTag)
			{
				this.m.BaseProperties.MeleeDamageMult = 1.15;
				this.m.Items.equip(::Const.World.Common.pickArmor([[3, "werewolf_mail_armor"],[1, "northern_mercenary_armor_00"],[3, "northern_mercenary_armor_01"],[2, "mail_shirt"],[4, "mail_hauberk"]]));
				this.m.Items.equip(::Const.World.Common.pickHelmet([[1, "witchhunter_hat"],[1, "hood"]]))
			}
			// regular melee witch hunter
			else
			{
				this.m.Items.equip(::Const.World.Common.pickArmor([[1, "thick_tunic"]]));

				if (::Math.rand(1, 100) <= 66)
				{
					this.m.Items.equip(::Const.World.Common.pickHelmet([[1, "witchhunter_hat"],[6, "hood"]]))
				}
			}

			return;
		}
		
		// special ranged witch hunter
		if (::Math.rand(1, 100) <= 66)
		{
			this.m.Items.equip(::new("scripts/items/weapons/crossbow"));
			this.m.Items.equip(::new("scripts/items/ammo/legend_broad_head_bolts"));
			this.m.Items.addToBag(::new("scripts/items/weapons/arming_sword"));
		}
		else
		{
			this.m.Items.equip(::new("scripts/items/weapons/greenskins/goblin_crossbow"));
			this.m.Items.equip(::new("scripts/items/ammo/" + ::MSU.Array.rand(["legend_armor_piercing_bolts", "quiver_of_bolts"])));
			this.m.Items.addToBag(::new("scripts/items/weapons/rondel_dagger"));
		}

		// nastier :)
		this.m.BaseProperties.RangedSkill += ::Math.rand(2, 7);
		this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_anticipation"));

		if (::Is_PTR_Exist)
		{
			if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			{
				this.m.Skills.addTreeOfEquippedWeapon(7);
			}
			else
			{
				this.m.Skills.addTreeOfEquippedWeapon(5);
			}
		}

		this.m.Items.equip(::Const.World.Common.pickArmor([[1, "padded_leather"],[2, "werewolf_hide_armor"],[1, "basic_mail_shirt"],[2, "mail_shirt"]]));
		this.m.Items.equip(::Const.World.Common.pickHelmet([[3, "witchhunter_hat"],[2, "hood"]]));
	}

})