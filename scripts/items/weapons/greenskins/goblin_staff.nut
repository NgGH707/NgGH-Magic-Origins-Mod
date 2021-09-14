this.goblin_staff <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 30
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_staff_gnarled";
		this.m.Name = "Gnarly Staff";
		this.m.Description = "A gnarly staff carved from old and hard wood, adorned with bones and feathers. May be of interest to collectors.";
		this.m.IconLarge = "weapons/melee/goblin_weapon_06.png";
		this.m.Icon = "weapons/melee/goblin_weapon_06_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Staff | this.Const.Items.WeaponType.MagicStaff;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_goblin_weapon_06";
		this.m.Value = 1000;
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.StaminaModifier = -4;
		this.m.RegularDamage = 25;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.4;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local s = this.new("scripts/skills/actives/legend_staff_bash");
		s.m.FatigueCost = 13;
		s.m.MaxRange = 1;
		this.addSkill(s);

		s = this.new("scripts/skills/actives/legend_staff_knock_out");
		s.m.FatigueCost = 25;
		s.m.MaxRange = 1;
		this.addSkill(s);
	}

});

