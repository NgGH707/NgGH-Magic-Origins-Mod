this.nggh_mod_inquisitor <- ::inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = ::Const.EntityType.Knight;
		this.m.BloodType = ::Const.BloodType.Red;
		this.m.XP = 500;
		this.m.Name = this.generateName();
		this.m.IsGeneratingKillName = false;
		this.human.create();
		this.m.Faces = ::Const.Faces.SmartMale;
		this.m.Hairs = ::Const.Hair.CommonMale;
		this.m.HairColors = ::Const.HairColors.All;
		this.m.Beards = ::Const.Beards.Tidy;
		this.m.AIAgent = ::new("scripts/ai/tactical/agents/military_melee_agent");
		this.m.AIAgent.setActor(this);
	}

	function generateName()
	{
		this.m.Title = ::MSU.Array.rand(::Const.World.Spawn.Troops.Inquisitor.TitleList);
		return ::MSU.Array.rand(::Const.Strings.KnightNames);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues({
			ActionPoints = 9,
			Hitpoints = 200,
			Bravery = 240,
			Stamina = 180,
			MeleeSkill = 100,
			RangedSkill = 60,
			MeleeDefense = 30,
			RangedDefense = 5,
			Initiative = 100,
			FatigueRecoveryRate = 30,
			FatigueEffectMult = 1.0,
			MoraleEffectMult = 1.0,
			Armor = [0,0],
		});
		b.TargetAttractionMult = 0.9;
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInAxes = true;
		b.IsSpecializedInMaces = true;
		b.IsSpecializedInFlails = true;
		b.IsSpecializedInPolearms = true;
		b.IsSpecializedInThrowing = true;
		b.IsSpecializedInHammers = true;
		b.IsSpecializedInSpears = true;
		b.IsSpecializedInCleavers = true;

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_military");

		this.m.Skills.add(::new("scripts/skills/perks/perk_brawny"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_captain"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_reach_advantage"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_last_stand"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_recover"));
		this.m.Skills.add(::new("scripts/skills/actives/rally_the_troops"));

		if (::Is_PTR_Exist)
		{
			this.m.Skills.add(::new("scripts/skills/perks/perk_ptr_man_of_steel"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_ptr_exude_confidence"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_ptr_bulwark"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_ptr_pattern_recognition"));
		}

		if("Assets" in ::World && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			this.m.Skills.add(::new("scripts/skills/perks/perk_legend_smashing_shields"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_legend_forceful_swing"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_bloody_harvest"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_legend_composure"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_steel_brow"));
			this.m.Skills.add(::new("scripts/skills/traits/fearless_trait"));

			if (::Is_PTR_Exist)
			{
				this.m.Skills.add(::new("scripts/skills/perks/perk_ptr_personal_armor"));
			}
			else
			{
				this.m.Skills.add(::new("scripts/skills/perks/perk_legend_full_force"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_legend_back_to_basics"));
			}
		}
	}

	function assignRandomEquipment()
	{
		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Mainhand))
		{
			this.m.Items.equip(::new("scripts/items/weapons/" + ::MSU.Array.rand([
				// one-handed
				"noble_sword",
				"winged_mace",
				"fighting_axe",
				"three_headed_flail",

				// two-handed
				"legend_swordstaff",
				"two_handed_hammer",
				"two_handed_flail",
				"greataxe",
			])));
		}

		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Offhand))
		{
			switch(::Math.rand(1, 2))
			{
			case 1:
				this.m.Items.equip(::new("scripts/items/shields/heater_shield"));
				break;

			default:
				this.m.Items.equip(::new("scripts/items/shields/kite_shield"));
			}

			this.m.Skills.add(::new("scripts/skills/perks/perk_shield_bash"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_shield_expert"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_legend_specialist_shield_skill"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_legend_specialist_shield_push"));
		}

		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Body))
		{
			this.m.Items.equip(::Const.World.Common.pickArmor([
				[1, "coat_of_plates"],
				[1, "coat_of_scales"]
			]));
		}

		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Head))
		{
			this.m.Items.equip(::Const.World.Common.pickHelmet([
				[25, "full_helm"],
				[5, "legend_helm_breathed"],
				[5, "legend_helm_full"],
				[5, "legend_helm_bearded"],
				[5, "legend_helm_point"],
				[5, "legend_helm_snub"],
				[5, "legend_helm_wings"],
				[5, "legend_helm_short"],
				[5, "legend_helm_curved"],
				[2, "legend_enclave_vanilla_great_helm_01"],
				[2, "legend_enclave_vanilla_great_bascinet_01"],
				[2, "legend_enclave_vanilla_great_bascinet_02"],
				[2, "legend_enclave_vanilla_great_bascinet_03"],
				[5, "legend_frogmouth_helm"],
				[1, "legend_frogmouth_helm_crested"]
			]))
		}

		if (::Is_PTR_Exist)
		{
			local tier = 6

			if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			{
				tier = 7;
			}
			
			if (this.getMainhandItem().isItemType(::Const.Items.ItemType.TwoHanded))
			{
				this.m.BaseProperties.MeleeDefense += 10;
				this.m.Skills.addPerkTree(::Const.Perks.TwoHandedTree, tier);
			}
			else
			{
				this.m.BaseProperties.MeleeDamageMult *= 1.2;
				this.m.Skills.addPerkTree(::Const.Perks.OneHandedTree, tier);
			}

			this.m.Skills.addTreeOfEquippedWeapon(tier);
		}
	}

	function makeMiniboss()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		this.getSprite("miniboss").setBrush("bust_miniboss");

		switch(::Math.rand(1, 3))
		{
		case 1:
			this.m.Items.equip(::new("scripts/items/weapons/named/" + ::MSU.Array.rand([
				// one-handed
				"named_axe",
				"named_sword",
				"named_cleaver",
				"named_three_headed_flail",

				// two-handed
				"named_greatsword",
				"named_two_handed_flail",
				"named_two_handed_hammer",
				"legend_named_swordstaff",
			])));
			break;

		case 2:
			this.m.Items.equip(::Const.World.Common.pickArmor(::Const.World.Common.convNameToList([
				"armor/named/brown_coat_of_plates_armor",
				"armor/named/golden_scale_armor",
				"armor/named/green_coat_of_plates_armor",
				"armor/named/heraldic_mail_armor"
			])));
			break;

		default:
			this.m.Items.equip(::new("scripts/items/" + ::MSU.Array.rand(::Const.Items.NamedShields)));
		}

		this.m.Items.equip(::Const.World.Common.pickHelmet([
			[3, "named/legend_frogmouth_helm_crested_painted"],
			[3, "named/bascinet_named"],
			[2, "named/kettle_helm_named"],
			[3, "named/deep_sallet_named"],
			[3, "named/barbute_named"],
			[3, "named/italo_norman_helm_named"],
			[1, "named/legend_helm_full_named"]
		]))

		this.m.Skills.add(::new("scripts/skills/perks/perk_killing_frenzy"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_hold_out"));
		return true;
	}

});

