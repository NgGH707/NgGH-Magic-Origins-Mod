this.nggh_mod_named_staff <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {
		MagicType = 0,
	},
	function create()
	{
		this.named_weapon.create();
		this.m.Variants = [1,2,3,4];
		this.m.Variant = ::MSU.Array.rand(this.m.Variants);
		this.m.ID = "weapon.named_staff";
		this.m.NameList = ["Staff"];
		this.m.Description = "This Staff is especially well-crafted. You can feel a mythical aura around it, an unnatural power is within it.";
		this.m.WeaponType = ::Const.Items.WeaponType.Staff | ::Const.Items.WeaponType.MagicStaff;
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Named | ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded | ::Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 5750;
		this.m.ShieldDamage = 0;
		this.m.Condition = 100.0;
		this.m.ConditionMax = 100.0;
		this.m.StaminaModifier = -6;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.40;
		this.m.DirectDamageMult = 0.4;
		this.pickMagicSkill();
		this.randomizeValues();
		this.updateVariant();
	}

	function getTooltip()
	{
		local ret = this.named_weapon.getTooltip();
		local index = this.isRuned() ? ret.len() - 2 : ret.len() - 1;

		// due to how the rune tooltip is added, i have to do this to make sure it is above the rune tooltip
		ret.insert(index, {
			id = 64,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Grants [color=#0b0084]" + ::Const.Nggh_NamedStaff_MagicSkills[this.m.MagicType].Name + "[/color] skill"
		});

		return ret
	}

	function pickMagicSkill()
	{
		// divide evenly all magic skills in ::Const.Nggh_NamedStaff_MagicSkills to each variant this item can have
		// then pick a random one in a divided group
		local a = ::Math.ceil(::Const.Nggh_NamedStaff_MagicSkills.len() / this.m.Variants.len());
		local lowerNum = (this.m.Variant - 1) * a;
		local upperNum = (this.m.Variant * a) - 1;

		if (this.m.Variant == this.m.Variants.len())
		{
			upperNum = ::Const.Nggh_NamedStaff_MagicSkills.len() - 1;
		}

		this.m.MagicType = ::Math.rand(lowerNum, upperNum);
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
		local s = ::new("scripts/skills/actives/legend_staff_bash");
		s.m.Icon = "skills/staff_bash_vala.png";
		s.m.IconDisabled = "skills/staff_bash_vala_bw.png";
		this.addSkill(s);

		local t = ::new("scripts/skills/actives/legend_staff_knock_out");
		t.m.Icon = "skills/staff_knock_out_vala.png";
		t.m.IconDisabled = "skills/staff_knock_out_vala_bw.png";
		this.addSkill(t);

		if (::Is_PTR_Exist)
		{
			this.addSkill(::new("scripts/skills/actives/ptr_staff_sweep_skill"));
		}

		local data = ::Const.Nggh_NamedStaff_MagicSkills[this.m.MagicType];
		local magic = ::new("scripts/skills/" + data.Script);
		magic.setFatigueCost(magic.getFatigueCostRaw() + data.AdditionalFatigue);
		magic.m.ActionPointCost += data.AdditionalAP;
		magic.m.IsSerialized = false;
		this.addSkill(magic);
	}

	function onSerialize( _out )
	{
		this.named_weapon.onSerialize(_out);
		_out.writeU16(this.m.MagicType);
	}

	function onDeserialize( _in )
	{
		this.named_weapon.onDeserialize(_in);
		this.m.MagicType = _in.readU16();
	}

});

