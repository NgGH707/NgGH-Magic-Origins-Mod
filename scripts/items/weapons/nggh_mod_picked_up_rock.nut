this.nggh_mod_picked_up_rock <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.picked_up_rock";
		this.m.Name = "A Huge Ass Rock";
		this.m.Description = "A rock you just picked up moment ago.";
		this.m.IconLarge = "weapons/ranged/huge_ass_rock.png";
		this.m.Icon = "weapons/ranged/huge_ass_rock_70x70.png";
		this.m.WeaponType = ::Const.Items.WeaponType.Throwing;
		this.m.SlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.RangedWeapon | ::Const.Items.ItemType.Ammo | ::Const.Items.ItemType.Defensive | ::Const.Items.ItemType.OneHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_mod_rock";
		this.m.Value = 0;
		this.m.Ammo = 1;
		this.m.AmmoMax = 1;
		this.m.AmmoCost = 1;
		this.m.RangeMin = 2;
		this.m.RangeMax = 4;
		this.m.RangeIdeal = 4;
		this.m.StaminaModifier = -20;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.8;
		this.m.DirectDamageMult = 0.35;
		this.m.IsDroppedAsLoot = false;
	}

	function isAmountShown()
	{
		return true;
	}

	function getAmountString()
	{
		return this.m.Ammo + "/" + this.m.AmmoMax;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/nggh_mod_unhold_throw_rock"));
	}

});

