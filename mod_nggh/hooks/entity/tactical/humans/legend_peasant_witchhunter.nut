::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/humans/legend_peasant_witchhunter", function(q) {
	q.m.IsMeleeWitchHunter <- false;

	q.create = @(__original) function()
	{
		__original();

		if (::Math.rand(1, 100) <= 40) {
			m.IsMeleeWitchHunter = true;
			m.AIAgent = ::new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
			m.AIAgent.getProperties().PreferCarefulEngage = true;
			m.AIAgent.setActor(this);
		}
	}

	q.onInit = @(__original) function()
	{
		if (!m.IsMeleeWitchHunter) {
			__original();
			m.BaseProperties.MoraleCheckBravery[1] += 25;
			return;
		}
		
		human.onInit();
		local b = m.BaseProperties;
		b.setValues({
			XP = 250,
			ActionPoints = 9,
			Hitpoints = 110,
			Bravery = 100,
			Stamina = 140,
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

		b.MoraleCheckBravery[1] += 25;
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

		m.ActionPoints = b.ActionPoints;
		m.Hitpoints = b.Hitpoints;
		m.CurrentProperties = clone b;
		setAppearance();

		local dirt = getSprite("dirt");
		dirt.Visible = true;
		dirt.Alpha = ::Math.rand(0, 255);

		m.Skills.add(::new("scripts/skills/perks/perk_bullseye"));
		m.Skills.add(::new("scripts/skills/perks/perk_quick_hands"));
		m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
		m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
		m.Skills.add(::new("scripts/skills/perks/perk_overwhelm"));
		m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
		m.Skills.add(::new("scripts/skills/perks/perk_footwork"));
		m.Skills.add(::new("scripts/skills/perks/perk_recover"));
		m.Skills.add(::new("scripts/skills/perks/perk_legend_net_casting"));
		m.Skills.add(::new("scripts/skills/perks/perk_legend_assured_conquest"));
		m.Skills.add(::new("scripts/skills/perks/perk_legend_push_the_advantage"));

		if (::Is_PTR_Exist) {
			m.Skills.add(::new("scripts/skills/perks/perk_ptr_follow_up"));
			m.Skills.add(::new("scripts/skills/perks/perk_legend_net_repair"));
		}

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary) {
			m.Skills.add(::new("scripts/skills/perks/perk_pathfinder"));
			m.Skills.add(::new("scripts/skills/perks/perk_head_hunter"));
			m.Skills.add(::new("scripts/skills/perks/perk_legend_clarity"));
			m.Skills.add(::new("scripts/skills/perks/perk_sundering_strikes"));
			m.Skills.add(::new("scripts/skills/perks/perk_anticipation"));
			m.Skills.add(::new("scripts/skills/perks/perk_legend_mastery_nets"));
			m.Skills.add(::new("scripts/skills/perks/perk_legend_net_repair"));

			if (::Is_PTR_Exist)
				m.Skills.add(::new("scripts/skills/perks/perk_ptr_pattern_recognition"));

			m.Skills.add(::new("scripts/skills/traits/fearless_trait"));
		}
	}

	q.assignRandomEquipment = @(__original) function()
	{
		local hasWitchHunterTag = m.WorldTroop != null && ("Party" in m.WorldTroop) && m.WorldTroop.Party != null && !m.WorldTroop.Party.isNull() && m.WorldTroop.Party.getFlags().has("WitchHunters");

		if (hasWitchHunterTag)
			getFlags().set("WitchHunters", true);
		else if (!m.IsMeleeWitchHunter) {
			// regular ranged witch hunter
			__original();
			return;
		}

		if (m.IsMeleeWitchHunter) {
			local weapon = ::new("scripts/items/weapons/spetum");

			if (::Is_PTR_Exist) {
				// shenanigans shit just in case if spetum is no longer treated as spear, it still gets the correct perks in ptr
				m.Items.equip(weapon);

				if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary) {
					m.BaseProperties.MeleeSkill += 5;
					m.Skills.addTreeOfEquippedWeapon(7);
				}
				else {
					m.Skills.addTreeOfEquippedWeapon(5);
				}

				m.Items.unequip(weapon);
			}
			
			// put it back to the bag
			m.Items.addToBag(weapon);

			// weapon for first encounter, throw first ask questions later :)
			m.Items.equip(::new("scripts/items/weapons/" + (hasWitchHunterTag && ::Math.rand(1, 100) <= 50 ? "javelin" : "throwing_spear")));
			m.Items.equip(::new("scripts/items/tools/" + (hasWitchHunterTag && ::Math.rand(1, 100) <= 33 ? "reinforced_throwing_net" : "throwing_net")));
			
			if (::Is_PTR_Exist)
				m.Skills.addTreeOfEquippedWeapon(7);

			// special melee witch hunter
			if (hasWitchHunterTag) {
				m.BaseProperties.MeleeDamageMult *= 1.25;
				m.Skills.add(::new("scripts/skills/effects/legend_hunting_big_game"));
				m.Items.equip(::Const.World.Common.pickArmor([[2, "werewolf_mail_armor"],[1, "northern_mercenary_armor_00"],[3, "northern_mercenary_armor_01"],[2, "mail_shirt"],[4, "mail_hauberk"],[1, "light_scale_armor"],[3, "leather_scale_armor"]]));
				m.Items.equip(::Const.World.Common.pickHelmet([[1, "witchhunter_hat"],[1, "hood"],[1, "rondel_helm"]]));
				
				if (::Is_PTR_Exist)
					m.Skills.addPerkTree(::Const.Perks.TwoHandedTree);
			}
			// regular melee witch hunter
			else {
				m.Items.equip(::Const.World.Common.pickArmor([[1, "thick_tunic"]]));

				if (::Math.rand(1, 100) <= 66)
					m.Items.equip(::Const.World.Common.pickHelmet([[1, "witchhunter_hat"],[6, "hood"]]));
			}

			return;
		}
		
		// give better AI agent
		m.AIAgent = ::new("scripts/ai/tactical/agents/bounty_hunter_ranged_agent");
		m.AIAgent.setActor(this);

		// special ranged witch hunter
		if (::Math.rand(1, 100) <= 66) {
			m.Items.equip(::new("scripts/items/weapons/crossbow"));
			m.Items.equip(::new("scripts/items/ammo/legend_broad_head_bolts"));
			m.Items.addToBag(::new("scripts/items/weapons/arming_sword"));
		}
		else {
			m.Items.equip(::new("scripts/items/weapons/greenskins/goblin_crossbow"));
			m.Items.equip(::new("scripts/items/ammo/" + ::MSU.Array.rand(["legend_armor_piercing_bolts", "quiver_of_bolts"])));
			m.Items.addToBag(::new("scripts/items/weapons/rondel_dagger"));
		}

		// nastier :)
		m.BaseProperties.RangedSkill += ::Math.rand(5, 10);
		m.BaseProperties.Initiative -= ::Math.rand(10, 15);
		m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
		m.Skills.add(::new("scripts/skills/perks/perk_quick_hands"));
		m.Skills.add(::new("scripts/skills/perks/perk_footwork"));
		m.Skills.add(::new("scripts/skills/effects/legend_hunting_big_game"));

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary) { 
			m.Skills.add(::new("scripts/skills/perks/perk_recover"));
			m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
			m.Skills.add(::new("scripts/skills/perks/perk_crippling_strikes"));
			m.Skills.add(::new("scripts/skills/perks/perk_fast_adaption"));
		}

		if (::Is_PTR_Exist) {
			m.Skills.add(::new("scripts/skills/perks/perk_anticipation"));

			if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
				m.Skills.addTreeOfEquippedWeapon(7);
			else
				m.Skills.addTreeOfEquippedWeapon(5);
		}

		m.Items.equip(::Const.World.Common.pickArmor([[1, "padded_leather"],[2, "werewolf_hide_armor"],[2, "mail_shirt"]]));
		m.Items.equip(::Const.World.Common.pickHelmet([[3, "witchhunter_hat"],[2, "hood"]]));
	}

})