this.master_sword <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		Variant = this.Math.rand(1, 3)
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.master_sword";
		this.updateVariant();
		this.m.Categories = "Unique Sword, One-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Condition = 1000.0;
		this.m.ConditionMax = 1000.0;
		this.m.StaminaModifier = -5;
		this.m.Value = 5200;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.15;
	}
	
	function updateVariant()
	{
		if (this.m.Variant == 1)
		{
			this.m.Name = "Master Sword";
			this.m.Description = "A well-balanced extraordinary long sword with a double-edged blade, it suited for all kind of fighting stance.";
			this.m.IconLarge = "weapons/melee/sword_03.png";
			this.m.Icon = "weapons/melee/sword_03_70x70.png";
			this.m.ArmamentIcon = "icon_sword_03";
		}
		else if (this.m.Variant == 2)
		{
			this.m.Name = "Exotic Shamshir";
			this.m.Description = "This well-crafted out of the world blade from the south has a curved edge that allows it to cut deep wounds with ease, and somehow makes it suited for thrusting and parrying.";
			this.m.IconLarge = "weapons/melee/scimitar_01.png";
			this.m.Icon = "weapons/melee/scimitar_01_70x70.png";
			this.m.ArmamentIcon = "icon_scimitar_01";
		}
		else if (this.m.Variant == 3)
		{
			this.m.Name = "Rapier";
			this.m.Description = "A light and elegant blade, favoring a swift and mobile fighting style, allowing easy parrying and thrusting.";
			this.m.IconLarge = "weapons/melee/sword_fencing_01.png";
			this.m.Icon = "weapons/melee/sword_fencing_01_70x70.png";
			this.m.ArmamentIcon = "icon_sword_fencing_01";
		}
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local slash = this.new("scripts/skills/actives/slash");
		slash.m.ActionPointCost = 3;
		if (this.m.Variant == 2)
		{
			slash.m.Icon = "skills/active_172.png";
			slash.m.IconDisabled = "skills/active_172_sw.png";
			slash.m.Overlay = "active_172";
		}
		this.addSkill(slash);
		
		local riposte = this.new("scripts/skills/actives/riposte");
		riposte.m.ActionPointCost = 3;
		this.addSkill(riposte);
		
		local lunge = this.new("scripts/skills/actives/lunge_skill");
		lunge.m.ActionPointCost = 3;
		this.addSkill(lunge);
		
		local gash = this.new("scripts/skills/actives/gash_skill");
		gash.m.ActionPointCost = 3;
		this.addSkill(gash);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});

