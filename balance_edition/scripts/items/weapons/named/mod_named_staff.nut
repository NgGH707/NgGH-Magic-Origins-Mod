this.mod_named_staff <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {
		Magic = 0,
		MagicList = this.Const.MC_NamedStaff_MagicSkills
	},
	function create()
	{
		this.named_weapon.create();
		this.m.Variants = [1,2,3,4];
		this.m.Variant = this.m.Variants[this.Math.rand(0, this.m.Variants.len() -1)];
		this.m.ID = "weapon.named_staff";
		this.m.NameList = ["Staff"];
		this.m.Description = "This Staff is especially well-crafted, it even has an unnatural air around it";
		this.m.WeaponType = this.Const.Items.WeaponType.Staff | this.Const.Items.WeaponType.MagicStaff;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 5700;
		this.m.ShieldDamage = 0;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.StaminaModifier = -6;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 0.35;
		this.m.DirectDamageMult = 0.35;
		this.pickMagicSkill();
		this.randomizeValues();
		this.updateVariant();
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		local magic = {
			id = 64,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Let wearer use [color=#0b0084]" + this.m.MagicList[this.m.Magic].Name + "[/color] skill"
		};

		if (this.isRuned())
		{
			ret.insert(ret.len() - 1, magic);
		}
		else
		{
			ret.push(magic);
		}

		return ret
	}

	function pickMagicSkill()
	{
		local a = this.Math.ceil(this.Const.MC_NamedStaff_MagicSkills.len() / this.m.Variants.len());
		local lowerNum = (this.m.Variant - 1) * a;
		local upperNum =  this.m.Variant * a - 1;

		if (this.m.Variant == this.m.Variants.len())
		{
			upperNum = this.Const.MC_NamedStaff_MagicSkills.len() - 1;
		}

		this.m.Magic = this.Math.rand(lowerNum, upperNum);
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/mod_staff_named_0" + this.m.Variant + "_70x140.png";
		this.m.Icon = "weapons/melee/mod_staff_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_mod_staff_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local s = this.new("scripts/skills/actives/legend_staff_bash");
		s.m.Icon = "skills/staff_bash_vala.png";
		s.m.IconDisabled = "skills/staff_bash_vala_bw.png";
		this.addSkill(s);

		local t = this.new("scripts/skills/actives/legend_staff_knock_out");
		t.m.Icon = "skills/staff_knock_out_vala.png";
		t.m.IconDisabled = "skills/staff_knock_out_vala_bw.png";
		this.addSkill(t);

		if (::mods_getRegisteredMod("mod_legends_PTR") != null)
		{
			this.addSkill(this.new("scripts/skills/actives/ptr_staff_sweep_skill"));
		}

		local data = this.m.MagicList[this.m.Magic];
		local magic = this.new("scripts/skills/" + data.Script);
		magic.m.ActionPointCost += data.AP;
		magic.setFatigueCost(magic.getFatigueCostRaw() + data.Fatigue);
		this.addSkill(magic);
	}

	function onSerialize( _out )
	{
		this.named_weapon.onSerialize(_out);
		_out.writeU16(this.m.Magic);
	}

	function onDeserialize( _in )
	{
		this.named_weapon.onDeserialize(_in);
		this.m.Magic = _in.readU16();
	}

});

