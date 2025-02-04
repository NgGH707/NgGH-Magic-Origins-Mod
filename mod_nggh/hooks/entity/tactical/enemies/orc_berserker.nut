::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/orc_berserker", function (q) 
{
	q.m.HasAssignedEquipment <- false;

    q.assignRandomEquipment = @(__original) function()
	{
		if (m.HasAssignedEquipment)
			return;

		__original();
		m.HasAssignedEquipment = true;
	}

	q.makeMiniboss <- function()
	{
		if (!actor.makeMiniboss())
			return false;

		// force assign weapon first
		assignRandomEquipment();

		m.XP *= 1.5; // extra xp
		m.BaseProperties.Bravery += 10;
		getSprite("miniboss").setBrush("bust_miniboss_greenskins");
		m.Items.addToBag(::new("scripts/items/accessory/berserker_mushrooms_item"));
		m.Items.unequip(m.Items.getItemAtSlot(::Const.ItemSlot.Mainhand));
		m.Items.equip(::new("scripts/items/weapons/named/" + ::MSU.Array.rand([
			"named_heavy_rusty_axe",
			"named_orc_axe_2h",
			"named_orc_flail_2h",
			"named_orc_axe"
		])));

		local head = m.Items.getItemAtSlot(::Const.ItemSlot.Head);
		local body = m.Items.getItemAtSlot(::Const.ItemSlot.Body);

		if ((head == null && body == null) || ::Math.rand(1, 100) <= 33) {
			m.Items.unequip(head);
			m.Items.unequip(body);
			m.Skills.add(::new("scripts/skills/perks/perk_legend_forceful_swing"));
			m.Skills.add(::new("scripts/skills/perks/perk_legend_alert"));
			m.Skills.add(::new("scripts/skills/perks/perk_fortified_mind"));
			m.Skills.add(::new("scripts/skills/perks/perk_dodge"));

			local nudist = ::new("scripts/skills/perks/perk_legend_ubernimble");
			nudist.m.IsForceEnabled = true;
			m.Skills.add(nudist);
		}
		else {
			m.Skills.add(::new("scripts/skills/perks/perk_legend_bloody_harvest"));
			m.Skills.add(::new("scripts/skills/perks/perk_stalwart"));
			m.Skills.add(::new("scripts/skills/perks/perk_underdog"));
			m.Skills.add(::new("scripts/skills/perks/perk_colossus"));
		}

		// has a chance to already be high at start
		if (::Math.rand(1, 100) <= 50) {
			m.Skills.add(::new("scripts/skills/effects/berserker_mushrooms_effect"));
			m.Items.addToBag(::new("scripts/items/accessory/berserker_mushrooms_item"));
		}
		
		m.Skills.add(::new("scripts/skills/perks/perk_legend_second_wind"));
		m.Skills.add(::new("scripts/skills/perks/perk_nimble"));

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary) {
			m.Skills.add(::new("scripts/skills/perks/perk_legend_last_stand"));
			m.Skills.add(::new("scripts/skills/perks/perk_steel_brow"));
		}

		return true;
	}
});