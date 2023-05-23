::mods_hookExactClass("entity/tactical/enemies/orc_berserker", function (obj) 
{
	obj.m.HasAssignedEquipment <- false;

	local ws_assignRandomEquipment = obj.assignRandomEquipment
    obj.assignRandomEquipment = function()
	{
		if (this.m.HasAssignedEquipment) return;

		ws_assignRandomEquipment();
		this.m.Items.unequip(this.m.Items.getItemAtSlot(::Const.ItemSlot.Body));
		this.m.Items.unequip(this.m.Items.getItemAtSlot(::Const.ItemSlot.Head));

		local roll = ::MSU.Array.rand([
			"orc_berserker_light",
			"orc_berserker_medium",
			""
		]);

		if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		{
			if (roll.len() != 0)
			{
				this.m.Items.equip(::new("scripts/items/armor/greenskins/" + roll + "_armor"));
			}

			if (::Math.rand(1, 100) <= 50)
			{
				this.m.Items.equip(::new("scripts/items/helmets/greenskins/orc_berserker_helmet"));
			}
		}
		else
		{
			if (roll.len() != 0)
			{
				this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_" + roll + "_armor"));
			}

			if (::Math.rand(1, 100) <= 50)
			{
				this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_orc_berserker_helmet"));
			}
		}

		this.m.HasAssignedEquipment = true;
	}

	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		// force assign weapon first
		this.assignRandomEquipment();

		this.m.XP *= 1.5; // extra xp
		this.m.BaseProperties.Bravery += 10;
		this.getSprite("miniboss").setBrush("bust_miniboss_greenskins");
		this.m.Items.addToBag(::new("scripts/items/accessory/berserker_mushrooms_item"));
		this.m.Items.unequip(this.m.Items.getItemAtSlot(::Const.ItemSlot.Mainhand));
		this.m.Items.equip(::new("scripts/items/weapons/named/" + ::MSU.Array.rand([
			"named_heavy_rusty_axe",
			"named_orc_axe_2h",
			"named_orc_flail_2h",
			"named_orc_axe"
		])));

		local head = this.m.Items.getItemAtSlot(::Const.ItemSlot.Head);
		local body = this.m.Items.getItemAtSlot(::Const.ItemSlot.Body);

		if ((head == null && body == null) || ::Math.rand(1, 100) <= 33)
		{
			this.m.Items.unequip(head);
			this.m.Items.unequip(body);
			this.m.Skills.add(::new("scripts/skills/perks/perk_legend_forceful_swing"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_legend_alert"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_fortified_mind"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));

			local nudist = ::new("scripts/skills/perks/perk_legend_ubernimble");
			nudist.m.IsForceEnabled = true;
			this.m.Skills.add(nudist);
		}
		else
		{
			this.m.Skills.add(::new("scripts/skills/perks/perk_bloody_harvest"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_stalwart"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_underdog"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_colossus"));
		}

		// has a chance to already be high at start
		if (::Math.rand(1, 100) <= 33)
		{
			this.m.Skills.add(::new("scripts/skills/effects/berserker_mushrooms_effect"));
			this.m.Items.addToBag(::new("scripts/items/accessory/berserker_mushrooms_item"));
		}
		
		this.m.Skills.add(::new("scripts/skills/perks/perk_legend_second_wind"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			this.m.Skills.add(::new("scripts/skills/perks/perk_last_stand"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_steel_brow"));
		}

		return true;
	}
});