this.drum_item <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_drum";
		this.m.Name = "War Drum";
		this.m.Description = "Instrument in battle of those from the north, only those who has honor can use this.";
		this.m.IconLarge = "accessory/wildmen_10.png";
		this.m.Icon = "accessory/wildmen_10_70x70.png";
		this.m.BreakingSound = "sounds/combat/lute_break_01.wav";
		this.m.WeaponType = this.Const.Items.WeaponType.Musical | this.Const.Items.WeaponType.Mace;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsDoubleGrippable = false;
		this.m.IsDroppedAsLoot = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_wildmen_10";
		this.m.RangeMin = 1;
		this.m.RangeMax = 6;
		this.m.RangeIdeal = 6;
		this.m.Value = 1000;
		this.m.Condition = 1.0;
		this.m.ConditionMax = 1.0;
		this.m.StaminaModifier = -5;
		this.m.RegularDamage = 25;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.2;
		this.m.DirectDamageMult = 0.5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/bash"));
		local s = this.new("scripts/skills/actives/knock_out");
		this.addSkill(s);
		this.addSkill(this.new("scripts/skills/actives/drums_of_war_skill"));
		
		local actor = this.getContainer().getActor();

		if (actor != null)
		{
			this.m.IsDroppedAsLoot = actor.isPlayerControlled();
		}
		else
		{
			this.m.IsDroppedAsLoot = false;
		}
	}
	
	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});

